window.ResourceName = 'capture'
$(document).ready(function(){
  $.post('https://'+ResourceName+'/NUIReady', JSON.stringify({}));
  window.addEventListener("message", function(event){
	  if(event.data.kill == true){
		  updateKillerBord(event.data.killlist);
	  }
    if(event.data.gang == true){
		  UpdateGangBoard(event.data.ganglist);
	  }
    if(event.data.change == true){
      $("#killlist").toggle(500);
      $("#GangList").toggle(500);
      $(".top-title").html("Top Killers");
    }
    else if(event.data.change == false){
      $("#killlist").toggle(500);
      $("#GangList").toggle(500);
      $(".top-title").html("Top Gangs");
    }
    if(event.data.update == true){
      clearInterval(x);
      $(".capturedby").text(event.data.Handeler);
      setProgress(event.data.Time);
    }else if(event.data.start == true){
      $(".capturename").text(titleCase(event.data.CapName));
	  if (event.data.CapName === "drug" || event.data.CapName === "skin" || event.data.CapName === "weapon" || event.data.CapName === "black_market")
	  {
		   $(".captureimg").css('background-image', 'url(assets/imgs/' + event.data.CapName.toLowerCase() + '.jpg');
	  }
	  else
	  {
       $(".captureimg").css('background-image', 'url(assets/imgs/black_market.jpg');
	  }
      $("body").fadeIn(400);
    }else if(event.data.stop == true){
      $("body").fadeOut(400);
    }
  });

//Edit Ahmad
//$("#killlist").fadeOut();
function updateKillerBord(data){
	 (function(){
		document.getElementById('killlist').innerHTML = "";
		 
        let ul = document.createElement('ul');
        ul.setAttribute('id','KillerList');
        
        let kills = data.sort((a, b) => {
			if (a.killcount > b.killcount) return -1;
			if (a.killcount < b.killcount) return 1;
			return 0;
			});

      

        document.getElementById('killlist').appendChild(ul);
        kills.forEach(renderProductList);

        function renderProductList(element, index, arr) {
			
			 if(index <= 5) {
				let li = document.createElement('li');
				li.setAttribute('class','item');

				ul.appendChild(li);


         if(element.name.length > 5)  {
          li.innerHTML = `${li.innerHTML} ${element.name.substring(0,5)}.. (${element.id}) [${element.gang}] <span>${element.killcount}</span>`; 
         } 
		    	else{
        li.innerHTML = `${li.innerHTML} ${element.name} (${element.id}) [${element.gang}] <span>${element.killcount}</span>`; 
        }
			 }
           
        }
    })();
}

function UpdateGangBoard(data){
  (function(){
   document.getElementById('GangList').innerHTML = "";
    
       let ul = document.createElement('ul');
       ul.setAttribute('id','GangSList');
       let Gang = data.sort((a, b) => {
     if (a.Score > b.Score) return -1;
     if (a.Score < b.Score) return 1;
     return 0;
     });

       document.getElementById('GangList').appendChild(ul);
       Gang.forEach(renderProductList2);

       function renderProductList2(element, index, arr) {
     
      if(index <= 5) {
       let li = document.createElement('li');
       li.setAttribute('class','item');

       ul.appendChild(li);



       li.innerHTML = `${li.innerHTML} ${element.name} ( ${element.capstr} ) <span>${element.Score}</span>`; 
      }
          
       }
   })();
}
  var x
  function setProgress(time){
    var mins 
    var secs 
    var distance = time+1;   
    var total = time / 100; 
    x = setInterval(function() {
      distance += -1;
      var percent =  100 - (distance/total);
      $('#myProgress').css("background-size", percent+"% 100%");
      if (distance > 600 && distance < 6000){
        mins = ("0" + Math.floor(distance/60)).slice(-2);
        secs = ("0" + Math.floor(distance%60)).slice(-2);
      }else{
        mins = ("0" + Math.floor(distance/60)).slice(-3);
        secs = ("0" + Math.floor(distance%60)).slice(-2);
      }
      $(".time").html(mins + ":" + secs); 

      if (distance <= 0) {
        clearInterval(x);
      }
    }, 1000);

  }

  function titleCase(str) {
    var splitStr = str.toLowerCase().split('_');
    for (var i = 0; i < splitStr.length; i++) {
        splitStr[i] = splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);     
    }
    return splitStr.join(' '); 
  }
});