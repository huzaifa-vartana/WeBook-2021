# frozen_string_literal: true

module Comments
  class CommentsController < CommentsController
    before_action :set_commentable

    private

    def set_commentable
      @commentable = Comment.find(params[:comment_id])
    end
  end
end
