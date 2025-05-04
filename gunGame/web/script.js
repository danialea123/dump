$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var i = event.data
        switch(i.action) {
            case 'showKillLeaders':
                $("#first").text(i.first)
                $("#second").text(i.second)
                $("#third").text(i.third)
                $("#firstKills").text(i.firstKills)
                $("#secondKills").text(i.secondKills)
                $("#thirdKills").text(i.thirdKills)
                $('.killleaders').fadeIn(500)
            break;
            case 'setLeaders':
                $('table').append(`<tr><td>${i.place}</td><td>${i.name}</td><td>${i.id}</td><td>${i.kills}</td><td>${i.deaths}</td><td>${i.kd}</td></tr>`)
            break;
            case 'HideKillLeaders':
                $('.killleaders').fadeOut(500)
            break;
            case 'showGunGameWinner':
                $("#firstName").text(i.firstName)
                $("#firstK").text(i.firstKills + " Kills")
                $('#callingCard').attr('src', "callingcards/" + i.calling);
                $('.gunGameWinners').fadeIn(500);
            break;
            case "hideAllUIs":
                $(".killleaders").hide()
            break;
            case 'hideGunGameWinner':
                $('.gunGameWinners').fadeOut(500);
            break;
            case "showCountdown":
                $("#countDownUI").fadeIn(500)
            break;
            case "hideCountdown":
                $("#countDownUI").hide()
            break;
            case "updateCountDown":
                $("#white").text(i.countDown)
            break;
            case "playAudio":
                const audio = new Audio("sounds/" + i.audioFile)
                audio.volume = i.volume;
                audio.play()     
            break;
        }
    });
});
