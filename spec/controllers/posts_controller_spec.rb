require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @user = User.create(email: "user@gmail.com", username: "userlong", password: "123123", password_confirmation: "123123", role: "user")
    @admin = User.create(email: "admin@gmail.com", username: "adminlong", password: "123123", password_confirmation: "123123", role: "admin")
    @topic = Topic.create(title: "New Topic Title", description: "New Topic Description")
    @post = Post.create(title: "New Post Title", body: "New Post Body New Post Body New Post Body New Post Body", topic_id: @topic.id)
  end

  describe "test Post controller" do

    it "should render post index" do
      params = { topic_id: @topic.id }
      get :index, params: params
      expect(subject).to render_template(:index)
    end
  end

  describe "create post" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.id }
      post :create, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create new post" do

      params = { topic_id: @topic.id, post: {title: "New Post Title", body: "New Post Body New Post Body New Post Body New Post Body"} }
      post :create, params: params, session: {id: @user.id}

      expect(Post.count).to eql(2)
      expect(@post.title).to eql("New Post Title")
      expect(@post.body).to eql("New Post Body New Post Body New Post Body New Post Body")
      expect(flash[:success]).to eql("You've created a new post.")
    end
  end

  describe "edit post" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: {id: @user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit post" do

      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: { id: @admin.id }
      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end


  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      patch :update, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id }
      patch :update, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post" do
      params = { topic_id: @topic.id, id: @post.id, post: {title: "New Post Title", body: "New Post Body New Post Body New Post Body New Post Body"} }
      patch :update, params: params, session: { id: @admin.id }

      @post.reload
      # expect(subject).to redirect_to(topic_posts_path)
      expect(flash[:success] = "You've edited the post.")
    end
  end

  describe "delete post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete post" do
      params = { topic_id: @topic.id, id: @post.id }
      delete :destroy, params: params, session: { id: @admin.id }

      expect(subject).to redirect_to(posts_path)
      expect(flash[:success] = "You've deleted the post.")
    end
  end

end
