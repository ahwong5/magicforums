class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!
  before_action :find_or_create_vote

  def upvote
    update_vote(1)
    flash.now[:success] = "You upvoted."
  end

  def cancelvote
    update_vote(0)
    flash.now[:success] = "You cancelvoted."
  end

  def downvote
    update_vote(-1)
    flash.now[:success] = "You downvoted."
  end

  private

  def find_or_create_vote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
    @comment =Comment.find_by(id: params[:comment_id])
  end

  def update_vote(value)
    @vote.update(value: value)
    VoteBroadcastJob.perform_later(@vote.comment)
  end
end
