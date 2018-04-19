class EventsController < ApplicationController
  def index
    @user = User.find(params[:id])
  end

  def create
  end

  def destroy
  end
end
