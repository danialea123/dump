var canPlay = false
var mute = false

$(function() {
  window.addEventListener('message', function(event) {
      var data = event.data   
      if(data.type == "selectPlayer" ) {
          $('body').show()
          $('.playerSelect').show()
          $('#mainPage').hide()
      }
      if(data.type == "openGame" ) {
        $('body').show()
        $('#playerPage').hide()
        $('#mainPage').show()
      //  createPlayer(data.max)
      }
      if(data.type == "addCard" ) {
        giveCard(data.chair, data.cardImage, data.id)
      }
      if(data.type == "randomCard" ) {
        addCenter(data.card)
      }
      if(data.type == "canPlay" ) {
        canPlay = true
      }
      if(data.type == "putCard" ) {
        putCard(data.card, data.mine, data.image)
      }
      if(data.type == "updateCard" ) {
        updateCard(data.chair, data.number)
      }
      if(data.type == "updateColor" ) {
        $('.colors').attr('src', 'images/colors/'+data.color+'.png')
      }
      if(data.type == "color" ) {
        $('.colorSelect').show()
      }
      if(data.type == "openChair" ) {
        $('.'+data.chair).show()
      }
      if(data.type == "resetChair" ) {
        $('.left').hide()
        $('.right').hide()
        $('.top').hide()
      }
      if(data.type == "updateProfil" ) {
        $('.'+data.chair+"Profil").attr('src', data.image)
        $('.'+data.chair+"Nick").text(data.nick)
      }
      if(data.type == "win" ) {
        $('.winTitle').text(data.nick+" won this game!")
        $('.winner').attr('src', data.image)
        $('.winArea').show()

        sound('winner')
      }
      if(data.type == "back" ) {
        $('body').show()
      }
      if(data.type == "close" ) {
        reset()
        $('body').hide()
        $('.winArea').hide()
      }
  })
})

function reset() {
  $('.otherCard').remove()
  $('.myCard').remove()
  $('.centerCard').remove()

  canPlay = false
}

function createPlayer(max) {
  $('.left').show()
  $('.right').show()
  if (max == 2){
    $('.left').hide()
    $('.right').hide()
  }
  else if(max == 3) {
    $('.right').hide()
  }
}

function giveMeCard() {
  if(canPlay) {
    $.post('https://diamond_uno/giveMeCard', JSON.stringify ({}));
    canPlay = false
  }
}

function selectColor(color) {
  $.post('https://diamond_uno/selectColor', JSON.stringify ({
    color: color
  }));
  $('.colorSelect').hide()
}

function updateCard(chair, number) {
  $('.card_'+chair).remove()
  for(var i = 0; i < number; i++){
    div = `<img class="otherCard card_`+chair+`" src="images/card.png">`
    $('.'+chair+"Card").append(div)
  }
  $("."+chair+'CardNumber').text(number+" Card")
}

function putCard(card, mine, image) {
  if(mine) {
    canPlay = false
  }
  else {
    $.post('https://diamond_uno/updateCard', JSON.stringify ({}));
  }
  $('.myCard_'+card).css('animation', 'center 0.5s linear')
  setTimeout(function(){
    addCenter(image)
    $('.myCard_'+card).remove()
  }, 500);
}

let number = 0

function animation(chair) {
  number++
  div = `<img class="animationCard rcard_`+number+`" src="images/card.png">`
  $('.animation').append(div)
  $('.rcard_'+number).css('animation', ''+chair+' 0.5s linear')
  deleteRCard(number)
}

function deleteRCard(number) {
  setTimeout(function(){
    $('.rcard_'+number).remove()
  }, 500);
}

function giveCard(chair, card, id) {
    animation(chair)

    if(chair == "me") {
      div = `<img onclick="playCard('`+id+`')" class="myCard myCard_`+id+`" src="images/cards/`+card+`.png">`
      $('.myCards').append(div)
    }
    else {
      div = `<img class="otherCard card_`+chair+`" src="images/card.png">`
      $('.'+chair+"Card").append(div)
    }
    sound('flip')
}

function playCard(id) {
  if(canPlay) {
    $.post('https://diamond_uno/putCard', JSON.stringify ({
      id: id
    }));
  }
  else {
  }
}

function startLobby(player) {
  $.post('https://diamond_uno/createGame', JSON.stringify ({
    player: player
  }));
  $('body').hide()
  $('.playerSelect').hide()
}


function addCenter(card) {
  div = `<img class="centerCard" src="images/cards/`+card+`.png">`
  $('.centerCardsArea').append(div)

  sound('flip')
  checkCenter()
}

function checkCenter() {
  let number = 0
  let first = undefined
  document.querySelectorAll(".centerCard").forEach(function(a){
    if(!first) {
      first = a
    }
    number++
  })
  if(number>4) {
    first.remove()
  }
}

let fullscreen = false

function fullScreen() {
  if(!fullscreen) {
    $('body').css('transform', 'scale(0.7)')
    fullscreen = true
  }
  else {
    $('body').css('transform', '')
    fullscreen = false
  }
}


function tab(){
  $('body').hide()
  $.post('https://diamond_uno/tab', JSON.stringify ({}));
}

function sound(a) {
  if(!mute){
    var snd = new Audio("sound/"+a+".wav"); // buffers automatically when created
    snd.play();
  }
}

function muteSound() {
  if(!mute){
    mute = true
    $('.mute').attr('src', 'images/mute.png')
  }
  else {
    mute = false
    $('.mute').attr('src', 'images/unmute.png')
  }
}