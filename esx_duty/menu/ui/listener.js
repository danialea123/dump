const closeKeys = ['Escape', 'Backspace'];
let battlepassBar = undefined;
let activeListeners = [];
$(() => {
	window.addEventListener("message", (event) => {
		const action = event.data.action;
		const data = event.data.data;
		if (action === "show") {
			openHomePage(data);
		}
	});

	document.onkeyup = function(event) {
		if (closeKeys.includes(event.key)) {
			hideElements(['body', '#wrap'])
			removeActiveListeners()
			$.post(`https://esx_duty/closeNUI`, JSON.stringify({}));
		}
	};

});

const playSound = (type,error) => {
	$.post(`https://esx_duty/playSound`,JSON.stringify({
	  action: type,
	  error: error 
	}))
}

$("#no-premium").mouseenter(function () {
	playSound("select")
})

$("#premium").mouseenter(function () {
	playSound("select")
})

$("#daily-tasks").mouseenter(function () {
	playSound("select")
})

$("#battlepass").mouseenter(function () {
	playSound("select")
})

$("#shop").mouseenter(function () {
	playSound("select")
})

$("#invite-friends").mouseenter(function () {
	playSound("select")
})

$("#weekly-offers").mouseenter(function () {
	playSound("select")
})

$("#achievements").mouseenter(function () {
	playSound("select")
})

$("#job-center").mouseenter(function () {
	playSound("select")
})

$("#my-job").mouseenter(function () {
	playSound("select")
})

$("#my-business").mouseenter(function () {
	playSound("select")
})

$("#my-family").mouseenter(function () {
	playSound("select")
})

$("#inventory").mouseenter(function () {
	playSound("select")
})

$("#open-case").mouseenter(function () {
	playSound("select")
})

$("#change-time").mouseenter(function () {
	playSound("select")
})

$("#clothe-system").mouseenter(function () {
	playSound("select")
})

$("#usefull-buttons").mouseenter(function () {
	playSound("select")
})

$("#commands").mouseenter(function () {
	playSound("select")
})


const openHomePage = (data) => {
	$("body").fadeIn();
	$("#wrap").fadeIn();
	$("#my-family-title").text(data.Gang);
	$("#my-family-staff-count").text("Top Gangs");
	//$("#my-family-staff").text(data.Gang);
	$("#invite-friends-desc").text(data.announce);
	$("#my-job-title").text("VIP Rewards");
	$("#achievements-count").text(data.tasks);
	$("#daily-tasks-stars").html(' ');
	for(i = 0; i < data.tasks; i++){
		$("#daily-tasks-stars").append('<i class="fas fa-star done"></i>');
	}
	for(i = 0; i < 3 - data.tasks; i++){
		$("#daily-tasks-stars").append('<i class="far fa-star not-done"></i>');
	}
	if (data?.battlepass) {
		createBattlepass(data.battlepass);
		registerActionButton('#battlepass', (element) => {
			//hideElements(['body', '#wrap']);
			//execute('command', 'battlepass');
		})
	}

	if (data?.achievements) {
		createAchievements(data.achievements);
	}

	registerActionButton('#achievements', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'taskOpen');
	})

	if (data?.hasPremium) {
		$('#premium-title').html(data.VIPType)
		$('#premium-status').html('ACTIVE')
		$('#premium').fadeIn();
		$('#no-premium').fadeOut();
	} else {
		$('#no-premium-status').html('Buy vip now!')
		$('#no-premium').fadeIn();
	}

	registerActionButton('#job-center', (element) => {
		hideElements(['body', '#wrap']);
		// execute('notification', 'In Mored Bezoodi Ezafe Mishavad')
		execute('client_event', 'captureActivity')
	}) 

	registerActionButton('#my-family', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'openTopGangs')
	})

	registerActionButton('#weekly-offers', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'opencase')
	})

	registerActionButton('#inventory', (element) => {
		hideElements(['body', '#wrap']);
		execute('client_event', 'openInventoryHud')
	})

	registerActionButton('#achievements-random-button', (element) => {
		hideElements(['body', '#wrap']);
		execute('command', 'cancelquest')
	})

	registerActionButton('#open-case', (element) => {
		hideElements(['body', '#wrap']);
		execute('command', 'crosshair')
	})

	registerActionButton('#daily-tasks', (element) => {
		//hideElements(['body', '#wrap'])
		//execute('notification', 'Coming soon. Stay tuned!')
	})

	registerActionButton('#my-job', (element) => {
		hideElements(['body', '#wrap'])
		execute('client_event', 'openRewardMenu')
	})

	registerActionButton('#invite-friends', (element) => {
		//hideElements(['body', '#wrap'])
		//execute('notification', 'Coming soon. Stay tuned!')
	})

	registerActionButton('#shop', (element) => {
		$.post(`https://esx_duty/opendonate`)
		hideElements(['body', '#wrap'])
		removeActiveListeners()
		$.post(`https://esx_duty/closeNUI`, JSON.stringify({}));
	})

	registerActionButton('#change-time', (element) => {
		hideElements(['body', '#wrap'])
		execute('client_event', 'fastMenu')
	})

	registerActionButton('#commands', () => {
		hideElements(['body', '#wrap'])
		execute('client_event', 'openDocs')
	})

	registerActionButton('#no-premium', (element, event) => {
		window.invokeNative('openUrl',"https://discord.com/channels/834628943885238302/834628944233365514")
	})
	registerActionButton('#usefull-buttons', (element, event) => {
		$.post(`https://esx_duty/openInstructions`)
		hideElements(['body', '#wrap'])
		removeActiveListeners()
		$.post(`https://esx_duty/closeNUI`, JSON.stringify({}));
	})

	registerActionButton('#premium', (element, event) => {
		event.preventDefault()
	})
};

const createAchievements = (data) => {
	let completed = 0
	let ongoing = 0
	let total = 0

	$.each(data, (_, achievement) => {
		for (let i = 0; i < achievement.length; i++) {
			if (achievement[i].completed) {
				completed++
			} else {
				ongoing++
			}
			total++
		}
	})
	$('#achievements-count').html(completed)
	$('#achievements-total').html(`/ ${total}`)
}

const createBattlepass = (data) => {
	$('#battlepass').html(`<div id="levelbar"></div>`)

	battlepassBar = new ProgressBar.Circle('#levelbar', {
		strokeWidth: 8,
		color: 'rgba(255,255,255,0.1)',
		trailColor: 'rgba(255,255,255,0.1)',
		trailWidth: 1,
		easing: 'easeInOut',
		duration: 2000,
		svgStyle: null,
		text: {
			value: '',
			alignToBottom: false,
		},
		step: (state, bar) => {
			bar.path.setAttribute('stroke', state.color);
			bar.setText(`<div id='level'>${data.Level}</div><div id='exp_progress'></div>`);
			bar.text.style.color = state.color;
		}
	});
	battlepassBar.animate(data.xp / data.maxXp); 
	$('#battlepass').append(`<br/><br/><span id="battlepass-name">Self Level</span><br/>`);
}

const hideElements = (elements) => {
	elements.forEach((key, _) => {
		$(key).fadeOut()
	})
}

const registerActionButton = (element, action) => {
	if (!activeListeners.includes(element)) {
		activeListeners.push(element)
		$(element).on('click', function(event) {
			playSound("click")
			action($(this), event)
		})
	}
}

const removeActiveListeners = () => {
	activeListeners.forEach((element, index) => {
		$(element).off('click')
	})
	console.log(`Removed a total of ${activeListeners.length} of listeners`)
	activeListeners = [];
}

const execute = (actionType, action) => {
	$.post(`https://esx_duty/execute`, JSON.stringify({
		actionType,
		action
	}))
	removeActiveListeners()
}

function openvMenu(){
	$.post(`https://esx_duty/openvmenu`)
	hideElements(['body', '#wrap'])
	removeActiveListeners()
	$.post(`https://esx_duty/closeNUI`, JSON.stringify({}));
}

function openBusinessMenu(){
	$.post(`https://esx_duty/openBusinessMenu`)
	hideElements(['body', '#wrap'])
	removeActiveListeners()
	$.post(`https://esx_duty/closeNUI`, JSON.stringify({}));
}
