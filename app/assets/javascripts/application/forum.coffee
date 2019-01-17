$(document).on 'click', '.submit-sub-settings', (e) ->
  forms = $("#subscription_modal form")
  $(forms[1]).find(".active").trigger('click') # without this radio pill inputs are not set
  checked_plan = $(forms[0]).find("input[type=radio]:checked").val()
  if checked_plan > 0
    $("#subscription_billing_type").val($($(forms[1]).find("input[type=radio]:checked")[checked_plan-1]).val())
  serialized = $(forms[0]).serializeArray()
  $.ajax
    type: 'GET'
    url: '/forum_subscriptions/create'
    data: serialized
    success: (data) ->
      console.log data
      window.location = '/business/settings/subscriptions'

$(document).on 'click', '.remote-submit-answer', (e) ->
  commenting = $(e.target).hasClass("add_forum_comment")
  form = $(this).closest("form")
  form_parent = form.parent().parent()
  if form.find("textarea[name='forum_answer[body]']").val().length > 0
    if $("input[name='forum_answer[file]']")[1].files.length == 0
      $.ajax
        type: 'POST'
        url: form.attr("action")
        data: form.serialize()
        success: (data) ->
          if commenting
            form_parent.append data
            pushed = form_parent.find(".forum_reply").last()
            pushed.addClass("new_forum_comment")
            $("textarea[name='forum_answer[body]']").val("")
            $("html").animate({scrollTop:(pushed.offset().top-300)}, 500, 'swing');
          else
            $(".answers_container").append data
            pushed = $(".answers_container").find(".forum_answer").last()
            pushed.addClass("new_forum_answer")
            #$(".forum_answer_form").detach().appendTo $(".answers_container")
            $('#forum_answer_reply_to').val ''
            $("#forum_answer_body").val ''
            $("html").animate({scrollTop:($(".answers_container").height())}, 500, 'swing');
    else
      form.submit()

$(document).on 'click', '.forum_upvote', (e) ->
  cont = $(this).parent()
  answer_id = cont.attr("data-answer-id")
  $.ajax
    type: 'GET'
    url: '/ask-a-specialist/upvote/'+answer_id
    success: (data) ->
      cont.html(data)
  return false

$(document).on 'click', '.forum_downvote', (e) ->
  cont = $(this).parent().parent()
  answer_id = cont.attr("data-answer-id")
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
