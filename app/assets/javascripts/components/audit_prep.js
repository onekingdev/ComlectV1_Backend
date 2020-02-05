$(document).ready(function() {
  if (typeof(audit_request_render_id) != "undefined") {
    var bsurl = "/business/audit_requests/";
    if (typeof(audit_baseurl) != "undefined") {
      bsurl = audit_baseurl;
    }
    var requestloop = setInterval(function() {
      $.ajax({
        type: 'GET',
        url: bsurl+audit_request_render_id+"json",
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