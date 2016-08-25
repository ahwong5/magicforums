require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @admin = create(:user, :admin)
    @user = create(:user, :sequenced_username, :sequenced_email)
    @topic = create(:topic, :sequenced_title, :sequenced_description)

    # @user = User.create(email: "user@gmail.com", username: "userlong", password: "123123", password_confirmation: "123123", role: "user")
    # @admin = User.create(email: "admin@gmail.com", username: "adminlong", password: "123123", password_confirmation: "123123", role: "admin")
    # @topic = Topic.create(title: "New Topic Title", description: "New Topic Description")
  end

  describe "test topic controller" do
    it "should render topic index" do
      get :index
      expect(subject).to render_template(:index)
    end
  end

  describe "create topic" do

    it "should redirect if not logged in" do

      params = { topic: { title: "New Topic Title", description: "New Topic Description" } }
      post :create, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic: { title: "New Topic Title", description: "New Topic Description" } }
      post :create, params: params, session: {id: @user.id}
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should create new topic" do

      params = { topic: { title: "New Topic Title", description: "New Topic Description" } }
      post :create, params: params, session: {id: @admin.id}

      expect(Topic.count).to eql(2)
      expect(@topic.title).to eql("New Topic Title")
      expect(@topic.description).to eql("New Topic Description")
      expect(flash[:success]).to eql("You've successfully created a new topic.")
    end
  end

  describe "edit topic" do

    it "should redirect if not logged in" do

      params = { id: @topic.id }
      get :edit, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @topic.id }
      get :edit, params: params, session: {id: @user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit topic" do

      params = { id: @topic.id }
      get :edit, params: params, session: { id: @admin.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end


  describe "update topic" do

    it "should redirect if not logged in" do
      params = { id: @topic.id, topic: { title: "New Topic Title", description: "New Topic Description" } }
      patch :update, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @topic.id, topic: { title: "New Topic Title", description: "New Topic Description" } }
      patch :update, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update topic" do
      params = { id: @topic.id, topic: { title: "New Topic Title", description: "New Topic Description" } }
      patch :update, params: params, session: { id: @admin.id }
      @topic.reload
      # expect(subject).to redirect_to(topics_path)
      expect(flash[:success] = "You've successfully edited the topic.")
    end
  end

  describe "delete topic" do

    it "should redirect if not logged in" do
      params = { id: @topic.id, topic: { title: "New Topic Title", description: "New Topic Description" } }
      delete :destroy, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @topic.id, topic: { title: "New Topic Title", description: "New Topic Description" } }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete topic" do
      params = { id: @topic.id, topic: { title: "New Topic Title", description: "New Topic Description" } }
      delete :destroy, params: params, session: { id: @admin.id }

      expect(subject).to redirect_to(topics_path)
      expect(flash[:success] = "You've successfully deleted the topic.")
    end
  end

end
