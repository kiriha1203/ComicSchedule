require 'uri'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'parallel'

class RakutenCrawler

  @@base_url = 'https://books.rakuten.co.jp'
  @@search_title = 'div.item-title > a'
  @@search_detail_xpath  = '//*[@id="productDetailedDescription"]/div/ul'
  @@next_url_xpath = '//*[@id="main-container"]/div[6]/div/div[2]/a'
  @@page_num = 100
  @@user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36'
  @content_urls = []
  @content_pages = []
  @details = []

  def self.run
    @content_urls = get_content_link
    puts @content_urls
    @content_urls.each do |content_url|
      url = content_url
      @@page_num.times do
       dom = read_html(url)
       @content_pages = get_scrape_content_page(dom)
       puts @content_pages
       url = get_next_url(dom)
       break if url.nil?
      end

      details = Parallel.map(@content_pages, in_threads: 5) do |links|
        url = links[:url]
        detail_title = links[:title]
        dom = read_detail_html(url)

        scrape_detail_page(dom, detail_title)
      end

      @details.push(details)
    end

  end

  def self.get_content_link
    target_date = Date.today
    search_days = ["#{target_date.year}-#{format( "%02d", target_date.month)}-01"]
    if Date.today.day > 14
      target_date2 = target_date >> 1
      search_days.push("#{target_date2.year}-#{format( "%02d", target_date2.month)}-01")
    end

    search_days.map do |search_day|
      "https://books.rakuten.co.jp/calendar/001001/monthly/?tid=#{search_day}"
    end

  end

  def self.read_html(url)
    charset = nil
    user_agent = {"User-Agent" => @@user_agent}
    html = open(url, user_agent) do |f|
      charset = f.charset
      f.read
    end

    Nokogiri::HTML.parse(html, nil, charset)
  end

  def self.get_scrape_content_page(dom)
    dom.search(@@search_title).map do |dom_by_title|
      {title: get_title(dom_by_title), url: get_article_url(dom_by_title)}
    end

  end

  def self.get_title(dom)
    dom.inner_text
  end

  def self.get_article_url(dom)
    dom.attribute('href').value
  end

  def self.get_next_url(dom)
    dom.xpath(@@next_url_xpath)[0].attribute('href').value
  rescue
    nil
  end

  def self.read_detail_html(url)
    Nokogiri::HTML(open(url, "User-Agent" => @@user_agent, "Referer" => 'https://books.rakuten.co.jp'))
  end

  def self.scrape_detail_page(dom, detail_title)
    elements = dom.search(@@search_detail_xpath)
    release = elements.search('li[1]/span[2]').inner_text
    author = elements.search('li[2]/span[2]').inner_text
    title = elements.search('li[3]/span[2]').inner_text
    label = elements.search('li[4]/span[2]').inner_text
    issue_from = elements.search('li[6]/span[2]').inner_text
    volume = elements.search('li[7]/span[2]').inner_text

    {release: release, author: author, title: title, label: label, issue_from: issue_from, volume: volume, detail_title: detail_title}
  end

end

RakutenCrawler.run

