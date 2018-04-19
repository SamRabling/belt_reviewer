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

  def show
    
  end

  def destroy
  end

  

  def edit
  end

  def update
  end
end
