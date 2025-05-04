$(function(){
	window.onload = (e) => {
        /* 'links' the js with the Nui message from main.lua */
        window.addEventListener('message', (event) => {
            //document.querySelector("#logo").innerHTML = " "
            var item = event.data;
            if (item !== undefined && item.type === "ui") {
                /* if the display is true, it will show */
                if (item.display === true) {
                    $('body').css('display', 'block')
                    $('#frame').css('display', 'block')
                    $('#main').css('display', 'block')
                     /* if the display is false, it will hide */
                } else{
                    $('body').css('display', 'none')
                    $('#frame').css('display', 'none')
                    $('#main').css('display', 'none')
                }
			}
		});
	};
    window.addEventListener('keydown', function(event){
        if(event.key === "Escape" || event.key === "Backspace" ){
            $.post('http://rcore_spray/close', JSON.stringify({}));
        }
    });
});

