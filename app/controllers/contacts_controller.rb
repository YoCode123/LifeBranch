class ContactsController < ApplicationController
  def new
  end

  def create
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]

    ContactMailer.contact(
      name: @name,
      email: @email,
      message: @message
    ).deliver_now

    redirect_to contact_path, notice: "お問い合わせを送信しました。"
  rescue StandardError => e
    Rails.logger.error "Contact mail failed: #{e.class}: #{e.message}"
    redirect_to contact_path, alert: "お問い合わせの送信に失敗しました。"
  end
end
