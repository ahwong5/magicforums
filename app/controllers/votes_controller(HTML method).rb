class VotesController < ApplicationController

  respond_to :js
  before_action :authenticate!, only: [:upvote, :cancelvote, :downvote]

  def upvote
    @comment = Comment.find_by(id: params[:comment_id])
    @post = @comment.post
    @topic = @post.topic
    page = params[:page] || 1
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
      @vote.update(value: +1)
      flash[:success] = "You've successfully +1 vote to a comment."
      redirect_to topic_post_comments_path(topic_id: @topic.id, post_id: @post.id, page: page)
    end
  end

  def cancelvote
    @comment = Comment.find_by(id: params[:comment_id])
    @post = @comment.post
    @topic = @post.topic
    page = params[:page] || 1
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
      @vote.update(value: 0)
      flash[:success] = "You've successfully cancel the vote."
      redirect_to topic_post_comments_path(topic_id: @topic.id, post_id: @post.id, page: page)
    end
  end

  def downvote
    # @comment = Comment.find_by(id: params[:comment_id])
    # @post = @comment.post
    # @topic = @post.topic
    # page = params[:page] || 1
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if @vote
      @vote.update(value: -1)
      flash.now[:success] = "You've successfully -1 vote to a comment."
      # redirect_to topic_post_comments_path(topic_id: @topic.id, post_id: @post.id, page: page)
    end
  end


end
