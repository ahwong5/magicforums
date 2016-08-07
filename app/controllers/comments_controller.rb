class CommentsController < ApplicationController

  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    # binding.pry
    # @topic = @post.topic #alternative way to find topic after post becoz post already
    @comments = @post.comments.order("created_at DESC")
  end

  def new
    # @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic #alternative way to find topic id after knowing post id
    @comment = Comment.new
    # binding.pry
  end

  def create
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))

    if @comment.save
      redirect_to topic_post_comments_path(@topic, @post)
    else
      render :new
    end
  end

  def edit
    # binding.pry
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic

    if @comment.update(comment_params)
      redirect_to topic_post_comments_path(@topic, @post)
    else
      render :new
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
    # binding.pry

    if @comment.destroy
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
