/**
 * Updates the neighborhood displayed at the top
 * @function
 * @param {string} neighborhood - The neighborhood name to be displayed at top
 */
function setNeighborhood(neighborhood) {
    if (!street) {
        console.error('Missing one or more required parameters (setNeighborhood() function call)');
        return false;
    } else {
        document.querySelector('#E001').innerHTML = neighborhood;
        return true;
    }
}

/**
 * Updates the street displayed at the top
 * @function
 * @param {string} street - The street name to be displayed at the top
 */
function setStreet(street) {
    if (!street) {
        console.error('Missing one or more required parameters (setStreet() function call)');
        return false;
    } else {
        document.querySelector('#E002').innerHTML = street;
        return true;
    }
}

/**
 * Changes the amount of cash displayed
 * @function
 * @param {int} cash - Cash amount to set
 */
function setCash(cash) {
    if (cash == null) {
        console.error('Missing one or more required parameters (setCash() function call)');
        return false;
    } else {
        document.querySelector('#E003').innerHTML = `$${cash.toLocaleString()}`;
        return true;
    }
}

/**
 * Changes the XP progress bar
 * @function
 * @param {int} xp - Current XP of the player
 * @param {int} rankupXp - XP required to rank up
 * @param {int} rank - Current rank of the player
 */
function setXp(xp, rankupXp, rank) {
    if (xp == null || rankupXp == null || rank == null) {
        console.error('Missing one or more required parameters (setXp() function call)');
        return false;
    } else {
        let percentage = (xp / rankupXp) * 100;
        if (percentage >= 100) { percentage = 100 }
        document.querySelector('#E006').style.width = `${percentage}%`;
        document.querySelector('#E005').innerHTML = `${xp.toLocaleString()}/${rankupXp.toLocaleString()}`;
        document.querySelector('#E004').innerHTML = `${rank.toLocaleString()}`;
        return true;
    }
}

/**
 * Changes the statistics for the teams
 * @function
 * @param {int} team - The team (1-3) being changed
 * @param {int} zone - The number of players in the player's zone
 * @param {int} points - The number of points the team has
 * @param {int} players - The number of players on the team
 */
function updateTeam(team, zone, points, players) {
    if (team == null || zone == null || points == null || players == null) {
        console.error('Missing one or more required parameters (updateTeam() function call)');
        return false;
    } else {
        try {
            const t = document.querySelector(`#T${team}`);
            t.querySelector('.zone').querySelector('h1').innerHTML = zone;
            t.querySelector('.points').querySelector('h1').innerHTML = points;
            t.querySelector('.players').querySelector('h1').innerHTML = players;
            return true;
        } catch (err) {
            console.error(`The team "T00${team}" could not be found.`);
            return false;
        }
    }
}

/**
 * Updates the compass element
 * @function
 * @param {int} deg - The direction the player is facing in degrees
 */
function updateCompass(direction) {
    $(".direction").find(".image").attr('style', 'transform: translate3d(' + direction + 'px, 0px, 0px)');
}

$('#play-button').click((e) => {
    e.preventDefault();
    $('.select-lang').css("display", "none");
    if ($('.select-team').css("display") == "block") {
        $('.select-team').css("display", "none");
    } else {
        $('.select-team').css("display", "block");
    }
});

function selectTeam(element) {
    let team = parseInt($(element).data("team"));
    $.post('http://koth-core/selectTeam', JSON.stringify({ team }));
}

$('#lang-button').click((e) => {
    e.preventDefault();
    $('.select-team').css("display", "none");
    if ($('.select-lang').css("display") == "block") {
        $('.select-lang').css("display", "none");
    } else {
        $('.select-lang').css("display", "block");
    }
});

function selectLang(lang) {
    $('.select-lang').css("display", "none");
    $.post('http://koth-core/selectLang', JSON.stringify({ lang }));
}

xHair = {}

xHair.show = function(data) {
    $('.crosshair-wrapper').fadeIn();
};

xHair.hide = function() {
    $(".crosshair-wrapper").fadeOut();
};

xHair.hide();

let centerNotifs = [];

let colorList = {
    red: '#eb4034',
    blue: '#34abeb',
    green: '#34eb59',
    white: '#ffffff',
    yellow: '#ebe652'
};

let timeouts = [];

function newNotification(icon, text, money, xp, color) {
    if (!color) { color = 'white' }
    centerNotifs.push({
        icon,
        text,
        money,
        xp,
        color
    })
    nextNotification();
}

function nextNotification() {
    if (document.getElementById("main_notif").style.display == "none") {
        if (centerNotifs.length > 0) {
            let negative = (centerNotifs[0].money.toString().startsWith("-")) ? true : false;
            document.getElementById("notification_icon").setAttribute("class", centerNotifs[0].icon);
            document.getElementById("notification_icon").style.color = colorList[centerNotifs[0].color];
            document.getElementById("notification_title").innerHTML = `${ (negative) ? "-" : "+" } $` + centerNotifs[0].money.toString().replace("-", "") + " " + centerNotifs[0].text;
            document.getElementById("notification_body").innerHTML = "+ " + centerNotifs[0].xp + " xp";
            document.getElementById("main_notif").style.display = "block";
            document.getElementById("main_notif").classList.add('animate__animated', 'animate__fadeInDown');
            document.getElementById("main_notif").addEventListener('animationend', () => {
                document.getElementById("main_notif").classList.remove('animate__animated', 'animate__fadeInDown');
                setTimeout(() => {
                    centerNotifs.shift();
                    document.getElementById("main_notif").classList.add('animate__animated', 'animate__fadeOutDown');
                    document.getElementById("main_notif").addEventListener('animationend', () => {
                        document.getElementById("main_notif").classList.remove('animate__animated', 'animate__fadeOutDown');
                        document.getElementById("main_notif").style.display = "none";
                        nextNotification();
                    }, {
                        once: true
                    });
                }, 1000);
            }, {
                once: true
            });
        }
    }
}

let audioPlayer = null;

window.addEventListener('message', (event) => {
    if (event.data.type === 'setCash') {
        setCash(event.data.amount);
    }

    if (event.data.type === 'setXp') {
        setXp(event.data.xp, event.data.rankup, event.data.rank);
    }

    if (event.data.type === 'updateTeam') {
        updateTeam(event.data.team, event.data.zone, event.data.points, event.data.players);
    }

    if (event.data.type === "setNeighborhood") {
        setNeighborhood(event.data.name);
    }

    if (event.data.type === "setStreet") {
        setStreet(event.data.name);
    }

    if (event.data.type === "setEnabled") {
        if (event.data.state) {
            document.querySelector('.overlay').style.display = 'block';
        } else {
            document.querySelector('.overlay').style.display = 'none';
        }
    }

    if (event.data.type === "setSelectionScreen") {
        if (event.data.state) {
            $('.selection-screen-wrapper').css("display", "block");
        } else {
            $('.selection-screen-wrapper').css("display", "none");
        }
    }

    if (event.data.type === "setCompassHeading") {
        updateCompass(event.data.heading);
    }

    if (event.data.type === "setCrosshair") {
        if (event.data.state) {
            xHair.show();
        } else {
            xHair.hide();
        }
    }

    if (event.data.type === "newNotification") {
        newNotification(event.data.icon, event.data.text, event.data.money, event.data.xp, event.data.color)
    }

    if (event.data.transactionType == "playSound") {

        if (audioPlayer != null) {
            audioPlayer.pause();
        }

        audioPlayer = new Howl({ src: ["./sounds/" + event.data.transactionFile + ".ogg"] });
        audioPlayer.volume(event.data.transactionVolume);
        audioPlayer.play();
    }

    if (event.data.type == "addKill") {

        let killerTeam = "green";
        let killedTeam = "red";
        addKill({ name: event.data.killer, team: killerTeam }, event.data.weapon, { name: event.data.killed, team: killedTeam }, event.data.headshot);
    }

    if (event.data.type == "setVehicleData") {
        $('.vehicle-info').html("");

        for (const person of event.data.persons) {
            addPersonToVehicle(person.driver, person.name);
        }
    }

    if (event.data.type == "hotbar_item") {
        setWeapon(event.data.slot, event.data.item);
    }

    if (event.data.type == "hotbar_select") {
        if (event.data.slot > 4) { return; }

        selectWeapon(event.data.slot);
    }

    if (event.data.type == "setLoadoutColor") {
        setLoadoutColor(event.data.color)
    }

    if (event.data.type == "setChatChannel") {
        $('.chat-type h3').html(`(Y) ${event.data.channel} Chat`);
    }

    if (event.data.type == "scoreboard") {
        let blueTeam = [];
        let redTeam = [];
        let greenTeam = [];

        for (const [_, person] of Object.entries(event.data.contents)) {
            let name = sanitizeString(person.name)
            if (person.team == 1 && redTeam.length < 25) {
                redTeam.push({ id: person.id, name: name, xp: person.xp, kills: person.kills, deaths: person.deaths, assists: person.assists });
            }
            if (person.team == 2 && greenTeam.length < 25) {
                greenTeam.push({ id: person.id, name: name, xp: person.xp, kills: person.kills, deaths: person.deaths, assists: person.assists });
            }
            if (person.team == 3 && blueTeam.length < 25) {
                blueTeam.push({ id: person.id, name: name, xp: person.xp, kills: person.kills, deaths: person.deaths, assists: person.assists });
            }
        }

        setTeamScoreboard("blue", blueTeam);
        setTeamScoreboard("red", redTeam);
        setTeamScoreboard("green", greenTeam);
    }

    if (event.data.type == "displayScoreboard") {
        displayScoreboard(event.data.state);
    }

    if (event.data.type == "showDeathScreen") {
        showDeathScreen(event.data.state);
    }

    if (event.data.type == "setupDeathScreen") {
        setupDeathScreen(event.data.killer, event.data.seconds);
    }

    if (event.data.type == "showEndScreen") {
        showEndScreen(event.data.victory, event.data.seconds);
    }

    if (event.data.type == "setSpecialEnabled") {
        setSpecialEnabled(event.data.state);
    }

    if (event.data.type == "setSpecial") {
        setSpecial(event.data.special);
    }

    if (event.data.type == "healthbar") {
        $("#boxSetHealth").css("width", event.data.health + "%");

        if (event.data.health <= 20) {
            $('#boxSetHealth').css("background", "rgb(192, 59, 59)");
        } else if (event.data.health <= 50) {
            $('#boxSetHealth').css("background", "rgb(245, 165, 69)");
        } else {
            $('#boxSetHealth').css("background", "rgb(60, 160, 59)");
        }
    }

    if (event.data.type == "hidehealthbar") {
        if (event.data.state) {
            $('#statusHud').css("display", "block");
        } else {
            $('#statusHud').css("display", "none");
        }

    }
});

function sanitizeString(str) {
    str = str.replace(/[^a-z0-9áéíóúñü \.,_-]/gim, "");
    return str.trim();
}

/* Killfeed */
function addKill(killer, weapon, killed, headshot) {

    let killerName = killer.name
    let killedName = killed.name
    let killfeedElement = `
        <div class="kill-wrapper">
            <div class="kill">
                <p style="color: #ffffff;background:#0061ff; padding:5px;">${killerName}</p>
                ${(weapon == "VEHICLE") ? `<i style="padding-left: 5px; padding-right: 5px;" class="fas fa-car-side"></i>` : `<img src="https://cdn.gtakoth.com/weapons/${weapon}.png">`}
                ${(true) ? '<i class="fas fa-crosshairs" style="color: #FFffff;"></i> ' : ""}
                <p style="color: #ffffff;background:#FF0032;padding:5px;">${killedName}</p>
            </div>
        </div>
    `;
    let elem = $(killfeedElement);
    $('.killfeed').append(elem);
    elem.hide().show(500);

    setTimeout(() => { elem.hide(500); setTimeout(() => { elem.html(""); }, 500); }, 5000);
}

/* Vehicle Info */
function addPersonToVehicle(driver, name) {
    let icon = (driver) ? "fas fa-car" : 'fas fa-user';

    let element = `
        <div class="info-wrapper">
            <div class="info">
                ${name} <i class="${icon}"></i>
            </div>
        </div>
    `;

    $('.vehicle-info').append(element);
}

/* Loadout */

let lastSlot = false;

function setWeapon(slot, weapon) {
    $(`#slot-${slot}`).addClass('animate__backOutDown');
    setTimeout(() => { $(`#slot-${slot} .img`).css("background-image", `url('https://cdn.gtakoth.com/inventory/${weapon}.png')`); $(`#slot-${slot}`).removeClass('animate__backOutDown'); $(`#slot-${slot}`).addClass('animate__backInUp'); setTimeout(() => { $(`#slot-${slot}`).removeClass('animate__backInUp'); }, 1500); }, 750);
}

function setLoadoutColor(team) {
    $(`.slot`).addClass(team);
}

function selectWeapon(slot) {
    if(lastSlot) {
        $(`#slot-${lastSlot}`).removeClass("active");
    }

    if(slot == lastSlot) { lastSlot = false; return; }
            
    $(`#slot-${slot}`).addClass("animate__pulse active");

    lastSlot = slot;
            
    setTimeout(() => { $(`#slot-${slot}`).removeClass('animate__pulse'); }, 1500);
}

function setSpecialEnabled(state) {
    if(state) {
        $('.special .slot').addClass("animate__fadeInLeft");
        $('.special').css("display", "block");

        setTimeout(() => { $('.special .slot').removeClass("animate__fadeInLeft"); }, 1000);
    } else {
        $('.special .slot').addClass("animate__fadeOutLeft");
        setTimeout(() => { $('.special').css("display", "none"); $('.special .slot').removeClass("animate__fadeOutLeft"); }, 1000);
    }
}

function setSpecial(weapon) {
    $(`.special .slot .img`).css("background-image", `url('https://cdn.gtakoth.com/inventory/${weapon}.png')`);
}

function setTeamScoreboard(team, members) {
    $(`.scoreboard-wrapper .team.${team} .rest`).html("");

    for(const member of members) {
        let memberName = sanitizeString(member.name)
        let elem = `
            <div class="stat">
            <h3>${member.id}</h3>
            <h3>${memberName}</h3>
            <h3>${member.xp}</h3>
            <h3>${member.kills}</h3>
            <h3>${member.deaths}</h3>
            <h3>${member.assists}</h3>
        </div>
        `;
        $(`.scoreboard-wrapper .team.${team} .rest`).append(elem);
    }

    for(let i = members.length; i < 25; i++) {
        let elem = `
        <div class="stat">
        </div>
        `;
        $(`.scoreboard-wrapper .team.${team} .rest`).append(elem);
    }
}

function displayScoreboard(state) {
    if(state) {
        $('.scoreboard').css("display", "block");
    } else {
        $('.scoreboard').css("display", "none");
    }
}

setTeamScoreboard("blue", []);
setTeamScoreboard("red", []);
setTeamScoreboard("green", []);

/* DEATHSCREEN */

function setupDeathScreen(killer, seconds) {
    setKiller(killer.name, killer.team);
    setBleedout(seconds);
}

function showDeathScreen(state) {
    $('.deathscreen-wrapper').css("display", (state) ? "flex" : "none")
}

function setKiller(name, team) {
    let killerName = sanitizeString(name);
    $('.deathscreen-wrapper #killer').html(killerName);
    $('.deathscreen-wrapper #killer').attr("class", team);
}

function setBleedout(seconds) {
    for(const [key, timeout] of Object.entries(timeouts)) {
        clearTimeout(timeout);
        timeouts[key] = null;
    }

    $('.bleed .count').html(seconds);
    $('.bar .inner').css("width", "100%");
    for(let i = 1; i <= seconds; i++) {
        timeouts[i] = setTimeout(() => {
            $('.bleed .count').html(seconds - i);

            let percentage = ((seconds-i) / seconds) * 100;

            $('.bar .inner').css("width", `${percentage}%`);

            if(i >= seconds) {
                $.post('http://koth-core/respawn', JSON.stringify({  }));
            }
            timeouts[i] = null;
        }, i * 1000);
    }
}

/* Endscreen */

let endScreenTimeouts = [];

function showEndScreen(victory, seconds) {

    $('.endscreen-wrapper').css("display", "flex");

    for(const [key, value] of Object.entries(endScreenTimeouts)) {
        clearTimeout(value);
    }

    if(victory) {
        $('.endscreen .state').html("VICTORY!");
    } else {
        $('.endscreen .state').html("DEFEAT!");
    }

    $('.endscreen .seconds').html(seconds);
    for(let i = 1; i < seconds; i++) {
        endScreenTimeouts[i] = setTimeout(() => {
            $('.endscreen .seconds').html(seconds - i);

            if(i >= seconds) { $('.endscreen-wrapper').css("display", "none"); }
        }, 1000 * i);
    }
}