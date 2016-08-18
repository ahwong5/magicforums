class CommentsController < ApplicationController
  # For Ajax part
  respond_to :js
  #request the user to login before performing the action create, edit, update, new and destroy
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]


  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @post = Post.includes(:comments).friendly.find(params[:post_id])
    # @topic = @post.topic #alternative way to find topic after post becoz post already
    @comments = @post.comments.order("created_at DESC").page params[:page]
    @comment = Comment.new
  end

  # no longer using below codes after implement Ajax
  # def new
  #   # @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
  #   @post = Post.find_by(id: params[:post_id])
  #   @topic = @post.topic #alternative way to find topic id after knowing post id
  #   @comment = Comment.new
  # end

  def create
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @post = Post.includes(:comments).friendly.find(params[:post_id])
    # @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))
    # @post = @comment.post
    # @topic = @post.topic
    @new_comment = Comment.new

    if @comment.save
      CommentBroadcastJob.perform_later("create", @comment)      # flash[:success] = "You've successfully created a new comment."
      flash.now[:success] = "You've successfully created a new comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
    authorize @comment
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
    authorize @comment

    if @comment.update(comment_params)
      flash.now[:success] = "You've successfully updated the comment."
      CommentBroadcastJob.perform_later("update", @comment)
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
    authorize @comment

    if @comment.destroy
      flash.now[:success] = "You've successfully deleted the comment."
      CommentBroadcastJob.perform_now("destroy", @comment)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image, :user_id)
  end
end
