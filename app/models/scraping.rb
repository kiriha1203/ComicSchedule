require 'mechanize'
require 'parallel'
require 'date'
require 'romkan'

class Scraping

  SEARCH_TITLE = 'div.item-title > a'.freeze
  SEARCH_DETAIL_XPATH  = '//*[@id="productDetailedDescription"]/div/ul'.freeze
  NEXT_URL_XPATH = '//*[@id="main-container"]/div[6]/div/div[2]/a'.freeze
  PAGE_NUM = 2.freeze


  def self.run
    save_details = []

    puts Time.now
    puts 'scraping start'
    content_urls = get_content_link

    content_urls.each do |content_url|
      content_pages = []
      url = content_url
      PAGE_NUM.times do
       dom = read_html(url)
       content_pages.push(get_scrape_content_page(dom))
       url = get_next_url(dom)
       break if url.nil?
      end


      puts 'content_page'
      puts content_pages
      content_pages.each do |contents|
        details = Parallel.map(contents, in_threads: 5) do |links|
          url = links[:url]
          detail_title = links[:title]
          dom = read_html(url)

          scrape_detail_page(dom, detail_title)
        end
        save_details.push(details)

      end
    end

    save_details.each do |month_details|
      month_details.each do |details|
        # titleがnilの場合飛ばす。要改善　正規表現でdetail_titleから取ってくる
        register_in_database(details) unless details[:title] == ""
      end
    end

    puts save_details
    puts Time.now
    puts 'scraping end'
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
    dom.search(SEARCH_TITLE).map do |dom_by_title|
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
    dom.xpath(NEXT_URL_XPATH)[0].attribute('href').value
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

    elements = dom.search(SEARCH_DETAIL_XPATH)

    unless elements.at_css("li/span:contains('発売日')").nil?
      release_str = elements.at_css("li/span:contains('発売日')").parent.search('span[2]').inner_text.delete('頃')
      if release_str.include?('日')
        release = Date.strptime(release_str, '%Y年%m月%d日')
      else
        release = Date.strptime(release_str, '%Y年%m月')
      end
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
    book.title_kana = details[:title_kana] if book.title_kana.nil?
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