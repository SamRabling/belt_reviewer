class CommentsController < ApplicationController
  def create
    @user = current_user
    @event = Event.find(params[:id])
    @comment = Comment.new(comment_params)
    @comment.user = @user
    @comment.event = @event
    if @comment.save
      redirect_to "/events/#{@event.id}"
    else
      flash[:error] = @comment.errors.full_messages
      redirect_to "/events/#{@event.id}"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
