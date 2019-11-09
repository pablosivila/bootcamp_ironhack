import scrapy
import re

class Projeto (scrapy.Spider):
    name = 'projeto_final'

    start_urls = ['https://www.astro.com/astro-databank']

    def parse (self, response):
        links = response.xpath(
            '//a[re:test(@href,"AllPages")]/@href'
            ).getall()
        #'https://www.astro.com/astro-databank/Special:AllPages?from=Z'

        for link in links[0:5]:
            if "namespace" not in link and "https" in link:
                yield scrapy.Request(
                    response.urljoin(link),
                    callback = self.parse_category
                    )

            else:
                pass

    def parse_category(self, response):
        pages = response.css('a::attr(href)').getall()
        #'/astro-databank/Acconcia,_Italo'
        for page in pages:
            if 'Special:' in page or 'Help' in page or 'Main' in page or 'Astro-Databank' in page:
                pass
            elif re.search(r'^/astro-databank/', page):
                yield {'url':page}
        
            #scrapy.Request(
      #          response.urljoin(page),
       #         callback = self.parse_new
        #        )
                

 #   def parse_new(self,response):
  #      title = response.css('h1::text').get()
   #     yield {
    #        'title': title,
     #       'url': response.url
      #  }

#  xpath='//div//div//div//ul//li//b//span//a[re:test(@href,"AllPages")]' 
# response.xpath('//div//div//div//ul//li//b//span//a[re:test(@href,"AllPages")]/@href').getall()

#'https://www.astro.com/astro-databank/Special:AllPages?from=Z',
#'https://www.astro.com/astro-databank/Special:AllPages?from=B&namespace=112',


#response.css('a::attr(href)').getall()
#'/astro-databank/Acconcia,_Italo',





#months = []
#for i in range(1,13):
#    months.append((datetime.date(2019, i, 1).strftime('%B')))

#response.xpath('//td').getall()

#retorna dia de nascimento:
# for link in links:
#   for month in months:
#       if month in link:
#           print (link.strip().split("<small>")[0].split("<td>")[1].split(" at ")[0])

#retorna horário de nascimento:
# for link in links:
#   for month in months:
#       if month in link:
#           print (link.strip().split("<small>")[0].split("<td>")[1].split(" at ")[1])


#response.xpath('//small').getall()[2]
#latitude = response.xpath('//small').getall()[2].strip().split(",")[0].split("<small>")[1]
#longitude = response.xpath('//small').getall()[2].strip().split(",  ")[1].split(" </small>")[0]

#biografia = response.xpath('//p').getall()[2]