# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: @users, include: 'attachments'
  end

  def show
    render json: @user, include: 'attachments'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created, include: 'attachments'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :accepted, include: 'attachments'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, attachments_attributes: %i[id title file_path kind _destroy])
  end
end
