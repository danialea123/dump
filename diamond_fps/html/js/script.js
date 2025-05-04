var urls = {};
$(document).ready(function () {
  window.addEventListener("message", function (event) {
    if (event.data.action == "OpenMenu") {
      $("body").css("display", "block");
    } else if (event.data.action == "addMenus") {
      info = event.data.details;
      if (event.data.details.typ == "ranger") {
        html =
          `
          <div class="Setting Setting1">
          <div class="SettingName">` +
          info.name +
          `</div>
          <div class="RangerBar">
            <div class="NextRange"></div>
            <input onchange="ChangeSetting('` +
          event.data.menuid +
          `','` +
          event.data.altid +
          `',this.value)" min="` +
          info.range.min +
          `" max="` +
          info.range.max +
          `" value="` +
          info.range.value +
          `" type="range" />
          </div>
        </div>
        `;
      } else {
        html =
          `
        <div class="Setting Setting2" id="` +
          event.data.menuid +
          `_` +
          event.data.altid +
          `" onclick="ChangeSetting2('` +
          event.data.menuid +
          `','` +
          event.data.altid +
          `')">
          <div class="NextRange"></div>
          <div class="SettingText">` +
          info.name +
          `</div>
        </div>
      `;
      }

      if (event.data.menu == "A") {
        $("#FpsMenu1").prepend(html);
      } else if (event.data.menu == "B") {
        $("#FpsMenu2").prepend(html);
      } else if (event.data.menu == "C") {
        $("#FpsMenu3").prepend(html);
      }
    } else if (event.data.action == "fpsupdate") {
      $(".TotalFPS t").html(event.data.Fps);
    } else if (event.data.action == "addURL") {
      urls = event.data.url;
    }
  });
});

$(document).on("keydown", function (event) {
  switch (event.keyCode) {
    case 27: // ESC
      closeAll();
  }
});

function closeAll() {
  $("body").css("display", "none");
  $.post("https://diamond_fps/close");
}

function ChangeSetting(menuid, altid, num) {
  $.post(
    "https://diamond_fps/ChangeSetting",
    JSON.stringify({
      typ: "range",
      menuid: menuid,
      altid: altid,
      num: num,
    })
  );
}

function ChangeSetting2(menuid, altid) {
  if ($("#" + menuid + "_" + altid).css("opacity") == 1) {
    $("#" + menuid + "_" + altid).css("opacity", "0.5");
  } else {
    $("#" + menuid + "_" + altid).css("opacity", "1");
  }
  $.post(
    "https://diamond_fps/ChangeSetting",
    JSON.stringify({
      typ: "on_off",
      menuid: menuid,
      altid: altid,
    })
  );
}

function openWeb(typ) {
  if (typ == "dc") {
    url = urls.Discord;
  } else {
    url = urls.Web;
  }
  window.invokeNative("openUrl", url);
}

function OpenSettings() {
  closeAll();
  $.post("https://diamond_fps/Settings");
}

function Reset() {
  $("#FpsMenu1").empty();
  $("#FpsMenu2").empty();
  $("#FpsMenu3").empty();
  $.post("https://diamond_fps/reset");
  closeAll();
}
