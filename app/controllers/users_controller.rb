class UsersController < ApplicationController
  def index
  end

  def new
    @errors = flash[:errors]
  end

  def create
    @user = User.new(first_name:params[:first_name], last_name:params[:last_name], city:params[:city], state:params[:state],email:params[:email], password:params[:password], password_confirmation:params[:confirm])
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/sessions/new"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to "/users/new"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(first_name:params[:name], last_name:params[:name], email:params[:email], city:params[:city], state:params[:state])
      p "~~~~~~~~~~~~~~~~~~~~"
      redirect_to "/users/#{@user.id}"
    else 
      flash[:errors] = @user.errors.full_messages
      p "################"
      redirect_to "/users/#{@user.id}/edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to "/users/new"
  end
end
