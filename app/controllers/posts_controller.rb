class PostsController < ApplicationController
  #request the user to login before performing the action create, edit, update, new and destroy
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @posts = @topic.posts.order("created_at DESC").page params[:page]
  end

  def new
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    # @topic = current_user.topics.build(id: params[:topic_id])
    # @post = Post.new(post_params.merge(topic_id: params[:topic_id]))
    @post = current_user.posts.build(post_params.merge(topic_id: @topic.id))
    # @post = current_user.posts.build(id: params[:post_id])

    if @post.save
      flash[:success] = "You've created a new post."
      redirect_to topic_posts_path(@topic)
    else
      flash[:danger] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post
  end

  def update
    #Following line option: @topic = @post.topic after @post = Post.find_by(id: params[:id])
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find(params[:id])
    authorize @post

    if @post.update(post_params.merge(slug: post_params[:title].gsub(" ", "-")))
      flash[:success] = "You've edited the post."
      redirect_to topic_posts_path(@topic)
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to edit_topic_post_path(@topic, @post)
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post

    if @post.destroy
      flash[:success] = "You've deleted the post."
      redirect_to topic_posts_path(@topic)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
