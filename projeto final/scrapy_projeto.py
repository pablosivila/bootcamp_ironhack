import scrapy


class Projeto (scrapy.Spider):
    name = 'projeto_final'

    start_urls = ['https://www.astro.com/astro-databank']

    def parse (self, response):
        links = response.xpath(
            '//div//div//div//ul//li//b//span//a[re:test(@href,"AllPages")]/@href'
            ).getall()
        #'https://www.astro.com/astro-databank/Special:AllPages?from=Z'
        for link in links[0:5]:
            yield scrapy.Request(
                response.urljoin(link),
                callback = self.parse_category
                )

    def parse_category(self, response):
        pages = response.css('a::attr(href)').getall()
        #'/astro-databank/Acconcia,_Italo'
        for page in pages[0:2]:
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

#  xpath='//div//div//div//ul//li//b//span//a[re:test(@href,"AllPages")]' 
# response.xpath('//div//div//div//ul//li//b//span//a[re:test(@href,"AllPages")]/@href').getall()

#'https://www.astro.com/astro-databank/Special:AllPages?from=Z',
#'https://www.astro.com/astro-databank/Special:AllPages?from=B&namespace=112',


#response.css('a::attr(href)').getall()
#'/astro-databank/Acconcia,_Italo',
