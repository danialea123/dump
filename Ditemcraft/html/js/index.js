$(document).keyup(function (e) {
  if (e.key === "Escape") {
    $(".container-fluid").css("display", "none");
    $.post("http://Ditemcraft/fechar", JSON.stringify({}));
  }
});
$(document).ready(function () {
  window.addEventListener("message", function (event) {
    var item = event.data;
    if (item.ativa == true) {
      $(".container-fluid").css("display", "block");
    } else if (item.ativa == false) {
      $(".container-fluid").css("display", "none");
    }
  });

  $("#1").click(function () {
    $.post("http://Ditemcraft/1", JSON.stringify({}));
    2;
  });

  $("#2").click(function () {
    $.post("http://Ditemcraft/2", JSON.stringify({}));
    2;
  });

  $("#3").click(function () {
    $.post("http://Ditemcraft/3", JSON.stringify({}));
    2;
  });

  $("#4").click(function () {
    $.post("http://Ditemcraft/4", JSON.stringify({}));
    2;
  });

  $("#5").click(function () {
    $.post("http://Ditemcraft/5", JSON.stringify({}));
  });
  $("#6").click(function () {
    $.post("http://Ditemcraft/6", JSON.stringify({}));
  });
  $("#7").click(function () {
    $.post("http://Ditemcraft/7", JSON.stringify({}));
  });
  $("#8").click(function () {
    $.post("http://Ditemcraft/8", JSON.stringify({}));
  });
  $("#9").click(function () {
    $.post("http://Ditemcraft/9", JSON.stringify({}));
  });
  $("#10").click(function () {
    $.post("http://Ditemcraft/10", JSON.stringify({}));
  });
});

let scale = 0;
const cards = Array.from(document.getElementsByClassName("job"));
const inner = document.querySelector(".inner");

function slideAndScale() {
  cards.map((card, i) => {
    card.setAttribute("data-scale", i + scale);
    inner.style.transform = `translateX(${scale * 16}em)`;
  });
}

(function init() {
  slideAndScale();
  cards.map((card, i) => {
    card.addEventListener(
      "click",
      () => {
        const id = card.getAttribute("data-scale");
        //if (id !== 1) {
        scale -= id;
        slideAndScale();
        //}
      },
      false
    );
  });
})();
