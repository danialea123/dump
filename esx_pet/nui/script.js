let buttonParams = [];
let menuOpened = false;
let interactionKeyOpened = false;
let Locales = {}
const interactionKeyDOM = document.getElementsByClassName("pet-bg")[0];
let boughtMenu = false;
let showInfo = true



window.addEventListener("message", (event) => {
    const data = event.data;
    const buttons = data.data;
    const coordX = data.coordX;
    const coordY = data.coordY;
    const action = data.action;
    switch (action) {
        case "PLAYSOUND":
            return playSound(data.type)
        case "OPEN_CONTROLPANEL":
            return openControlMenu(data.data, data.Locales, data.Orders, data.ManualMode, data.isSelling)
        case "SHOW_NOTIFY":
            return systemNotify(data.message,data.level,data.Locales)
        case "OPEN_BOUGHTSCREEN":
            return openBoughtScreen(data.petlist, data.secondhand, data.playerIdentifier)
        case "OPEN_MENU":
        case "SHOW_HEADER":
            return openMenu(buttons, coordX, coordY);
        case "OPEN_KEY":
        case "SHOW_KEY":
            return openInteractionKey(coordX, coordY, data.petName,data.petLevel,data.petIMG,data.petHungryLevel, data.petThirstLevel, data.petEnergyLevel, data.petHealthLevel, data.petGender, data.vehicleSeat, data.showInfo,data.Locales);
        case "CLOSE_MENU":
            return closeMenu();
        case "CLOSE_KEY":
            return closeInteractionKey();
        case "MY_PETS":
            return openMyPetsScreen(data.petlist);
        case "SELL_PET":
            return sellMyPet(data.animalType, data.animalNetworkID);
        default:
            return;
    }
});


playSound = function(type) {
    var audio = new Audio("sounds/" + type + ".mp3");
    audio.volume = 0.1;
    audio.play();
}



const openInteractionKey = (coordX, coordY,petName,petLevel,petIMG,petHungryLevel, petThirstLevel, petEnergyLevel, petHealthLevel, petGender, vehicleSeat, showInfo, Locales) => {
    $('.pet-name').text(petName)
    $('.pet-level').text(petLevel+ " y.o")
    $('.pet-level').text(petLevel+ " y.o")
    $('.pet-gender').text(petGender)
    Locales = Locales
    $('.pet-interacttext').text(Locales.petInteractLabel)
    if (petIMG !== undefined) {
        $('.pet-img').css({'background-image':'url('+petIMG+')'})
    } else {
        $('.pet-img').css({'background-image':'url(./unkownpet.png)'})
    }
    showInfo = showInfo
    if (!vehicleSeat) {

        if (showInfo) {
            if (interactionKeyOpened) {
                interactionKeyDOM.style.left = coordX*100+"%";
                interactionKeyDOM.style.right = (100 - coordX*100)+"%";
                interactionKeyDOM.style.top = coordY*100+"%";
                interactionKeyDOM.style.bottom = (100 - coordY*100)+"%";
            }
            else {
                interactionKeyDOM.style.left = coordX*100+"%";
                interactionKeyDOM.style.right = (100 - coordX*100)+"%";
                interactionKeyDOM.style.top = coordY*100+"%";
                interactionKeyDOM.style.bottom = (100 - coordY*100)+"%";
                
                interactionKeyOpened = true;
                interactionKeyDOM.classList.add("fadeIn");
                setTimeout(function(){
                    interactionKeyDOM.classList.remove("fadeIn");
                    interactionKeyDOM.style.opacity = 1
                }, 1000);
            }
        }
    }
}


const closeInteractionKey = () => {

    if (showInfo) {
        
        interactionKeyOpened = false;
        interactionKeyDOM.classList.add("fadeOut");
        setTimeout(function(){
            interactionKeyDOM.classList.remove("fadeOut");
            interactionKeyDOM.style.opacity = 0
        }, 1000);
    }
    cancelMenu();
};


var petPrice
var petName
var petLabel
var pedHash
var petGender
var petHungryLevel
var petThirstLevel
var petEnergyLevel
var petHealthLevel
var petLevel 
var hungryDecrase
var thirstDecrase
var petBoughtAnim
var petTexureID
var animalList
var petXP = 0
var lastXP = 100
var disableKeyboard = false
var ClickedBox = false
var isOutSide
var mynetID

var myanimalType
var myanimalNetworkID

var petOwner

// MyPets

sellMyPet = function (animalType, animalNetworkID) { 
    myanimalType = animalType;
    myanimalNetworkID = animalNetworkID;
    showMenus("interactionPanel", "pet-input-area");
    $('.pet-input-area-header').text("How much do you want to sell?");
}

openMyPetsScreen = function (mypets) { 

    $('.mypet-buybox').css({'display':'none'})
    $('.mypet-buybox').css({'opacity':'0'})

    $('.pet-mypetsmenu').css({'display':'block'})
    $('.pet-mypetsmenu').css({'opacity':'1'})
    $('.pet-mypets').html("")

    $.each(mypets, function (i, v) { 
        if ( v.petIMG !== "" ) {
            petImage = v.petIMG
        } else {
            petImage = "./unkownpet.png"
        }
        html = ""
        html = `
        <div class="pet-mypet" data-netID = "${v.netID}" data-list="${v.listOf}" data-isOutSide="${v.isOutSide}" data-pettexureid=${v.petTexureID} data-petname="${v.petName}" data-petlabel="${v.petLabel}" data-pedhash="${v.petHash}" data-petgender=${v.petGender} data-petHungryLevel=${v.petHungryLevel} data-petThirstLevel=${v.petThirstLevel} data-petEnergyLevel=${v.petEnergyLevel} data-petHealthLevel=${v.petHealthLevel} data-petlevel=${v.petLevel} data-hungrydecrase=${v.hungryDecrase} data-thirstdecrase=${v.thirstDecrase}>
            <div class="pet-mypet-img" style="background-image:url(${petImage})"></div>
            <div class="pet-mypet-name">${v.petName}</div>
            <div class="pet-mypet-label">${v.petLabel}</div>
        </div>`
        $('.pet-mypets').append(html);
    });

    $('.pet-mypet').click(function (e) { 
        e.preventDefault();
        petName = $(this).attr('data-petname')
        petLabel = $(this).attr('data-petlabel')
        petHungryLevel = $(this).attr('data-petHungryLevel')
        petThirstLevel = $(this).attr('data-petThirstLevel')
        petEnergyLevel = $(this).attr('data-petEnergyLevel')
        petHealthLevel = $(this).attr('data-petHealthLevel')
        petGender = $(this).attr('data-petgender')
        petLevel = $(this).attr('data-petlevel')
        pedHash = $(this).attr('data-pedhash')
        hungryDecrase = $(this).attr('data-hungrydecrase')
        thirstDecrase = $(this).attr('data-thirstdecrase')
        animalList = $(this).attr('data-list')
        petTexureID =  $(this).attr('data-pettexureid')
        isOutSide =  $(this).attr('data-isOutSide')
        mynetID = $(this).attr('data-netID')

        $('.mypet-info-level').text(petLevel+' LVL')      
        if (petGender == "M") {
            $('.mypet-info-gender').css({'background-image':'url(./img/M.png)'})
        } else {
            $('.mypet-info-gender').css({'background-image':'url(./img/F.png)'})
        }
        $('.mypet-info-petname').text(petName)
        $('.mypet-info-label').text(petLabel)
        $('.mypet-info').css({'opacity': 1});
        $('#myhungry-bar').animate({'width': petHungryLevel+'%'})
        $('#mythrist-bar').animate({'width': petThirstLevel+'%'})
        $('#myenergy-bar').animate({'width': petEnergyLevel+'%'})
        $('#myhealth-bar').animate({'width': petHealthLevel+'%'})
        //$.post("https://esx_pet/changePet", JSON.stringify({pedHash, animalList,petBoughtAnim}));

        $('.mypet-buybox').attr('data-petname', petName);
        $('.mypet-buybox').attr('data-petlabel', petLabel);
        $('.mypet-buybox').attr('data-petHungryLevel', petHungryLevel);
        $('.mypet-buybox').attr('data-petThirstLevel', petThirstLevel);
        $('.mypet-buybox').attr('data-petEnergyLevel', petEnergyLevel);
        $('.mypet-buybox').attr('data-petHealthLevel', petHealthLevel);
        $('.mypet-buybox').attr('data-petgender', petGender);
        $('.mypet-buybox').attr('data-petlevel', petLevel);
        $('.mypet-buybox').attr('data-pedHash', pedHash);
        $('.mypet-buybox').attr('data-isOutSide', isOutSide);

        

        if (isOutSide == 0) {
            $('.mypet-buybox').css({'display':'block'})
            $('.mypet-buybox').css({'opacity':1})
        } else {
            $('.mypet-buybox').css({'display':'none'})
            $('.mypet-buybox').css({'opacity':'0'})
        }
        
        ClickedBox = true

    });
}

//  PET BOUGHT PANEL SIDE 
openBoughtScreen = function (petlist, secondhand, player) { 
    boughtMenu  = true
    $('.pet-buybox').css({'opacity':0})
    $('.pet-boughtmenus').css({'display':'block'})
    $('.pet-boughtmenus').css({'opacity':'1'})
    $('.pet-boughtlist').html("")
    $.each(petlist, function (i, v) { 
        if ( v.petIMG !== "" ) {
            petImage = v.petIMG
        } else {
            petImage = "./unkownpet.png"
        }
        html = ""
        html = `
        <div class="pet-boughtbox" data-list="${v.listOf}" data-pettexureid=${v.petTexureID} data-petboughtanim=${v.petBoughtAnim} data-petprice=${Number(v.price)} data-petname="${v.petName}" data-petlabel="${v.petLabel}" data-pedhash="${v.pedHash}" data-petgender=${v.petGender} data-petHungryLevel=${v.hungryRatio} data-petThirstLevel=${v.thirstRatio} data-petEnergyLevel=${v.energyRatio} data-petHealthLevel=${v.healthRatio} data-petlevel=${v.petLevel} data-hungrydecrase=${v.hungryDecrase} data-thirstdecrase=${v.thirstDecrase}>
            <div class="pet-boughtbox-img" style="background-image:url(${petImage})"></div>
            <div class="pet-boughtbox-price">${Number(v.price)}$</div>
            <div class="pet-boughtbox-name">${v.petName}</div>
            <div class="pet-boughtbox-label">${v.petLabel}</div>
        </div>`
        $('.pet-boughtlist').append(html);
    });
    $('#dog-list').click(function (e) { 
        e.preventDefault();
        $('.pet-boughtlist').html("")
        $.each(petlist, function (i, v) { 
            if (v.listOf == "dog") {
                if ( v.petIMG !== "" ) {
                    petImage = v.petIMG
                } else {
                    petImage = "./unkownpet.png"
                }
                html = ""
                html = `
                <div class="pet-boughtbox" data-list="${v.listOf}" data-pettexureid=${v.petTexureID} data-petboughtanim=${v.petBoughtAnim} data-petprice=${Number(v.price)} data-petname="${v.petName}" data-petlabel="${v.petLabel}" data-pedhash="${v.pedHash}" data-petgender=${v.petGender} data-petHungryLevel=${v.hungryRatio} data-petThirstLevel=${v.thirstRatio} data-petEnergyLevel=${v.energyRatio} data-petHealthLevel=${v.healthRatio} data-petlevel=${v.petLevel} data-hungrydecrase=${v.hungryDecrase} data-thirstdecrase=${v.thirstDecrase}>
                <div class="pet-boughtbox-img" style="background-image:url(${petImage})"></div>
                <div class="pet-boughtbox-price">${Number(v.price)}$</div>
                <div class="pet-boughtbox-name">${v.petName}</div>
                <div class="pet-boughtbox-label">${v.petLabel}</div>
                </div>`
                $('.pet-boughtlist').append(html);
            }
        });
        $('.pet-boughtbox').click(function (e) { 
            e.preventDefault();
            petPrice = $(this).attr('data-petprice')
            petName = $(this).attr('data-petname')
            petLabel = $(this).attr('data-petlabel')
            petHungryLevel = $(this).attr('data-petHungryLevel')
            petThirstLevel = $(this).attr('data-petThirstLevel')
            petEnergyLevel = $(this).attr('data-petEnergyLevel')
            petHealthLevel = $(this).attr('data-petHealthLevel')
            petGender = $(this).attr('data-petgender')
            petLevel = $(this).attr('data-petlevel')
            pedHash = $(this).attr('data-pedhash')
            hungryDecrase = $(this).attr('data-hungrydecrase')
            thirstDecrase = $(this).attr('data-thirstdecrase')
            animalList = $(this).attr('data-list')
            petBoughtAnim =  $(this).attr('data-petboughtanim')
            petTexureID =  $(this).attr('data-pettexureid')
            $('.pet-info-level').text(petLevel+' LVL')      
            if (petGender == "M") {
                $('.pet-info-gender').css({'background-image':'url(./img/M.png)'})
            } else {
                $('.pet-info-gender').css({'background-image':'url(./img/F.png)'})
            }
            $('.pet-info-petname').text(petName)
            $('.pet-info-label').text(petLabel)
            $('.pet-info').css({'opacity': 1});
            $('#hungry-bar').animate({'width': petHungryLevel+'%'})
            $('#thirst-bar').animate({'width': petThirstLevel+'%'})
            $('#energy-bar').animate({'width': petEnergyLevel+'%'})
            $('#health-bar').animate({'width': petHealthLevel+'%'})
            $.post("https://esx_pet/changePet", JSON.stringify({pedHash, animalList, petBoughtAnim}));
    
            $('.pet-buybox').attr('data-petprice', petPrice);
            $('.pet-buybox').attr('data-petname', petName);
            $('.pet-buybox').attr('data-petlabel', petLabel);
            $('.pet-buybox').attr('data-petHungryLevel', petHungryLevel);
            $('.pet-buybox').attr('data-petThirstLevel', petThirstLevel);
            $('.pet-buybox').attr('data-petEnergyLevel', petEnergyLevel);
            $('.pet-buybox').attr('data-petHealthLevel', petHealthLevel);
            $('.pet-buybox').attr('data-petgender', petGender);
            $('.pet-buybox').attr('data-petlevel', petLevel);
            $('.pet-buybox').attr('data-pedHash', pedHash);
    
            $('.pet-buybox').css({'opacity':1})
            ClickedBox = true
    
        });
    });
    $('#cat-list').click(function (e) { 
        e.preventDefault();
        $('.pet-boughtlist').html("")
        $.each(petlist, function (i, v) { 
            if (v.listOf == "cat") {
                if ( v.petIMG !== "" ) {
                    petImage = v.petIMG
                } else {
                    petImage = "./unkownpet.png"
                }
                html = ""
                html = `
                <div class="pet-boughtbox" data-list="${v.listOf}" data-pettexureid=${v.petTexureID} data-petboughtanim=${v.petBoughtAnim} data-petprice=${Number(v.price)} data-petname="${v.petName}" data-petlabel="${v.petLabel}" data-pedhash="${v.pedHash}" data-petgender=${v.petGender} data-petHungryLevel=${v.hungryRatio} data-petThirstLevel=${v.thirstRatio} data-petEnergyLevel=${v.energyRatio} data-petHealthLevel=${v.healthRatio} data-petlevel=${v.petLevel} data-hungrydecrase=${v.hungryDecrase} data-thirstdecrase=${v.thirstDecrase}>
                <div class="pet-boughtbox-img" style="background-image:url(${petImage})"></div>
                <div class="pet-boughtbox-price">${Number(v.price)}$</div>
                <div class="pet-boughtbox-name">${v.petName}</div>
                <div class="pet-boughtbox-label">${v.petLabel}</div>
                </div>`
                $('.pet-boughtlist').append(html);
            }
        });
        $('.pet-boughtbox').click(function (e) { 
            e.preventDefault();
            petPrice = $(this).attr('data-petprice')
            petName = $(this).attr('data-petname')
            petLabel = $(this).attr('data-petlabel')
            petHungryLevel = $(this).attr('data-petHungryLevel')
            petThirstLevel = $(this).attr('data-petThirstLevel')
            petEnergyLevel = $(this).attr('data-petEnergyLevel')
            petHealthLevel = $(this).attr('data-petHealthLevel')
            petGender = $(this).attr('data-petgender')
            petLevel = $(this).attr('data-petlevel')
            pedHash = $(this).attr('data-pedhash')
            hungryDecrase = $(this).attr('data-hungrydecrase')
            thirstDecrase = $(this).attr('data-thirstdecrase')
            animalList = $(this).attr('data-list')
            petBoughtAnim =  $(this).attr('data-petboughtanim')
            petTexureID =  $(this).attr('data-pettexureid')
            $('.pet-info-level').text(petLevel+' LVL')      
            if (petGender == "M") {
                $('.pet-info-gender').css({'background-image':'url(./img/M.png)'})
            } else {
                $('.pet-info-gender').css({'background-image':'url(./img/F.png)'})
            }
            $('.pet-info-petname').text(petName)
            $('.pet-info-label').text(petLabel)
            $('.pet-info').css({'opacity': 1});
            $('#hungry-bar').animate({'width': petHungryLevel+'%'})
            $('#thirst-bar').animate({'width': petThirstLevel+'%'})
            $('#energy-bar').animate({'width': petEnergyLevel+'%'})
            $('#health-bar').animate({'width': petHealthLevel+'%'})
            // petBoughtAnim =  $(this).attr('data-petboughtanim')

            $.post("https://esx_pet/changePet", JSON.stringify({pedHash, animalList,petBoughtAnim}));
    
            $('.pet-buybox').attr('data-petprice', petPrice);
            $('.pet-buybox').attr('data-petname', petName);
            $('.pet-buybox').attr('data-petlabel', petLabel);
            $('.pet-buybox').attr('data-petHungryLevel', petHungryLevel);
            $('.pet-buybox').attr('data-petThirstLevel', petThirstLevel);
            $('.pet-buybox').attr('data-petEnergyLevel', petEnergyLevel);
            $('.pet-buybox').attr('data-petHealthLevel', petHealthLevel);
            $('.pet-buybox').attr('data-petgender', petGender);
            $('.pet-buybox').attr('data-petlevel', petLevel);
            $('.pet-buybox').attr('data-pedHash', pedHash);
    
            $('.pet-buybox').css({'opacity':1})
            ClickedBox = true
    
        });
    });
    $('#bird-list').click(function (e) { 
        e.preventDefault();
        $('.pet-boughtlist').html("")
        $.each(petlist, function (i, v) { 
            if (v.listOf == "bird") {
                if ( v.petIMG !== "" ) {
                    petImage = v.petIMG
                } else {
                    petImage = "./unkownpet.png"
                }
                html = ""
                html = `
                <div class="pet-boughtbox" data-list="${v.listOf}" data-pettexureid=${v.petTexureID} data-petboughtanim=${v.petBoughtAnim} data-petprice=${Number(v.price)} data-petname="${v.petName}" data-petlabel="${v.petLabel}" data-pedhash="${v.pedHash}" data-petgender=${v.petGender} data-petHungryLevel=${v.hungryRatio} data-petThirstLevel=${v.thirstRatio} data-petEnergyLevel=${v.energyRatio} data-petHealthLevel=${v.healthRatio} data-petlevel=${v.petLevel} data-hungrydecrase=${v.hungryDecrase} data-thirstdecrase=${v.thirstDecrase}>
                <div class="pet-boughtbox-img" style="background-image:url(${petImage})"></div>
                <div class="pet-boughtbox-price">${Number(v.price)}$</div>
                <div class="pet-boughtbox-name">${v.petName}</div>
                <div class="pet-boughtbox-label">${v.petLabel}</div>
                </div>`
                $('.pet-boughtlist').append(html);
            }
        });
        $('.pet-boughtbox').click(function (e) { 
            e.preventDefault();
            petPrice = $(this).attr('data-petprice')
            petName = $(this).attr('data-petname')
            petLabel = $(this).attr('data-petlabel')
            petHungryLevel = $(this).attr('data-petHungryLevel')
            petThirstLevel = $(this).attr('data-petThirstLevel')
            petEnergyLevel = $(this).attr('data-petEnergyLevel')
            petHealthLevel = $(this).attr('data-petHealthLevel')
            petGender = $(this).attr('data-petgender')
            petLevel = $(this).attr('data-petlevel')
            pedHash = $(this).attr('data-pedhash')
            hungryDecrase = $(this).attr('data-hungrydecrase')
            thirstDecrase = $(this).attr('data-thirstdecrase')
            animalList = $(this).attr('data-list')
            petBoughtAnim =  $(this).attr('data-petboughtanim')
            petTexureID =  $(this).attr('data-pettexureid')
            $('.pet-info-level').text(petLevel+' LVL')      
            if (petGender == "M") {
                $('.pet-info-gender').css({'background-image':'url(./img/M.png)'})
            } else {
                $('.pet-info-gender').css({'background-image':'url(./img/F.png)'})
            }
            $('.pet-info-petname').text(petName)
            $('.pet-info-label').text(petLabel)
            $('.pet-info').css({'opacity': 1});
            $('#hungry-bar').animate({'width': petHungryLevel+'%'})
            $('#thirst-bar').animate({'width': petThirstLevel+'%'})
            $('#energy-bar').animate({'width': petEnergyLevel+'%'})
            $('#health-bar').animate({'width': petHealthLevel+'%'})
            $.post("https://esx_pet/changePet", JSON.stringify({pedHash, animalList,petBoughtAnim}));
    
            $('.pet-buybox').attr('data-petprice', petPrice);
            $('.pet-buybox').attr('data-petname', petName);
            $('.pet-buybox').attr('data-petlabel', petLabel);
            $('.pet-buybox').attr('data-petHungryLevel', petHungryLevel);
            $('.pet-buybox').attr('data-petThirstLevel', petThirstLevel);
            $('.pet-buybox').attr('data-petEnergyLevel', petEnergyLevel);
            $('.pet-buybox').attr('data-petHealthLevel', petHealthLevel);
            $('.pet-buybox').attr('data-petgender', petGender);
            $('.pet-buybox').attr('data-petlevel', petLevel);
            $('.pet-buybox').attr('data-pedHash', pedHash);
    
            $('.pet-buybox').css({'opacity':1})
            ClickedBox = true
    
        });
    });

    $('#secondhand-list').click(function (e) { 
        e.preventDefault();
        $('.pet-boughtlist').html("")
        $.each(secondhand, function (i, v) { 
            if ( v.petIMG !== "" ) {
                petImage = v.petIMG
            } else {
                petImage = "./unkownpet.png"
            }
            html = ""
            html = `
            <div class="pet-boughtbox" data-netID = "${v.netID}" data-owner="${v.petOwner}" data-list="${v.listOf}" data-pettexureid=${v.petTexureID} data-petboughtanim=${v.petBoughtAnim} data-petprice=${Number(v.petSellingPrice)} data-petname="${v.petName}" data-petlabel="${v.petLabel}" data-pedhash="${v.petHash}" data-petgender=${v.petGender} data-petHungryLevel=${v.petHungryLevel} data-petThirstLevel=${v.petThirstLevel} data-petEnergyLevel=${v.petEnergyLevel} data-petHealthLevel=${v.petHealthLevel} data-petlevel=${v.petLevel} data-hungrydecrase=${v.hungryDecrase} data-thirstdecrase=${v.thirstDecrase}>
                <div class="pet-boughtbox-img" style="background-image:url(${petImage})"></div>
                <div class="pet-boughtbox-price">${Number(v.petSellingPrice)}$</div>
                <div class="pet-boughtbox-name">${v.petName}</div>
                <div class="pet-boughtbox-label">${v.petLabel}</div>
            </div>`
            $('.pet-boughtlist').append(html);
        });
        $('.pet-boughtbox').click(function (e) { 
            e.preventDefault();
            petPrice = $(this).attr('data-petprice')
            petName = $(this).attr('data-petname')
            petLabel = $(this).attr('data-petlabel')
            petHungryLevel = $(this).attr('data-petHungryLevel')
            petThirstLevel = $(this).attr('data-petThirstLevel')
            petEnergyLevel = $(this).attr('data-petEnergyLevel')
            petHealthLevel = $(this).attr('data-petHealthLevel')
            petGender = $(this).attr('data-petgender')
            petLevel = $(this).attr('data-petlevel')
            pedHash = $(this).attr('data-pedhash')
            hungryDecrase = $(this).attr('data-hungrydecrase')
            thirstDecrase = $(this).attr('data-thirstdecrase')
            animalList = $(this).attr('data-list')
            petBoughtAnim =  $(this).attr('data-petboughtanim')
            petTexureID =  $(this).attr('data-pettexureid')
            petOwner = $(this).attr('data-owner')
            mynetID = $(this).attr('data-netID')
            $('.pet-info-level').text(petLevel+' LVL')      
            if (petGender == "M") {
                $('.pet-info-gender').css({'background-image':'url(./img/M.png)'})
            } else {
                $('.pet-info-gender').css({'background-image':'url(./img/F.png)'})
            }
            $('.pet-info-petname').text(petName)
            $('.pet-info-label').text(petLabel)
            $('.pet-info').css({'opacity': 1});
            $('#hungry-bar').animate({'width': petHungryLevel+'%'})
            $('#thirst-bar').animate({'width': petThirstLevel+'%'})
            $('#energy-bar').animate({'width': petEnergyLevel+'%'})
            $('#health-bar').animate({'width': petHealthLevel+'%'})
            $.post("https://esx_pet/changePet", JSON.stringify({pedHash, animalList,petBoughtAnim}));
    
            $('.pet-buybox').attr('data-petprice', petPrice);
            $('.pet-buybox').attr('data-petname', petName);
            $('.pet-buybox').attr('data-petlabel', petLabel);
            $('.pet-buybox').attr('data-petHungryLevel', petHungryLevel);
            $('.pet-buybox').attr('data-petThirstLevel', petThirstLevel);
            $('.pet-buybox').attr('data-petEnergyLevel', petEnergyLevel);
            $('.pet-buybox').attr('data-petHealthLevel', petHealthLevel);
            $('.pet-buybox').attr('data-petgender', petGender);
            $('.pet-buybox').attr('data-petlevel', petLevel);
            $('.pet-buybox').attr('data-pedHash', pedHash);
            $('.pet-buybox').attr('data-owner', petOwner);
    
            if (player == petOwner) {
                $('.pet-buybox').css({'opacity':1})
                $('.pet-buybox').text("Cancel")
                $('.pet-buybox').css({'border':'.3px solid red'})
            } else {
                $('.pet-buybox').css({'opacity':1})
            }
            ClickedBox = true
    
        });
    });

    $('.pet-boughtbox').click(function (e) { 
        e.preventDefault();
        petPrice = $(this).attr('data-petprice')
        petName = $(this).attr('data-petname')
        petLabel = $(this).attr('data-petlabel')
        petHungryLevel = $(this).attr('data-petHungryLevel')
        petThirstLevel = $(this).attr('data-petThirstLevel')
        petEnergyLevel = $(this).attr('data-petEnergyLevel')
        petHealthLevel = $(this).attr('data-petHealthLevel')
        petGender = $(this).attr('data-petgender')
        petLevel = $(this).attr('data-petlevel')
        pedHash = $(this).attr('data-pedhash')
        hungryDecrase = $(this).attr('data-hungrydecrase')
        thirstDecrase = $(this).attr('data-thirstdecrase')
        animalList = $(this).attr('data-list')
        petBoughtAnim =  $(this).attr('data-petboughtanim')
        petTexureID =  $(this).attr('data-pettexureid')
        petOwner = $(this).attr('data-owner')
        $('.pet-info-level').text(petLevel+' LVL')      
        if (petGender == "M") {
            $('.pet-info-gender').css({'background-image':'url(./img/M.png)'})
        } else {
            $('.pet-info-gender').css({'background-image':'url(./img/F.png)'})
        }
        $('.pet-info-petname').text(petName)
        $('.pet-info-label').text(petLabel)
        $('.pet-info').css({'opacity': 1});
        $('#hungry-bar').animate({'width': petHungryLevel+'%'})
        $('#thirst-bar').animate({'width': petThirstLevel+'%'})
        $('#energy-bar').animate({'width': petEnergyLevel+'%'})
        $('#health-bar').animate({'width': petHealthLevel+'%'})
        $.post("https://esx_pet/changePet", JSON.stringify({pedHash, animalList,petBoughtAnim}));

        $('.pet-buybox').attr('data-petprice', petPrice);
        $('.pet-buybox').attr('data-petname', petName);
        $('.pet-buybox').attr('data-petlabel', petLabel);
        $('.pet-buybox').attr('data-petHungryLevel', petHungryLevel);
        $('.pet-buybox').attr('data-petThirstLevel', petThirstLevel);
        $('.pet-buybox').attr('data-petEnergyLevel', petEnergyLevel);
        $('.pet-buybox').attr('data-petHealthLevel', petHealthLevel);
        $('.pet-buybox').attr('data-petgender', petGender);
        $('.pet-buybox').attr('data-petlevel', petLevel);
        $('.pet-buybox').attr('data-pedHash', pedHash);
        $('.pet-buybox').attr('data-owner', petOwner);

        $('.pet-buybox').css({'opacity':1})
        ClickedBox = true

    });
}




$('.pet-buybox').click(function (e) { 
    e.preventDefault();
    cancelMenu();
    listOf = animalList

    if ($('.pet-buybox').text() == "Cancel") {
        $.post("https://esx_pet/RemoveFromList", JSON.stringify({petOwner, mynetID}));     
    } else {
        $.post("https://esx_pet/buyPet", JSON.stringify({petOwner, petPrice, petName,petLabel,petHungryLevel,petThirstLevel,petEnergyLevel,petHealthLevel,petGender,petLevel,pedHash,hungryDecrase,thirstDecrase,animalList,listOf, petXP, lastXP,petTexureID}));     
    } 
});

$('.mypet-buybox').click(function (e) { 
    e.preventDefault();
    cancelMenu();
    listOf = animalList
    if (isOutSide == 0) {
        $.post("https://esx_pet/getPet", JSON.stringify({mynetID, petName,petLabel,petHungryLevel,petThirstLevel,petEnergyLevel,petHealthLevel,petGender,petLevel,pedHash,hungryDecrase,thirstDecrase,animalList,listOf, petXP, lastXP,petTexureID}));     
    }
});



//  PET CONTROL PANEL SIDE 
openControlMenu = function(data,Locales, Orders, ManualMode, isSelling) {
    Locales = Locales
    $('#pet-interaction-name').attr("placeholder", data.petName);
    showMenus("controlPanel", "pet-interaction")
    // openMenu("status")
    // openMenu("order")
    $("#pet-interaction-status").css({'display':'flex'});
    $("#pet-interaction-order").css({'display':'block'});

    if (data.petIMG !== undefined) {
        $('.pet-interaction-petimg').css({'background-image':'url('+data.petIMG+')'})
    } else {
        $('.pet-interaction-petimg').css({'background-image':'url(./unkownpet.png)'})
    }
    if (data.petGender == "M") {
        $('.pet-interaction-gender').css({'background-image':'url(./img/M.png)'})
    } else {
        $('.pet-interaction-gender').css({'background-image':'url(./img/F.png)'})
    }
    $('.pet-interaction-name').text(data.petName)
    $('.pet-interaction-level').text(data.petLevel +' y.o')   
    $('#hungry-status-bar').animate({'width': data.petHungryLevel+'%'})
    $('#thirst-status-bar').animate({'width': data.petThirstLevel+'%'})
    $('#health-status-bar').animate({'width': data.petHealthLevel+'%'})
    $('#confirm').attr('data-netid', Number(data.netID));
    $('#pet-interaction-text-save').attr('data-netid', Number(data.netID));
    Progress(data.petHealthLevel, '.progress-health')
    Progress(data.petHungryLevel, '.progress-hungry')
    Progress(data.petThirstLevel, '.progress-thirst')
    // 
    $("#pet-interaction-order").html("")
    $.each(Orders, function (i, v) { 
        orderHTML = ""
        if (data.listOf == v.listOf) {
            if (v.label == "Go Back") 
            {
                if (ManualMode) {
                    orderHTML = `
                    <div class="pet-interaction-order-box" style="opacity:2.5; border: .3px solid green" data-netid=${Number(data.netID)} data-animaltype="${v.listOf}" data-event="${v.args}" data-clickable=true>
                        <div class="pet-interaction-orders-label">${v.label}</div>
                    </div>`
                }   
            } 
            else if (v.label == "Sell Pet") {
                if (isSelling) {
                    orderHTML = `
                    <div class="pet-interaction-order-box" style="opacity:2.5; border: .3px solid red" data-netid=${Number(data.netID)} data-animaltype="${v.listOf}" data-event="${v.args}" data-clickable=true>
                        <div class="pet-interaction-orders-label">${v.label}</div>
                    </div>`
                }  
            }
            else 
            {
                if (data.petHealthLevel >= 3) {
                    if (data.petLevel >= v.level) {
                        clickable = true
                        style = "opacity:1;border: 1px solid #ffffff7a;"
                    } else {
                        clickable = false
                        style = "opacity:0.5; border: .3px solid red"
                    }
                } else {
                    clickable = false
                    style = "opacity:0.5; border: .3px solid darkred"
                }
                orderHTML = `
                <div class="pet-interaction-order-box" style="${style}" data-netid=${Number(data.netID)} data-animaltype="${v.listOf}" data-event="${v.args}" data-clickable=${clickable}>
                    <div class="pet-interaction-orders-label">${v.label}</div>
                    <div class="pet-interaction-orders-level">${v.level} y.o</div>
                </div>`
            }
            
        }
        $("#pet-interaction-order").append(orderHTML);
    });
    
    $('.pet-interaction-order-box').click(function (e) { 
        e.preventDefault();
        eventName = $(this).attr('data-event')
        animalType = $(this).attr('data-animaltype') 
        animalNetworkID = $(this).attr('data-netid') 
        clickable = $(this).attr('data-clickable') 
        if (clickable == "true") {
            $.post("https://esx_pet/setEvent", JSON.stringify({eventName,animalType,animalNetworkID}));
        }
    });
}

function Progress(percent, element) {
    var circle = document.querySelector(element)
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;     
    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;
  
    const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
    circle.style.strokeDashoffset = -offset;
}

oldBoolName = null
openMenu = function (boolName) {
    if (oldBoolName == null) {
        oldBoolName =  boolName
        showMenus(boolName+"Panel", "pet-interaction-"+boolName)
    } else {
        showMenus(oldBoolName+"Panel", "pet-interaction-"+oldBoolName)
        showMenus(boolName+"Panel", "pet-interaction-"+boolName)
        oldBoolName = boolName
    }
}   

$('#pet-interaction-name').click(function (e) { 
    e.preventDefault();
    $('.pet-interaction-text-save').css({'display':'block'})
    $.post('https://esx_pet/disableControls', JSON.stringify({}))

    showMenus("textSavePanel", "pet-interaction-text-save")    
});
$('#pet-interaction-text-save').click(function (e) { 
    e.preventDefault();
    var petNewName = $('#pet-interaction-name').val()
    var networkID = $(this).attr('data-netid')
    $.post("https://esx_pet/changePetName", JSON.stringify({networkID, petNewName, variable :"name"}));
    $.post('https://esx_pet/disableControls', JSON.stringify({}))

    showMenus("textSavePanel", "pet-interaction-text-save")    
});

$('.pet-interaction-petimg').click(function (e) { 
    e.preventDefault();
    $('.pet-input-area-header').text("URL")
    $('.pet-input-area-header').text(Locales.petChangePhoto)
    showMenus("interactionPanel", "pet-input-area")

});
$('#decline').click(function (e) { 
    e.preventDefault();
    showMenus("interactionPanel", "pet-input-area")
});

$('#confirm').click(function (e) { 
    e.preventDefault();
    var petNewIMG = $('#pet-input-area-text').val()
    var networkID = $(this).attr('data-netid')

    if ($('.pet-input-area-header').text() == "How much do you want to sell?") 
    {
        if (Number(petNewIMG) > 0) {
            if (myanimalNetworkID && myanimalType) {
                $.post("https://esx_pet/sellPet", JSON.stringify({myanimalType, myanimalNetworkID, petNewIMG}));
                myanimalNetworkID = null;
                myanimalType = null;
            }
        }
    }
    else
    {
        $('.pet-interaction-petimg').css({'background-image':'url('+petNewIMG+')'})
        $.post("https://esx_pet/changePetIMG", JSON.stringify({networkID,petNewIMG, variable :"img"}));
        showMenus("interactionPanel", "pet-input-area")
    }
});

var side = {}

showMenus = function(elementSide,elementName) {
    if (elementSide == "controlPanel") {
        if (side["controlPanel"] == undefined ){
            side["controlPanel"] = false
        }
        if (side["controlPanel"] == false) {
            $("#"+elementName+"").css({'display':'block'});
            $("#"+elementName+"").removeClass("animate__animated animate__fadeOutRight");
            $("#"+elementName+"").addClass("animate__animated animate__fadeInRight");
            side["controlPanel"] = true

        } else {
            $("#"+elementName+"").removeClass("animate__animated animate__fadeInRight");
            $("#"+elementName+"").addClass("animate__animated animate__fadeOutRight");
            side["controlPanel"] = false
            $("#"+elementName+"").css({'display':'none'});

        }

    }
    if (elementSide == "statusPanel") {
        if (side["statusPanel"] == undefined ){
            side["statusPanel"] = false
        }
        if (side["statusPanel"] == false) {
            $("#"+elementName+"").css({'display':'flex'});
            $("#"+elementName+"").removeClass("animate__animated animate__fadeOutRight");
            $("#"+elementName+"").addClass("animate__animated animate__fadeInRight");
            side["statusPanel"] = true

        } else {
            $("#"+elementName+"").removeClass("animate__animated animate__fadeInRight");
            $("#"+elementName+"").addClass("animate__animated animate__fadeOutRight");
            side["statusPanel"] = false
            $("#"+elementName+"").css({'display':'none'});
        }

    }


    if (elementSide == "orderPanel") {
        if (side["orderPanel"] == undefined ){
            side["orderPanel"] = false
        }
        if (side["orderPanel"] == false) {
            $("#"+elementName+"").css({'display':'block'});
            $("#"+elementName+"").removeClass("animate__animated animate__zoomOut");
            $("#"+elementName+"").addClass("animate__animated animate__zoomIn");
            side["orderPanel"] = true

        } else {
            $("#"+elementName+"").removeClass("animate__animated animate__zoomIn");
            $("#"+elementName+"").addClass("animate__animated animate__zoomOut");
            side["orderPanel"] = false
            $("#"+elementName+"").css({'display':'none'});

        }
    }

    if (elementSide == "interactionPanel") {
        if (side["interactionPanel"] == undefined ){
            side["interactionPanel"] = false
        }
        if (side["interactionPanel"] == false) {
            $("#"+elementName+"").css({'display':'block'});
            $("#"+elementName+"").removeClass("animate__animated animate__zoomOut");
            $("#"+elementName+"").addClass("animate__animated animate__zoomIn");
            side["interactionPanel"] = true

        } else {
            $("#"+elementName+"").removeClass("animate__animated animate__zoomIn");
            $("#"+elementName+"").addClass("animate__animated animate__zoomOut");
            side["interactionPanel"] = false
            $("#"+elementName+"").css({'display':'none'});

        }
    }
    if (elementSide == "textSavePanel") {
        if (side["textSavePanel"] == undefined ){
            side["textSavePanel"] = false
        }
        if (side["textSavePanel"] == false) {
            $("#"+elementName+"").css({'display':'block'});
            $("#"+elementName+"").removeClass("animate__animated animate__zoomOut");
            $("#"+elementName+"").addClass("animate__animated animate__zoomIn");
            side["textSavePanel"] = true
        } else {
            $("#"+elementName+"").removeClass("animate__animated animate__zoomIn");
            $("#"+elementName+"").addClass("animate__animated animate__zoomOut");
            side["textSavePanel"] = false
            $("#"+elementName+"").css({'display':'none'});

        }
    }
}



















//Mouse Dragging
//Draggable Item Parameters
var itemDragging
var dragging = false
var dragX = 0
var dragY = 0

document.addEventListener('mousedown',  e => {
    if(boughtMenu) {
        if (!$(e.target).hasClass('ui-draggable-handle')  ) {
            dragX = e.pageX;    
            dragY = e.pageY;
            $.post('https://esx_pet/registerMouse', JSON.stringify({}));
            dragging = true
        }
        document.addEventListener('mouseup', () => dragging = false);
        document.addEventListener('mousemove', e => {
        
            if (dragging && !itemDragging) {
                var x = dragX - e.pageX;
                var y = dragY - e.pageY;
                $.post('https://esx_pet/mouseMovement', JSON.stringify({x: x, y: y}));
            }  
        });
    }
});


systemNotify = function(message,level,Locales) {
    Locales = Locales
    $(".levelup-headerside-text").text("")
    $(".levelup-skill-headerside-level").text("")
    $(".levelup-headerside-level").text("")
    $('.levelup-bottomside').text(message)
    if (level !== undefined) {
        $(".levelup-headerside-text").text("LEVEL UP!")
        $(".levelup-headerside-level").text(level)
    }
    $(".levelup-notify").animate({top: "75vh"},2000, function() {
        $(".levelup-notify").animate({top: "105vh"}, 1600)
    });
}



document.onkeyup = function (event) {
    const charCode = event.key;
    if (charCode == "Escape") {
        cancelMenu();

        
    }
};

const cancelMenu = () => {
    boughtMenu = false

    $('.pet-mypetsmenu').css({'opacity':'0'})
    $('.pet-mypetsmenu').css({'display':'none'})

    $('.pet-boughtmenus').css({'opacity':'0'})
    $('.pet-boughtmenus').css({'display':'none'})
    if (side["controlPanel"]) {
        showMenus("controlPanel", "pet-interaction")
    }
    if (side["interactionPanel"]) {
        showMenus("interactionPanel", "pet-input-area")

    }
    // showMenus()
    $.post(`https://${GetParentResourceName()}/closeMenu`);
};
