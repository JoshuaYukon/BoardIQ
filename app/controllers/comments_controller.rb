class CommentsController < ApplicationController
  before_action :set_issue
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @issue.comments.build(comment_params)
    @comment.user_id = current_user.id if current_user

    if @comment.save
      Activity.log(project: @issue.project, user: current_user, action: "commented on issue", trackable: @issue, description: @issue.title)
      # Notify the issue assignee if they're someone else
      if @issue.user && @issue.user != current_user
        Notification.notify(
          user: @issue.user,
          message: "#{current_user&.name || 'Someone'} commented on your issue \"#{@issue.title}\"",
          notifiable: @issue
        )
      end
      redirect_to @issue, notice: 'Comment created successfully.'
    else
      redirect_to @issue, alert: 'Error creating comment.'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @issue, notice: 'Comment updated successfully.'
    else
      redirect_to @issue, alert: 'Error updating comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @issue, notice: 'Comment deleted successfully.'
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, images: [])
  end
end
