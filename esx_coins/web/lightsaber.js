 var roulette    = document.getElementById('roleta')
var store       = document.getElementById('shop')
var qrcode       = document.getElementById('qrcode')
var zCoins     = 'esx_coins'
var config      = null
var actions     = []
var multiplier  = 1
var atualCoins  = 0
var currency    = new Intl.NumberFormat('pt-BR', {
  currency: 'BRL',
  minimumFractionDigits: 0
})
var animation

function shuffle(array) {
  var currentIndex = array.length,  randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;

    // And swap it with the current element.
    [array[currentIndex], array[randomIndex]] = [
      array[randomIndex], array[currentIndex]];
  }

  return array;
}

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

$(document).ready(async() =>{
  //edit molaei
  await sleep(30000)
  $.post(`https://${zCoins}/loadConfig`)
});

var canOpen = false 
window.addEventListener('message', async(ev) => {
  switch(ev.data.event){
    case 'open':
      if(!config || !canOpen) return
      roulette.style.display = 'none';
      $("#menu").show()
      $(".esc").show()
      store.style.display = '';
      qrcode.style.display = 'none';
      multiplier = 1
      atualCoins = ev.data.coins
      buildStore(config.products)

      $('body').show()
      $(".qtd").first().click()
      $("#totalCaixa").text(currency.format(atualCoins))
    break;
    case 'setup':
      try{
        config = JSON.parse(ev.data.config)
        $("#qrcode-img").attr('src',`https://cdn.discordapp.com/attachments/1018992994281599006/1019718910997712987/frame_1.png?ex=66203cbd&is=660dc7bd&hm=271aecc8ad2acc7d0fb0e45f40a3aef6d21730780240c1164dce3d6027cd64eb&`)
        $("#ou-clique").on('click',function () {
          window.invokeNative('openUrl',"https://shop.diamondrp.ir")
        })
         buildRoulette(config.roulette).then(() => canOpen = true)
      }catch(err){
        $.post(`https://${zCoins}/close`,JSON.stringify(err, Object.getOwnPropertyNames(err)),function(){
          $("body").hide()
        })
      }
    break;
    case 'updateCoin':
      atualCoins = ev.data.coins
      $("#totalCaixa").text(currency.format(atualCoins))
    break;
    case 'notify': 
      let isOpen = ev.data.opened
      if(config.onlyNotifyPlayersOnStore && !isOpen) return false 
      if(!isOpen){
        $("#menu").hide()
        $(".esc").hide()
        roulette.style.display = 'none';
        store.style.display = 'none';
        qrcode.style.display = 'none';
        $('body').show()
      }
      $("#foto-notify").attr('src',`${config.imagesUrl+'/'+(ev.data.info.index)+'.png'}`)
      $("#texto-notify").html(`<b>${ev.data.info.identity[config.identity.nome]}</b> ganhou um item <b>${ev.data.info.type.toUpperCase()}</b>! (${ev.data.info.name || ""})`)
      $("#notify").addClass('animate__slideInRight')
      $("#notify").show()
      $("#notify").removeClass('animate__slideOutRight')
      setTimeout(() => {
        if(!isOpen) $('body').hide()
        $("#notify").addClass('animate__slideOutRight')
        $("#notify").removeClass('animate__slideInRight')
      }, 6000);
    break;
  }
})
document.addEventListener('keydown', (ev) => {
  if (ev.key === 'Escape' && (!animation || animation.stopAnimation) ) {
    $.post(`https://${zCoins}/close`,undefined,function(){
      $('body').hide()
    })
  }
})
const buildStore = async(storeData) => {
  
  $(".menuShop").html('')
  $(".menu_selecionado").removeClass("menu_selecionado")
  let stores = Object.keys(storeData).sort((a,b) => a > b ? 1 : -1)
  for(const category of stores){
    $(".menuShop").append(`<div class="itemMenuShop" data-category='${category}'>${category}</div>`)
  }
  $(".itemMenuShop").mouseenter(function () {
    playSound("select")
	})
  let firstEl = $('.itemMenuShop').first()
  firstEl.addClass('menu_selecionado')
  await selectCategory(firstEl.text());
  return true 
}

const selectCategory = async(category = 'Itens') => {
  

  $("#containerLoja").html('')
  let items = config.products[category].sort((a,b) => a.price > b.price ? 1 : -1)
  items.forEach((value,index)=>{
    
    $('#containerLoja').append(`
      <div class="itemShop">
        <div class="parteFoto">
          <img src="${config.imagesUrl ? config.imagesUrl+'/'+(value.idname||value.model||value.index||'default')+'.png' : 'https://cdn.discordapp.com/attachments/712813090952970345/845364098917072906/repairkit.png'}" alt="" id="fotoItemShop">
          <div class="nameItemShop">${value.name+' <b style="color:#ffd800"> '+(value.amount ? ' x'+value.amount : '')+'</b>' || value.idname  + ' <b style="color:#ffd800">'+(value.amount ? ' x'+value.amount : '')+'</b>'}</div>  
        </div>
      <div class="infos">
          <div class="valorItem">
              <img src="https://cdn.discordapp.com/attachments/780886760078835712/855332650403233802/coin-stack.png?ex=6618d41b&is=66065f1b&hm=fee26756c99b0640b4432761e94b9b9d1c59f8e44f80c95188707d2cc43478ac&" alt=""> 
              <div class="valorCaixa">${currency.format(value.price)} </div>
          </div>
          <div class="comprar" style="background-image: url(https://cdn.discordapp.com/attachments/712813090952970345/857153865802580008/shopping-cart.png?ex=661f743e&is=660cff3e&hm=34766f25ac695654328b05c20326d43a804a0af125d151bd11c928da47fbc389&); background-size: 60%;" data-price=${value.price} data-index=${value.position} data-category="${category}">
          </div>
      </div>
    </div>
    `)  
  })
  return true
}

const playSound = (type,error) => {
  $.post(`https://${zCoins}/playSound`,JSON.stringify({
    action: type,
    error: error 
  }))
}
$(document).on("click",".itemMenuShop",function() {
  if($(this).hasClass("menu_selecionado")) return
  $(".menu_selecionado").removeClass("menu_selecionado")
  $(this).addClass('menu_selecionado')
  let category  = $(this).data('category')
  selectCategory(category)
  playSound('click')
});

$(document).on("click",".comprar",function() {
  $(this).css('pointer-events','none').css('cursor','none').css('opacity','0.7')
  let index     = $(this).data('index')
  let category  = $(this).data('category')
  let price     = $(this).data('price')
  let _this     = $(this)
  Swal.fire({
    title: "آیا از خرید خود اطمینان دارید؟",
    text: "خرید شما غیر قابل برگشت خواهد بود",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#0DCA20",
    cancelButtonColor: "#d33",
    confirmButtonText: "Buy"
  }).then((result) => {
    if (result.isConfirmed) {
      $.post(`https://${zCoins}/buyProduct`,JSON.stringify({
        category: category, index: Number(index)
      }),function(data){
        if(data.success){
            if(data.coins){
                $("#totalCaixa").text(currency.format(Number(data.coins)))
                atualCoins = Number(data.coins)
            }else{
    
                $("#totalCaixa").text(currency.format(atualCoins - price))
                atualCoins = atualCoins - price
            }
          setTimeout(() => {
            _this.css('pointer-events','auto').css('cursor','pointer').css('opacity','1.0')        
          }, 2000);
          playSound('buy')
        }else{
          _this.css('pointer-events','auto').css('cursor','pointer').css('opacity','1.0')
          playSound('error',data.error)
        }
      })
    }
  });
});

const buildRoulette = async(rouletteData) => {
  new Promise(async function(res,rej) {
    let items = []
    let sortedData = []
    sortedData = sortedData.concat(rouletteData.items.sort((a,b) => rouletteData.types[a.type].percent > rouletteData.types[b.type].percent ? 1 : -1 ))
    $("#custoCaixa").text(rouletteData.price)
    $(".listaFalsa").html('')
    let multiplierStatus = items.length < 10 ? 5 : 1
    await rouletteData.items.forEach((value,index)=>{
      for (let i = 0; i < ((rouletteData.types[value.type].porcent * 10) * multiplierStatus);i++){

        items.push({data: value,ind: index})
      }
    })
    items = shuffle(items)
    items.forEach((value,index)=>{
        $(".listaFalsa").append(`
        <div class="itemRoleta ${value.data.type}" data-index=${value.data.position}>
          <img src="${config.imagesUrl ? config.imagesUrl+'/'+(value.data.idname||value.data.model||value.data.index||'default')+'.png' : 'https://cdn.discordapp.com/attachments/712813090952970345/845364098917072906/repairkit.png'}" alt="" class="imagemItem">
          <div class="bordinha"></div>
        </div>    
      `)
    })
    $('.listaPremios').html('')
    sortedData.forEach((value)=>{
      $(".listaPremios").append(`
      <div class="circle ${value.type || 'normal'}">
        <img src="${config.imagesUrl ? config.imagesUrl+'/'+(value.idname||value.model||value.index||'default')+'.png' : 'https://cdn.discordapp.com/attachments/712813090952970345/845364098917072906/repairkit.png'}" alt="">
      </div>
      `)
    })
    res(true)
  })
}

$(".item").on('click',function(){
  if(document.getElementById($(this).data('menu')).style.display == '') return 
  roulette.style.display = 'none';
  store.style.display = 'none';
  qrcode.style.display = 'none'
  document.getElementById($(this).data('menu')).style.display = ''
  playSound("click")
})

$(".item").mouseenter(function () {
  playSound("select")
})

class SpinnerAnimation {
  constructor() {
    this.tickSound = new Audio("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-55112/zapsplat_multimedia_cell_phone_smart_screen_button_press_click_feedback_001_60930.mp3");
    this.tickSound.playbackRate = 5;

    this.winSound = new Audio("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-46416/zapsplat_multimedia_game_sound_treasure_chest_win_thud_coins_synth_warm_001_52067.mp3");

    this.firstRound = true;
    this.started = false 
    this.reset();

    this.spinnerContainer = document.getElementById('listaRoleta');
    this.spinnerList = this.spinnerContainer.children.namedItem('listaFalsa');
    this.spinnerItems = this.spinnerList.children;
    this.spinnerWon = document.getElementById("spinnerWon");
  }

  reset() {
    this.started = false;
    this.stopped = false;
    this.stopAnimation = false;
    this.lowerSpeed = 0;
    this.ticks = 0;
    this.offSet = 0;
    this.recycle = false;
    this.tick = false;
    this.state = null;
    this.speed = 0;
    this.winningItem = 0;
    this.firstRound = false;
  }
  // speed 2900
  start(speed = 1900) {
    this.started = true;
    this.speed = speed;


    this.loop();
  }

  loop() {
    let dt = 0; // Delta Time is the amount of time between two frames
    let last = 0; // Last time of frame

    // The Animation Loop
    function loop(ms) {

      if (this.recycle) {
        this.recycle = false;
         const item = this.spinnerList.firstElementChild;
        this.spinnerList.append(item);
      }

      if (this.tick) {
        this.tick = false;

        this.tickSound.play();
      }

      this.offSet += this.speed * dt;

      const ct = ms / 1500;
      dt = ct - last;
      last = ct;



      if (this.offSet >= 215) {
        this.recycle = true;
        this.offSet = 0;
        this.tick = true;
        this.ticks += 1;
        // Cálculo do tempo para ficar girando
        // padrão estava 90
        if (this.ticks >= 10 && (Math.random() * 10) >= 5) {
          this.stop();
        }
      }

      if (this.stopped) {
        let stopped = false;
        if (!stopped) this.speed -= this.lowerSpeed;

        if (this.speed <= 0) {
          stopped = true;
          this.speed = 0;
        }

        if (stopped) {


          if (this.offSet >= 100.0) {
            if(this.offSet < 200){
              this.offSet += 2;
            }else{
              this.offSet = 216
            }
          } else {
            if(this.offSet > 4){
              this.offSet -= 4;
            }else{
              this.offSet = 0
            }
          }

          if (this.offSet >= 202 || this.offSet > 210 || this.offSet <= 0) {
            this.winSound.play();
            if (this.offSet >= 202 || this.offSet > 210) {
              this.stopAnimation = true 
              itemWon(this.spinnerItems.item((this.offSet > 215) ? 5 : 4));
            }
            if (this.offSet <= 0) {
              
              this.winningItem = 4;

              this.stopAnimation = true 
              itemWon(this.spinnerItems.item(3));
            }

          }

        }
      }
      document.getElementById('listaFalsa').style.right = this.offSet + "px";
      if (!this.stopAnimation) {
        requestAnimationFrame(loop);
      }
    }
    loop = loop.bind(this);
    requestAnimationFrame(loop);
  }

  stop() {
    this.stopped = true;
    this.lowerSpeed = Math.ceil(Math.random() * 10) + 1;
  }
}

const itemWon = (ev) => {
  $.post(`https://${zCoins}/rewardReedem`,JSON.stringify({
    index: Number(ev.dataset.index), multiplier: multiplier
  }),function(data){
    playSound(multiplier)
    if (multiplier > 1){
      setTimeout(() => {
        multiplier = multiplier - 1 
        animation = new SpinnerAnimation()
        animation.start()
      }, 2000);
    }else{
      $("#rolar")
      .css("pointer-events","auto")
      .css("opacity","1.0")
      .css("cursor","pointer");
      $(".qtd").css("pointer-events","auto").css("cursor","pointer")
    }  
  }) 
}


$("#rolar").on('click',()=>{
  $("#rolar").css("pointer-events","none").css("opacity","0.5").css("cursor","wait");
  $(".qtd").css("pointer-events","none").css("cursor","wait")
  $.post(`https://${zCoins}/tryOpenBox`,JSON.stringify({
    multiplier: multiplier
  }),function(data){
    if(data.success){
      atualCoins = atualCoins - config.roulette.price * multiplier
        $("#totalCaixa").text(currency.format(atualCoins))
        animation = new SpinnerAnimation()
        animation.start()
    }else{
      playSound('error',data.error)
      $("#rolar").css("pointer-events","auto").css("opacity","1.0").css("cursor","pointer")
      $(".qtd").css("pointer-events","auto").css("cursor","pointer")
    }
  })

})


$(".qtd").on('click',function(){
 if(!animation || animation.stopAnimation){
    multiplier = Number(this.innerText.replace("x",""))
    $(".qtd").removeClass('selecionado')
    $(this).addClass('selecionado')
    $("#custoCaixa").text(currency.format((config?.roulette?.price || 1500)* multiplier))
 }else{
    playSound('error',data.error)
 }
})
