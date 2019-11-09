import scrapy
import re
import string
import datetime

class Projeto (scrapy.Spider):
    name = 'projeto_final'

    start_urls = ['https://www.astro.com/astro-databank']

    def parse (self, response):
        
        path = response.xpath('//div//a[re:test(@href,"AllPages")]/@href').get().split("=")[0]
        upper_letters = string.ascii_uppercase
        for letter in upper_letters:
            yield scrapy.Request(
                    path + "=" + letter,
                    callback = self.parse_category
                    )
    #'https://www.astro.com/astro-databank/Special:AllPages?from=Z'
              
    def parse_category(self, response):

        pages = response.css('a::attr(href)').getall()
        #'/astro-databank/Acconcia,_Italo'
        for page in pages:
            if 'Special:' in page or 'Help' in page or 'Main' in page or 'Astro-Databank' in page:
                pass
            elif re.search(r'^/astro-databank/', page):
                yield scrapy.Request(
                response.urljoin(page),
                callback = self.parse_new
                )
        
        pages_url = response.css('.mw-allpages-nav a::attr(href)').getall()[:2]
        for page in pages_url:
            yield scrapy.Request(
                response.urljoin(page),
                callback=self.parse_category
            )

    def parse_new(self,response):

        title = response.css('h1::text').get() #nome da pessoa

        months = []
        for i in range(1,13):
            months.append((datetime.date(2019, i, 1).strftime('%B')))
        
        links = response.xpath('//td').getall()
        for link in links:
            for month in months:
                if month in link:
                    birthday = link.strip().split("<small>")[0].split("<td>")[1].split(" at ")[0]
                    #retorna dia de nascimento
        
        for link in links:
            for month in months:
                if month in link:
                    birthhour = link.strip().split("<small>")[0].split("<td>")[1].split(" at ")[1]
                    #retorna horário de nascimento

        latitude = response.xpath('//small').getall()[2].strip().split(",")[0].split("<small>")[1]
        longitude = response.xpath('//small').getall()[2].strip().split(",  ")[1].split(" </small>")[0]

        biografia = response.xpath('//p').getall()[2]
        

        yield {
            'name': title,
            'data': birthday,
            'horario': birthhour,
            'lat': latitude,
            'long': longitude, 
            'bio': biografia,
            'url': response.url
        }
      