var PlantId = " "
$(document).ready(function() {

    window.addEventListener('message', function(event) {
      var data = event.data;
      PlantId = data.plantId

      $("#close-button").css("display", data.nuiFocus ? "block" : "none");
    
      if (data.nuiFocus == true){
        $("#general").css("background-color","rgba(33, 37, 41, 0.6)");
      }else{
        $("#general").css("background-color","rgba(33, 37, 41, 0.3)");
      }
       $("#plant-logo").css("content","url('img/"+data.plantType+".png')"); 
      if (data["harvest"] != false && data["harvest"] != null) {
        $("#progbar-harvest").css("display","block");
        $("#prog-ust-yazi-harvest").html(data["harvest"].title);
        $("#prog-sol-yazi-harvest").html(data["harvest"].time);
        $("#prog-sag-yazi-harvest").html(data["harvest"].percent);
        $("#prog-in-bar-harvest").css("width",data["harvest"].percent);
       
      } else{
        $("#progbar-harvest").css("display","none");
      }

      if (data["quality"] != false && data["quality"] != null) {
        $("#progbar-quality").css("display","block");
        $("#prog-ust-yazi-quality").html(data["quality"].title);
        $("#prog-sol-yazi-quality").html(data["quality"].time);
        $("#prog-sag-yazi-quality").html(data["quality"].percent);
        $("#prog-in-bar-quality").css("width",data["quality"].percent);
      } else{
        $("#progbar-quality").css("display","none");
      }

      if (data["water"] != false && data["water"] != null) {
        $("#progbar-water").css("display","block");
        $("#prog-ust-yazi-water").html(data["water"].title);
        $("#prog-sol-yazi-water").html(data["water"].time);
        $("#prog-sag-yazi-water").html(data["water"].percent);
        $("#prog-in-bar-water").css("width",data["water"].percent);
      } else{
        $("#progbar-water").css("display","none");
      }

      if (data["fertilizer"] != false && data["fertilizer"] != null) {
        $("#progbar-fertilizer").css("display","block");
        $("#prog-ust-yazi-fertilizer").html(data["fertilizer"].title);
        $("#prog-sol-yazi-fertilizer").html(data["fertilizer"].time);
        $("#prog-sag-yazi-fertilizer").html(data["fertilizer"].percent);
        $("#prog-in-bar-fertilizer").css("width",data["fertilizer"].percent);
      } else{
        $("#progbar-fertilizer").css("display","none");
      }

      if (data["decay"] != false && data["decay"] != null) {
        $("#progbar-decay").css("display","block");
        $("#prog-ust-yazi-decay").html(data["decay"].title);
        $("#prog-sol-yazi-decay").html(data["decay"].time);
        $("#prog-sag-yazi-decay").html(data["decay"].percent);
        $("#prog-in-bar-decay").css("width",data["decay"].percent);
      } else{
        $("#progbar-decay").css("display","none");
      }
      
      if (data["btnWater"] )    {$("#btn-txt-water").html(data["btnWater"]);     $("#prg-btn-water").css("display","block");}     else{$("#prg-btn-water").css("display","none");}
      if (data["btnHarvest"] )  {$("#btn-txt-harvest").html(data["btnHarvest"]);   $("#prg-btn-harvest").css("display","block");}   else{$("#prg-btn-harvest").css("display","none");}
      if (data["btnFertilizer"]){$("#btn-txt-fertilizer").html(data["btnFertilizer"]);$("#prg-btn-fertilizer").css("display","block");}else{$("#prg-btn-fertilizer").css("display","none");}
      if (data["btnFire"])      {$("#btn-txt-fire").html(data["btnFire"]);      $("#prg-btn-fire").css("display","block");}      else{$("#prg-btn-fire").css("display","none");}

      $("body").css("display", data.show ? "block" : "none");

    })


    $("#prg-btn-water").click(function()      {
      $("#prg-btn-water").css("display","none");
      $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event :"water"
        }));
    });
    
    $("#prg-btn-fertilizer").click(function() {
      $("#prg-btn-fertilizer").css("display","none");
      $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event :"fertilizer"
        }));
    });
    
    $("#prg-btn-fire").click(function()       {
      $("#prg-btn-fire").css("display","none");
      $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event : "fire"
        }));
    });
    
    $("#prg-btn-harvest").click(function()    {
      $("#prg-btn-harvest").css("display","none");
      $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event : "harvest"
        }));
    });
    
    $("#close-button").click(function()         {
      $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event : "close"
        }));
    });

    $(document).on('keydown', function() {
      switch(event.keyCode) {
          case 8: // D
          $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event : "close"
        }));
              break;
          case 27: // A
          $.post('https://plt_plants/action', JSON.stringify({
            plantId : PlantId,
            event : "close"
        }));
              break;
      }
  });

})



