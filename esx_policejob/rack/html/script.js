let imageDictionary = {
    armor: "armorItem",
    ammo: "ammo",
    weapon: "weapon",
    picklock: "picklock",
    silencer: "silencer",
    grip: "grip",
}

let closeKeys = [8, 27, 121];

let plate

var job_kays = {
    "sheriff": {"img":"images/LSSD.png", "title":"Los Santos Sheriff Department"},
    "government": {"img":"images/GOV.png", "title":"Government"},
    "police": {"img":"images/LSPD.png", "title":"Diamond Police Department"}
};

$(document).ready(() => {   

    window.addEventListener("keyup", (e) => {
        if (closeKeys.includes(e.keyCode)) {
            event.preventDefault()
            $(".panel-main").hide()
            plate = false
            $.post('https://esx_policejob/closeRack', 1);
        }
    })

    window.addEventListener('message', event => {
        let data = event.data
        if (data.type == "open") {
            clearAllData();
            let faction = job_kays[event.data.data.job];
            $('.factionImage').attr('src', faction.img);
            $('.title').text(faction.title);
            let sorted = Object.keys(data.data.inventory)
               .sort()
               .reduce(function (acc, key) { 
                   acc[key] = data.data.inventory[key];
                   return acc;
                }, {});

            for (const key in sorted) {
               let info = sorted[key]
                appendItems(info.label, key, (key.includes("WEAPON")) ? "weapon" : info.type, info.count)
            }

            plate = data.data.plate
            // $(".panel-main").show()
            $(".panel-main").css('display','inline-table')
        } else if (data.type == "update") {
            var image = (data.data.item.includes("WEAPON")) ? "weapon" : data.data.item.toLowerCase()
            $(`#${data.data.item} p`).text(`${data.data.label} (${data.data.count}x)`);
        } else if (data.type == "close") {
            $(".panel-main").hide()
            plate = false
        }
    });
})

function appendItems(name, item, type, count) {
    $('#rack').append(`<tr id="${item}"><td><img src="images/${imageDictionary[type]}.png"><p>${name} (${count}x)</p></td></tr>`);
    // let CurrenHight = $(".panel-main").height()
    // $(".panel-main").height(CurrenHight + 65)
    $(`#${item}`).on("click", () => {
        if (!plate) return
        $.post("https://esx_policejob/sendRequest", JSON.stringify({
            plate: plate,
            item: item
        }));

    })
}

function clearAllData() {
    $("#rack").empty()
}