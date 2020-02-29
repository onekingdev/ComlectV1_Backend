$(document).ready(function() {
  if (typeof(_audit_request_id) != "undefined") {
    $("html, body").stop().animate({scrollTop:$("#_audit_request_"+_audit_request_id).position().top-100}, 500, 'swing');
  }
})