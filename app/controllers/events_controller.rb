class EventsController < ApplicationController
  def index
    @events = Event.all
    @user = current_user
    @same_state = Event.joins(:location, :user).where(locations: {state: @user.location.state})
    @other_state = Event.joins(:location, :user).where.not(locations: {state: @user.location.state})
    
  end

  def create
    @location = Location.find_or_create_by(location_params)
    @user = current_user
    @event = Event.new(event_params)
    @event.location = @location
    @event.user = @user
    if @event.save
      p "~~~~~~~~~~~~~~~"
      redirect_to '/events'
    else
      flash[:errors] = @event.errors.full_messages
      p "################"
      redirect_to "/events"
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  private
  def event_params
    params.require(:event).permit(:name, :date)
  end

  def location_params
    params.require(:location).permit(:city, :state) 
  end

end
