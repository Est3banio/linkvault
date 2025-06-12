# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    
    if resource_updated
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_to do |format|
        format.html do
          set_flash_message_now :notice, :updated
          redirect_to after_update_path_for(resource)
        end
        format.json { render json: { status: 'ok' } }
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end
  
  protected

  def update_resource(resource, params)
    # Check if password fields are blank
    password_changing = params[:password].present? || params[:password_confirmation].present?
    
    if password_changing
      # Password is being changed, validate current password
      if params[:current_password].blank?
        resource.errors.add(:current_password, "can't be blank when changing password")
        return false
      end
      resource.update_with_password(params)
    else
      # Only email is being updated, no current password required
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  def set_flash_message_now(key, kind, options = {})
    message = find_message(kind, options)
    
    case kind
    when :updated
      flash.now[:notice] = "Your profile has been updated successfully."
    else
      flash.now[key] = message if message.present?
    end
  end
end