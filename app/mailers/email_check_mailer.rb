class EmailCheckMailer < ApplicationMailer
  def send_user_email_check(user, authcode)
    @user = user
    @authcode = authcode
    mail(
      to: @user["email"],
      subject: "LinkS ユーザ認証"
    ) do |format|
      format.text
    end
  end
end
