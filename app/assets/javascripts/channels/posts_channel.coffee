postsChannelFunctions = () ->

  # to check only admin or owner of the post can see edit/delete buttons
  checkMe = (comment_id, username) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{username}]").length > 0
      $(".comment-child[data-id=#{comment_id}] .control-panel").remove()
    $(".comment-child[data-id=#{comment_id}]").removeClass("hidden")

  createComment = (data) ->
    if $('.comments-container').data().id == data.post.id
      $('#comments').prepend(data.partial)
      checkMe(data.comment.id, data.username)

  updateComment = (data) ->
    if $('.comments-container').data().id == data.post.id
      $(".comment-child[data-id=#{data.comment.id}]").after(data.partial).remove();
      checkMe(data.comment.id, data.username)

  destroyComment = (data) ->
    if $('.comments-container').data().id == data.post.id
      $(".comment-child[data-id=#{data.comment.id}]").remove();

  if $('.comments-container').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("user logged in")

    disconnected: () ->
      console.log("user logged out")

    received: (data) ->
      console.log(data);
      switch data.type
        when "create" then createComment(data)
        when "update" then updateComment(data)
        when "destroy" then destroyComment(data)


$(document).on 'turbolinks:load', postsChannelFunctions
