$(function () {
  function display(bool) {
      if (bool) {
          $("#uiPage").show();
      } else {
          $("#uiPage").hide();
      }
  }

  display(false)

  window.addEventListener('message', function(event) {
      var item = event.data;
      if (item.type === "ui") {
          if (item.status == true) {
              display(true)
          } else {
              display(false)
          }
      }
  })

  document.onkeyup = function (data) {
    if (data.which == 27) {
        $.post('http://esx_addoninventory/exit', JSON.stringify({}));
        return
    }
};

$("#submit").click(function () {
  $.post('http://esx_addoninventory/submit', JSON.stringify({
      ok: true,
  }));
  return;
})
})