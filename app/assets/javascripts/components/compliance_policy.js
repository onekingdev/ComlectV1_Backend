function hide_annual_compliance_fields() {
  $(".policy_blank_case").slideUp();
}

$(document).ready(function() {
  if (typeof(hide_annual_compliance_fields_trig) != "undefined") {
    hide_annual_compliance_fields();
  }
  if (typeof(compliance_policy_render_id) != "undefined") {
    var bsurl = "/business/compliance_policies/";
    if (typeof(compliance_policy_baseurl) != "undefined") {
      bsurl = compliance_policy_baseurl;
    }
    var requestloop = setInterval(function() {
      $.ajax({
        type: 'GET',
        url: bsurl+compliance_policy_render_id+"json",
        success: function(data) {
          if (data.preview != false) {
            $(".pdf_preview_area").html("<iframe height='500px' src='/pdfjs/minimal?file="+encodeURIComponent(data.preview)+"' width='100%'></iframe>");
            clearInterval(requestloop);
          }
        }
      });
    }, 3000)
  }
});

$("body").on("change", ".compliance_policy_section_trigger", function() {
  window.kek = this;
  if ($(this).val().length > 0) {
    $(this).parent().parent().find(".policy_blank_case").slideUp();
  } else {
    $(this).parent().parent().find(".policy_blank_case").slideDown();
  }
});