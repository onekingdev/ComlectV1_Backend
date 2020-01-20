$(document).ready(function() {
  if (typeof(audit_request_render_id) != "undefined") {
    var requestloop = setInterval(function() {
      $.ajax({
        type: 'GET',
        url: "/business/audit_requests/"+audit_request_render_id+"json",
        success: function(data) {
          if (data.preview != false) {
            $(".pdf_preview_area").html("<iframe height='500px' src='/pdfjs/minimal?file="+encodeURIComponent(data.preview)+"' width='100%'></iframe>");
            clearInterval(requestloop);
          }
        }
      });
    }, 3000)
  }
})