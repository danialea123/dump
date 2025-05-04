
$(document).ready(function(){
 

    function closestartmmain() {
     
        $("#exit").fadeIn(400);
        $("#start").fadeOut(400);
        $("#starttext2").fadeOut(400);
        $("#starttext").fadeOut(400);
        $("#shipment").fadeIn(400);
    }
    function openstartmmain() {
        $("#tablet").fadeIn(400);
        $("#starttext").fadeIn(400);
        $("#exit").fadeIn(400);
        $("#starttext2").fadeIn(400);
        $("#start").fadeIn(400);
        $("#shipment").fadeOut(400);

    } 
    function closeall() {
        $("#start").fadeOut(400);
        $("#exit").fadeOut(400);
        $("#starttext2").fadeOut(400);
        $("#starttext").fadeOut(400);
        $("#shipment").fadeOut(400);
        $("#tablet").fadeOut(400);
      
    }
    
        /*  */ 
    $(".start").click(function () {
        closestartmmain();
       
    });
    $(".exit").click(function () {
        closeall() 
        $.post('http://esx_pursuit/exit', JSON.stringify({}));
    });
    $(".shipmentotherinfobuy").click(function () {
        closeall()
        $.post('http://esx_pursuit/buymecano', JSON.stringify({}));
    });
    window.addEventListener('message', function (event) {

        var item = event.data;
        if (item.message == 'close' ) {
            closeall()
        }
        if (item.message == 'open' ) {
            openstartmmain()
        }
       
        
    });
    
});
