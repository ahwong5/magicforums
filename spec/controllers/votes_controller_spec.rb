require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  before(:all) do
    @comment = create(:comment)
    @user = create(:user)
  end

  describe "upvote comment" do
    it "should require login" do

      params = { comment_id: @comment.id }
      post :upvote, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create vote if non-existant" do

      cookies.signed[:id] = @user.id
      params = { comment_id: @comment.id }

      expect(Vote.all.count).to eql(0)

      post :upvote, xhr: true, params: params

      expect(Vote.all.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(Vote.first.comment).to eql(@comment)
      expect(assigns[:vote]).to_not be_nil
    end

    it "should find vote if existant" do

      @vote = @user.votes.create(comment_id: @comment.id)
      expect(Vote.all.count).to eql(1)

      cookies.signed[:id] = @user.id
      params = { comment_id: @comment.id }
      post :upvote, xhr: true, params: params

      expect(Vote.all.count).to eql(1)
      expect(assigns[:vote]).to eql(@vote)
    end

    it "should +1 vote" do

      cookies.signed[:id] = @user.id
      params = { comment_id: @comment.id }
      post :upvote, xhr: true, params: params

      expect(assigns[:vote].value).to eql(1)
      expect(Vote.first.value).to eql(1)
    end
  end

  describe "downvote comment" do
    it "should require login" do

      params = { comment_id: @comment.id }
      post :downvote, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should create vote if non-existant" do

      cookies.signed[:id] = @user.id
      params = { comment_id: @comment.id }

      expect(Vote.all.count).to eql(0)

      post :downvote, xhr: true, params: params

      expect(Vote.all.count).to eql(1)
      expect(Vote.first.user).to eql(@user)
      expect(Vote.first.comment).to eql(@comment)
      expect(assigns[:vote]).to_not be_nil
    end

    it "should find vote if existant" do

      @vote = @user.votes.create(comment_id: @comment.id)
      expect(Vote.all.count).to eql(1)

      cookies.signed[:id] = @user.id
      params = { comment_id: @comment.id }
      post :downvote, xhr: true, params: params

      expect(Vote.all.count).to eql(1)
      expect(assigns[:vote]).to eql(@vote)
    end

    it "should -1 vote" do

      cookies.signed[:id] = @user.id
      params = { comment_id: @comment.id }
      post :downvote, xhr: true, params: params

      expect(assigns[:vote].value).to eql(-1)
      expect(Vote.first.value).to eql(-1)
    end
  end
end
