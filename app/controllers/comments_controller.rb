class CommentsController < ApplicationController
  # For Ajax part
  respond_to :js
  #request the user to login before performing the action create, edit, update, new and destroy
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    # @topic = @post.topic #alternative way to find topic after post becoz post already
    @comments = @post.comments.order("created_at DESC").page params[:page]
    @comment = Comment.new
    # @user = User.find_by(id: params[:user_id])
  end

  # no longer using below codes after implement Ajax
  # def new
  #   # @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
  #   @post = Post.find_by(id: params[:post_id])
  #   @topic = @post.topic #alternative way to find topic id after knowing post id
  #   @comment = Comment.new
  # end

  def create
    # @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))
    @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
    @post = @comment.post
    @topic = @post.topic
    @new_comment = Comment.new

    if @comment.save
      # flash[:success] = "You've successfully created a new comment."
      flash.now[:success] = "You've successfully created a new comment."
      # redirect_to topic_post_comments_path(@topic, @post)
    else
      flash.now[:danger] = @comment.errors.full_messages
      #use render :new instead of redirect_to to avoid page refresh and remove all entered data
    end
  end

  def edit
    # binding.pry
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
      flash[:success] = "You've successfully updated the comment."
      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash[:danger] = @comment.errors.full_messages
      render :edit #render the method edit when it has failed
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
    authorize @comment

    if @comment.destroy
      flash[:success] = "You've successfully deleted the comment."
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image, :user_id)
  end
  #
  # def user_params
  #   params.require(:user).permit(:email, :username, :password, :password_confirmation, :image)
  # end

end
