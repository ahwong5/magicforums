votesChannelFunctions = () ->
  if $('.comments-container').length > 0
    App.votes_channel = App.cable.subscriptions.create {
      channel: "VotesChannel"
    },

    connected: () ->
      console.log("hello")
    disconnected: () ->

    received: (data) ->

      $(".comment-child[data-id=#{data.comment_id}] .total-votes").html(data.value)

$(document).on 'turbolinks:load', votesChannelFunctions
