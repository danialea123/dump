var actionContainer = $("#container");
window.ResourceName = 'job_tracker'
$(document).ready(function(){
    window.addEventListener('message',function(event){
        var item = event.data;
        console.log(item.action)
        if (item.action == "show"){
            (item.favorito !== undefined) ? $("#favorito").data("local",item.favorito) : $("#favorito").data("local","NENHUM");
           actionContainer.show();
        }

    });

    
  

    $('#fundo').click(()=>{
        $('#fundo').removeClass("animate__fadeInRightBig").addClass("animate__fadeOutRightBig");
    })
    $.post('https://'+ResourceName+'/NUIReady', JSON.stringify({}));
});

function selecionar(ev,pic){
    $("#foto").css("background-image",`url(${pic})`)
    $("#nome").text($(ev).text())
    $(".botaoFavorito").data("local",$(ev).data("local"))
    $('#fundo').css("visibility","visible").removeClass("animate__fadeOutRightBig").addClass("animate__fadeInRightBig");
}
function fav_select(ev){
    if($(ev).data("local") !== "NENHUM"){
        $.post("https://job_tracker/selecionar", JSON.stringify({
            name: $(ev).data("local"),
        }))
        actionContainer.hide();
    }
}    
function selectLocal(ev){
        $.post("https://job_tracker/selecionar", JSON.stringify({
            name: $(ev).data("local"),
        }))
        actionContainer.hide();
}        
function savelocal(ev){
        $.post("https://job_tracker/favoritar", JSON.stringify({
            name: $(ev).data("local"),
        }))
        $("#favorito").data("local", $(ev).data("local"))
}