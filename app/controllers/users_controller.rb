class UsersController < ApplicationController
  def new
    @errors = flash[:errors]
  end

  def create
    @location = Location.find_or_create_by(location_params)
    @user = User.new(user_params)
    @user.location = @location
    if @user.save
      session[:user_id] = @user.id
      p "~~~~~~~~~~~~~~~"
      redirect_to '/events'
    else
      flash[:errors] = @user.errors.full_messages
      p "################"
      redirect_to "/"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @location = Location.find_or_create_by(location_params)
    if @user.update(update_params)
      p "~~~~~~~~~~~~~~~~~~~~"
      redirect_to "/users/#{@user.id}"
    else 
      flash[:errors] = @user.errors.full_messages
      p "################"
      redirect_to "/users/#{@user.id}/edit"
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to "/users/new"
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :confirm)
  end

  def location_params
    params.require(:location).permit(:city, :state)
  end

  def update_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def verify_user
    @user = User.find(session[:user_id]) if session.include? (:user_id)
    redirect_to '/events' unless @user && session[:user_id] == params[:id]
  end
end
