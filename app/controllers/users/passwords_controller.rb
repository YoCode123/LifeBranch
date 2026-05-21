class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      redirect_to password_sent_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      flash[:notice] = "パスワードを変更しました"

      redirect_to password_changed_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def sent
  end

  def changed
  end
end
