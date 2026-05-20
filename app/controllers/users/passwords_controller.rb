class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      flash.discard(:notice)
      redirect_to password_sent_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def sent
  end

  def changed
  end
end
