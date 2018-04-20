class EventsController < ApplicationController
  def index
    @events = Event.all
    @user = current_user
    @same_state = Event.joins(:location, :user).where(locations: {state: @user.location.state})
    @other_state = Event.joins(:location, :user).where.not(locations: {state: @user.location.state})
  end

  def show
    @event = Event.find(params[:id])
    @attendees = @event.attendees.includes(:location)
    @comments = @event.comments.includes(:user)
  end

  def create
    @loc = Location.find_or_create_by(location_params)
    puts @loc.inspect
    @event = Event.new(event_params)
    @user = current_user
    @event.user = @user
    @event.location = @loc
    puts @event.inspect
    if @event.save
      p "~~~~~~~~~~~~~~~"
      redirect_to '/events'
    else
      flash[:errors] = @event.errors.full_messages
      p "################"
      redirect_to "/events"
    end
  end

  def join
    @event = Event.find(params[:id])
    @user = current_user
    @event.attendees += [@user]
    redirect_to "/events"
  end

  def cancel
    if @event.attendees.exists?(@user.id)
      @event.attendees.delete(@user)
    end
    redirect_to "/events"
  end

  def update
    @location = Location.find_or_create_by(location_params)
    if @event.update(update_params)
      @event.update(@location)
      p "~~~~~~~~~~~~~~~~~~~~"
      redirect_to "/users/#{@event.id}"
    else 
      flash[:errors] = @event.errors.full_messages
      p "################"
      redirect_to "/users/#{@event.id}/edit"
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def destroy
    @event.destroy
    s[:user_id] = nil
    redirect_to "/users/new"
  end

  private
  def event_params
    params.require(:event).permit(:name, :date)
  end

  def location_params
    params.require(:location).permit(:city, :state) 
  end

end
