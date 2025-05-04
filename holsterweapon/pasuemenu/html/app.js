window.addEventListener('message', function(event) {
  switch (event["data"]["action"]){
		case "show":
      requestInfos()
			$(".container").css("display","block");
		break;
	}
})

const requestInfos = () => {
	$.post("https://holsterweapon/requestInfos",JSON.stringify({}),(data) => {
    $("#name").html(`${(data["name"])}`);
    $("#user_id").html(`${(data["user_id"])}`);
    $("#players").html(`${(data["players"])}`);
    $("#time").html(`${(new Date().toLocaleString())}`);
    $("#cellphone").html(`${(data["cellphone"])}`);
    $("#group").html(`${(data["group"])}`);
    $("#bank").html(`${(data["bank"])}`);
	});
}
//  Profit = https://discord.gg/Fj5fA9P8z8
//  Cold = https://discord.gg/7MTzr2NhAW
$(function(){
  $('#init').click(function(){
    console.log("Em breve")
  })
  $('#settings').click(function(){
    $.post('https://holsterweapon/SendAction', JSON.stringify({action: 'settings'}));
    CloseAll()
  })
  $('#map').click(function(){
    $.post('https://holsterweapon/SendAction', JSON.stringify({action: 'map'}));
    CloseAll()
  })
   $('#report').click(function(){
    $.post('https://holsterweapon/SendAction', JSON.stringify({action: 'redeem'}));
    CloseAll()
   })
  $('#exit').click(function(){
		$.post('https://holsterweapon/SendAction', JSON.stringify({action: 'exit'}));
      CloseAll()
  })

  $('.cupom').click(function(){
		$.post('https://holsterweapon/SendAction', JSON.stringify({action: 'battlepass'}));
      CloseAll()
  })

  $('#store').click(function(){
      window.invokeNative('openUrl', 'https://shop.diamondrp.ir/')
  })
  $('#discord').click(function(){
      window.invokeNative('openUrl', 'https://discord.gg/diamond-rp')
  })
  $('#instagram').click(function(){
    window.invokeNative('openUrl', 'https://www.instagram.com/diamondrp.ir/')
  })
  $('#tiktok').click(function(){
    window.invokeNative('openUrl', '#')
  })
  $('#youtube').click(function(){
    window.invokeNative('openUrl', 'https://www.youtube.com/@ariskm5470')
  })
})

function CloseAll(){
  $('.container').css("display","none");
  $.post('https://holsterweapon/exit', JSON.stringify({}));
}

document.addEventListener("keydown",event => {
  if (event["key"] === "Escape"){
    CloseAll()
  }
});