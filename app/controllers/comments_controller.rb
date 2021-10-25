class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: "Comment Posted"
    else
      redirect_to @commentable, alert: "Error"
    end
  end

  def like
    @comment = Comment.find(params[:comment_id])

    if current_user.liked_comment?(@comment)
      comment_like = Like.where(user_id: current_user.id, likeable_id: @comment.id, likeable_type: @comment.class.name)
      if Like.destroy(comment_like.first.id)
        redirect_back(fallback_location: root_path)
      end
    else
      if Like.create(likeable: @comment, user_id: current_user.id)
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = "Error"
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
