class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    ids = current_user.friends.pluck(:id) << current_user.id
    @posts = Post.where(user_id: ids).order("created_at DESC")
    @post = Post.new
  end

  def like
    @post = Post.find(params[:post_id])

    if current_user.liked_post?(@post)
      post_like = Like.where(user_id: current_user.id, likeable_id: @post.id, likeable_type: @post.class.name)
      if Like.destroy(post_like.first.id)
        redirect_back(fallback_location: root_path)
      end
    else
      respond_to do |format|
        if Like.create(likeable: @post, user_id: current_user.id)
          format.html { redirect_to root_path, notice: "Liked" }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    current_user.posts << @post
    respond_to do |format|
      if current_user.posts << @post
        format.html { redirect_to root_path, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:body)
  end
end
