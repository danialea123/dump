window.ResourceName = 'diamond_hud'
$(document).ready(function(){
    $.post('https://'+ResourceName+'/NUIReady', JSON.stringify({}));
    window.addEventListener("message", function(event) {
        var v = event.data 
        var datos = v.dato
        var vida = new ldBar("#vida")
        var armor = new ldBar("#chaleco")
        var stamina = new ldBar("#stamina")
        var stress = new ldBar("#stress")
        var comida = new ldBar("#comida")
        var agua = new ldBar("#agua")
        var co2 = new ldBar("#co2")
        var gaso = new ldBar("#carhudjs")
        var dollar = Intl.NumberFormat('en-US');
    
        switch (v.action) {
            // Compass
            case "updateRotation": 
                $('.mapIMG').css('transform', 'rotate(' + parseFloat(v.rotation).toFixed(2) + 'deg)')
            break;

            // Show Car Hud
            case "showCarhud":
                gaso.set(v.gasolina, true)
                $('.callejs').html(v.street)
                if (v.cinturon == true) {
                    $('.cinto').attr('src', 'https://cdn.discordapp.com/attachments/933891151885381682/937154076108546108/belt2.png')
                } else if(v.cinturon == false) {
                    $('.cinto').attr('src', 'https://cdn.discordapp.com/attachments/933891151885381682/937154076368572456/belt.png')
                }

                if (v.bateria == true) {
                    $('.motor').attr('src', 'https://cdn.discordapp.com/attachments/933891151885381682/937152305667657778/engine2.png')
                } else if(v.bateria == false) {
                    $('.motor').attr('src', 'https://cdn.discordapp.com/attachments/933891151885381682/937152305889951804/engine.png')
                }
                $('.velojs').html(Math.round(v.vel.toFixed(2)))
                if (v.gasolina < 20) {
                    $('.igaso').attr('src', 'https://cdn.discordapp.com/attachments/933891151885381682/937152934649659464/gas2.png')
                    $('#carhudjs path.mainline').css({'stroke':'#fa0000'})
                } else {
                    $('.igaso').attr('src', 'https://cdn.discordapp.com/attachments/933891151885381682/937152934863581225/gas.png')
                    $('#carhudjs path.mainline').css({'stroke':'#00ADFA'})
                }
                $('.gasojs').html(Math.round(v.gasolina)+'%')
                $('.motorjs').html(Math.round(v.vidav)+'%')
                $('.mapa').fadeIn(100)
                $('.carhud').fadeIn(100)
                $('.calle').fadeIn(100)
                $('.imgcar').fadeIn(100)
            break;

            case "ShowMap":
                $('.mapa').show();
            break;

            case "HideMap":
                $('.mapa').hide();
            break;
            // Hide Car Hud

            case "hideCarhud":
                $('.carhud').fadeOut(100)
                $('.calle').fadeOut(100)
                $('.imgcar').fadeOut(100)
            break;
            
            case "updateStatusUP":
                $('.pedID').html(' Player ID: '+v.pid)
                $('.logoprueba').attr('src', v.logo)
                $('.logotext').text(v.logotext)
                $(".pedclock").text(event.data.time);
                $("#total-players").html(v.playerss);
                $('.job').text(event.data.job);
                $('.gang').text(event.data.gang);
                $('.pedcash').html('$'+dollar.format(v.wallet))
                $('.pedbank').html('$'+dollar.format(v.banks))
                $('.pedduty').html('$'+dollar.format(v.duty))

            break;

            // Status
            case "updateStatus":
                //$('.playerJOB').text(event.data.job);
                vida.set(v.health, true)
                $('.vidap').html(v.health+'%')
                armor.set(v.armor, true)
                $('.chalecop').html(v.armor+'%')
                stamina.set(v.stamina, true)
                $('.staminap').html(Math.round(v.stamina)+'%')
                stress.set(v.stress, true)
                $('.stressp').html(Math.round(v.stress)+'%')
                comida.set(v.hunger, true)
                $('.comidap').html(Math.round(v.hunger)+'%')
                agua.set(v.thirst, true)
                $('.aguap').html(Math.round(v.thirst)+'%')
                co2.set(v.oxigen, true)
                $('.co2p').html(Math.round(v.oxigen)+'%')
            break;

            case "statushud":
                $(".statusHUD").fadeIn();

            break;

            case "statushide":
                $(".statusHUD").fadeOut();

            break;

            case "speed1":
                $(".kmh").show();
                $(".mph").hide();
            break;

            case "speed2":
                $(".mph").show();
                $(".kmh").hide();
            break;

            case "pedONLINEHide":
                $("#playersONLINE").fadeOut();
            break;

            case "pedIDHide":
                $("#playersID").fadeOut();
            break;

            case "jobHide":
                $(".playerJOB").fadeOut();
            break;

            case "logoHide":
                $("#logoimg").hide();
            break;

            case "logoTextHide":
                $("#logotext").hide();
            break;

            case "jobShow":
                $(".playerJOB").fadeIn();
            break;

            case "Showkeybindsall":
                $('#keybindsall').show()
            break;

            case "Hidekeybindsall":
                $("#keybindsall").hide();
            break;
                

            case  "updateAmmo":
                $('.ammo').show()
                $('.ammojs').html('Ammo <span style="color: #00abe4;">'+v.ammohand+'/'+v.ammo+' </span>', 'src')
            break;

            // Hide ammo
            case "hideAmmo":
                $('.ammo').fadeOut(100);
            break;

            case "ShowAllHud":
                $('.todoelhud').show()
            break;
            
            case "hideAllHud":
                $('.todoelhud').hide()
            break;

            case "microphoneShow":
                $(".micro").fadeIn();
            break;

            case "microphoneHide":
                $(".micro").fadeOut(100);
            break;

            case "hidecash":
                $('.playersCASH').fadeOut(100);
            break;

            case "hidebank":
                $('.playersBANK').fadeOut(100);
            break;

            case "hideduty":
                $('.playersDUTY').fadeOut(100);
            break;

            case "hideclock":
                $('.CLOCK').fadeOut(100);
            break;

            case "zonehide":
                $(".zoneX").hide();
                $(".zone").hide();
            break;

        }
            if (event.data.talking == true) 
            {
                $('.voicejs').attr("src","https://cdn.discordapp.com/attachments/933891151885381682/937137628027953203/Micro2.png")
            }
            else if (event.data.talking == false)
            {
                $('.voicejs').attr("src","https://cdn.discordapp.com/attachments/933891151885381682/937137627574992956/Micro1.png")
            }

    });


    $(function () {
        window.addEventListener('message', function (event) {
            var v = event.data 
            switch (v.action) {
                // Notify

                case "showNoti":
                    if (v.type == 'error') {
                        $('.notification').css({'border-right':'.3vw solid #ff0000'})
                        $('.titlejs').html(v.title)
                        $('.texto').html(v.msg)
                        $('.notify').fadeIn()
                        setTimeout(() => {
                            $('.notify').fadeOut()
                        }, v.time)
                    } else if(v.type == 'success') {
                        $('.notification').css({'border-right':'.3vw solid #09ff00'})
                        $('.titlejs').html(v.title)
                        $('.texto').html(v.msg)
                        $('.notify').fadeIn()
                        setTimeout(() => {
                            $('.notify').fadeOut()
                        }, v.time)
                    }
                    if (v.type == 'info') {
                        $('.notification').css({'border-right':'.3vw solid #1900ff'})
                        $('.titlejs').html(v.title)
                        $('.texto').html(v.msg)
                        $('.notify').fadeIn()
                        setTimeout(() => {
                            $('.notify').fadeOut()
                        }, v.time)
                    } 
                break;
                
            }
        })
    })


    $(function () {
        window.addEventListener('message', function (event) {
            switch (event.data.action) {
                case "menuShow":
                    $(".OpcionPanel").show();
                    $('.notify').show();
                break;

                case "menuHide":
                    $(".OpcionPanel").hide();
                    $('.notify').hide();
                break;

            }
        })
    })


    $(function () {
        window.addEventListener('message', function (event) {
            switch (event.data.action) {
                case 'setJob':
                    $('.job').text(event.data.data)
                break;
            }
        })
    })

    $(function () {
        window.addEventListener('message', function (event) {
            if(event.data.showZone == true){
                $(".zone").show();
                $(".zoneX").hide()
            }
            if(event.data.showZone == false){
                $(".zone").hide();
                $(".zoneX").show()
            }
        })
    })


    $(function() {
        window.addEventListener('message', function (event) {
            // switch (event.data.action) {
            $("#movehud").click(function () { 
            

                // case 'move':
                $('#co2').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("co2Top", dragpositionHealthdivTop);
                    localStorage.setItem("co2Left", dragpositionHealthdivLeft);
                }
                });
                $('#vida').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("vidaTop", dragpositionHealthdivTop);
                    localStorage.setItem("vidaLeft", dragpositionHealthdivLeft);
                }
                });
                $('#comida').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("comidaTop", dragpositionHealthdivTop);
                    localStorage.setItem("comidaLeft", dragpositionHealthdivLeft);
                }
                });
                $('#agua').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("aguaTop", dragpositionHealthdivTop);
                    localStorage.setItem("aguaLeft", dragpositionHealthdivLeft);
                }
                });
                $('#stamina').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("staminaTop", dragpositionHealthdivTop);
                    localStorage.setItem("staminaLeft", dragpositionHealthdivLeft);
                }
                });
                $('#stress').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("stressTop", dragpositionHealthdivTop);
                    localStorage.setItem("stressLeft", dragpositionHealthdivLeft);
                }
                });
                $('#chaleco').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("chalecoTop", dragpositionHealthdivTop);
                    localStorage.setItem("chalecoLeft", dragpositionHealthdivLeft);
                }
                });
                $('#micro').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("microTop", dragpositionHealthdivTop);
                    localStorage.setItem("microLeft", dragpositionHealthdivLeft);
                }
                });
                $('#playersID').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("playersIDTop", dragpositionHealthdivTop);
                    localStorage.setItem("playersIDLeft", dragpositionHealthdivLeft);
                }
                });
                $('#playersONLINE').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("playersONLINETop", dragpositionHealthdivTop);
                    localStorage.setItem("playersONLINELeft", dragpositionHealthdivLeft);
                }
                });
                $('#logo').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("logoTop", dragpositionHealthdivTop);
                    localStorage.setItem("logoLeft", dragpositionHealthdivLeft);
                }
                });
                $('#carhud').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("carhudTop", dragpositionHealthdivTop);
                    localStorage.setItem("carhudLeft", dragpositionHealthdivLeft);
                }
                });
                $('#playersCASH').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("playersCASHTop", dragpositionHealthdivTop);
                    localStorage.setItem("playersCASHLeft", dragpositionHealthdivLeft);
                }
                });
                $('#playersBANK').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("playersBANKTop", dragpositionHealthdivTop);
                    localStorage.setItem("playersBANKLeft", dragpositionHealthdivLeft);
                }
                });
                $('#playersDUTY').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("playersDUTYTop", dragpositionHealthdivTop);
                    localStorage.setItem("playersDUTYLeft", dragpositionHealthdivLeft);
                }
                });
                $('#CLOCK').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("CLOCKTop", dragpositionHealthdivTop);
                    localStorage.setItem("CLOCKLeft", dragpositionHealthdivLeft);
                }
                });
                $('#calle').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("calleTop", dragpositionHealthdivTop);
                    localStorage.setItem("calleLeft", dragpositionHealthdivLeft);
                }
                });

                $('#playerJOBMOVE').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("playerJOBMOVETop", dragpositionHealthdivTop);
                    localStorage.setItem("playerJOBMOVELeft", dragpositionHealthdivLeft);
                }
                });

                $('#playergangMOVE').draggable({
                    drag: function(event, ui){
                        dragpositionHealthdivTop = ui.position.top;
                        dragpositionHealthdivLeft = ui.position.left;
                        localStorage.setItem("playergangMOVETop", dragpositionHealthdivTop);
                        localStorage.setItem("playergangMOVELeft", dragpositionHealthdivLeft);
                    }
                    });

                $('#ammoMove').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("ammoMoveTop", dragpositionHealthdivTop);
                    localStorage.setItem("ammoMoveLeft", dragpositionHealthdivLeft);
                }
                });

                $('#ZoneMove').draggable({
                drag: function(event, ui){
                    dragpositionHealthdivTop = ui.position.top;
                    dragpositionHealthdivLeft = ui.position.left;
                    localStorage.setItem("ZoneMoveTop", dragpositionHealthdivTop);
                    localStorage.setItem("ZoneMoveLeft", dragpositionHealthdivLeft);
                }
                });

                $('#notifyMOVE').draggable({
                    drag: function(event, ui){
                        dragpositionHealthdivTop = ui.position.top;
                        dragpositionHealthdivLeft = ui.position.left;
                        localStorage.setItem("notifyMOVETop", dragpositionHealthdivTop);
                        localStorage.setItem("notifyMOVELeft", dragpositionHealthdivLeft);
                }
                });
                // break;
            
            });
        //     }
        })
    })

    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "setPosition": 
                
            $("#micro").animate({ top: localStorage.getItem("microTop"), left: localStorage.getItem("microLeft") });
            $("#co2").animate({ top: localStorage.getItem("co2Top"), left: localStorage.getItem("co2Left") });
            $("#vida").animate({ top: localStorage.getItem("vidaTop"), left: localStorage.getItem("vidaLeft") });
            $("#comida").animate({ top: localStorage.getItem("comidaTop"), left: localStorage.getItem("comidaLeft") });
            $("#agua").animate({ top: localStorage.getItem("aguaTop"), left: localStorage.getItem("aguaLeft") });
            $("#stamina").animate({ top: localStorage.getItem("staminaTop"), left: localStorage.getItem("staminaLeft") });
            $("#stress").animate({ top: localStorage.getItem("stressTop"), left: localStorage.getItem("stressLeft") });
            $("#chaleco").animate({ top: localStorage.getItem("chalecoTop"), left: localStorage.getItem("chalecoLeft") });                     
            $("#playersID").animate({ top: localStorage.getItem("playersIDTop"), left: localStorage.getItem("playersIDLeft") });
            $("#playersONLINE").animate({ top: localStorage.getItem("playersONLINETop"), left: localStorage.getItem("playersONLINELeft") });
            $("#playersCASH").animate({ top: localStorage.getItem("playersCASHTop"), left: localStorage.getItem("playersCASHLeft") });
            $("#playersBANK").animate({ top: localStorage.getItem("playersBANKTop"), left: localStorage.getItem("playersBANKLeft") });
            $("#playersDUTY").animate({ top: localStorage.getItem("playersDUTYTop"), left: localStorage.getItem("playersDUTYLeft") });
            $("#CLOCK").animate({ top: localStorage.getItem("CLOCKTop"), left: localStorage.getItem("CLOCKLeft") });
            $("#logo").animate({ top: localStorage.getItem("logoTop"), left: localStorage.getItem("logoLeft") });
            $("#calle").animate({ top: localStorage.getItem("calleTop"), left: localStorage.getItem("calleLeft") });
            $("#carhud").animate({ top: localStorage.getItem("carhudTop"), left: localStorage.getItem("carhudLeft") });

            $("#playerJOBMOVE").animate({ top: localStorage.getItem("playerJOBMOVETop"), left: localStorage.getItem("playerJOBMOVELeft") });
            $("#playergangMOVE").animate({ top: localStorage.getItem("playergangMOVETop"), left: localStorage.getItem("playergangMOVELeft") });
            $("#ammoMove").animate({ top: localStorage.getItem("ammoMoveTop"), left: localStorage.getItem("ammoMoveLeft") });
            $("#ZoneMove").animate({ top: localStorage.getItem("ZoneMoveTop"), left: localStorage.getItem("ZoneMoveLeft") });
            $("#notifyMOVE").animate({ top: localStorage.getItem("notifyMOVETop"), left: localStorage.getItem("notifyMOVELeft") });


            
            break;
        }
    });


    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "resetPosition": 
                $("#reset-position").click(function () {
                        $("#micro").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("microTop", "0vw");
                        localStorage.setItem("microLeft", "0vw");
                        $("#co2").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("co2Top", "0vw");
                        localStorage.setItem("co2Left", "0vw");
                        $("#vida").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("vidaTop", "0vw");
                        localStorage.setItem("vidaLeft", "0vw");
                        $("#comida").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("comidaTop", "0vw");
                        localStorage.setItem("comidaLeft", "0vw");
                        $("#agua").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("aguaTop", "0vw");
                        localStorage.setItem("aguaLeft", "0vw");
                        $("#stamina").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("staminaTop", "0vw");
                        localStorage.setItem("staminaLeft", "0vw");
                        $("#stress").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("stressTop", "0vw");
                        localStorage.setItem("stressLeft", "0vw");
                        $("#chaleco").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("chalecoTop", "0vw");
                        localStorage.setItem("chalecoLeft", "0vw");
                        $("#playersID").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playersIDTop", "0vw");
                        localStorage.setItem("playersIDLeft", "0vw");
                        $("#playersONLINE").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playersONLINETop", "0vw");
                        localStorage.setItem("playersONLINELeft", "0vw");
                        $("#playersCASH").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playersCASHTop", "0vw");
                        localStorage.setItem("playersCASHLeft", "0vw");
                        $("#playersBANK").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playersBANKTop", "0vw");
                        localStorage.setItem("playersBANKLeft", "0vw");
                        $("#playersDUTY").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playersDUTYTop", "0vw");
                        localStorage.setItem("playersDUTYLeft", "0vw");
                        $("#CLOCK").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("CLOCKTop", "0vw");
                        localStorage.setItem("CLOCKLeft", "0vw");
                        $("#logo").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("logoTop", "0vw");
                        localStorage.setItem("logoLeft", "0vw");
                        $("#carhud").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("carhudTop", "0vw");
                        localStorage.setItem("carhudLeft", "0vw");
                        $("#calle").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("calleTop", "0vw");
                        localStorage.setItem("calleLeft", "0vw");
                        $("#playerJOBMOVE").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playerJOBMOVETop", "0vw");
                        localStorage.setItem("playerJOBMOVELeft", "0vw");
                        $("#playergangMOVE").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("playergangMOVETop", "0vw");
                        localStorage.setItem("playergangMOVELeft", "0vw");
                        $("#ZoneMove").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("ZoneMoveTop", "0vw");
                        localStorage.setItem("ZoneMoveLeft", "0vw");
                        $("#ammoMove").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("ammoMoveTop", "0vw");
                        localStorage.setItem("ammoMoveLeft", "0vw");
                        $("#notifyMOVE").animate({top: "0vw", left: "0vw"});
                        localStorage.setItem("notifyMOVETop", "0vw");
                        localStorage.setItem("notifyMOVELeft", "0vw");

                });
            break;
        }
    })

    
    $(document).keyup((e) => {
        if (e.key === "Escape") {
            setTimeout(() => {
                $.post('https://esx_playerIndicator/exit', JSON.stringify({}));
            }, 300);
        }
    });

    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "HideElement":

                $(document).ready(function() {
                    if (window.localStorage.getItem("co21") != null) {
                    var pb = window.localStorage.getItem("co21");
                    if (pb == "true") {
                        $("#co2").hide(300);
                    }
                    }
                
                    $("#switch1").click(function() {
                    var v = $("#co2").is(":visible")
                    $("#co2").fadeToggle(500, "swing");
                    window.localStorage.setItem("co21", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("vida1") != null) {
                    var pb = window.localStorage.getItem("vida1");
                    if (pb == "true") {
                        $("#vida").hide(300);
                    }
                    }
                
                    $("#switch2").click(function() {
                    var v = $("#vida").is(":visible")
                    $("#vida").fadeToggle(500, "swing");
                    window.localStorage.setItem("vida1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("comida1") != null) {
                    var pb = window.localStorage.getItem("comida1");
                    if (pb == "true") {
                        $("#comida").hide(300);
                    }
                    }
                
                    $("#switch3").click(function() {
                    var v = $("#comida").is(":visible")
                    $("#comida").fadeToggle(500, "swing");
                    window.localStorage.setItem("comida1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("agua1") != null) {
                    var pb = window.localStorage.getItem("agua1");
                    if (pb == "true") {
                        $("#agua").hide(300);
                    }
                    }
                
                    $("#switch4").click(function() {
                    var v = $("#agua").is(":visible")
                    $("#agua").fadeToggle(500, "swing");
                    window.localStorage.setItem("agua1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("stamina1") != null) {
                    var pb = window.localStorage.getItem("stamina1");
                    if (pb == "true") {
                        $("#stamina").hide(300);
                    }
                    }
                
                    $("#switch5").click(function() {
                    var v = $("#stamina").is(":visible")
                    $("#stamina").fadeToggle(500, "swing");
                    window.localStorage.setItem("stamina1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("stress1") != null) {
                    var pb = window.localStorage.getItem("stress1");
                    if (pb == "true") {
                        $("#stress").hide(300);
                    }
                    }
                
                    $("#switch15").click(function() {
                    var v = $("#stress").is(":visible")
                    $("#stress").fadeToggle(500, "swing");
                    window.localStorage.setItem("stress1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("chaleco1") != null) {
                    var pb = window.localStorage.getItem("chaleco1");
                    if (pb == "true") {
                        $("#chaleco").hide(300);
                    }
                    }
                
                    $("#switch6").click(function() {
                    var v = $("#chaleco").is(":visible")
                    $("#chaleco").fadeToggle(500, "swing");
                    window.localStorage.setItem("chaleco1", v)
                    });
                });
    // UP

                $(document).ready(function() {
                    if (window.localStorage.getItem("playersID1") != null) {
                    var pb = window.localStorage.getItem("playersID1");
                    if (pb == "true") {
                        $("#playersID").hide(300);
                    }
                    }
                
                    $("#switch7").click(function() {
                    var v = $("#playersID").is(":visible")
                    $("#playersID").fadeToggle(500, "swing");
                    window.localStorage.setItem("playersID1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("playersONLINE1") != null) {
                    var pb = window.localStorage.getItem("playersONLINE1");
                    if (pb == "true") {
                        $("#playersONLINE").hide(300);
                    }
                    }
                
                    $("#switch8").click(function() {
                    var v = $("#playersONLINE").is(":visible")
                    $("#playersONLINE").fadeToggle(500, "swing");
                    window.localStorage.setItem("playersONLINE1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("playersCASH1") != null) {
                    var pb = window.localStorage.getItem("playersCASH1");
                    if (pb == "true") {
                        $("#playersCASH").hide(300);
                    }
                    }
                
                    $("#switch9").click(function() {
                    var v = $("#playersCASH").is(":visible")
                    $("#playersCASH").fadeToggle(500, "swing");
                    window.localStorage.setItem("playersCASH1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("playersBANK1") != null) {
                    var pb = window.localStorage.getItem("playersBANK1");
                    if (pb == "true") {
                        $("#playersBANK").hide(300);
                    }
                    }
                
                    $("#switch10").click(function() {
                    var v = $("#playersBANK").is(":visible")
                    $("#playersBANK").fadeToggle(500, "swing");
                    window.localStorage.setItem("playersBANK1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("playersDUTY1") != null) {
                    var pb = window.localStorage.getItem("playersDUTY1");
                    if (pb == "true") {
                        $("#playersDUTY").hide(300);
                    }
                    }
                
                    $("#switch11").click(function() {
                    var v = $("#playersDUTY").is(":visible")
                    $("#playersDUTY").fadeToggle(500, "swing");
                    window.localStorage.setItem("playersDUTY1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("CLOCK1") != null) {
                    var pb = window.localStorage.getItem("CLOCK1");
                    if (pb == "true") {
                        $("#CLOCK").hide(300);
                    }
                    }
                
                    $("#switch12").click(function() {
                    var v = $("#CLOCK").is(":visible")
                    $("#CLOCK").fadeToggle(500, "swing");
                    window.localStorage.setItem("CLOCK1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("logo1") != null) {
                    var pb = window.localStorage.getItem("logo1");
                    if (pb == "true") {
                        $("#logo").hide(300);
                    }
                    }
                
                    $("#logohud").click(function() {
                    var v = $("#logo").is(":visible")
                    $("#logo").fadeToggle(500, "swing");
                    window.localStorage.setItem("logo1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("micro1") != null) {
                    var pb = window.localStorage.getItem("micro1");
                    if (pb == "true") {
                        $("#micro").hide(300);
                    }
                    }
                
                    $("#microhud").click(function() {
                    var v = $("#micro").is(":visible")
                    $("#micro").fadeToggle(500, "swing");
                    window.localStorage.setItem("micro1", v)
                    });
                });

                $(document).ready(function() {
                    if (window.localStorage.getItem("playerJOB1") != null) {
                    var pb = window.localStorage.getItem("playerJOB1");
                    if (pb == "true") {
                        $("#playerJOB").hide(300);
                    }
                    }
                
                    $("#jobhud").click(function() {
                    var v = $("#playerJOB").is(":visible")
                    $("#playerJOB").fadeToggle(500, "swing");
                    window.localStorage.setItem("playerJOB1", v)
                    });
                });

            break;
        }
    });


    //COLOR 
    window.addEventListener("message", function(event) {
        switch (event.data.action) {

            case "setColors":

                $('#playersID').css('color', localStorage.getItem("playersIDColor"));
                $('#playersONLINE').css('color', localStorage.getItem("playersONLINEColor"));
                $('#playersCASH').css('color', localStorage.getItem("playersCASHColor"));
                $('#playersBANK').css('color', localStorage.getItem("playersBANKColor"));
                $('#playersDUTY').css('color', localStorage.getItem("playersDUTYColor"));
                $('#CLOCK').css('color', localStorage.getItem("CLOCKColor"));
                $('#logotext').css('color', localStorage.getItem("logotextColor"));
                $('#playerJOB').css('background', localStorage.getItem("playerJOBColor"));
                $('#playerGang').css('background', localStorage.getItem("playergangColor"));
                $('#notification').css('background', localStorage.getItem("notificationColor"));
                $('#co2 path.mainline').css('stroke', localStorage.getItem("co2Color"));
                $('#vida path.mainline').css('stroke', localStorage.getItem("vidaColor"));
                $('#agua path.mainline').css('stroke', localStorage.getItem("aguaColor"));
                $('#comida path.mainline').css('stroke', localStorage.getItem("comidaColor"));
                $('#stamina path.mainline').css('stroke', localStorage.getItem("staminaColor"));
                $('#stress path.mainline').css('stroke', localStorage.getItem("stressColor"));
                $('#chaleco path.mainline').css('stroke', localStorage.getItem("chalecoColor"));
                $('#carhudjs path.mainline').css('stroke', localStorage.getItem("carhudjsColor"));
                $('#mapborde').css('border-color', localStorage.getItem("mapbordeColor"));

        
            break;
        };
    })

    $(function () {
        $('#color-block').on('colorchange', function () {
        let color = $(this).wheelColorPicker('value')
        
        switch ($("#selection").val()) {
            
            case "playersID-option":
            $('#playersID').css('color', color);
            localStorage.setItem("playersIDColor", color);
            break;

            case "playersONLINE-option":
            $('#playersONLINE').css('color', color);
            localStorage.setItem("playersONLINEColor", color);
            break;

            case "playersCASH-option":
            $('#playersCASH').css('color', color);
            localStorage.setItem("playersCASHColor", color);
            break;

            case "playersBANK-option":
            $('#playersBANK').css('color', color);
            localStorage.setItem("playersBANKColor", color);
            break;

            case "playersDUTY-option":
            $('#playersDUTY').css('color', color);
            localStorage.setItem("playersDUTYColor", color);
            break;

            case "CLOCK-option":
            $('#CLOCK').css('color', color);
            localStorage.setItem("CLOCKColor", color);
            break;

            case "logotext-option":
            $('#logotext').css('color', color);
            localStorage.setItem("logotextColor", color);
            break;

            case "playerJOB-option":
            $('#playerJOB').css('background', color);
            localStorage.setItem("playerJOBColor", color);
            break;

            case "playergang-option":
                $('#playerGang').css('background', color);
                localStorage.setItem("playergangColor", color);
            break;

            case "notification-option":
            $('#notification').css('background', color);
            localStorage.setItem("notificationColor", color);
            break;

            case "co2-option":
            $('#co2 path.mainline').css('stroke', color);
            localStorage.setItem("co2Color", color);
            break;

            case "vida-option":
            $('#vida path.mainline').css('stroke', color);
            localStorage.setItem("vidaColor", color);
            break;

            case "agua-option":
            $('#agua path.mainline').css('stroke', color);
            localStorage.setItem("aguaColor", color);
            break;

            case "comida-option":
            $('#comida path.mainline').css('stroke', color);
            localStorage.setItem("comidaColor", color);
            break;

            case "stamina-option":
            $('#stamina path.mainline').css('stroke', color);
            localStorage.setItem("staminaColor", color);
            break;

            case "stress-option":
                $('#stress path.mainline').css('stroke', color);
                localStorage.setItem("stressColor", color);
            break;

            case "chaleco-option":
            $('#chaleco path.mainline').css('stroke', color);
            localStorage.setItem("chalecoColor", color);
            break;

            case "carhudjs-option":
            $('#carhudjs path.mainline').css('stroke', color);
            localStorage.setItem("carhudjsColor", color);
            break;

            case "mapborde-option":
            $('#mapborde').css('border-color', color);
            localStorage.setItem("mapbordeColor", color);
            break;

        };
        });
    });

    window.addEventListener("message", function(event) {
        switch (event.data.action) {

            case "ResetColor":

                $("#reset-color").click(function () {
                    $('#playersID').css('color', '#ffffff');
                    localStorage.setItem("playersIDColor", '#ffffff');
                    $('#playersONLINE').css('color', '#ffffff');
                    localStorage.setItem("playersONLINEColor", '#ffffff');
                    $('#playersBANK').css('color', '#ffffff');
                    localStorage.setItem("playersBANKColor", '#ffffff');
                    $('#playersCASH').css('color', '#ffffff');
                    localStorage.setItem("playersCASHColor", '#ffffff');
                    $('#playersDUTY').css('color', '#ffffff');
                    localStorage.setItem("playersDUTYColor", '#ffffff');
                    $('#CLOCK').css('color', '#ffffff');
                    localStorage.setItem("CLOCKColor", '#ffffff');
                    $('#logotext').css('color', '#ffffff');
                    localStorage.setItem("logotextColor", '#ffffff');
                    $('#playerJOB').css('background', '');
                    localStorage.setItem("playerJOBColor", '');
                    $('#playerGang').css('background', '');
                    localStorage.setItem("playergangColor", '');
                    $('#notification').css('background', '');
                    localStorage.setItem("notificationColor", '');
                    $('#co2 path.mainline').css('stroke', '');
                    localStorage.setItem("co2Color", '');
                    $('#vida path.mainline').css('stroke', '');
                    localStorage.setItem("vidaColor", '');
                    $('#agua path.mainline').css('stroke', '');
                    localStorage.setItem("aguaColor", '');
                    $('#comida path.mainline').css('stroke', '');
                    localStorage.setItem("comidaColor", '');
                    $('#stamina path.mainline').css('stroke', '');
                    localStorage.setItem("staminaColor", '');
                    $('#stress path.mainline').css('stroke', '');
                    localStorage.setItem("stressColor", '');
                    $('#chaleco path.mainline').css('stroke', '');
                    localStorage.setItem("chalecoColor", '');

                    $('#carhudjs path.mainline').css('stroke', '');
                    localStorage.setItem("carhudjsColor", '');
                    
                    $('#mapborde').css('border-color', '#00ADFA');
                    localStorage.setItem("mapbordeColor", '#00ADFA');

                });
            break;
        };
    })


    $(function () {
    $('#color-block').on('colorchange', function () {
        let color = $(this).wheelColorPicker('value');
        let alpha = $(this).wheelColorPicker('color').a;
        $('.color-preview-box').css('background-color', color);
        $('.color-preview-alpha').text(Math.round(alpha * 100) + '%');
    });
    });
});
// //COLOR PRUEBA
// $(function() {
//     window.addEventListener('message', function (event) {
//         $("#reset-color").click(function () {
//             $('#hunger').css('background', '#cfcfcf');
//             localStorage.setItem("hungerColor", '#cfcfcf');
//         });
//     })
// })

// $(function() {
//     window.addEventListener('message', function (event) {
//         $("#reset-color").click(function () {
//             $('#comidap').css('background', '#cfcfcf');
//             localStorage.setItem("hungerColor", '#cfcfcf');
//         });


//         $(function () {
//             $('#color-block').on('colorchange', function () {
//               let color = $(this).wheelColorPicker('value');
//               let alpha = $(this).wheelColorPicker('color').a;
//               $('.color-preview-box').css('background-color', color);
//               $('.color-preview-alpha').text(Math.round(alpha * 100) + '%');
//             });
//           });
//     })
// })


  
  
  
//   // Data
// window.addEventListener("message", function(event) {
//     switch (event.data.action) {
//         case "show":
//             $("#setting").fadeIn();
//         break;
  
  
//         case "setColors":

//             $('#comidap').css('background', localStorage.getItem("hungerColor"));
    
//         break;
//         };
//     });
