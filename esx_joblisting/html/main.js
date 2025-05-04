$(document).ready(function() {
    var JobName
    window.addEventListener('message', (event) => {
        switch (event.data.action) {
            case "open":
                
                $.post(`https://${GetParentResourceName()}/stats`, JSON.stringify({
                    stats : true
                }));

                $("#body").html("display", "block");
                $("#Title").html(event.data.Title);
                $("#Desc").html(event.data.Desc);
                $("#img").css("background",`url(img/${event.data.img}.png)`);
                $("#img").css("border", event.data.border);
                $("#img").css("box-shadow", event.data.box_shadow);
                $(".button").css("background-color",event.data.color);
                $(".button").css("box-shadow", event.data.buttom_shadow);
                $(".button2").css("background-color",event.data.color2);
                $(".button2").css("box-shadow", event.data.buttom_shadow2);
                $(".blue-color").css("color", event.data.xcolor);
                JobName = event.data.JobName
                $("body").fadeIn(300);
                break;
            case "close":
                $("#body").html("display", "none");
                $("body").fadeOut(300);
                break;
        }

    })

    var joinjob = document.getElementById('joinjob')
    joinjob.addEventListener('click', function() {
        $.post(`https://${GetParentResourceName()}/joinjob`, JSON.stringify({
            job : JobName
        }));
        $("body").fadeOut(300)
        $.post(`https://${GetParentResourceName()}/stats`, JSON.stringify({
            stats : false
        }));
    }, false);

    var quitjob = document.getElementById('quitjob')
    quitjob.addEventListener('click', function() {
        $.post(`https://${GetParentResourceName()}/quitjob`, JSON.stringify({}));
        $("body").fadeOut(300)
        $.post(`https://${GetParentResourceName()}/stats`, JSON.stringify({
            stats : false
        }));
    }, false);

    var close = document.getElementById('close')
    close.addEventListener('click', function() {
        $("body").fadeOut(300);
        $.post(`https://${GetParentResourceName()}/stats`, JSON.stringify({
            stats : false
        }));
    }, false);
})