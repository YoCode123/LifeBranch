class ContactMailer < ApplicationMailer
  def contact(name:, email:, message:)
    @name = name
    @email = email
    @message = message

    mail(
      to: "hyousatu@gmail.com",
      subject: "LifeBranch お問い合わせ"
    )
  end
end
