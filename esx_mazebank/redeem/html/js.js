let ResourceName = GetParentResourceName()
$(document).ready(function () {
  window.addEventListener("message", function (event) {
    if (event.data.action == "CodeMenu") {
      $("body").css("display", "flex");
      $(".firstScreen").css("display", "flex");
      $(".twoScreen").css("display", "none");
    } else if (event.data.action == "CodeMyMenu") {
      $("body").css("display", "flex");
      $(".firstScreen").css("display", "none");
      $(".twoScreen").css("display", "flex");
      $(".mycodeBox").html(event.data.code);
      number = event.data.price;
      $(".bigPrizePrice").html(
        "$" + number.toLocaleString("en-US", { minimumFractionDigits: 0 })
      );
    } else if (event.data.action == "listed") {
      html =
        `
      <div class="prizeBoxs">
      <div class="prizeNumber">` +
        event.data.k +
        `</div>
      <div class="noprizeBox">
        <div class="prizeName">Money</div>
        <div
          class="prizeImg"
          style="background-image: url(./img/prize.png)"
        ></div>
        <div class="prizePrice">$ ` +
        event.data.price +
        `</div>
      </div>
    </div>
      `;
      $(".prizeSide").prepend(html);
    } else if (event.data.action == "listed-ok") {
      html =
        `
      <div class="prizeBoxs" >
      <div class="prizeNumber">` +
        event.data.k +
        `</div>
      <div class="noprizeBox" style="background: radial-gradient(110.31% 110.31% at 50% 50%, rgba(255, 255, 255, 0.45) 0%, rgba(255, 255, 255, 0) 100%);">
        <div class="prizeName">Money</div>
        <div
          class="prizeImg"
          style="background-image: url(./img/prize-okok.png)"
        ></div>
        <div class="prizePrice">$ ` +
        event.data.price +
        `</div>
      </div>
    </div>
      `;
      $(".prizeSide").prepend(html);
    } else if (event.data.action == "listed-okok") {
      html =
        `
      <div class="prizeBoxs">
      <div class="prizeNumber">` +
        event.data.k +
        `</div>
      <div class="noprizeBox" style="background: radial-gradient(80% 80% at 50% 50%, rgba(0, 148, 255, 0.43) 0%, rgba(0, 148, 255, 0) 100%), radial-gradient(110.31% 110.31% at 50% 50%, rgba(255, 255, 255, 0.21) 0%, rgba(255, 255, 255, 0) 100%); ">
        <div class="prizeName">Money</div>
        <div
          class="prizeImg"
          style="background-image: url(./img/prize-ok.png)"
        ></div>
        <div class="prizePrice">$ ` +
        event.data.price +
        `</div>
      </div>
    </div>
      `;
      $(".prizeSide").prepend(html);
    }
  });
});

$(document).on("keydown", function (event) {
  switch (event.keyCode) {
    case 27: // ESC
      CloseMenu();
  }
});

function clollect() {
    $.post("http://BakiTelli_references/collect");
    Swal.fire({
        icon: "success",
        title: "Successfully Collected",
        background: "rgba(1, 4, 6, 0.90)",
        width: 600,
        padding: "3em",
        color: "#FFFFFF",
        showConfirmButton: false,
        timer: 1000,
    });
    setTimeout(function () {
        CloseMenu();
    }, 2000);
}

let spam = false

function accept() {
    if (spam){ return };
    spam = true
    fetch(`https://${ResourceName}/accept`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            code: $("#code_input").val()
        })
    }).then(resp => resp.json()).then(valid => {
        if (valid){
            Swal.fire({
                icon: "success",
                title: valid,
                background: "rgba(1, 4, 6, 0.90)",
                width: 600,
                padding: "3em",
                color: "#FFFFFF",
                showConfirmButton: false,
                timer: 3000,
            });
            setTimeout(function () {
                spam = false
                CloseMenu();
            }, 3000);
        }else{
            Swal.fire({
                icon: "error",
                title: "Code Vared Shode Sahih Nist",
                background: "rgba(1, 4, 6, 0.90)",
                width: 600,
                padding: "3em",
                color: "#FFFFFF",
                showConfirmButton: false,
                timer: 3000,
            });
            setTimeout(function () {
                spam = false
            }, 3000);
        }
    });
}

function copy() {
  var mycodeBox = document.querySelector(".mycodeBox");
  var textToCopy = mycodeBox.innerText;
  var textarea = document.createElement("textarea");
  textarea.value = textToCopy;
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand("copy");
  document.body.removeChild(textarea);
  Swal.fire({
    icon: "success",
    title: "Successfully Coppied",
    background: "rgba(1, 4, 6, 0.90)",
    width: 600,
    padding: "3em",
    color: "#FFFFFF",
    showConfirmButton: false,
    timer: 1000,
  });
}

function CloseMenu() {
  $("body").css("display", "none");
  $(".prizeSide").empty();
  $.post(`https://${ResourceName}/close`);
}
