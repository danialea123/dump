$(function() {
    var lastloc = null
    window.addEventListener('message', (event) => {
        const data = event.data;


        if (data.action == 'hudstats') {
            if (data.display) {
                $(".body").fadeIn(500)
            } else {
                $(".body").fadeOut(500)
            }
        }

        if (data.action == "refreshstatus") {
            $("#hunger").html(data.hunger + '%')
            $("#thirst").html(data.thirst + '%')
        } 

        if (data.action == "refreshtime") {
            $("#clock").html(data.hour + ":" + data.minute)
            $("#timestamp").html(data.timestamp)
            $("#players").html(data.players)
        } 

        if (data.action == 'refreshjob') {
            $("#job").html(data.joblabel)
        }
         
        if (data.action == 'refreshid') {
            $("#playerid").html('ID: ' + data.playerid)
        }

        if (data.action == 'playertalking') {
            
            if (data.stats != 1) {
                $("#playermic").attr('src', 'assets/images/defmice.png') 
            } else {
                $("#playermic").attr('src', 'assets/images/micetalking.gif') 
            }
        }

        if (data.action == 'refreshstreatlabel') {

            if (data.location != lastloc) {
                $('#location').html(data.location)
                lastloc = data.location
                document.getElementById("location").classList.add('animate__animated', 'animate__fadeInDown');
                document.getElementById("location").style.setProperty('--animate-duration', '.3s');
                document.getElementById("location").addEventListener('animationend', () => {
                    document.getElementById("location").classList.remove('animate__animated', 'animate__fadeInDown');
                }, {
                    once: true
                });
            }

            $('#streetlabel').css('color', '#a3a3a3')
            $('#zonelabel').css('color', '#cfcccc')
            
            $('#streetlabel').html(data.streetlabel)
            $('#zonelabel').html(data.zonelabel)
        }
         
        if (data.action == 'enteredvehicle') {
            $("#vehiclehud").fadeIn(500)
        }
         
        if (data.action == 'refreshvehiclehud') {
            $("#vehiclespeed").html(data.speed)
            $("#vehicleengine").css('width', data.engine)
            $("#vehiclegear").html(data.gear)

            $("#vehiclefuel").css('width', data.fuel)

            if (data.light) {
                $("#vehiclelight").attr('src', 'assets/images/aclights.png')
            } else {
                $("#vehiclelight").attr('src', 'assets/images/delights.png')
            }

            if (data.enginestats) {
                $("#vehicleenginestats").attr('src', 'assets/images/alengine.png')
            } else {
                $("#vehicleenginestats").attr('src', 'assets/images/deengine.png')
            }

            if (data.door) {
                $("#vehicledoor").attr('src', 'assets/images/acdoor.png')
            } else {
                $("#vehicledoor").attr('src', 'assets/images/dedoor.png')
            }

            if (data.seatbelt) {
                $("#vehiclebelt").attr('src', 'assets/images/acbelt.png')
            } else {
                $("#vehiclebelt").attr('src', 'assets/images/debelt.png')
            }
        }
         
        if (data.action == 'exitedvehicle') {
            $("#vehiclehud").fadeOut(500)
        }
    })
})