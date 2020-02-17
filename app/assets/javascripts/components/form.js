$(document).on('change', 'input[data-autosubmit]', function(e) {
  return $(this).parents('form').submit();
});

$(document).ready(function() {
  $('#education-histories').find('.remove_fields').first().removeClass('remove_fields').click(function(e) {
    return e.preventDefault();
  });
  $('#work-experiences').find('.remove_fields').first().removeClass('remove_fields').click(function(e) {
    return e.preventDefault();
  });
  var shadow_containers = $('.shadow_container');
  for (sc of shadow_containers) {
    $(sc).find('.remove_fields').first().removeClass('remove_fields').click(function(e) {
      return e.preventDefault();
    });
  }
});
