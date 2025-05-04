$(function () {
    function display(bool) {
        if (bool) {
            $("body").fadeIn(500);
        } else {
            $("body").fadeOut(500);
        }
    }

    window.addEventListener('message', function(event) {
        var item = event.data;


        
        $("#blackMoney").html(item.currentblackMoney + "$")
        $("#washingCost").html(item.currentWashCost + "$")
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
   

    

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('https://gangaccount/exit', JSON.stringify({})); 
            return
        }
    };
    $("#close").click(function () {
        $.post('https://gangaccount/exit', JSON.stringify({})); 
        return
    })

    
})