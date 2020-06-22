class NotificationMailer < ApplicationMailer
  default from: "example@example.com"

  def send_release_mail
    @user = user
    # 通知設定の漫画を入れる
    mail(
      subject: "通知の漫画が#{@user.notification}に発売されます",
      to: @user.email
    ) do |format|
      format.text
    end
  end
end
