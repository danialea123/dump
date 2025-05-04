function CloseShop() {
    $(".items").empty();
    $(".container").fadeOut(100);
    $("body").fadeOut(100);
    $(".modal").removeClass("visible");
    $.post('http://esx_weaponshop/focusOff');
}

$(document).keyup(function(e) {
    if (e.key === "Escape") {
       CloseShop()
   }
});

function closeModal() {
    $(".modal").removeClass("visible");
}

window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.clear == true) {
        $(".items").empty();
    }
    if (item.display == true) {
        $(".container").show();
        $("body").show();
        $("body").fadeIn(100);
    }
    if (item.display == false) {
        $(".container").fadeOut(100);
        $("body").fadeOut(100);
    }
});

document.addEventListener('DOMContentLoaded', function () {
    $(".container").hide();
});

function buyItem(item, zone, horam) {
    $.post('http://esx_weaponshop/buyItem', JSON.stringify({item: item, zone: zone, horam: horam}));
}

function showModal(item, zone, itemLabel, desc, price, horam){

    $(".container").click(function(){
        $(".modal").addClass("visible");
        $(".modalimage").html(`<img src="./img/`+item+`.png" style="animation-name: slide-in; animation-duration: 0.5s;"><div class="itemName"><p class="modal-label">`+itemLabel+`</p><span class="modal-price">$`+price+`</span></div><p class="modal-desc">`+desc+`</p>`);
        $(".btn-open").html(`<button class="btn-1" onclick="buyItem('`+item+`', '`+zone+`', '`+horam+`')"></button>`);
    });

    $(".modal-close").click(function(){
        $(".modal").removeClass("visible");
    });

    $(document).click(function(event) {
        if (!$(event.target).closest(".modal,.items").length) {
            $(".container").find(".modal").removeClass("visible");
        }
    });
}

window.addEventListener('message', function (event) {
    var data = event.data;
        if (data.price !== undefined) {
        $(".items").append(`
            <div class="item" onclick="showModal('`+data.item+`', '`+data.zone+`', '`+data.itemLabel+`', '`+data.desc+`', '`+data.price+`', '`+data.type+`')">
                <img class="img-item" src="./img/`+data.item+`.png">
                <div class="label">
                    <p class="itemString">`+data.itemLabel+`</p>
                    <p class="itemPrice"><span class="bg-price">$`+data.price+`</span>
                    </p>
                </div>
            </div>
        `);
    }
});

 
