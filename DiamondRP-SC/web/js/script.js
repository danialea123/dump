window.ResourceName = 'DiamondRP-SC'
let closeKeys = [8, 27, 121];
let shopCd = false
let PursuitCd = false
let Jewelry3Cd = false
let FleecaBankCd = false
let Jewelery2Cd = false
let MazeBankCd = false
let JeweleryCd = false
let minijewelryCd = false
let LibertyCd = false
let ShBankCd = false
let LifeInsurancecd = false
let Bobcatcd = false
let ShipmentCd = false
let GlobalInterval
let Steam = "Hex"
let mythicCd = false
let CBankCd = false
let CargoCd = false
$(document).ready(function () {
    let jobs = {
        ['police']: {
            Shoghl: "POLICE",
            Tozihat: "پلیس نیرویی برای حفاظت از شهر در 24 ساعت شبانه روز ",
            Image: "img/police.png",
            Online: 3,
        },
        ['ambulance']: {
            Shoghl: "HOSPITAL",
            Tozihat: "بیمارستان مکانی برای مداوا ",
            Image: "img/ambulance.png",
            Online: 3,
        },
        ['taxi']: {
            Shoghl: "TAXI",
            Tozihat: "ارگانی برای جا به جایی شما شهروندان در صورت نداشتن وسیله نقلیه ",
            Image: "img/taxi.png",
            Online: 3,
        },
        ['sheriff']: {
            Shoghl: "SHERIFF",
            Tozihat: "شریف نیرویی برای حفاظت از بیرون شهر در 24 ساعت شبانه روز ",
            Image: "img/sheriff.png",
            Online: 3,
        },
        ['weazel']: {
            Shoghl: "WEAZEL NEWS",
            Tozihat: "ارگانی برای تهیه گزارش از اتفاقات و رخ داد ها در سطح شهر ",
            Image: "img/weazel.png",
            Online: 3,
        },
        ['mechanic']: {
            Shoghl: "MECHANIC",
            Tozihat: "مکانی برای تعمیر ، رنگ و ارتقا قطعات فنی ماشین و موتور ",
            Image: "img/mechanic.png",
            Online: 3,
        },
        ['force']: {
            Shoghl: "SPECIAL FORCES",
            Tozihat: "نیروی ویژه ای ، در کنار پلیس و شریف برای مقابله با مجرمین در تمام شهر",
            Image: "img/sf.png",
            Online: 3,
        },
        ['benny']: {
            Shoghl: "BENNY",
            Tozihat: "مکانی برای تعمیر ، رنگ و ارتقا قطعات فنی ماشین و موتور",
            Image: "img/benny.png",
            Online: 3,
        },
        ['FBI-1']: {
            Shoghl: "FBI",
            Tozihat: " اداره تحقیقات فدرال ، از نهاد های رسیدگی به جنایات و جرایم",
            Image: "img/FBI-1.png",
            Online: 3,
        },
        ['justice']: {
            Shoghl: "JUSTICE",
            Tozihat: "ارگان دادگستری پاسخگو به سوالات شما و مکانی برای ثبت و رسیدگی به شکایات شما",
            Image: "img/justice.png",
            Online: 3,
        },
    }
    let Robs = {
        ['Cargo']: {
            Rob: "CARGO",
            Cops: 10,
            Robbers: 10,
            Info: "تعداد نیروهای نظامی حداکثر 10 نفر (شامل 4 سوات + 6 نفر آفیسر+ یک واحد به عنوان واحد هلیکوپتر) باشند. و رابر ها حداقل 8 نفر و حداکثر 10 نفر باشند. این رابری جوینر ندارد ",
            movie: false,
            photo: "img/CargoCover.png",
            Active: "Active",
        },
        ['CBank']: {
            Rob: "CENTRAL BANK",
            Cops: 8,
            Robbers: 8,
            Info: "رابرها باید ، حداقل 6 نفر و حداکثر 8 نفر باشند.           تعداد نیروی های نظامی می تواند ، حداکثر 8 نفر ( شامل 3 سوات + 5 نیروی نظامی + 1 واحد به عنوان واحد هلی )  باشند. این رابری جوینر ندارد .",
            movie: false,
            photo: "img/CBankCover.png",
            Active: "Active",
        },
        ['Mythic']: {
            Rob: "MYTHIC",
            Cops: 10,
            Robbers: 10,
            Info: "تعداد نیروی های نظامی می تواند ، حداکثر 10 نفر (شامل 4 سوات + 6 نیروی نظامی + یک واحد به عنوان واحد هلی  )  و رابرها  حداقل 7 نفر و حداکثر 10 نفر باشند . این رابری جوینر ندارد",
            movie: false,
            photo: "img/MythicCover.png",
            Active: "Active",
        },
        ['Shipment']: {
            Rob: "SHIPMENT",
            Cops: 11,
            Robbers: 10,
            Info: "تعداد نیروهای نظامی حداکثر 11 نفر (شامل  5 نفر سوات و 6 نفر نیروی نظامی + یک واحد به عنوان واحد هلی )  در این رابری رابرها باید حداقل 8 نفر و حداکثر 10 نفر باشند.  این رابری جوینر ندارد",
            movie: false,
            photo: "img/ShipmentCover.png",
            Active: "Active",
        },
        ['Bobcat']: {
            Rob: "BOBCAT",
            Cops: 8,
            Robbers: 7,
            Info: "تعداد نیروهای نظامی حداکثر 8 نفر میباشد ( شامل 3 سوات و 5 نفر  نیروی نظامی + یک واحد به عنوان هلی )  و رابر ها باید حداقل 5 نفر و حداکثر 7 نفر باشند  این رابری جوینر ندارد",
            movie: false,
            photo: "img/BobcatCover.png",
            Active: "Active",
        },
        ['LifeInsurance']: {
            Rob: "Life Insurance",
            Cops: 8,
            Robbers: 8,
            Info: "تعداد نیروهای نظامی حداکثر 8 نفر میباشد (شامل 4 سوات + 4 نفر نیروهای نظامی + یک واحد به عنوان واحد هلی  )  تعداد رابرها باید، حداقل 4 نفر و حداکثر 8 نفر باشند.  از تعداد 8 نفر رابر،  1 نفر می توانند ،  جوینر باشند ",
            movie: false,
            photo: "img/LifeInsuranceCover.png",
            Active: "Active",
        },
        ['ShBank']: {
            Rob: "Paleto BANK",
            Cops: 6,
            Robbers: 6,
            Info: "تعداد نیروهای نظامی حداکثر 6 نفر میباشد (شامل 2 سوات + 4 نیروی نظامی + یک واحد به  عنوان واحد هلی) رابرها باید حداقل 4 نفر و حداکثر  6 نفر باشند . این رابری جوینر ندارد ",
            movie: false,
            photo: "img/ShBankCover.png",
            Active: "Active",
        },
        ['Jewelry']: {
            Rob: "JEWELRY",
            Cops: 4,
            Robbers: 4,
            Info: "تعداد نیروهای نظامی حداکثر 4 نفر میباشد (شامل 1 سوات + 3 نیروی آفیسر )  رابر ها حداقل 3 نفر و حداکثر 4 نفر  می باشد",
            movie: false,
            photo: "img/JewelryCover.png",
            Active: "Active",
        },
        ['MazeBank']: {
            Rob: "MAZE BANK",
            Cops: 8,
            Robbers: 8,
            Info: "تعداد نیروهای نظامی حداکثر 8 نفر ( شامل 4 نفر نیروی نظامی و 4 نفر سوات  ) در این رابری رابر ها باید حداقل 6 نفر و حداکثر 8 نفر باشند . این رابری جوینر ندارد ",
            movie: false,
            photo: "img/MazeBankCover.png",
            Active: "Active",
        },
        ['Jewelry2']: {
            Rob: "JEWELRY 2",
            Cops: 4,
            Robbers: 4,
            Info: "تعداد نیروهای نظامی حداکثر 4 نفر میباشد (شامل 1 سوات + 3 نیروی آفیسر )  رابر ها حداقل 3 نفر و حداکثر 4 نفر  می باشد",
            movie: false,
            photo: "img/Jewelry2Cover.png",
            Active: "Active",
        },
        ['FleecaBank']: {
            Rob: "FLEECA BANK",
            Cops: 4,
            Robbers: 4,
            Info: "تعداد نیروهای نظامی 4 نفر ( شامل 1 سوات و 3 نیروی نظامی ) رابرها باید حداقل 3 نفر و حداکثر  4 نفر باشند.  این رابری فقط با پیستول میباشد و جوینر ندارد",
            movie: false,
            photo: "img/FleecaBankCover.png",
            Active: "Active",
        },
        ['Jewelry3']: {
            Rob: "Almas Jewelry",
            Cops: 8,
            Robbers: 7,
            Info: "تعداد نیروهای نظامی حداکثر 8 نفر میباشد (شامل 2 سوات + 6 نیروی آفیسر )  رابر ها حداقل 5 نفر و حداکثر 7 نفر  می باشد",
            movie: false,
            photo: "img/Jewelry3Cover.png",
            Active: "Active",
        },
        ['Pursuit']: {
            Rob: "Pursuit",
            Cops: "∞",
            Robbers: "2",
            Info: "رابر ها باید حداقل یک نفر و حداکثر 2 نفر باشند . این رابری جوینر ندارد و باید قوانین پرسوت در آن رعایت شود",
            movie: "https://cdn.discordapp.com/attachments/834628944069132346/991689689775996949/Pursuit_Robbery.mp4",
            Active: "Active",
        },
        ['Shop']: {
            Rob: "ُShop",
            Cops: 2,
            Robbers: 2,
            Info: "حداکثر 2 نفر نیروی نظامی و حداکثر 2 نفر رابر. این رابری فقط با پیستول میباشد و جوینر ندارد",
            movie: false,
            photo: "img/ShopCover.png",
            Active: "Active",
        },
        ['minijewelry']: {
            Rob: "Mini Jewelry",
            Cops: 4,
            Robbers: 3,
            Info: "حداکثر 4 نفر نیروی نظامی (( شامل 3 آفیسر و یک نفر سوات )) رابر ها حداقل 2 نفر و حداکثر 3 نفر . این رابری فقط با پیستول میباشد و جوینر ندارد",
            movie: false,
            photo: "img/DiamondJewelry.png",
            Active: "Active",
        },
        ['liberty']: {
            Rob: "Liberty",
            Cops: 8,
            Robbers: 7,
            Info: "در این رابری رابر ها باید حداقل 5 نفر و حداکثر 7 نفر باشند . تعداد نیروهای نظامی حداکثر 8 نفر شامل 5 نیروی نظامی و 3 سوات  این رابری جوینر ندارد",
            movie: false,
            photo: "img/LibertyBankk.png",
            Active: "Active",
        },



    }



    $('#CopyDiscord').click(function () {
        CopyClipBoard('https://discord.gg/diamond-rp')
    })
    $('#CopyRules').click(function () {
        CopyClipBoard('https://docs.google.com/document/d/1MVSMllX3nJzfGatfeEw2ElZL0uGBsuoOKbnRYNkbHMY/edit#heading=h.wtntzz7czvq8')
    })
    $('#CopyHex').click(function () {
        CopyClipBoard(Steam)
    })
    $('#CopyPhone').click(function () {
        CopyClipBoard('phone')
    })
    $('#Cargo').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Cargo'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Cargo'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Cargo'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Cargo'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Cargo'].Active;
        if (Robs['Cargo'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Cargo'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Cargo'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Cargo'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Cargo'].Active == "Down"){
            SetupTimer(Robs['Cargo'].Stamp)
        }
    })
    $('#CBank').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['CBank'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['CBank'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['CBank'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['CBank'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['CBank'].Active;
        if (Robs['CBank'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['CBank'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['CBank'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['CBank'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['CBank'].Active == "Down"){
            SetupTimer(Robs['CBank'].Stamp)
        }
    })

    $('#Mythic').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Mythic'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Mythic'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Mythic'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Mythic'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Mythic'].Active;
        if (Robs['Mythic'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Mythic'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Mythic'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Mythic'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Mythic'].Active == "Down"){
            SetupTimer(Robs['Mythic'].Stamp)
        }
    })

    $('#Shipment').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Shipment'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Shipment'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Shipment'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Shipment'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Shipment'].Active;
        if (Robs['Shipment'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Shipment'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Shipment'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Shipment'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Shipment'].Active == "Down"){
            SetupTimer(Robs['Shipment'].Stamp)
        }
    })
    $('#Bobcat').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Bobcat'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Bobcat'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Bobcat'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Bobcat'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Bobcat'].Active;
        if (Robs['Bobcat'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Bobcat'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Bobcat'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Bobcat'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Bobcat'].Active == "Down"){
            SetupTimer(Robs['Bobcat'].Stamp)
        }
    })
    $('#LifeInsurance').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['LifeInsurance'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['LifeInsurance'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['LifeInsurance'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['LifeInsurance'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['LifeInsurance'].Active;
        if (Robs['LifeInsurance'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['LifeInsurance'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['LifeInsurance'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['LifeInsurance'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['LifeInsurance'].Active == "Down"){
            SetupTimer(Robs['LifeInsurance'].Stamp)
        }
    })
    $('#ShBank').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['ShBank'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['ShBank'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['ShBank'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['ShBank'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['ShBank'].Active;
        if (Robs['ShBank'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['ShBank'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['ShBank'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['ShBank'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['ShBank'].Active == "Down"){
            SetupTimer(Robs['ShBank'].Stamp)
        }
    })
    $('#Jewelry').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Jewelry'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Jewelry'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Jewelry'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Jewelry'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Jewelry'].Active;
        if (Robs['Jewelry'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Jewelry'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Jewelry'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Jewelry'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Jewelry'].Active == "Down"){
            SetupTimer(Robs['Jewelry'].Stamp)
        }
    })

    $('#MazeBank').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['MazeBank'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['MazeBank'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['MazeBank'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['MazeBank'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['MazeBank'].Active;
        if (Robs['MazeBank'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['MazeBank'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['MazeBank'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['MazeBank'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['MazeBank'].Active == "Down"){
            SetupTimer(Robs['MazeBank'].Stamp)
        }
    })

    $('#Jewelry2').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Jewelry2'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Jewelry2'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Jewelry2'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Jewelry2'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Jewelry2'].Active;
        if (Robs['Jewelry2'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Jewelry2'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Jewelry2'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Jewelry2'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Jewelry2'].Active == "Down"){
            SetupTimer(Robs['Jewelry2'].Stamp)
        }
    })
    $('#FleecaBank').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['FleecaBank'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['FleecaBank'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['FleecaBank'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['FleecaBank'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['FleecaBank'].Active;
        if (Robs['FleecaBank'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['FleecaBank'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['FleecaBank'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['FleecaBank'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['FleecaBank'].Active == "Down"){
            SetupTimer(Robs['FleecaBank'].Stamp)
        }
    })
    $('#Jewelry3').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Jewelry3'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Jewelry3'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Jewelry3'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Jewelry3'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Jewelry3'].Active;
        if (Robs['Jewelry3'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Jewelry3'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Jewelry3'].movie)
        }
        else {

            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Jewelry3'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Jewelry3'].Active == "Down"){
            SetupTimer(Robs['Jewelry3'].Stamp)
        }
    })
    $('#Pursuit').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Pursuit'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Pursuit'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Pursuit'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Pursuit'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Pursuit'].Active;
        if (Robs['Pursuit'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Pursuit'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Pursuit'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Pursuit'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Pursuit'].Active == "Down"){
            SetupTimer(Robs['Pursuit'].Stamp)
        }
    })

    $('#Shop').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['Shop'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Shop'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Shop'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Shop'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Shop'].Active;
        if (Robs['Shop'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Shop'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Shop'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Shop'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Shop'].Active == "Down"){
            SetupTimer(Robs['Shop'].Stamp)
        }
    })
    $('#minijewelry').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['minijewelry'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['minijewelry'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['minijewelry'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['minijewelry'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['minijewelry'].Active;
        if (Robs['minijewelry'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['minijewelry'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['minijewelry'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['minijewelry'].photo)
        }     
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['minijewelry'].Active == "Down"){
            SetupTimer(Robs['minijewelry'].Stamp)
        } 
    }) 
            
    $('#liberty').click(function () {

        document.getElementById("setRobName").innerHTML = Robs['liberty'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['liberty'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['liberty'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['liberty'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['liberty'].Active;
        if (Robs['liberty'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['liberty'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['liberty'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['liberty'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['liberty'].Active == "Down"){
            SetupTimer(Robs['liberty'].Stamp)
        } 
    })
    $('#police').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['police'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['police'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['police'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['police'].Image)

    })
    $('#sheriff').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['sheriff'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['sheriff'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['sheriff'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['sheriff'].Image)

    })
    $('#ambulance').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['ambulance'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['ambulance'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['ambulance'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['ambulance'].Image)
    })
    $('#taxi').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['taxi'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['taxi'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['taxi'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['taxi'].Image)
    })
    $('#mechanic').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['mechanic'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['mechanic'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['mechanic'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['mechanic'].Image)
    })
    $('#weazel').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['weazel'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['weazel'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['weazel'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['weazel'].Image)
    })

    $('#force').click(function () {
        document.getElementById("setJobName").innerHTML = jobs['force'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['force'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['force'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['force'].Image)
    })
    $('#benny').click(function () {

        document.getElementById("setJobName").innerHTML = jobs['benny'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['benny'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['benny'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['benny'].Image)
    })
    $('#FBI-1').click(function () {

        document.getElementById("setJobName").innerHTML = jobs['FBI-1'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['FBI-1'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['FBI-1'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['FBI-1'].Image)
    })
    $('#justice').click(function () {

        document.getElementById("setJobName").innerHTML = jobs['justice'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['justice'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['justice'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['justice'].Image)
    })
    $('#uwu').click(function () {

        document.getElementById("setJobName").innerHTML = jobs['uwu'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['uwu'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['uwu'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['uwu'].Image)
    })
    $('#bahamas').click(function () {

        document.getElementById("setJobName").innerHTML = jobs['bahamas'].Shoghl;
        document.getElementById("Tozihat").innerHTML = jobs['bahamas'].Tozihat;
        document.getElementById("Online").innerHTML = jobs['bahamas'].Online;
        $('.ShowInfoJob img').attr('src', "./" + jobs['bahamas'].Image)
    })
    $('.Home').click(function () {

        $('#HomePage').css('display', 'block');
        $('#JobsPage').css('display', 'none');
        $('#RobsPage').css('display', 'none');
        $('#usersPage').css('display', 'none');
        $('#infoPage').css('display', 'none');
    })
    $('.Jobs').click(function () {

        $('#HomePage').css('display', 'none');
        $('#JobsPage').css('display', 'block');
        $('#RobsPage').css('display', 'none');
        $('#usersPage').css('display', 'none');
        $('#infoPage').css('display', 'none');
    })
    $('.Robs').click(function () {

        $('#HomePage').css('display', 'none');
        $('#JobsPage').css('display', 'none');
        $('#RobsPage').css('display', 'block');
        $('#usersPage').css('display', 'none');
        $('#infoPage').css('display', 'none');
        document.getElementById("setRobName").innerHTML = Robs['Cargo'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Cargo'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Cargo'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Cargo'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Cargo'].Active;
        if (Robs['Cargo'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Cargo'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Cargo'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Cargo'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Cargo'].Active == "Down"){
            SetupTimer(Robs['Cargo'].Stamp)
        }
    })
    $('.users').click(function () {

        $('#HomePage').css('display', 'none');
        $('#JobsPage').css('display', 'none');
        $('#RobsPage').css('display', 'none');
        $('#usersPage').css('display', 'block');
        $('#infoPage').css('display', 'none');
    })
    $('.diamond').click(function () {

        $('#HomePage').css('display', 'none');
        $('#JobsPage').css('display', 'none');
        $('#RobsPage').css('display', 'none');
        $('#usersPage').css('display', 'none');
        $('#infoPage').css('display', 'block');
    })
    function SetRob() {
        document.getElementById("setRobName").innerHTML = Robs['Cargo'].Rob;
        document.getElementById("PDMax").innerHTML = Robs['Cargo'].Cops;
        document.getElementById("RobMax").innerHTML = Robs['Cargo'].Robbers;
        document.getElementById("TozihatRob").innerHTML = Robs['Cargo'].Info;
        document.getElementById("ColdDown").innerHTML = Robs['Cargo'].Active;
        if (Robs['Cargo'].Active == "Active"){
            $('#ColdDown').css('color', 'rgb(150, 243, 11)')
        }else{
            $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
        }
        if (Robs['Cargo'].movie != false) {
            $('.ShowInfoRob img').css('display', 'none')
            $('.ShowInfoRob video').css('display', 'block')
            $('.ShowInfoRob video').attr('src', Robs['Cargo'].movie)
        }
        else {
            $('.ShowInfoRob video').css('display', 'none')
            $('.ShowInfoRob img').css('display', 'block')
            $('.ShowInfoRob img').attr('src', Robs['Cargo'].photo)
        }
        clearInterval(GlobalInterval);
        $('#jamal').hide();
        if (Robs['Cargo'].Active == "Down"){
            SetupTimer(Robs['Cargo'].Stamp)
        }
    }
    window.addEventListener("keyup", (e) => {
        if (closeKeys.includes(e.keyCode)) {
            closeui()
        }
    })
    function closeui() {

        $.post('http://' + window.ResourceName + '/close', JSON.stringify({}));
        $('#Scoreboard').css('display', 'none');
        $('#HomePage').css('display', 'block');
        $('#JobsPage').css('display', 'none');
        $('#RobsPage').css('display', 'none');
        $('#usersPage').css('display', 'none');
        $('#infoPage').css('display', 'none');
        clearInterval(GlobalInterval);
        $('#jamal').hide();
    }

    function CopyClipBoard(Copy) {
        $("#CopyDone").fadeIn(123)
        setTimeout(() => {
            $("#CopyDone").fadeOut(123)
        }, 2000);
        $.post('https://' + ResourceName + '/Copy', JSON.stringify({ CThis: Copy }));
    }

    function SetRobActivity(Rob) {
        $('#' + Rob).attr('src', './img/' + Rob  + Robs[Rob].Active+'.png')
    }
    function RobCd(cops, copsneed, namerob, cdname) {
        if (cops >= copsneed) {
            if (cdname == false) {
                Robs[namerob].Active = "Active";
                $('#ColdDown').css('color', 'rgb(150, 243, 11)')
            }
            else {
                Robs[namerob].Active = "Down";
                $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
            }
        }
        else {
            if (cdname == false) {
                Robs[namerob].Active = "Deactive";
                $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
            }
            else {
                Robs[namerob].Active = "Down";
                $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
            }

        };
        if (namerob == "Pursuit") {
            if (cdname == false) {
                Robs[namerob].Active = "Active";
                $('#ColdDown').css('color', 'rgb(150, 243, 11)')
            }
            else {
                Robs[namerob].Active = "Down";
                $('#ColdDown').css('color', 'rgb(238, 18, 18) ')
            }
        }
        SetRobActivity(namerob)
    }

    window.addEventListener('message', (event) => {
        if (event.data.Dtoggle == true) {
            $('#Scoreboard').css('display', 'block');
            SetRob()

        }
        if (event.data.Dtoggle == false) {
            $('#Scoreboard').css('display', 'none');
        }

        if (event.data.action == 'updateJob') {
            var JobData = event.data.data.job;
            jobs['police'].Online = JobData.police
            jobs['force'].Online = JobData.forces
            jobs['sheriff'].Online = JobData.sheriff
            jobs['mechanic'].Online = JobData.mechanic
            jobs['benny'].Online = JobData.benny
            jobs['FBI-1'].Online = JobData.fbi
            jobs['justice'].Online = JobData.justice
            jobs['taxi'].Online = JobData.taxi
            jobs['ambulance'].Online = JobData.ambulance
            jobs['weazel'].Online = JobData.weazel
            document.getElementById("setJobName").innerHTML = jobs['police'].Shoghl;
            document.getElementById("Tozihat").innerHTML = jobs['police'].Tozihat;
            document.getElementById("Online").innerHTML = jobs['police'].Online;
            $('.ShowInfoJob img').attr('src', "./" + jobs['police'].Image)
        }

        if (event.data.action == 'updateJob') {

            var JobData = event.data.data.job;
            shopCd = event.data.data.rob.Shop.Status
            PursuitCd = event.data.data.rob.Pursuit.Status
            Jewelry3Cd = event.data.data.rob.Jewelry3.Status
            FleecaBankCd = event.data.data.rob.FleecaBank.Status
            Jewelery2Cd = event.data.data.rob.Jewelry2.Status
            minijewelryCd = event.data.data.rob.minijewelry.Status
            LibertyCd = event.data.data.rob.liberty.Status
            MazeBankCd = event.data.data.rob.MazeBank.Status
            JeweleryCd = event.data.data.rob.Jewelry.Status
            ShBankCd = event.data.data.rob.ShBank.Status
            LifeInsurancecd = event.data.data.rob.LifeInsurance.Status
            Bobcatcd = event.data.data.rob.Bobcat.Status
            ShipmentCd = event.data.data.rob.Shipment.Status
            mythicCd = event.data.data.rob.Mythic.Status
            CBankCd = event.data.data.rob.CBank.Status
            CargoCd = event.data.data.rob.Cargo.Status
            
            Robs['Shop'].Stamp = event.data.data.rob.Shop.CoolDown
            Robs['Pursuit'].Stamp = event.data.data.rob.Pursuit.CoolDown
            Robs['Jewelry3'].Stamp= event.data.data.rob.Jewelry3.CoolDown
            Robs['FleecaBank'].Stamp = event.data.data.rob.FleecaBank.CoolDown
            Robs['Jewelry2'].Stamp = event.data.data.rob.Jewelry2.CoolDown
            Robs['minijewelry'].Stamp = event.data.data.rob.minijewelry.CoolDown
            Robs['liberty'].Stamp = event.data.data.rob.liberty.CoolDown
            Robs['MazeBank'].Stamp = event.data.data.rob.MazeBank.CoolDown
            Robs['Jewelry'].Stamp = event.data.data.rob.Jewelry.CoolDown
            Robs['ShBank'].Stamp = event.data.data.rob.ShBank.CoolDown
            Robs['LifeInsurance'].Stamp = event.data.data.rob.LifeInsurance.CoolDown
            Robs['Bobcat'].Stamp = event.data.data.rob.Bobcat.CoolDown
            Robs['Shipment'].Stamp = event.data.data.rob.Shipment.CoolDown
            Robs['Mythic'].Stamp = event.data.data.rob.Mythic.CoolDown
            Robs['CBank'].Stamp = event.data.data.rob.CBank.CoolDown
            Robs['Cargo'].Stamp = event.data.data.rob.Cargo.CoolDown
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Shop"].Cops, "Shop", shopCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Pursuit"].Cops, "Pursuit", PursuitCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Jewelry3"].Cops, "Jewelry3", Jewelry3Cd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["FleecaBank"].Cops, "FleecaBank", FleecaBankCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Jewelry2"].Cops, "Jewelry2", Jewelery2Cd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["minijewelry"].Cops, "minijewelry", minijewelryCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["liberty"].Cops, "liberty", LibertyCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["MazeBank"].Cops, "MazeBank", MazeBankCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Jewelry"].Cops, "Jewelry", JeweleryCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["ShBank"].Cops, "ShBank", ShBankCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["LifeInsurance"].Cops, "LifeInsurance", LifeInsurancecd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Bobcat"].Cops, "Bobcat", Bobcatcd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Shipment"].Cops, "Shipment", ShipmentCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Mythic"].Cops, "Mythic", mythicCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["CBank"].Cops, "CBank", CBankCd)
            RobCd(JobData.police + JobData.sheriff + JobData.forces, Robs["Cargo"].Cops, "Cargo", CargoCd)
        }

        if (event.data.action == 'updatePlayerInfo') {
            Steam = event.data.data.Hex;
            document.getElementById("MySteam").innerHTML = event.data.data.SteamName;
            document.getElementById("Myjob2").innerHTML = event.data.data.job;
            document.getElementById("MyLeveL").innerHTML = "Level "+event.data.data.level;
            document.getElementById("MyHex").innerHTML = event.data.data.Hex;
        }
        if (event.data.action == 'updatePlayer') {
            timerint = setInterval(function () {
                let strTime = new Date().toLocaleTimeString();
                document.getElementById("clock").innerHTML = strTime
            }, 1000)
            document.getElementById("AllP").innerHTML = event.data.player_count;
        }

    })
})

function SetupTimer(time){
    clearInterval(GlobalInterval);
    var countDownDate = time*1000
    // Update the count down every 1 second
    GlobalInterval = setInterval(function() {
    
      // Get today's date and time
      var now = new Date().getTime();
      // Find the distance between now and the count down date
      var distance = countDownDate - now;

      // Time calculations for days, hours, minutes and seconds
      var days = Math.floor(distance / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);
        if (seconds < 10){
            seconds = "0"+seconds
        }
        if (hours < 10){
            hours = "0"+hours
        }
        if (minutes < 10){
            minutes = "0"+minutes
        }
      // Display the result in the element with id="demo"
      document.getElementById("RobDown").innerHTML = hours + ":"
      + minutes + ":" + seconds;
      $('#jamal').show();
      // If the count down is finished, write some text
      if (distance < 0) {
        clearInterval(GlobalInterval);
        $('#jamal').hide();
      }
    }, 1000);
}