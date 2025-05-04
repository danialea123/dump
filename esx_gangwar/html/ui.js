function setValue(key, value){
	$('#'+key+' span').html(value)

}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        
        var data = event.data;
        if (data.punkte === false) {

        $('ballas').text("img", data.image1);
        $('#color1').css("background-color", data.color1);
        $('#color2').css("background-color", data.color2);
        $('#color3').css("background-color", data.color1);
        $('#color4').css("background-color", data.color2);
        $('#color1').css("border", "3px solid " + data.color1);
        $('#color2').css("border", "3px solid " + data.color2);
        $('#color3').css("border", "3px solid " + data.color1);
        $('#color4').css("border", "3px solid " + data.color2);                   
        $('#bgcolor1').css("background-color", data.bgcolor1);
        $('#bgcolor2').css("background-color", data.bgcolor2);
        
        $('#job1').text(data.job1);
        $('#job2').text(data.job2);
        } else if (data.punkte === true) {
            $('#punktezahl-links').text(data.prechts);
            $('#punktezahl-rechts').text(data.plinks);
			$('#punktezahl-countdown').text(data.countdown);
        }
    });
});