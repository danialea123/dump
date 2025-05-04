$(function() {
     window.addEventListener('message', function(event) {
         var data = event.data   
         if(data.type == "addGame" ) {
             let div = `<div onclick="openGame('`+data.url+`')" class="allGamesBox `+data.label+`">
             <img id="allGameSett" src="images/game/`+data.image+`">
         </div>`
          $('#lastPage').append(div)
         }
         if(data.type == "addLastGame" ) {
          let div = `<div onclick="openGame('`+data.url+`')" class="gameOne">
          <img id="gamePhoto" src="images/game/`+data.image+`">
      </div>`
       $('#gamesBox').append(div)
      }
      if(data.type == "updateImage" ) {
          $('.pp').attr('src', data.image)
     }
     if(data.type == "open" ) {
          $('body').show()
          setTimeout(function(){
               $('#consoleBox').css('top', '10vw')
          }, 200);
     }
     })
})

function openGame(url) {
     $('#gameArea').show()
     let div = `<iframe src="`+url+`" id="game"></iframe>`
     $('#gameArea').append(div)
}

function exitGame() {
     $('#gameArea').hide()
     $('#game').remove()

}

function updateDate() {
     const d = new Date();
     let m = addZero(d.getMinutes());
     let h = addZero(d.getHours());
     let year = d.getFullYear().toString()[2]+d.getFullYear().toString()[3]
     let month = addZero(d.getMonth() + 1)
     let day = d.getDate()

     $("#consoleTime").text(h+":"+m)
     $('#dateText').text(day+"."+month+"."+year)
}
 
function addZero(i) {
     if (i < 10) {i = "0" + i}
     return i;
}   
 
 
setInterval(updateDate, 5000); 

$(document).on('keydown', function() {
     switch (event.keyCode) {
          case 27:
          exit()
          break;
     }
});
 

 function exit() {
     $.post(`https://${GetParentResourceName()}/exit`);
     exitGame()
     $('#consoleBox').css('top', '65vw')
     setTimeout(function(){
          $('body').hide()
     }, 700);
 }