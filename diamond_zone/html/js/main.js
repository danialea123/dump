const time = document.getElementById("Timer");
var circleA;
var circleB;
var circleC;
var circleD;


$(document).ready(function () {
  $.post(
    "https://" + GetParentResourceName() + "/NUIReady",
    JSON.stringify({})
  );
  window.addEventListener("message", function (event) {
    var edata = event.data;
    if (edata.type == "showHud") {
      $(".hud").addClass("active");
      circleA = new ProgressBar.Circle("#progressA", {
        color: "#6cb7d6",
        strokeWidth: 5.1,
        trailColor: "#dbdbdbb8",
        text: {
          value: "A",
          className: "progressbar__label",
          style: {},
          autoStyleContainer: true,
          alignToBottom: false,
        },
        duration: 3000,
        easing: "easeInOut",
        step: function (state, circle) {
          const value = Math.round(circle.value() * 100);
          circle.setText(`A<br>${value}%`);
        },
      });
      circleA.set(0);

      circleB = new ProgressBar.Circle("#progressB", {
        color: "#6cb7d6",
        strokeWidth: 5.1,
        trailColor: "#dbdbdbb8",
        text: {
          value: "B",
          className: "progressbar__label",
          style: {},
          autoStyleContainer: true,
          alignToBottom: false,
        },
        duration: 3000,
        easing: "easeInOut",
        step: function (state, circle) {
          const value = Math.round(circle.value() * 100);
          circle.setText(`B<br>${value}%`);
        },
      });
      circleB.set(0);

      circleC = new ProgressBar.Circle("#progressC", {
        color: "#6cb7d6",
        strokeWidth: 5.1,
        trailColor: "#dbdbdbb8",
        text: {
          value: "C",
          className: "progressbar__label",
          style: {},
          autoStyleContainer: true,
          alignToBottom: false,
        },
        duration: 3000,
        easing: "easeInOut",
        step: function (state, circle) {
          const value = Math.round(circle.value() * 100);
          circle.setText(`C<br>${value}%`);
        },
      });
      circleC.set(0);
      circleD = new ProgressBar.Circle("#progressD", {
        color: "#6cb7d6",
        strokeWidth: 5.1,
        trailColor: "#dbdbdbb8",
        text: {
          value: "D",
          className: "progressbar__label",
          style: {},
          autoStyleContainer: true,
          alignToBottom: false,
        },
        duration: 3000,
        easing: "easeInOut",
        step: function (state, circle) {
          const value = Math.round(circle.value() * 100);
          circle.setText(`D<br>${value}%`);
        },
      });
      circleD.set(0);
    } else if (edata.type == "UpdateHud") {
      if (edata.action == "ZoneA") {
        circleA.set(edata.value);
      } else if (edata.action == "ZoneB") {
        circleB.set(edata.value);
      } else if (edata.action == "ZoneC") {
        circleC.set(edata.value);
      } else if (edata.action == "ZoneD") {
        circleD.set(edata.value);
      } else if (edata.action == "GameTime") {
        time.textContent = edata.value;
      }
    } else if (edata.type == "HideHud") {
      $(".hud").removeClass("active");
      time.textContent = "--:--:--";
      if (circleA) {
        circleA.destroy();
      }
      if (circleB) {
        circleB.destroy();
      }
      if (circleC) {
        circleC.destroy();
      }
      if (circleD) {
        circleD.destroy();
      }
    } else if (edata.type == "newKill") {
      addKill(edata.killer, edata.killed, edata.weapon);
    } else if (edata.type == "newDeath") {
      newDeath(edata.killed);
    }
  });
});

function addKill(killer, killed, weapon) {
  const $killElement = $(
    `<div class="killContainer">
          <span class="killer">${killer}</span>
          <img src="img/${weapon}.webp" class="weapon">
          <span class="killed">${killed}</span>
      </div><br class="clear">`
  );

  $killElement.prependTo(".kills").css({
    transform: "translateX(-100%)",
    opacity: 0,
  });

  setTimeout(() => {
    $killElement.css({
      transform: "translateX(0)",
      opacity: 1,
    });
  }, 10);

  setTimeout(() => {
    $killElement.css({
      transform: "translateX(-100%)",
      opacity: 0,
    });

    setTimeout(() => {
      $killElement.remove();
    }, 1000);
  }, 5000);
}

function newDeath(killed) {
  const $deathElement = $(
    `<div class="killContainer">
          <span class="killer">${killed}</span>
          <img src="img/weapon_unarmed.webp" class="weapon">
          <span class="killed">${killed}</span>
      </div><br class="clear">`
  );

  $deathElement.prependTo(".kills").css({
    transform: "translateX(-100%)",
    opacity: 0,
  });
  setTimeout(() => {
    $deathElement.css({
      transform: "translateX(0)",
      opacity: 1,
    });
  }, 10);

  setTimeout(() => {
    $deathElement.css({
      transform: "translateX(-100%)",
      opacity: 0,
    });

    setTimeout(() => {
      $deathElement.remove();
    }, 1000);
  }, 5000);
}
