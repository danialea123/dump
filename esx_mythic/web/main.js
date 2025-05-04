function closeMain() {
	$("body").css("display", "none");
}
function openMain() {
	$("body").css("display", "block");
}
$(".helpclick").click(function () {
	closeMain();
	$.post('http://esx_mythic/start', JSON.stringify({}));
});
window.addEventListener('message', function (event) {

	var item = event.data;
    if (item.message == 'close' ) {
        closeMain()
    }
    if (item.message == 'open' ) {
        openMain()
    }
	
});
// SetNuiFocus(true, true)
//SendNUIMessage({
  //  message	= "open"
//})	