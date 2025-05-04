let ResourceName = 'esx_paintball';
let weapons = [
    'advancedrifle.png', 'appistol.png',
    'assaultrifle.png', 'assaultrifle_mk2.png',
    'assaultshotgun.png', 'assaultsmg.png',
    'autoshotgun.png', 'bullpuprifle.png',
    'bullpuprifle_mk2.png', 'bullpupshotgun.png',
    'carbinerifle.png', 'carbinerifle_mk2.png',
    'combatmg.png', 'combatmg_mk2.png',
    'combatpdw.png', 'combatpistol.png',
    'compactrifle.png', 'dbshotgun.png',
    'doubleaction.png', 'gusenberg.png',
    'heavypistol.png', 'heavyshotgun.png',
    'heavysniper.png', 'heavysniper_mk2.png',
    'machinepistol.png', 'marksmanpistol.png',
    'marksmanrifle.png', 'marksmanrifle_mk2.png',
    'mg.png', 'microsmg.png',
    'minigun.png', 'minismg.png',
    'musket.png', 'pistol.png',
    'pistol50.png', 'pistol_mk2.png',
    'pumpshotgun.png', 'pumpshotgun_mk2.png',
    'revolver.png', 'revolver_mk2.png',
    'sawnoffshotgun.png', 'smg.png',
    'smg_mk2.png', 'snspistol.png',
    'snspistol_mk2.png', 'specialcarbine.png',
    'specialcarbine_mk2.png', 'vintagepistol.png',
    'random.png'
];

let weaponsprice = {
    "pumpshotgun.png": 0, "snspistol.png": 0,
    "pistol_mk2.png": 0, "revolver_mk2.png": 0,
    "bullpuprifle.png": 0, "mg.png": 0,
    "combatmg_mk2.png": 0, "appistol.png": 0,
    "minigun.png": 0, "revolver.png": 0,
    "carbinerifle.png": 0, "bullpupshotgun.png": 0,
    "assaultrifle_mk2.png": 0, "gusenberg.png": 0,
    "advancedrifle.png": 0, "assaultrifle.png": 0,
    "combatmg.png": 0, "heavypistol.png": 0,
    "snspistol_mk2.png": 0, "heavysniper_mk2.png": 0,
    "combatpistol.png": 0, "specialcarbine_mk2.png": 0,
    "assaultsmg.png": 0, "carbinerifle_mk2.png": 0,
    "marksmanpistol.png": 0, "vintagepistol.png": 0,
    "specialcarbine.png": 0, "bullpuprifle_mk2.png": 0,
    "smg_mk2.png": 0, "marksmanrifle.png": 0,
    "compactrifle.png": 0, "sawnoffshotgun.png": 0,
    "mpshotgun_mk2.png": 0, "pistol50.png": 0,
    "pistol.png": 0, "smg.png": 0,
    "minismg.png": 0, "microsmg.png": 0,
    "marksmanrifle_mk2.png": 0, "musket.png": 0,
    "machinepistol.png": 0, "heavysniper.png": 0,
    "doubleaction.png": 0, "autoshotgun.png": 0,
    "assaultshotgun.png": 0, "heavyshotgun.png": 0,
    "dbshotgun.png": 0, "combatpdw.png": 0,
    "pumpshotgun_mk2.png": 0, "random.png": 0,
};

let maps = {
    "cargo": "cargo.jpg",
    "bank": "bank.jpg",
    "jewellery": "jewellery.jpg",
    "bimeh": "bimeh.jpg",
    "army": "army.jpg",
    "banksheriff": "banksheriff.jpg",
    "banksahel": "banksahel.jpg",
    "Shop1": "Shop1.jpg",
    "Shop2": "Shop2.jpg",
    "Shop3": "Shop3.jpg",
    "dust2": "dust2.jpg",
    "jewellery2": "jewellery2.jpg",
    "ArmyMaze": "ArmyMaze.jpg",
    "Office": "Office.jpg",
    "mythic": "mythic.jpg",
    "bobcat": "bobcat.jpg",
    "mazebank": "mazebank.jpg",
    "libertybank": "libertybank.jpg",
    "minijewellery": "minijewellery.jpg",
}
var lobbyID, TeamID, mapping, SWeapon, lobbyname, roundNum, timer, head, armor;
var page = 0;

// Create Lobby Functions
function onCreateLobby() {
    $('.question').css('display', 'none');
    $('div[name="createlobby"]').css('display', 'block');
};
function onChangeWeapon() {
    SWeapon = $('#weapon').val();
    $('.weapon-img').attr('src', './assets/weapons/' + SWeapon + ".png")
};
function onChangeMap() {
    var newSelect = $('#map').val();
    $('.map-img').attr('src', './assets/imgs/' + maps[newSelect])
};
function onSubmit() {
    lobbyname = $('#lname');
    lobbypass = $('#lbpass');
    roundNum = $('#round');
    timer = $('#timer');
    head = $('#head').find(":selected").val();
    armor = $('#armor');
    fee = $('#fee').find(":selected").val();
    bet = $('#bet').find(":selected").val();
    fire = $('#fire').find(":selected").val();

    var submit = true;
    if (lobbyname.length == 0 || lobbyname.val().length < lobbyname.attr('minlength')) {
        $('#lname').css('border-color', 'red');
        submit = false;
    }
    if (roundNum.val() < 0 || parseInt(roundNum.val()) > parseInt(roundNum.attr('max'))) {
        roundNum.val(roundNum.attr('max'));
        $('#round').css('border-color', 'red');
        submit = false;
    }
    if (parseInt(timer.val()) < parseInt(timer.attr('min')) || parseInt(timer.val()) > parseInt(timer.attr('max'))) {
        if (timer.val() > timer.attr('min')) {
            timer.val(timer.attr('max'));
            $('#timer').css('border-color', 'red');
        }
        else {
            timer.val(timer.attr('min'));
            $('#timer').css('border-color', 'red');
        }
        submit = false;
    }
    if (parseInt(armor.val()) < 0 || parseInt(armor.val()) > parseInt(armor.attr('max'))) {
        armor.val(armor.attr('max'));
        $('#armor').css('border-color', 'red');
        submit = false;
    }









    if (submit) {
        fetch(`https://${ResourceName}/CreateLobby`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                mapName: $("#map").val(),
                weaponModel: $('#weapon').val(),
                lobbyName: lobbyname.val(),
                roundNum: roundNum.val(),
                Password: lobbypass.val(),
                armor: armor.val(),
                timer: timer.val(),
                head: head,
                fee: fee,
                bet: bet,
                fire: fire,
            })
        }).then(resp => resp.json()).then(lobid => {
            lobbyID = lobid
        });
        page = 100;
        TeamID = 0;
        $('div[name="createlobby"]').css('display', 'none');
        $('#startButton').css('display', 'block');
        $('div[name="main"]').css('display', 'block');
    }

};
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
         li.innerHTML = `${li.innerHTML} ${element.name.substring(0,5)}.. (${element.id}) <span>${element.killcount}</span>`; 
        } 
               else{
       li.innerHTML = `${li.innerHTML} ${element.name} (${element.id}) <span>${element.killcount}</span>`; 
       }
            }
          
       }
   })();
}

// Join In Lobby Functions
function onJoinLobby() {
    $('.question').css('display', 'none');
    $('.list').css('display', 'block');
    fetch(`https://${ResourceName}/LobbyList`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(data => {
        var jdata = JSON.parse(data);
        if (jdata.length != 0) {
            $("#nolobby").fadeOut(100);
            for (var i = 0; i < jdata.length; i++) {
                if (jdata[i].pass == null || jdata[i].pass == "") {
                    
                        $(".boxlobbeys").append(`
                        <li id="Lobby-${jdata[i].LobbyId}" onclick="onSelectLobby(this.id)" class="list-group-item d-flex justify-content-between align-items-center">
                        ${jdata[i].name} 
                            <span class="badge bg-primary badge-pill">${jdata[i].map} | ${jdata[i].weapon}</span>
                        </li>

                    `)  
                    
                    
                    // $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-' + jdata[i].LobbyId + '" onclick="onSelectLobby(this.id)">' + jdata[i].name + ' | ' + jdata[i].map + ' | ' + jdata[i].weapon + '</h1>');
                } else {
                        $(".boxlobbeys").append(`
                    <li id="Lobby-${jdata[i].LobbyId}-locked" onclick="onSelectLobby(this.id)" class="list-group-item d-flex justify-content-between align-items-center">
                    ${jdata[i].name} 
                        <span class="badge bg-primary badge-pill">${jdata[i].map} | ${jdata[i].weapon}</span>
                    </li>

                `)
                    
                    // $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-' + jdata[i].LobbyId + '-locked" onclick="onSelectLobby(this.id)">' + jdata[i].name + ' | ' + jdata[i].map + ' | Locked</h1>');
                };
            };
        } else {
            
                $(".boxlobbeys").append(`<li id="nolobby" style="display: none;"
                class="list-group-item d-flex justify-content-between align-items-center">
                No Found Any Lobby
                <span class="badge bg-primary badge-pill">N/A</span>
              </li>`)
        };
    });
};
function onSelectLobby(id) {
    var lid = id.split('-');
    lobbyID = lid[1];
    if (lid[2] == 'locked') {
        $('.lobby-password').css('display', 'block');
        $('.boxlobbeys').css('display', 'none');
        page = 85;
    } else {
        page = 0;
        TeamID = 0;
        $('.list').css('display', 'none');
        $('#startButton').css('display', 'none');
        $('div[name="main"]').css('display', 'block');
        fetch(`https://${ResourceName}/JoinLobby`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                LobbyId: lobbyID
            })
        }).then(resp => resp.json()).then(data => {
            var jdata = JSON.parse(data);
            for (var i = 0; i < 3; i++) {
                var team = jdata[i];
                for (var i2 = 0; i2 < team.length; i2++) {
                    if (i == 0) {
                        $('.joiners').append(team[i2].value);
                    } else if (i == 1) {
                        $('.teamone').append(team[i2].value);
                    } else {
                        $('.teamtwo').append(team[i2].value);
                    };
                };
            };
        });
    };
};
function onJoin(id) {
    var tid = id.split('-')[1];
    fetch(`https://${ResourceName}/SwitchTeam`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            LastTeam: TeamID,
            JoinTeam: tid
        })
    }).then(resp => resp.json()).then(data => {
        if (data) {
            if (TeamID != 0) {
                // $('#TM-' + TeamID).fadeIn();
            };
            // $('#' + id).css('display', 'none');
            page = 100;
            TeamID = tid;
        };
    })
};

// In Lobby Functions
function onStart() {
    page = 0;
    fetch(`https://${ResourceName}/StartMatch`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID
        })
    }).then(resp => resp.json());
    $(".org-style").fadeIn(100);
};
function onReady() {
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: true
        })
    }).then(resp => resp.json()).then(data => {
        if (data) {
            $('#ReadyButton').css('display', 'none');
            $('#UnReadyButton').css('display', 'block');
        };
    })
};
function onUnready() {
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: false
        })
    }).then(resp => resp.json()).then(data => {
        if (data) {
            $('#UnReadyButton').css('display', 'none');
            $('#ReadyButton').css('display', 'block');
        };
    })
};
function onLeave() {
    page = 0;
    $('.lobby').css('display', 'none');
    fetch(`https://${ResourceName}/QuitLobby`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID
        })
    }).then(resp => resp.json());
    TeamID = 0;
    lobbyID = 0;
    location.reload();
    $('.teamone').find('li').remove();
    $('.teamtwo').find('li').remove();
};

// Other Functions
function onNext() {
    if (page == 0) {
        $('#cancelButton').css('display', 'none');
        $('#backButton').css('display', 'block');
        $('.selectmap').css('display', 'none');
        $('.weapon-select').css('display', 'block');
        mapping = $('#map').val();
        page = page + 1;
    } else {
        $('#nextButton').css('display', 'none');
        $('#submitButton').css('display', 'block');
        $('.weapon-select').css('display', 'none');
        $('.setting').css('display', 'block');
        SWeapon = $('.weapon-name').attr('id');
        page = page + 1;
    };
};
function onBack() {
    if (page == 2) {
        $('#nextButton').css('display', 'block');
        $('#submitButton').css('display', 'none');
        $('.weapon-select').css('display', 'block');
        $('.setting').css('display', 'none');
        page = page - 1;
    } else {
        $('#cancelButton').css('display', 'block');
        $('#backButton').css('display', 'none');
        $('.selectmap').css('display', 'block');
        $('.weapon-select').css('display', 'none');
        page = page - 1;
    };
};
function onCancel() {
    page = 0;
    $('.lobby').css('display', 'none');
    fetch(`https://${ResourceName}/QuitFromMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json());
    location.reload()
};
function onBackQuestion() {
    if (page != 85) {
        $('.question').css('display', 'block');
        $('.list').css('display', 'none');
        $('.boxlobbeys').find('li').remove();
    } else {
        page = 0
        $('.lobby-password').css('display', 'none');
        $('.lobbeys').css('display', 'block');
    };
};

//For Source And Timer


function startMatch() {
    _stopTimer = false;
    $('#who_won').hide();
    var fiveMinutes = 60 * 3,
        display = $('#time_counter');
    startTimer(fiveMinutes, display);
    Speak("The match has started!");
}

// Keyup Event
document.onkeyup = function (data) {
    if (data.which == 27) { // ESC Press
        /*if (page == 0) {
            fetch(`https://${ResourceName}/QuitFromMenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            }).then(resp => resp.json());
            location.reload();
        };*/
    } else if (data.which == 13) {
        if (page == 85) {
            var pass = $('#lpass').val();
            if (pass != null || pass != "") {
                fetch(`https://${ResourceName}/GetLobbyPassword`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({
                        LobbyId: lobbyID
                    })
                }).then(resp => resp.json()).then(data => {
                    if (data == pass) {
                        page = 0;
                        TeamID = 0;
                        $('.list').css('display', 'none');
                        $('#startButton').css('display', 'none');
                        $('div[name="main"]').css('display', 'block');
                        fetch(`https://${ResourceName}/JoinLobby`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: JSON.stringify({
                                LobbyId: lobbyID
                            })
                        }).then(resp => resp.json()).then(data => {
                            var jdata = JSON.parse(data);
                            for (var i = 0; i < 3; i++) {
                                var team = jdata[i];
                                for (var i2 = 0; i2 < team.length; i2++) {
                                    if (i == 0) {
                                        $('.joiners').append(team[i2].value);
                                    } else if (i == 1) {
                                        $('.teamone').append(team[i2].value);
                                    } else {
                                        $('.teamtwo').append(team[i2].value);
                                    };
                                };
                            };
                        });
                    } else {
                        $('#lpass').css('border-color', 'red');
                    };
                });
            };
        };
    };
};

function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    var _interVal = setInterval(function () {


        if (--timer >= 0) {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);

            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            display.text(minutes + ":" + seconds);
        }
    }, 1000);
}

// NUI Sended Event
window.addEventListener("message", function (event) {
    if(event.data.kill == true){
        updateKillerBord(event.data.killlist);
    }
    if (event.data.type == 'show') {
        if (event.data.show) {
            $('.lobby').css('display', 'block');
            if (event.data.create != true) {
                $('#btn_Create').attr("disabled", true);
            }
        } else {
            //$('.lobby').css('display', 'none');
            this.location.reload();
        };
    } else if (event.data.type == 'start') {
        $('#headerss').show();
        $(".org-style").fadeIn(100);
        $('#round_counter').text(`End In ${event.data.round}`); //new edit
        startTimer(event.data.time, $('#time_counter'));
    } else if (event.data.type == 'stop') {
        $('#headerss').hide();
        $(".org-style").fadeOut(100);
    } else if (event.data.type == "update") {
        $('.team1_score').text(event.data.t1);
        $('.team2_score').text(event.data.t2);
    } else if (event.data.type == "updatealive1") {
        $('.white').text(`(${event.data.t1}) Team 1`);//alive team 1
    } else if (event.data.type == "updatealive2") {
        $('.orange').text(`(${event.data.t2}) Team 2`);//alive team 2
    } else if (event.data.type == "time") {
        startTimer(event.data.time, $('#time_counter'));
    }


    if (event.data.action == 'JoinTeam') {
        if (event.data.team == 0) {
            $('.joiners').append(event.data.value);
        } else if (event.data.team == 1) {
            $('.teamone').append(event.data.value);
        } else {
            $('.teamtwo').append(event.data.value);
        };
    } else if (event.data.action == 'LeftTeam') {
        $('#' + event.data.player).remove();
    };


});