let canClose = true
window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.type === 'nui') {
        if (data.display) {
            canClose = data.data.canClose
            Display(data);
        } else {
            Hide();
        }
    }
});

$(document).on("keydown", function (key) {
    if (key.which == 27 && canClose) {
        $.post("https://esx_weazelnews/exit");
    }
});


function Display(data) {
    const parameter = data.data
    $(".gfxgunmenu-main-contain").css("display", "flex");
    $(".bg-effect").css("display", "block");
    $(".header-contain > h1 > span").html(parameter.money);
    Timer(parameter)
    SetWeapons(parameter)
}

function SetWeapons(parameter) {
    const classes = parameter.classes;
    $.each(classes, function (k, v) { 
        const obj = $(".content-contain").find(`[data-id=${k}]`)
        obj.find(".boxs-header > h1").html(v.label)
        obj.find(".gun-box").remove()
        $.each(v.items, function (i, j) { 
            const content = `
                <div class="gun-box" data-category=${k} data-id=${i + 1}>
                   <h1 class="item-list-number">${i + 1}</h1>
                   <p class="item-list-name">${j.label}</p>
                   <img src="assets/guns/${j.image || j.name}.png" alt="">
                   <p class="item-list-price">${j.price == 0 ? "FREE" : "$" + j.price}</p>
                </div>
            `
            obj.append(content);
        });
    });
}

$(document).on("click", ".gun-box", function () {
    const obj = $(this)
    const category = obj.data("category");
    const id = obj.data("id");
    $.post("https://esx_weazelnews/buy", JSON.stringify({ category, id }), function (data) {
        if (data) {
            if (category == "rifles") {
                obj.parent().parent().find(`[data-category="midtier"]`).css("filter", "grayscale(0%)")
            }
            if (category == "midtier") {
                obj.parent().parent().find(`[data-category="rifles"]`).css("filter", "grayscale(0%)")
            }
            obj.parent().parent().find(`[data-category=${category}]`).css("filter", "grayscale(0%)")
            obj.css("filter", "grayscale(100%)")
            obj.addClass("buyed")
        }
    });
});

let timer = null
function Timer(parameter) {
    const started = new Date().getTime();
    const maxTime = parameter.time;
    if (maxTime == 0) return $(".header-contain > p > strong").html("∞")
    timer = setInterval(() => {
        const remaining = (maxTime * 1000) - (new Date().getTime() - started)
        $(".header-contain > p > strong").html(MilliSecondsToMMSS(remaining))
        if (remaining <= 0) {
            $.post("https://esx_weazelnews/exit");
            clearInterval(timer);
            timer = null;
        }
    }, 1000);
}

function MilliSecondsToMMSS(input) {
    const minutes = Math.floor(input / 60000);
    const seconds = ((input % 60000) / 1000).toFixed(0);
    return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
}

function Hide() {
    $(".gfxgunmenu-main-contain").css("display", "none");
    $(".bg-effect").css("display", "none");
}