# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    include AdminAuthentication

    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.all.order(:email)
    end

    def show
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      
      if @user.save
        redirect_to admin_user_path(@user), notice: 'User was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      # Remove empty password fields to avoid validation errors
      params[:user].delete(:password) if params[:user][:password].blank?
      params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
      
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: 'You cannot delete your own account.'
        return
      end

      if @user.destroy
        redirect_to admin_users_path, notice: 'User was successfully deleted.'
      else
        redirect_to admin_users_path, alert: 'Failed to delete user.'
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :admin)
    end
  end
end