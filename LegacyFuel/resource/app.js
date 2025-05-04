$(function() {
    let ul = document.querySelector('#customers')
    let span = document.createElement('span').textContent = 'Arya'
        // ul.appendChild(span)
    window.addEventListener('message', (event) => {
        let item = event.data;
        if (event.data.display) {
            $("body").fadeIn(500);
        } else if (event.data.display == false) {
            $("body").fadeOut(500);
        }
        let template = (id, name, owner, gasPrice, gaslitr, forsale, stationprice, navigate) => {

            return `
        <tr class='td' ">
            <td class='id' style="text-align: center;">${id}</td>
            <td style="text-align: center;">${name}</td>
            <td>${owner}</td>
            <td style="text-align: center; font-weight:bold;">${gasPrice}</td>
            <td style="text-align: center; font-weight:bold;">${gaslitr}</td>
            <td style="text-align: center; color:green;">${forsale}</td>
            <td style="text-align: center; font-weight:bold;">${stationprice} 💲</td>
            <td><button style="font-weight:bold;">Mark</button></td>
        </tr> 
    `

        }
        $("#customers").empty();
        $("#customers").append(`<tr >
            <th id='text'">ID</th>
            <th>Name</th>
            <th>Owner</th>
            <th>Gas Price</th>
            <th>Gas Litr</th>
            <th>Forsale</th>
            <th>Station Price</th>
            <th>Navigate</th>
        </tr>`)
        for (let i = 0; i < event.data.detail.length; i++) {
            const element = event.data.detail[i].id;
            if (event.data.detail[i].forSale == 'true') {
            $("#customers").append(template(event.data.detail[i].id, event.data.detail[i].name, event.data.detail[i].owner, event.data.detail[i].gasPrice, event.data.detail[i].gasvalue, '✔', event.data.detail[i].price))
            } else {
            $("#customers").append(template(event.data.detail[i].id, event.data.detail[i].name, event.data.detail[i].owner, event.data.detail[i].gasPrice, event.data.detail[i].gasvalue, '❌', event.data.detail[i].price))
                
            }
        }
        // $("td").parent(".td").css("background", "yellow");
        $('#clsbtn').click(function() {
            $.post('http://LegacyFuel/trunoff', JSON.stringify({}));
        })

        let buttons = document.querySelectorAll('tr')
        buttons.forEach((e) => {
            e.addEventListener('click', function() {
                let target = this.querySelector('tr .id').textContent
                $.post('http://LegacyFuel/setWaypoint', JSON.stringify({
                    id: target
                }));

            })
        })

    })


    // function template(id, name, owner, gasPrice, gaslitr, forsale, stationprice, navigate) {
    //     let template = 's'
    // }
})