const center_x = 117.3;
const center_y = 172.8;
const scale_x = 0.02072;
const scale_y = 0.0205;
mymap = undefined;
let blipdata = [];

// https://discord.gg/vf1
//speech recognition


//auto pilot
var AutoPilotNameExist = false;
var contentSizeBtn = $("#content-contain-size-button");
var emergencyBtn = $("#emergencyBtn");
var danceBtn = $("#danceBtn");
var parkBtn = $("#parkBtn");
var openHood = $("#openHood");
var openTrunk = $("#openTrunk");
var days = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];
var drivestyleNumber = 0;
var otopilotActive = false;
//#region livemap
CUSTOM_CRS = L.extend({}, L.CRS.Simple, {
  projection: L.Projection.LonLat,
  scale: function (zoom) {
    return Math.pow(2, zoom);
  },
  zoom: function (sc) {
    return Math.log(sc) / 0.6931471805599453;
  },
  distance: function (pos1, pos2) {
    var x_difference = pos2.lng - pos1.lng;
    var y_difference = pos2.lat - pos1.lat;
    return Math.sqrt(x_difference * x_difference + y_difference * y_difference);
  },
  transformation: new L.Transformation(scale_x, center_x, -scale_y, center_y),
  infinite: true,
});

function customIcon(icon) {
  return L.icon({
    iconUrl: `assets/${icon}.png`,
    iconSize: [20, 20],
    iconAnchor: [20, 20],
    popupAnchor: [-10, -27],
  });
}

var ExampleGroup = L.layerGroup();
var Icons = {
  Example: ExampleGroup,
};
(AtlasStyle = L.tileLayer("mapStyles/styleAtlas/{z}/{x}/{y}.jpg", {
  minZoom: 0,
  maxZoom: 5,
  noWrap: true,
  continuousWorld: false,
  attribution: "Online map GTA V",
  id: "styleAtlas map",
})),
  (AttrMap = function (data, date, isroute, id) {
    $("#map").html("");
    if (mymap) {
      mymap.off();
      mymap.remove();
    }
    mymap = L.map("map", {
      crs: CUSTOM_CRS,
      zoomControl: false,
      minZoom: 1,
      maxZoom: 5,
      Zoom: 5,
      maxNativeZoom: 5,
      preferCanvas: true,
      attributionControl: false,
      layers: [AtlasStyle],
      center: [0, 0],
      zoom: 3,
    });
    SetBG();
  });

SetBG = function () {
  $("#map").append("<div class='test'></div>");
};

var marker;
$(document).on("dblclick", "#map", function (e) {
  var latLng = mymap.mouseEventToLatLng(e.originalEvent);
  if (marker) {
    mymap.removeLayer(marker);
  }
  marker = L.marker([latLng.lat, latLng.lng], {
    icon: customIcon("directions/location-icon-active"),
    draggable: true,
    id: 1,
    autoPan: true,
  })
    .addTo(mymap)
    .bindPopup(
      `<div class ="general-buttons"> 
        <button class="autopilot-start" data-location="${
          latLng.lat.toFixed(2) + " " + latLng.lng.toFixed(2)
        }" data-type = "custom">
          <p>Destination</p>
        </button>
        <button class="saveBtn" data-location="${
          latLng.lat.toFixed(2) + " " + latLng.lng.toFixed(2)
        }"> 
          <p>Save Location</p>
        </button>
      </div>`
    );
  mymap.panTo(new L.LatLng(latLng.lat, latLng.lng));
  DraggindMarker();
  //console.log("latLng", JSON.stringify(latLng));
  //console.log(latLng.lat.toFixed(2) + " " + latLng.lng.toFixed(2));
  //console.log("latlng", JSON.stringify(latLng));
});

function DraggindMarker() {
  if (marker) {
    marker.on("dragend", function () {
      var position = marker.getLatLng();

      // Marker'ın konumunu güncelle
      marker.setLatLng(position, { draggable: "true" });
      $(this).data(
        "location",
        position.lat.toFixed(2) + " " + position.lng.toFixed(2)
      );
      console.log("data-", $(this).data("location"));
      //$(".autopilot-start").attr("data-location", position.lat.toFixed(2) + " " + position.lng.toFixed(2) );
      //new L.LatLng(position.lat, position.lng));

      // Haritayı yeni konuma odakla
      mymap.panTo(new L.LatLng(position.lat, position.lng));
    });
  }
}

$(document).ready(function () {
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:ready",
    JSON.stringify({}),
    function (data) {
      blipdata = data;
    }
  );
  // get autopilot name from localstorage
  var autopilotName = JSON.parse(localStorage.getItem("autopilotName"));
  if (autopilotName != null) {
    $(".autoPilotName").text(autopilotName);
    $.post("https://esx_ktackle/gfx:client:autopilot:AutoPilotName", JSON.stringify({ name: autopilotName }));
    AutoPilotNameExist = true;
  }
});
//#endregion

//auto pilot

window.addEventListener("message", function (event) {
  if (event.data.action == "gfx:client:autopilot:directionContainer") {
    $(".apilot-directions").css("animation", "slideoutdirection 0.5s forwards");
  }
});

contentSizeBtn.on("click", function () {
  if ($(".apilot-main").hasClass("-menu-opened")) {
    $(".apilot-main").removeClass("-menu-opened");
    $(".apilot-options").css("animation", "slideout 0.5s forwards");
  } else {
    if (!otopilotActive) {
      $(".apilot-options").css("animation", "slidein 0.5s forwards");
      $(".DrivingAutoPilot").addClass("hide");
      mymap.panTo(new L.LatLng(myposCoord.y, myposCoord.x));
    }else { $(".DrivingAutoPilot").removeClass("hide"); }
    $(".apilot-main").addClass("-menu-opened");
  }
});
emergencyBtn.on("click", function () {
  if (!otopilotActive)
  {
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:emptyDriverSeat",
    JSON.stringify({}),
    function (data) {
      $.post(
        "https://esx_ktackle/gfx:client:autopilot:emergency",
        JSON.stringify({ seatFree: data })
      );
      $(".apilot-directions").css(
        "animation",
        "slideindirection 0.5s forwards"
      );
      $(".apilot-main").removeClass("-menu-opened");
      $(".apilot-options").css("animation", "slideout 0.5s forwards");
    }
  );
  }else{
    $.post("https://esx_ktackle/gfx:client:autopilot:Notify", JSON.stringify({}));
  }
});
danceBtn.on("click", function () {
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:dance",
    JSON.stringify({})
  );
});
parkBtn.on("click", function () {
  if (!otopilotActive)
  {
    $.post("https://esx_ktackle/gfx:client:autopilot:park", JSON.stringify({}));
    $.post("https://esx_ktackle/gfx:client:autopilot:exit", JSON.stringify({ bool: false }.bool));
    $(".apilot-main").removeClass("-menu-opened");
    $(".apilot-options").css("animation", "slideout 0.5s forwards");
  }else{
    $.post("https://esx_ktackle/gfx:client:autopilot:Notify", JSON.stringify({}));
  }
});
openHood.on("click", function () {
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:openHood",
    JSON.stringify({})
  );
});
openTrunk.on("click", function () {
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:openTrunk",
    JSON.stringify({})
  );
});

var turnLeft = $(".leftDirection");
var turnRight = $(".rightDirection");
var turnStraight = $(".straightDirection");
var turnBack = $(".backDirection");
var hardRight = $(".hardRightDirection");
var hardLeft = $(".hardLeftDirection");


window.addEventListener("message", function (e) {
  const data = e.data;
  if (data.action == "gfx:copilot:direction") {
    GetDirectionData(
      data.direction,
      data.turndistance,
      data.currentLocation,
      data.destinationDistance,
      data.speedLimitSign
    );
  }
    //traffic light
    if(data.action == "gfx:copilot:trafficLight")
    {
      if (data.trafficLight == true ) {
        $(".trafficLight").css("display", "block");
      } else {
        setTimeout(() => {
          $(".trafficLight").css("display", "none");
        }, 1500);
      }
    }
});

// var directiontable = {
//   0: "i dont know",
//   1: " %s You are going the wrong direction",
//   2: "Please Proceed the Highlighted Route %s",
//   3: "In %s Turn Left",
//   4: "In %s Turn Right",
//   5: "In %s Keep Straight",
//   6: "In %s Turn Sharply To The Left",
//   7: "In %s Turn Sharply To The Right",
//   8: " %s Route is being recalculated or the navmesh is confusing.",
// };
function GetDirectionData(
  direction,
  turndistance,
  currentLocation,
  destinationDistance
) {
  if (direction == 2) {
    turnLeft
      .find("img")
      .attr("src", `assets/directions/roadroad.png`);
    turnLeft.find("h1").text(`${turndistance.toFixed(0)} m`);
    turnLeft.find("p").text(currentLocation);
  } else if (direction == 3) {
    turnLeft
      .find("img")
      .attr("src", `assets/directions/leftturn-icon-active.png`);
    turnLeft.find("h1").text(`${turndistance.toFixed(0)} m`);
    turnLeft.find("p").text(currentLocation);
  } else if (direction == 4) {
    turnLeft
      .find("img")
      .attr("src", `assets/directions/rightturn-icon-active.png`);
    turnLeft.find("h1").text(`${turndistance.toFixed(0)} m`);
    turnLeft.find("p").text(currentLocation);
  } else if (direction == 5) {
    turnLeft
      .find("img")
      .attr("src", `assets/directions/roadroad.png`);
    turnLeft.find("h1").text(`${turndistance.toFixed(0)} m`);
    turnLeft.find("p").text(currentLocation);
  } else if (direction == 6) {
    turnLeft
      .find("img")
      .attr("src", `assets/directions/hardleft-iconl.png`);
    turnLeft.find("h1").text(`${turndistance.toFixed(0)} m`);
    turnLeft.find("p").text(currentLocation);
  } else if (direction == 7) {
    turnLeft
      .find("img")
      .attr("src", `assets/directions/hardright-iconr.png`);
    turnLeft.find("h1").text(`${turndistance.toFixed(0)} m`);
    turnLeft.find("p").text(currentLocation);
  }
  $("#destinationDistance").text(`${destinationDistance} m`);
}

var mypos;
var myposCoord = [];
window.addEventListener("message", function (e) {
  const data = e.data;
  if (data.action == "gfx:copilot:openAndProcessData") {
    //live map live pos
    if (mymap) {
      if (mypos) {
        mymap.removeLayer(mypos);
      }
      let x = data.mypos.x;
      let y = data.mypos.y;
      mypos = L.marker([y, x], {
        icon: customIcon("directions/you"),
        draggable: false,
        id: "mypos",
      }).addTo(mymap)
      myposCoord.y = data.mypos.y;
      myposCoord.x = data.mypos.x;
    }
    if ($(".gfxautopilot-main-contain").height() <= 0) {
      Display(true);
      if (AutoPilotNameExist)
      {
        mymap.invalidateSize();
        mymap.panTo(new L.LatLng(data.mypos.y, data.mypos.x));
      }
    }

    //speed fuel limit
    $(".KMText h1").text(data.speed.toFixed(0));
    $(".fuel-text p").text(`${data.fuel.toFixed(0)}%`);
    $(".path").css("width", `${data.fuel.toFixed(0)}%`);

    if (data.speedLimit != undefined) {
      $(".speedLimitText").text(`${data.speedLimit}`);
    }
    //time data
    if (data.time.h > 18) {
      $("#gameTime").text(`${data.time.h}:${data.time.m} PM`);
    } else {
      $("#gameTime").text(`${data.time.h}:${data.time.m} AM`);
    }
    $("#gameDay").text(`${days[data.time.d]}`);

  }
  if (data.action == "gfx:copilot:vehicleInDirection") {
    if (data.direction == "left" || data.direction == "crossLeft") {
      leftCar.css("display", "block");
      redLeft.css("display", "block");
      leftRedArrow.css("display", "block");

      leftBlueArrow.css("display", "none");
      blueLeft.css("display", "none");
    }
    if (data.direction == "right" || data.direction == "crossRight") {
      rightCar.css("display", "block");
      redRight.css("display", "block");
      rightRedArrow.css("display", "block");

      rightBlueArrow.css("display", "none");
      blueRight.css("display", "none");
    }
    if (data.direction == "front") {
      midCar.css("display", "block");
    }
  }
  if (data.action == "gfx:copilot:vehicleInNotDirection") {
    if (data.direction == "left" || data.direction == "crossLeft") {
      leftCar.css("display", "none");
      redLeft.css("display", "none");
      leftRedArrow.css("display", "none");
      leftBlueArrow.css("display", "none");
      blueLeft.css("display", "block");
    }
    if (data.direction == "right" || data.direction == "crossRight") {
      rightCar.css("display", "none");
      redRight.css("display", "none");
      rightRedArrow.css("display", "none");
      rightBlueArrow.css("display", "none");
      blueRight.css("display", "block");
    }
    if (data.direction == "front") {
      midCar.css("display", "none");
    }
  }
  if (data.action == "gfx:autopilot:close") {
    if ($(".gfxautopilot-main-contain").height() != 0) {
      Display(false);
    }else if ($(".InformationPopup").css("display") == "block"){
      $(".popupScreen").css("background", "transparent");
      $(".InformationPopup").css("display", "none");
      //Display(false);
    }
  }
});

var blueLeft = $(".blueLeft");
var blueRight = $(".blueRight");
var redLeft = $(".redLeft");
var redRight = $(".redRight");
var leftRedArrow = $(".leftRedArrow");
var rightRedArrow = $(".rightRedArrow");
var leftBlueArrow = $(".leftBlueArrow");
var rightBlueArrow = $(".rightBlueArrow");
var leftCar = $(".leftCar");
var rightCar = $(".rightCar");
var midCar = $(".midCar");

$(document).on("click", ".autopilot-start", function () {
  var type = $(this).data("type");
  var location = $(this).data("location");
  $(".apilot-main").removeClass("-menu-opened");
  if (marker) {
  coordy = marker.getLatLng().lat.toFixed(2);
  coordx = marker.getLatLng().lng.toFixed(2);
  }else{
    coordy = location.split(" ")[0];
    coordx = location.split(" ")[1];
  }
  var speedType = $(".selected").data("speed");
  if (speedType == undefined || speedType == null) {
    speedType = "ecomode";
  }
  //var driveStyle = DrivestyleNumberTotal();

  if (type == "fixed") {
    $.post(
      "https://esx_ktackle/gfx:client:autopilot:emptyDriverSeat",
      JSON.stringify({}),
      function (data) {
        $.post(
          "https://esx_ktackle/gfx:client:autopilot:route",
          JSON.stringify({
            type: type,
            location: location,
            speedType: speedType,
            driveStyle:  DrivestyleNumberTotal(),
            seatFree: data,
          })
        );
      }
    );
    return;
  }
  if (type == "saved") {
    $.post(
      "https://esx_ktackle/gfx:client:autopilot:emptyDriverSeat",
      JSON.stringify({}),
      function (data) {
        $.post(
          "https://esx_ktackle/gfx:client:autopilot:route",
          JSON.stringify({
            type: type,
            coordx: coordx,
            coordy: coordy,
            speedType: speedType,
            driveStyle:  DrivestyleNumberTotal(),
            seatFree: data,
          })
        );
      }
    );
    return;
  }
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:emptyDriverSeat",
    JSON.stringify({}),
    function (data) {
      $.post(
        "https://esx_ktackle/gfx:client:autopilot:route",
        JSON.stringify({
          type: type,
          coordx: coordx,
          coordy: coordy,
          speedType: speedType,
          driveStyle:  DrivestyleNumberTotal(),
          seatFree: data,
        })
      );
    }
  );
});

$(document).on("click", ".direction-cancel-trip", function () {
  $.post(
    "https://esx_ktackle/gfx:client:autopilot:cancelTrip",
    JSON.stringify({})
  );
  otopilotActive = false;
  //$(".apilot-directions").css("animation", "slideoutdirection 0.5s forwards");
});

$(document).on("click", ".speedbtn", function () {
  $(".speedbtn").removeClass("selected");
  $(this).addClass("selected");
});

window.addEventListener("message", function (event) {
  if (event.data.action == "gfx:client:autopilot:otopilotActive") {
    otopilotActive = event.data.active;
    //console.log("otopilotActive", otopilotActive);
    if (otopilotActive == true) {
      $(".apilot-directions").css(
        "animation",
        "slideindirection 0.5s forwards"
      );
      $(".apilot-options").css("animation", "slideout 0.5s forwards");
      $(".DrivingAutoPilot").removeClass("hide");
    } else {
      $(".apilot-directions").css(
        "animation",
        "slideoutdirection 0.5s forwards"
      );
      $(".DrivingAutoPilot").addClass("hide");
    }
  }
});

//$(document).on("click", ".toggle-input", function () {
  //console.log($(this).val());
  //DrivestyleNumberTotal();
  //start dediğimde checked olmayanların valuesini toplayacağız çünkü checked olanlar off durumda oluyor
  //console.log("total", DrivestyleNumberTotal());
//});

$(document).on("click", ".saveBtn", function () {
  //var location = $(this).data("location");
  //$(".popupScreen").css("display", "flex");
  $(".enterNameLocation").css("display", "flex");
  $(".popupScreen").css("background", "rgba(37, 37, 37, 0.4)");

  $("#enterName").focus();
  $("#enterNameButton").on("click", function () {
    var name = $("#enterName").val();
    if (name.trim() === "") {
      return;
    }
    coordy = marker.getLatLng().lat.toFixed(2);
    coordx = marker.getLatLng().lng.toFixed(2);
    $(".enterNameLocation").css("display", "none");
    $(".popupScreen").css("background", "transparent");

    //$(".popupScreen").css("display", "none");
    LocationSave(coordx, coordy, name);
  });
});

function DrivestyleNumberTotal() {
  drivestyleNumber = 0;
  $(".toggle-input").each(function () {
    if (!$(this).prop("checked")) {
      //console.log($(this).parent().parent().find("h1").text());
      drivestyleNumber += parseInt($(this).val());
    }
  });
  //console.log("drivestyleNumber", drivestyleNumber);
  return drivestyleNumber;
}
function AddFixedPos() {
  if (mymap) {
    $.each(blipdata, function (k, v) {
      L.marker([v.coords.y, v.coords.x], {
        icon: customIcon(v.icon),
        draggable: false,
        id: k,
      })
        .addTo(mymap)
        .bindPopup(
          `<div class ="general-buttons"> <button class="autopilot-start" data-location=${k} data-type="fixed"><p>${k.toUpperCase()}</p></button></div>`
        );
      //console.log(JSON.stringify(k), JSON.stringify(v));
    });
  }
}
// localStorage
function LocationSave(coordx, coordy, name) {
  var location = {
    x: coordx,
    y: coordy,
    name: name,
  };
  var locations = JSON.parse(localStorage.getItem("SavedLocations")) || [];
  locations.push(location);
  localStorage.setItem("SavedLocations", JSON.stringify(locations));
  //console.log("LOCATION SAVE", JSON.stringify(locations));

  if (mymap) {
    // marker != undefined ? mymap.removeLayer(marker) : null;
    if (marker) {
      mymap.removeLayer(marker);
    }
    L.marker([coordy, coordx], {
      icon: customIcon("directions/location-icon-active"),
      draggable: false,
      id: coordx,
    })
      .addTo(mymap)
      .bindPopup(
        `<div class ="general-buttons"> 
            <button class="autopilot-start" data-location= "${
              coordy + " " + coordx
            }" data-type="saved">
              <p>${name.toUpperCase()}</p>
            </button>
            <button class="deleteBtn" data-location="${coordy + " " + coordx}">
              <p>Delete</p>
            </button>
          </div>`
      );
  }
}
function GetSavedLocations() {
  //get locations from localstorage
  var locations = JSON.parse(localStorage.getItem("SavedLocations")) || [];
  //console.log("GET LOCATION", JSON.stringify(locations));
  if (mymap) {
    if (locations.length > 0) {
      $.each(locations, function (k, v) {
        L.marker([v.y, v.x], {
          icon: customIcon("directions/fixedlocations"),
          draggable: false,
          id: k,
        })
          .addTo(mymap)
          .bindPopup(
            `<div class ="general-buttons"> 
                <button class="autopilot-start" data-location= "${
                  v.y + " " + v.x
                }" data-type="saved">
                  <p>${v.name.toUpperCase()}</p>
                </button>
                <button class="deleteBtn" data-location="${v.y + " " + v.x}">
                  <p>Delete</p>
                </button>
              </div>`
          );
      });
    }
  }
}

$(document).on("click", ".deleteBtn", function () {
  var location = $(this).data("location");
  var locations = JSON.parse(localStorage.getItem("SavedLocations")) || [];
  var newLocations = locations.filter(function (v) {
    return v.y + " " + v.x != location;
  });
  localStorage.setItem("SavedLocations", JSON.stringify(newLocations));
  //console.log("DELETE LOCATION", JSON.stringify(newLocations));
  if (mymap) {
    mymap.eachLayer(function (layer) {
      if (layer instanceof L.Marker) {
        if (layer.getLatLng().lat + " " + layer.getLatLng().lng == location) {
          mymap.removeLayer(layer);
        }
      }
    });
  }
});

function Display(bilgi) {
  var body = $(".gfxautopilot-main-contain");
  if (!AutoPilotNameExist) {
    $.post("https://esx_ktackle/gfx:client:autopilot:cursor", JSON.stringify({}));
    $(".popupScreen").css("background", "rgba(37, 37, 37, 0.4)");
    $(".InformationPopup").css("display", "block");
    $("#autoPilotNameSubmit").on("click", function (e) {
      var name = $("#otopilotName").val();
        if (name.trim() === "") {
          return;
        }
        $(".autoPilotName").text(name);
        localStorage.setItem("autopilotName", JSON.stringify(name));
        AutoPilotNameExist = true;
        $(".InformationPopup").css("display", "none");
        $(".popupScreen").css("background", "transparent");
        $.post("https://esx_ktackle/gfx:client:autopilot:AutoPilotName", JSON.stringify({ name: name }));
      body.css("animation", "slideInMain 0.5s forwards");
      AttrMap();
      AddFixedPos();
      GetSavedLocations();
    });
  }else{

    if (bilgi == true) {
      //body.css("display", "flex");
      body.css("animation", "slideInMain 0.5s forwards");
      AttrMap();
      AddFixedPos();
      GetSavedLocations();
    } else if (bilgi == false) {
      //body.css("display", "none");
      body.css("animation", "slideOutMain 0.5s forwards");
    }
  }
}

$(document).on("keydown", function (event) {
  if (event.keyCode == 27) {
    $.post(
      "https://esx_ktackle/gfx:client:autopilot:exit",
      JSON.stringify({ bool: false }.bool)
      //Display(false)
    );
  }
});
