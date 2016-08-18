class VoteBroadcastJob < ApplicationJob
  queue_as :default

  def perform(type, comment)
    ActionCable.server.broadcast 'votes_channel', comment_id: comment.id, value: comment.total_votes
  end

end
