require 'mechanize'
require 'parallel'
require 'date'

class Scraping

  @@base_url = 'https://books.rakuten.co.jp'
  @@search_title = 'div.item-title > a'
  @@search_detail_xpath  = '//*[@id="productDetailedDescription"]/div/ul'
  @@next_url_xpath = '//*[@id="main-container"]/div[6]/div/div[2]/a'
  @@page_num = 1
  @@user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36'
  @content_urls = []
  @content_pages = []
  @details = []

  def self.run
    @content_urls = get_content_link

    @content_urls.each do |content_url|
      url = content_url
      @@page_num.times do
       dom = read_html(url)
       @content_pages = get_scrape_content_page(dom)
       url = get_next_url(dom)
       break if url.nil?
      end

      details = Parallel.map(@content_pages, in_threads: 5) do |links|
        url = links[:url]
        detail_title = links[:title]
        dom = read_html(url)

        scrape_detail_page(dom, detail_title)
      end

      @details.push(details)
    end

    @details.each do |month_details|
      month_details.each do |details|
        # titleがnilの場合飛ばす。要改善　正規表現でdetail_titleから取ってくる
        register_in_database(details) unless details[:title] == ""
      end
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
    agent = Mechanize.new
    agent.get(url)
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

  def self.scrape_detail_page(dom, detail_title)
    release = ""
    author = ""
    title = ""
    label = ""
    issue_from = ""
    page = ""

    elements = dom.search(@@search_detail_xpath)

    unless elements.at_css("li/span:contains('発売日')").nil?
      release_str = elements.at_css("li/span:contains('発売日')").parent.search('span[2]').inner_text.delete('頃')
      release = Date.strptime(release_str, '%Y年%m月%d日')
    end
    unless elements.at_css("li/span:contains('著者／編集')").nil?
      author = elements.at_css("li/span:contains('著者／編集')").parent.search('span[2]').inner_text.gsub!(/\n/, '')
    end
    unless elements.at_css("li/span:contains('関連作品')").nil?
      title = elements.at_css("li/span:contains('関連作品')").parent.search('span[2]').inner_text.gsub!(/\n/, '')
    end
    unless elements.at_css("li/span:contains('レーベル')").nil?
      label = elements.at_css("li/span:contains('レーベル')").parent.search('span[2]').inner_text.gsub!(/\n/, '')
    end
    unless elements.at_css("li/span:contains('発行形態')").nil?
      issue_from = elements.at_css("li/span:contains('発行形態')").parent.search('span[2]').inner_text
    end
    unless elements.at_css("li/span:contains('ページ数')").nil?
      page = elements.at_css("li/span:contains('ページ数')").parent.search('span[2]').inner_text.gsub!(/p/, '').to_i
    end

    if detail_title.match?('（\d+）')
      volume = detail_title.match('（\d+）')[0].delete("^0-9").to_i
    else
      volume = detail_title.delete("^0-9").to_i
    end

    detail_title.sub!(/\n.*/m, '')

    {release: release, author: author, title: title, label: label, issue_from: issue_from, page: page, volume: volume, detail_title: detail_title}
  end

  def self.register_in_database(details)
    book = Book.where(title: details[:title]).first_or_initialize
    book.author = details[:author]
    book.label = details[:label]
    book.issue_from = details[:issue_from]
    book.save

    book_detail = BookDetail.where(title: details[:detail_title]).first_or_initialize
    book_detail.book_id = book.id
    book_detail.volume = details[:volume]
    book_detail.page = details[:page]
    book_detail.release = details[:release]
    book_detail.save
  end

end