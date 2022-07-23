# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user

    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_to @commentable, alert: 'Error'
    end
  end

  def like
    @comment = Comment.find(params[:comment_id])

    if current_user.liked_comment?(@comment)
      comment_like = Like.where(user_id: current_user.id, likeable_id: @comment.id, likeable_type: @comment.class.name)
      redirect_back(fallback_location: root_path) if Like.destroy(comment_like.first.id)
    else
      if Like.create(likeable: @comment, user_id: current_user.id)
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = 'Error'
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
