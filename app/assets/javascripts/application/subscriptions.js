$(document).ready(function() {


  function renewSub(e) {
    e.preventDefault();

    let form = $(this).parents('form');
    let label = $(this)

    $(this).addClass('loading');
    label.unbind('click');

    $.ajax({
      url: form.attr('action') + '.json',
      type: 'PUT',
      success: function (res) {
        if (res.status === 'ok') {
          if (res.renew === true) {
            console.log(form.find('.renew-input'));
            form.find('.renew-input').attr('checked', true)
            label.addClass('checked');
          } else {
            form.find('.renew-input').removeAttr('checked');
            label.removeClass('checked');
          }
        }
        $('.renew-btn').on('click', renewSub);
        label.removeClass('loading');
      },
      error: function (res) {
        $('.renew-btn').on('click', renewSub);
        label.removeClass('loading');
      }
    })
  }

  $('.renew-btn').on('click', renewSub);
});
