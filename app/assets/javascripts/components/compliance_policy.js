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
        url: bsurl+compliance_policy_render_id+".json",
        success: function(data) {
          if (data.preview != false) {
            $(".pdf_preview_area").html("<iframe class='pdf_preview_fullheight' src='/pdfjs/minimal?file="+encodeURIComponent(data.preview)+"' width='100%'></iframe>");
            $(".cpolicy_downloadbtn").attr("href", data.preview).removeClass("disabled");
            $(".cpolicy_sharebtn").attr("href", data.email).removeClass("disabled");
            $(".pdf_preview_fullheight, .pdf_preview_area").height($($(".fullheight")[0]).height());
            clearInterval(requestloop);
          }
        }
      });
    }, 3000)
  }
  if ($(".compliance_policy_title_trigger").length > 0) {
    if ($(".compliance_policy_title_trigger").val().length > 0) {
      $(".cpolicy_or_name").slideUp();
      $(".compliance_policy_section").slideUp();
    }
  }
});

$("body").on("change", ".compliance_policy_section_trigger", function() {
  if ($(this).val().length > 0) {
    $(this).parent().parent().find(".policy_blank_case").slideUp();
  } else {
    $(this).parent().parent().find(".policy_blank_case").slideDown();
  }
});

$("body").on("keydown", ".compliance_policy_title_trigger", function() {
  _this = this;
  setTimeout(function() {
    if ($(_this).val().length > 0) {
      $(".cpolicy_or_name").slideUp();
      $(".compliance_policy_section").slideUp();
    } else {
      $(".cpolicy_or_name").slideDown();
      $(".compliance_policy_section").slideDown();
    }
  }, 50);
})

function new_compliance_policy_popup_from_name(name) {
  /*if ($("#new_compliance_policy_pixel").length > 0) {
    $("#new_compliance_policy_pixel").remove();
  }
  $("#footer").append("<a href='"+new_compliance_policy_url+"?title="+encodeURI(name)+"' data-toggle='modal' data-target='#modal' data-remote='true' id='new_compliance_policy_pixel'>&nbsp;</a>");

  $("#new_compliance_policy_pixel").trigger("click");*/
  var win = window.open((new_compliance_policy_url+"?title="+encodeURI(name)), "_blank");
  win.focus();
}

$("#new_compliance_policy_name").on('keydown', function(e) {
  if (e.keyCode == 13) {
    e.preventDefault;
    $("#new_compliance_policy_plusbtn").trigger("click");
    return false;
  }
});


$(".compliance_list").sortable({
    update: function(e, ui) {
        $.ajax({
            url: $(this).data("url"),
            type: "PUT",
            data: $(this).sortable('serialize'),
        });
    }
});

