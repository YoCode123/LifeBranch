class Users::PasswordsController < Devise::PasswordsController
  def create
    redirect_to root_path
  end
end
