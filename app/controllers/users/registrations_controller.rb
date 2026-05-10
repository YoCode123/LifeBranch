class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_with_password(params)
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end
end
