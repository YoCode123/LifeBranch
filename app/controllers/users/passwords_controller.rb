class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render :sent
    else
      render :new, status: :unprocessable_entity
    end
  end
end
