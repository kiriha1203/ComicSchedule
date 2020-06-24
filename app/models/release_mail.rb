require 'date'

class ReleaseMail
  def self.run
    times = 1..User.count
    times.each do |number|
      user = User.find(number)
      bookmarks_id = user.bookmark_books.ids
      bookmarks_id.each do |detail_search|
        details = Book.find(detail_search).book_details
        details.each do |detail|
          release_day = detail.release
          if release_day == Date.today + user.notification_before_type_cast
            NotificationMailer.send_release_mail(user, detail).deliver_now
          end
        end
      end
    end
  end
end