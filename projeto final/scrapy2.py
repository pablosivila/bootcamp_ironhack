import scrapy
import re
import string

class Projeto (scrapy.Spider):
    name = 'projeto_final'

    start_urls = ['https://www.astro.com/astro-databank']

    def parse (self, response):
        
        link = response.xpath('//div//a[re:test(@href,"AllPages")]/@href').get().split("=")[0]
        upper_letters = string.ascii_uppercase
        for letter in upper_letters:
            yield scrapy.Request(
                    link + "=" + letter,
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
        
def parse_new(self,response):
        title = response.css('h1::text').get()
        yield {
            'title': title,
            'url': response.url
        }
      