class PostsController < ApplicationController

 def index
   @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
   @posts = @topic.posts.order("created_at DESC")
 end

 def new
   @topic = Topic.find_by(id: params[:topic_id])
   @post = Post.new
 end

 def create
   @topic = Topic.find_by(id: params[:topic_id])
   @post = Post.new(post_params.merge(topic_id: params[:topic_id]))

   if @post.save
    flash[:success] = "You've created a new post."
     redirect_to topic_posts_path(@topic)
   else
    flash[:danger] = @post.errors.full_messages
     redirect_to new_topic_post_path(@topic)
   end
 end

 def edit
   @post = Post.find_by(id: params[:id])
   @topic = @post.topic
 end

 def update
   #Following line option: @topic = @post.topic after @post = Post.find_by(id: params[:id])
   @topic = Topic.find_by(id: params[:topic_id])
   @post = Post.find_by(id: params[:id])

   if @post.update(post_params)
     flash[:success] = "You've edited the post."
     redirect_to topic_posts_path(@topic)
   else
     flash[:danger] = @post.errors.full_messages
     redirect_to edit_topic_post_path(@topic, @post)
   end
 end

 def destroy
   @post = Post.find_by(id: params[:id])
   @topic = @post.topic

   if @post.destroy
     flash[:success] = "You've deleted the post."
     redirect_to topic_posts_path(@topic)
   end
 end

 private

 def post_params
   params.require(:post).permit(:title, :body)
 end
end
