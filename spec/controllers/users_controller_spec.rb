require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) do
    # The full statement is @user = FactoryGirl.create(:user), check in rspec helper - config.include FactoryGirl::Syntax::Methods
    @user = create(:user)
    @unauthorized_user = create(:user, email: "userthor2@gmail.com", username: "thor2", password: "123123", password_confirmation: "123123")
    # binding.pry
  end

  describe "render new" do
    it "should render new" do
      get :new
      expect(subject).to render_template(:new)
      expect(assigns[:user]).to be_present
    end
  end


  describe "create user" do
    it "should create new user" do

      params = { user: { email: "userthor3@gmail.com", username: "thor3", password: "123123", password_confirmation: "123123" } }
      post :create, params: params

      user = User.find_by(email: "userthor3@gmail.com")

      expect(User.count).to eql(3)
      expect(user.email).to eql("userthor3@gmail.com")
      expect(user.username).to eql("thor3")
      expect(flash[:success]).to eql("You've successfully created an account")
    end
  end


  describe "edit user" do

    it "should redirect if not logged in" do

      params = { id: @user.id }
      get :edit, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end



    it "should redirect if user unauthorized" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end


    it "should render edit" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end


  describe "update user" do

    it "should redirect if not logged in" do
      params = { id: @user.id, user: { email: "new@email.com", username: "newusername" } }
      patch :update, params: params

      expect(subject).to redirect_to(new_session_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @user.id, user: { email: "new@email.com", username: "newusername" } }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update user" do

      params = { id: @user.id, user: { email: "new@email.com", username: "newusername", password: "newpassword" } }
      patch :update, params: params, session: { id: @user.id }

      @user.reload
      current_user = subject.send(:current_user).reload

      expect(current_user.email).to eql("new@email.com")
      expect(current_user.username).to eql("newusername")
      expect(current_user.authenticate("newpassword")).to eql(@user)
    end
  end
end
