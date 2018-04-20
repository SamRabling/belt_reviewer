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
    @user = current_user
    @event.attendees.delete(@user)
    redirect_to "/events"
  end

  def update
    @event = Event.find(params[:id])
    @loc = Location.find_or_create_by(location_params)
    if @event.update(event_params)
      p "~~~~~~~~~~~~~~~~~~~~"
      redirect_to "/users/#{@event.id}"
    end
    if @event.update(@loc)
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
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to "/events"
  end

  private
  def event_params
    params.require(:event).permit(:name, :date)
  end

  def location_params
    params.require(:location).permit(:city, :state) 
  end

end
