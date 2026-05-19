class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    redirect_to password_sent_path
  end

  def sent
  end
end
