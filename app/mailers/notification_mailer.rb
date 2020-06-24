class NotificationMailer < ApplicationMailer
  default from: "example@example.com"

  def send_release_mail(user, detail)
    @user = user
    @detail = detail
    # 通知設定の漫画を入れる
    mail(
      subject: "#{@detail.title}が#{@user.notification_i18n}に発売されます",
      to: @user.email
    ) do |format|
      format.text
    end
  end
end
