$(document).on 'click', '.forum_answer .forum_reply_btn', (e) ->
  answer_id = parseInt($(this).attr('data-answer-id'))
  next_thread = $(this).parent().parent().next('.thread')
  if next_thread.length == 0
    next_thread = $(this).parent().parent().parent()
  $('.forum_answer_form').detach().appendTo next_thread
  $('#forum_answer_reply_to').val answer_id
  $('#forum_answer_body').focus()
  return

$(document).on 'click', '.remote-submit-answer', (e) ->
  form = $(this).closest("form")
  form_parent = form.parent().parent()
  $.ajax
    type: 'POST'
    url: form.attr("action")
    data: form.serialize()
    success: (data) ->
      form_parent.append data
      $(".forum_answer_form").detach().appendTo $(".answer_form_wrapper")
      $('#forum_answer_reply_to').val ''
      $("#forum_answer_body").val ''

$(document).on 'click', '.forum_upvote', (e) ->
  cont = $(this).parent()
  answer_id = $(this).parent().find(".forum_reply_btn").attr("data-answer-id")
  $.ajax
    type: 'GET'
    url: '/ask-a-specialist/upvote/'+answer_id
    success: (data) ->
      cont.html(data)
  return false

$(document).on 'click', '.forum_downvote', (e) ->
  cont = $(this).parent()
  answer_id = $(this).parent().find(".forum_reply_btn").attr("data-answer-id")
  $.ajax
    type: 'GET'
    url: '/ask-a-specialist/downvote/'+answer_id
    success: (data) ->
      cont.html(data)
  return false

$(window).on 'load', ->
  if typeof(show_sign_up_modal) != "undefined"
    if show_sign_up_modal == true
      $(".sign_up_navbar_link").trigger('click')
  if typeof(show_subscriptions) != "undefined"
    if show_subscriptions == true
      $("#subscribe-modal").modal('show')