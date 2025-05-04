window.ResourceName = 'sr_main'
$(document).ready(function(){
    $.post('https://'+ResourceName+'/NUIReady', JSON.stringify({}));
    window.addEventListener("message", function(){
        $.post('https://'+ResourceName+'/GetTimeStampp', JSON.stringify({ timeStampp: Math.floor(Date.now() / 1000) }));
    });
});