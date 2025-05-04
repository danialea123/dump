window.ResourceName  = 'esx_comserv'
$(document).ready(function() {
    let news = {
        ['news'] : {
            [1] : '' , 
            [2] : '' , 
            [3] : '' , 
            [4] : '' , 
        }, 
        ['title'] :     '', 
        ['mainnews'] :  '', 
        ['link'] :      '', 
        ['type'] :      '',  
        ['ads1']:        '',
        ['ads2']:        '',

    }
   function setnewspaper() {
    $('.weazel_set').css('display', 'block')
   }
   function SetNewinNPaper(){
    $('#news_title').text(  news['title'])
    $('#news_mainnews').text(  news['mainnews'])
    $('#news_1').text(  news['news'][1])
    $('#news_2').text(  news['news'][2])
    $('#news_3').text(  news['news'][3])
    $('#news_4').text(  news['news'][4])
    $('.image img').attr('src', news['link'])
    if (news["ads1"].length >= 10){
        $('#ads1').attr('src', news["ads1"])
    }
    if (news["ads2"].length >= 10){
        $('#ads2').attr('src', news["ads2"])
    }
   }
   $('#create').click(function () {
        submit()
    })
   function submit(cb) {
    let err = true
    news['title']       =  document.getElementById("titlen").value
    news['mainnews']    =  document.getElementById("mainnews").value
    news['link']        =  document.getElementById("link").value
    news['type']        =  document.getElementById("type").value
    news['news'][1]     =  document.getElementById("news1").value
    news['news'][2]     =  document.getElementById("news2").value
    news['news'][3]     =  document.getElementById("news3").value
    news['news'][4]     =  document.getElementById("news4").value
    news['ads1']        = document.getElementById("ads11").value
    news['ads2']        = document.getElementById("ads22").value
    if (news['title'].length > 200 || news['title'].length < 5 ) {
        $('.form-group #titlen').css('color' , 'red') 
      
    }
    else if ( news['mainnews'].length > 250 || news['mainnews'].length < 5  ) {
        $('.form-group #mainnews').css('color' , 'red')
       
    }
    else if ( news['link'].length > 250 || news['link'].length < 5 ) {
        $('.form-group #link').css('color' , 'red')
    }
    else if (news['news'][1].length > 250 || news['news'][1].length < 5  ) {
        $('.form-group #news1').css('color' , 'red')
    }
    else if ( news['news'][2].length > 250 || news['news'][2].length < 5 ) {
        $('.form-group #news2').css('color' , 'red')
    }
    else if (news['news'][3].length > 250 || news['news'][3].length < 5  ) {
        $('.form-group #news3').css('color' , 'red')
    }
    else if ( news['news'][4].length > 250 || news['news'][4].length < 5  ) {
        $('.form-group #news4').css('color' , 'red')
    }
    else {
        err = false
    $.post('http://'+ window.ResourceName  + '/SaveData', JSON.stringify(news));
     closesetnewspaper() 
    }
    if (err) {
        $.post('http://'+ window.ResourceName  + '/notify', JSON.stringify('Maghadir ra be Dorosti vared konid'))
        $.post('http://'+ window.ResourceName  + '/close', JSON.stringify({}))
    }
}
   function ShowNewsPaper() {
    $('.newsp').css('display', 'block')
   }
   function hideNewsPaper() {
    $('.newsp').css('display', 'none')
   }
   function closesetnewspaper() {
    $('.weazel_set').css('display', 'none')
   }
   window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.message == 'opennews' ) {
        ShowNewsPaper()
    }
    if (item.message == 'setnews' ) {
        setnewspaper() 
    }
    if (item.message == 'closenews' ) {
        hideNewsPaper()
    }
    if (item.message == 'closesetnews' ) {
        closesetnewspaper()
    }
    if (item.message == 'getnews' ) {
        news = item.news
        SetNewinNPaper()
    }
   })

   document.onkeyup = function (data) {
    if (data.which == 27) { // ESC Press
        closesetnewspaper()
        hideNewsPaper()
        $.post('http://'+ window.ResourceName  + '/close', JSON.stringify({}));}}

 
    
})    