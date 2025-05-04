window.addEventListener('message', function (e) {
    if (e.data.action == 'sendIdentity') {
      
        $('.showname').html(e.data.userData.name)
        $('.showid').html(e.data.userData.id)
        $('.showjob').html(e.data.userData.job)
        $('.country1').html(e.data.userData.jobgrade)
        if (e.data.userData.job == "police") {
            $('.imagepd').fadeIn()
        }
        if (e.data.userData.job == "ambulance") {
            $('.imagemd').fadeIn()
        }
       if (e.data.userData.job == "taxi") {
            $('.imagetaxi').fadeIn()
        }
        if (e.data.userData.job == "mechanic") {
            $('.imagemecano').fadeIn()
        }
        if (e.data.userData.job == "sheriff") {
            $('.imagesh').fadeIn()
        }
        if (e.data.userData.job == "fbi") {
            $('.imagefbi').fadeIn()
        }
        if (e.data.userData.job == "justice") {
            $('.imagejustice').fadeIn()
        }
        if (e.data.userData.job == "forces") {
            $('.imageforces').fadeIn()
        }
        if (e.data.userData.job == "weazel") {
            $('.imageweazel').fadeIn()
        }
        if (e.data.userData.job == "bahamas") {
            $('.imagebahamas').fadeIn()
        }
        if (e.data.userData.job == "catcafe") {
            $('.imagecatcafe').fadeIn()
        }
        if (e.data.userData.job == "benny") {
            $('.imagebenny').fadeIn()
        }
        if (e.data.userData.job == "medic") {
            $('.imagemedic').fadeIn()
        }
        
        if (e.data.userData.jobc == true  ) {
     
            $('.other').fadeIn()    
        }
          
          
        $('body').fadeIn()
        $('.card').fadeIn()
    } else if (e.data.action == 'close') {
        $('.card').fadeOut()
        $('body').fadeOut()
        $('.imagefbi').fadeOut()
        $('.imageweazel').fadeOut()
        $('.imagejustice').fadeOut()
        $('.other').fadeOut()   
        $('.imagesh').fadeOut()
        $('.imageforces').fadeOut()
        $('.imagetaxi').fadeOut()
        $('.imagemecano').fadeOut()
        $('.imagepd').fadeOut()
        $('.imagemd').fadeOut()
        $('.imagecatcafe').fadeOut()
        $('.imagebahamas').fadeOut()
        $('.imagebenny').fadeOut()
        $('.imagemedic').fadeOut()
    } })