var hottubresourcename = "rtx_hottub";

function closeMain() {
	$("body").css("display", "none");
}

function openMain() {
	$("body").css("display", "block");
}

$(".closehottubcover").click(function(){
    $.post('http://'+hottubresourcename+'/quit', JSON.stringify({}));
});

$(".closehottubmanagment").click(function(){
    $.post('http://'+hottubresourcename+'/quit', JSON.stringify({}));
});

window.addEventListener('message', function (event) {

	var item = event.data;
	
	if (item.message == "hottubcovershow") {
		document.getElementsByClassName("hottubcoverbutton")[0].innerHTML = item.hottubcovermessage;
		$('#hottubmanagmentshow').hide();	
		$("#hottubprogressbarshow").hide();	
		$('#hottubcovershow').show();	
		openMain();
	}
	
	if (item.message == "hottubmanagmentshow") {
		$('#hottubcovershow').hide();	
		$("#hottubprogressbarshow").hide();	
		$('#hottubmanagmentshow').show();	
		openMain();
	}	
	
	if (item.message == "resyncslider") {
		document.getElementById(item.resyncname).checked = item.resynchandler;
	}   

	if (item.message == "hottubprogressbarshow") {
		$('.hottubprogressbarmaincontainerdata').css("width", "0%")	
		$("#hottubmanagmentshow").hide();	
		$("#hottubcovershow").hide();	
		$("#hottubprogressbarshow").show();	
		openMain();
	}	
	
	if (item.message == "hottubprogressbarshow") {
		document.getElementsByClassName("hottubprogressbartext")[0].innerHTML = item.hottubprogressbartext;
		$('.hottubprogressbarmaincontainerdata').css("width", "0%")	
		$("#hottubmanagmentshow").hide();	
		$("#hottubcovershow").hide();	
		$("#hottubprogressbarshow").show();	
		openMain();
	}		
		
	if (item.message == "updatehottubprogressbar") {
		$('.hottubprogressbarmaincontainerdata').css("width", item.progressbardata+"%")
	}			
		
	if (item.message == "hide") {
		closeMain();
	}
	
	if (item.message == "updateinterfacedata") {
		hottubresourcename = item.hottubresouredata;
		let root = document.documentElement;
		root.style.setProperty('--color', item.interfacecolordata);	
	}			
	
    document.onkeyup = function (data) {
        if (open) {
            if (data.which == 27) {
				$.post('http://'+hottubresourcename+'/quit', JSON.stringify({}));
            }
        }	
	};
});

$(".hottubcoverbutton").click(function () {
	$.post('http://'+hottubresourcename+'/cover', JSON.stringify({}));
});

$("#hottublighttoggleswitch").click(function(){
	if (document.getElementById("hottublighttoggleswitch").checked == false){
		document.getElementById("hottublighttoggleswitch").checked = false;
		$.post('http://'+hottubresourcename+'/lighttoggle', JSON.stringify({
			lighthandler: false
		}));			
	}
	else {
		document.getElementById("hottublighttoggleswitch").checked = true;
		$.post('http://'+hottubresourcename+'/lighttoggle', JSON.stringify({
			lighthandler: true
		}));		
	}
})

$("#hottublighttogglergbswitch").click(function(){
	if (document.getElementById("hottublighttogglergbswitch").checked == false){
		document.getElementById("hottublighttogglergbswitch").checked = false;
		$.post('http://'+hottubresourcename+'/lightrgbtoggle', JSON.stringify({
			lightrgbtoggle: false
		}));			
	}
	else {
		document.getElementById("hottublighttogglergbswitch").checked = true;
		$.post('http://'+hottubresourcename+'/lightrgbtoggle', JSON.stringify({
			lightrgbtoggle: true
		}));		
	}
})

$("#hottublightrgbspeedchangeswitch1").click(function(){
	document.getElementById("hottublightrgbspeedchangeswitch1").checked = true;
	document.getElementById("hottublightrgbspeedchangeswitch2").checked = false;
	document.getElementById("hottublightrgbspeedchangeswitch3").checked = false;
	$.post('http://'+hottubresourcename+'/changergbspeed', JSON.stringify({
		rgbspeeddata: 1
	}));
})

$("#hottublightrgbspeedchangeswitch2").click(function(){
	document.getElementById("hottublightrgbspeedchangeswitch1").checked = false;
	document.getElementById("hottublightrgbspeedchangeswitch2").checked = true;
	document.getElementById("hottublightrgbspeedchangeswitch3").checked = false;
	$.post('http://'+hottubresourcename+'/changergbspeed', JSON.stringify({
		rgbspeeddata: 2
	}));
})

$("#hottublightrgbspeedchangeswitch3").click(function(){
	document.getElementById("hottublightrgbspeedchangeswitch1").checked = false;
	document.getElementById("hottublightrgbspeedchangeswitch2").checked = false;
	document.getElementById("hottublightrgbspeedchangeswitch3").checked = true;
	$.post('http://'+hottubresourcename+'/changergbspeed', JSON.stringify({
		rgbspeeddata: 3
	}));
})

$("#hottublightchangeswitch1").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = true;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 1
	}));
})

$("#hottublightchangeswitch2").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = true;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 2
	}));
})

$("#hottublightchangeswitch3").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = true;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 3
	}));
})

$("#hottublightchangeswitch4").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = true;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 4
	}));
})

$("#hottublightchangeswitch5").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = true;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 5
	}));
})

$("#hottublightchangeswitch6").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = true;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 6
	}));
})

$("#hottublightchangeswitch7").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = true;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 7
	}));
})

$("#hottublightchangeswitch8").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = true;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 8
	}));
})

$("#hottublightchangeswitch9").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = true;
	document.getElementById("hottublightchangeswitch10").checked = false;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 9
	}));
})

$("#hottublightchangeswitch10").click(function(){
	document.getElementById("hottublightchangeswitch1").checked = false;
	document.getElementById("hottublightchangeswitch2").checked = false;
	document.getElementById("hottublightchangeswitch3").checked = false;
	document.getElementById("hottublightchangeswitch4").checked = false;
	document.getElementById("hottublightchangeswitch5").checked = false;
	document.getElementById("hottublightchangeswitch6").checked = false;
	document.getElementById("hottublightchangeswitch7").checked = false;
	document.getElementById("hottublightchangeswitch8").checked = false;
	document.getElementById("hottublightchangeswitch9").checked = false;
	document.getElementById("hottublightchangeswitch10").checked = true;
	$.post('http://'+hottubresourcename+'/changecolor', JSON.stringify({
		colordata: 10
	}));
})

$("#hottubtelevisionswitch").click(function(){
	if (document.getElementById("hottubtelevisionswitch").checked == false){
		document.getElementById("hottubtelevisionswitch").checked = false;
		$.post('http://'+hottubresourcename+'/televisontoggle', JSON.stringify({
			televisontoggle: false
		}));			
	}
	else {
		document.getElementById("hottubtelevisionswitch").checked = true;
		$.post('http://'+hottubresourcename+'/televisontoggle', JSON.stringify({
			televisontoggle: true
		}));		
	}
})

$("#hottubnozzlesswitch").click(function(){
	if (document.getElementById("hottubnozzlesswitch").checked == false){
		document.getElementById("hottubnozzlesswitch").checked = false;
		$.post('http://'+hottubresourcename+'/nozzlestoggle', JSON.stringify({
			nozzlestoggle: false
		}));			
	}
	else {
		document.getElementById("hottubnozzlesswitch").checked = true;
		$.post('http://'+hottubresourcename+'/nozzlestoggle', JSON.stringify({
			nozzlestoggle: true
		}));		
	}
})
