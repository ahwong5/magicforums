require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:all) do

    @user = User.create(email: "user@gmail.com", username: "userlong", password: "123123", password_confirmation: "123123", role: "user")
    @admin = User.create(email: "admin@gmail.com", username: "adminlong", password: "123123", password_confirmation: "123123", role: "admin")
    @topic = Topic.create(title: "New Topic Title", description: "New Topic Description")
    @post = Post.create(title: "New Post Title", body: "New Post Body New Post Body New Post Body New Post Body", topic_id: @topic.id)
    @comment = Comment.create(body: "New Comment New Comment New Comment New Comment New Comment New Comment", post_id: @post.id)

  end

  describe "test Post controller" do

    it "should render post index" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :index, params: params
      expect(subject).to render_template(:index)
    end
  end

  describe "create comment" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      post :create, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create new comment" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: {body: "New Comment New Comment New Comment New Comment New Comment New Comment"} }
      post :create, xhr: true, params: params, session: {id: @user.id}

      expect(Comment.count).to eql(2)
      expect(@comment.body).to eql("New Comment New Comment New Comment New Comment New Comment New Comment")
      expect(flash[:success]).to eql("You've successfully created a new comment.")
    end
  end

  describe "edit comment" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params, session: {id: @user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit comment" do

      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params, session: { id: @admin.id }
      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end


  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      patch :update, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update comment" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: {body: "New Comment New Comment New Comment New Comment New Comment New Comment"} }
      patch :update, xhr: true, params: params, session: { id: @admin.id }

      @comment.reload
      # expect(subject).to redirect_to(topic_posts_path)
      expect(flash[:success] = "You've successfully updated the comment.")
    end
  end

  describe "delete comment" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete comment" do
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id}
      delete :destroy, xhr: true, params: params, session: { id: @admin.id }
      expect(flash[:success] = "You've successfully deleted the comment.")
    end
  end

end
