class Users::PasswordsController < Devise::PasswordsController
  def create
    super do |resource|
      if successfully_sent?(resource)
        redirect_to password_sent_path and return
      end
    end
  end

  def sent; end
  def changed; end

end
