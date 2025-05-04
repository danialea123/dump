(() => {

	ESX = {};
	ESX.HUDElements = [];

	// ESX.setHUDDisplay = function (opacity) {
	// 	$('#hud').css('opacity', opacity);
	// };

	ESX.insertHUDElement = function (name, index, priority, html, data) {
		ESX.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		ESX.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	ESX.updateHUDElement = function (name, data) {

		for (let i = 0; i < ESX.HUDElements.length; i++) {
			if (ESX.HUDElements[i].name == name) {
				ESX.HUDElements[i].data = data;
			}
		}

		ESX.refreshHUD();
	};

	ESX.deleteHUDElement = function (name) {
		for (let i = 0; i < ESX.HUDElements.length; i++) {
			if (ESX.HUDElements[i].name == name) {
				ESX.HUDElements.splice(i, 1);
			}
		}

		ESX.refreshHUD();
	};

	ESX.refreshHUD = function () {
		// $('#hud').html('');

		for (let i = 0; i < ESX.HUDElements.length; i++) {
			let html = Mustache.render(ESX.HUDElements[i].html, ESX.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	ESX.inventoryNotification = function (add, item, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		notif += count + ' ' + item.label;

		let elem = $('<div>' + notif + '</div>');

		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
	};

	ESX.showTarget = function (bool) {
		if(bool){
			$('#target').css('display', 'inline');
		}else{
			$('#target').css('display', 'none');
		}
	};

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				ESX.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				ESX.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				ESX.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				ESX.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				ESX.inventoryNotification(data.add, data.item, data.count);
			}

			case 'show':{
				ESX.showTarget(data.show);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();

// NOTIFICATION HAYYAWH

$(function () {
    var sound = new Audio('sound.mp3');
    sound.volume = 0.3;
    window.addEventListener('message', function (event) {
        if (event.data.action == 'open') {
            var number = Math.floor((Math.random() * 1000) + 1);
			let foundShit = false;
			$('[class*="text-"]').each((ind,div) => {
				if($(div).html().includes(stylize(event.data.message))) {
					foundShit = true;
					return;
				}
			});
			if(foundShit) return;
            $('.notify').append(`
            <div class="wrapper-${number}">
                <div class="notification_main-${number}">
                    <div class="title-${number}"></div>
                    <div class="text-${number}">
                        ${stylize(event.data.message)}
                    </div>
                </div>
            </div>`)
            $(`.wrapper-${number}`).css({
                "margin-bottom": "10px",
                "margin": "0 0 8px -180px",
                "border-radius": "15px"
            })
            $('.notification_main-'+number).addClass('main')

            if (event.data.type == 'success') {
                $(`.title-${number}`).html(stylize(event.data.title))
				if(event.data.subject) {
					$(`.title-${number}`).append(`<br><span class="subject">${stylize(event.data.subject)}</span>`);
				}
                $(`.notification_main-${number}`).addClass('success-icon')
                $(`.wrapper-${number}`).addClass('success')
                sound.play();
            } else if (event.data.type == 'info') {
                $(`.title-${number}`).html(stylize(event.data.title))
				if(event.data.subject) {
					$(`.title-${number}`).append(`<br><span class="subject">${stylize(event.data.subject)}</span>`);
				}
                $(`.notification_main-${number}`).addClass('info-icon')
                $(`.wrapper-${number}`).addClass('info')
                sound.play();
            } else if (event.data.type == 'error') {
                $(`.title-${number}`).html(stylize(event.data.title))
				if(event.data.subject) {
					$(`.title-${number}`).append(`<br><span class="subject">${stylize(event.data.subject)}</span>`);
				}
                $(`.notification_main-${number}`).addClass('error-icon')
                $(`.wrapper-${number}`).addClass('error')
                sound.play();
            } else if (event.data.type == 'warning') {
                $(`.title-${number}`).html(stylize(event.data.title))
				if(event.data.subject) {
					$(`.title-${number}`).append(`<br><span class="subject">${stylize(event.data.subject)}</span>`);
				}
                $(`.notification_main-${number}`).addClass('warning-icon')
                $(`.wrapper-${number}`).addClass('warning')
                sound.play();
            } else if (event.data.type == 'long') {
                $(`.title-${number}`).html(stylize(event.data.title))
				if(event.data.subject) {
					$(`.title-${number}`).append(`<br><span class="subject">${stylize(event.data.subject)}</span>`);
				}
                $(`.notification_main-${number}`).addClass('long-icon')
                $(`.wrapper-${number}`).addClass('long')
                sound.play();
            }
			if(event.data.icon) {
				$(`.notification_main-${number}`).attr('style', `--img:url(../img/notificationImages/${event.data.icon}.jpg)`);
				$(`.notification_main-${number}`).addClass('advanced');
			}
			if(event.data.iconType) {
				$(`.notification_main-${number}`).attr('iconType', event.data.iconType);
				$(`.notification_main-${number}`).addClass('advanced');
			}
			(event.data.radar) ? $('.notify').css('height', event.data.minimap.top_y+event.data.minimap.height) : $('.notify').css('height', event.data.minimap.top_y-15);
            anime({
                targets: `.wrapper-${number}`,
                translateX: (180+event.data.minimap.x-15),
                duration: 750,
                easing: 'spring(5, 100, 35, 10)',
            })
            setTimeout(function () {
                anime({
                    targets: `.wrapper-${number}`,
                    translateX: -200,
                    duration: 750,
                    easing: 'spring(5, 80, 5, 0)'
                })
                setTimeout(function () {
                    $(`.wrapper-${number}`).remove()
                }, 750)
            }, event.data.time)
        }
    })
})
const stylize = (text) => {
    return "<span>" + (text.replace(/\~(r|b|g|y|p|o|c|m|u|n|s|w|h)\~(.*?)/g, (text, mod) => {
        if(mod == 'n')
            return `<br>`;
        return `</span><span class="text-${mod}">`;
    })) + "</span>";
}