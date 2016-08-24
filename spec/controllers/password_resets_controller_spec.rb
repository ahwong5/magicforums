require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  before(:all) do
    @user = create(:user)
  end

  describe "new reset" do
    it "should render new" do

      get :new
      expect(subject).to render_template(:new)
    end
  end

  describe "create reset" do

    it "should set token and date" do
      params = { reset: { email: "user@email.com" } }
      post :create, params: params

      @user.reload
      expect(ActionMailer::Base.deliveries.count).to eql(1)
      expect(@user.password_reset_token).to be_present
      expect(@user.password_reset_at).to be_present
      expect(subject).to redirect_to(new_password_reset_path)
    end

    it "should err if no user" do
      params = { reset: { email: "no@such.email" } }
      post :create, params: params

      @user.reload

      expect(@user.password_reset_token).to be_nil
      expect(@user.password_reset_at).to be_nil
      expect(flash[:danger]).to eql("User does not exist")
      expect(subject).to redirect_to(new_password_reset_path)
    end
  end

  describe "edit password" do
    it "should redirect to edit" do

      params = { id: "resettoken" }
      get :edit, params: params

      expect(subject).to render_template(:edit)
      expect(assigns[:token]).to eql("resettoken")
    end
  end

  describe "update password" do

    it "should update user password" do

      params = { reset: { email: "user@email.com" } }
      post :create, params: params

      @user.reload

      params = { id: @user.password_reset_token, user: { password: "newpassword" } }
      patch :update, params: params

      @user.reload

      user = @user.authenticate("newpassword")

      expect(user).to be_present
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_at).to be_nil
      expect(subject).to redirect_to(root_path)
    end

    it "should err if token invalid" do

      params = { reset: { email: "user@email.com" } }
      post :create, params: params

      edit_params = { id: "wrongtoken" }
      params = { id: "wrongtoken", user: { password: "newpassword" } }
      patch :update, params: params

      @user.reload

      user = @user.authenticate("newpassword")

      expect(user).to eql(false)
      expect(flash[:danger]).to eql("Error, token is invalid or has expired")
      expect(subject).to redirect_to(edit_password_reset_path(edit_params))
    end
  end
end
