require 'mechanize'

agent = Mechanize.new


target_date = Date.today

search_day = target_date.year + "-" + format("%02d", target_date.month) + "-" + 01

# num = true

# for num in 1...10 do
#
# page = agent.get('https://books.rakuten.co.jp/calendar/001001/monthly/?tid="#{search_day}"&p="#{num}"')
# elements = page.search('div.item-title > a')


page = agent.get('https://books.rakuten.co.jp/calendar/001001/monthly/?tid="#{search_day}"&p=1')
links = page.search('div.item-title > a')

details = []

links.each do |link|
  detail = page.link_with(href: "#{link.get_attribute(:href)}").click
  title = detail.search('//*[@id="productTitle"]/h1/text()')
  list = detail.search('//*[@id="productDetailedDescription"]/div/ul/')

  binding.irb


  details.push({
                 title: 'ttile',
                 date: '2020-10-10',
                 page: 200
               })
end

details[0]

# elements.each do |a|
#   detail = page.link_with(href: "#{a.get_attribute(:href)}").click
#   puts detail.search('//*[@id="productTitle"]/h1/text()')
# end

# detail = page.link_with(href: "#{elements[0].get_attribute(:href)}").click
# title = detail.search('//*[@id="productTitle"]/h1/text()')
# list = detail.search('//*[@id="productDetailedDescription"]/div/ul/')
#
# title.each do |f|
#   puts f.inner_text
# end
#
# list.each do |f|
#   puts f.inner_text
# end
#
#  end
