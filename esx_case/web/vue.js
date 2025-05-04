const app = new Vue({
    el: '#app',
    data: {
        player: {
            gold: 0,
            bank: 0,
            name: ''
        },
        rewards: {
            item: '',
            sell: '',
            size: 0,
            price: 0,
            type: ''
        },
        variable: {
            background: '',
            case: '',
            size: 80,
            price: 0,
            category: '',
            rolling: false,
        },
        page: {
            home: true,
            open: false,
            gold: false,
            case: false,
            rewards: false,
            ui: false,
            sell: true,
        }, 
        notify: {
            page: false,
            shadow: '0px 4px 13px rgba(255, 77, 77, 0.55)',
            color: '#FF4D4D',
            header: 'ERROR',
            message: "You don't have enough money the required amount is 35$"
        }, 
        key: '', 
        sellect: null,
        open: {
            ['items']: []
        }, avatar: 'https://i1.sndcdn.com/artworks-000072177875-aq7b9l-t500x500.jpg', gold: [], live: {
            ['case']: [],
            ['standart']: []
        }, 
        things: [], 
        categories: [], 
        cases: {
        name: ''
        }
    },
    methods: {
    FormatPrice(value) {
        let val = (value / 1).toFixed(0).replace('.', ',')
        return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")
    },
    NewPage(i) {
        if (this.variable.rolling) {return;}
        this.sellect = i.category, this.cases.name = i.category[0].toUpperCase() + i.category.substring(1) + " Case" , this.page.home = !0, this.page
            .gold = !1, this.page.open = !1, this.page.case = !1, UserCheck();
    },
    GoldBuy(data) {
      var audioPlayer = null;
      $.post(`https://${GetParentResourceName()}/GetGold`, JSON.stringify({
          gold: data
      }), function(o) {
          o.data ? (app.player.bank = o.bank, null != audioPlayer && audioPlayer.pause(), (
              audioPlayer = new Howl({
                  src: ["./assets/sound/gold.ogg"]
              })).volume(.2), audioPlayer.play()) : (app.notify.message =
              "You don't have enough money to buy products!", app.notify.color = "#FF4D4D", app
              .notify.shadow = "0px 4px 13px rgba(255, 77, 77, 0.55)", app.notify.header =
              "ERROR", app.notify.page = !0, setTimeout(() => {
                  app.notify.page = !1
              }, 5e3))
      }), UserCheck();
  },
  Coins(i) {
      this.page.gold = !0, this.page.home = !1, this.page.open = !1, this.page.case = !1, this.cases.name =
          "Gold Coins Shop", UserCheck();
  },
  LoadCase(i) {
    this.page.sell = true
      this.open.items = [];
      var list = [];
      i.items.map(e => {list.push(e)}),
      this.open.items = list, this.variable.background = i.icon, this.variable.size = i.size, this.variable.category = i.category,
      this.variable.name = i.label, this.variable.price = i.price, this.page.open = !0, this.page.home = !1,
      this.page.gold = !1, UserCheck();

  },
  OpenCase() {
    this.variable.rolling = true
      $.post(`https://${GetParentResourceName()}/GetCase`, JSON.stringify({
          case: this.variable
      }), function(e) {
        if (e.check == false){
            app.notify.message =
            "Shoma DCoin Kafi Nadarid"
            app.notify.color = "#FF4D4D", app.notify.shadow = "0px 4px 13px rgba(255, 77, 77, 0.55)", app
            .notify.header = "ERROR", app.notify.page = !0,
            setTimeout(() => {
                app.notify.page = false;
                app.variable.rolling = false;
            }, 3000);
        }
          e.check ? (app.page.case = !0, app.page.home = !1, app.page.open = !1, app.page.gold = !1,
              generate(1e3)) : (app.page.case = !1, app.page.home = !0, app.page.open = !1, app
              .page.gold = !1), UserCheck()
      });
  },
  OpenFastCase() {
      const item = this.open.items[randomInt(0, this.open.items.length)];
      $.post(`https://${GetParentResourceName()}/GetCase`, JSON.stringify({
          case: this.variable
      }), function(e) {
        if (e.check == false){
            app.notify.message =
            "Shoma DCoin Kafi Nadarid"
            app.notify.color = "#FF4D4D", app.notify.shadow = "0px 4px 13px rgba(255, 77, 77, 0.55)", app
            .notify.header = "ERROR", app.notify.page = !0,
            setTimeout(() => {
                app.notify.page = false;
            }, 3000);
        }
          e.check ? (app.page.open = !0, app.rewards.item = item.item, app.rewards.image = item.image, app.rewards.sell = item.sell,
              app.rewards.size = item.size, app.rewards.price = item.price, app.rewards.type =
              item.type, app.page.rewards = !0, $(".things").css({
                  opacity: 0
              })) : (app.page.case = !1, app.page.home = !0, app.page.open = !1, app.page
              .gold = !1)
      });
  },
  SellRewards() {
    this.variable.rolling = false
      this.page.rewards = !1, this.page.case = !1, this.page.home = !0, this.page.open = !1, this.page
          .gold = !1, $.post(`https://${GetParentResourceName()}/sell`, JSON.stringify({
              rewards: this.rewards
          }), function(s) {
              app.player.gold = s.amount
          });
      var audioPlayer = null;
      null != audioPlayer && audioPlayer.pause(), (audioPlayer = new Howl({
              src: ["./assets/sound/sell.ogg"]
          })).volume(1), audioPlayer.play(), this.notify.message =
          "You have successfully sold the product, the amount added to your account: " + this.rewards.sell,
          this.notify.color = "#4CFB0E", this.notify.shadow = "0px 4px 13px rgba(76, 251, 14, 0.55)", this
          .notify.header = "Success", this.notify.page = !0, setTimeout(() => {
              this.notify.page = !1
          }, 3e3), $(".things").css({
              opacity: 1
          }), UserCheck();
  },
  Purchase() {
      var audioPlayer = null;
      $.post(`https://${GetParentResourceName()}/Purchase`, JSON.stringify({
          key: this.key
      }), function(a) {
          a.variable && (app.notify.page = !0, app.notify.message =
              "The amount of GC you have uploaded to your account: " + a.amount, app.notify
              .color = "#4CFB0E", app.notify.shadow = "0px 4px 13px rgba(76, 251, 14, 0.55)",
              app.notify.header = "Success", null != audioPlayer && audioPlayer.pause(), (
                  audioPlayer = new Howl({
                      src: ["./assets/sound/gold.ogg"]
                  })).volume(1), audioPlayer.play()), setTimeout(() => {
              app.notify.page = !1
          }, 4e3)
      }), this.key = "", UserCheck();
  },
  Collect() {
    this.variable.rolling = false
      this.page.rewards = !1, this.page.case = !1, this.page.home = !0, this.page.open = !1, this.page
          .gold = !1, this.notify.message = "Saved to your product account you earned: " + this.rewards
          .item, this.notify.color = "#4CFB0E", this.notify.shadow = "0px 4px 13px rgba(76, 251, 14, 0.55)",
          this.notify.header = "Success", this.notify.page = !0, setTimeout(() => {
              this.notify.page = !1
          }, 3e3), $(".things").css({
              opacity: 1
          }), $.post(`https://${GetParentResourceName()}/give`, JSON.stringify({
              case: this.rewards
          })), UserCheck();
  }
},
created() {
  this.sellect = this.live['case'][0].category;
  this.cases.name = this.categories[0].border[0].toUpperCase() + this.categories[0].border.substring(
      1) + ' Cases ';
},
})

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}
function generate(time) {
  var audioPlayer = null;
  if (audioPlayer != null) {
    audioPlayer.pause();
  }
  audioPlayer = new Howl({src: ["./assets/sound/case.ogg"]});
  audioPlayer.volume(6.0);
  audioPlayer.play();
  $('.cases').html("")
  $('.cases').css({
      transition: "sdf",
      "margin-left": "0px"
  }, 10).html('');
  for (let i = 0; i < 101; i++) {
      const item = app.open['items'][randomInt(0, app.open['items'].length)]
      const element = `
    <div class="border" id="case${i}">
      <div class="item" style="background-image:url(${item.image}); background-size: ${item.size}%;"></div>
      <div class="label">${item.label}</div>
    </div>
  `;
      setTimeout(function() {
          $(element).appendTo('.cases');
          $(`#case${i}`).data('item', item)
      }, 0);
  }
  setTimeout(function() {
      goRoll(app.open['items']);
  }, time);
}

function UserCheck() {
  $.post(`https://${GetParentResourceName()}/Check`, JSON.stringify({}));
}

function goRoll(item) {
    var width = window.screen.availWidth;
    var height = window.screen.availHeight;
    $('#case29').css('transform', 'scale(0.95)')
    $('#case30').css('transform', 'scale(0.95)')
    $('#case31').css('transform', 'scale(0.95)')
    $('#case32').css('transform', 'scale(0.95)')
    $('#case33').css('transform', 'scale(0.95)')
    $('#case34').css('transform', 'scale(0.95)')
    $('#case35').css('transform', 'scale(0.95)')
    $('#case36').css({
        opacity: 1
    });
    $('#case37').css('transform', 'scale(0.95)')
    $('#case38').css('transform', 'scale(0.95)')
    $('#case39').css('transform', 'scale(0.95)')
    $('#case40').css('transform', 'scale(0.95)')

    setTimeout(function() {
        $('#case32').css('opacity', '0.2')
        $('#case39').css('opacity', '0.2')
        $('#case40').css('opacity', '0.2')
    }, 5000);
  $('.cases').css({
      transition: "all 8s cubic-bezier(.08,.6,0,1)"
  });
  if (width == 3440 || height == 1440){ 
    $('.cases').css('margin-left', `-${randomInt(409.5, 409.5)}rem`);
  }else{
    $('.cases').css('margin-left', `-${randomInt(429.063, 429.063)}rem`);
  }
  const data = $('#case36').data('item');
  setTimeout(function() {
      app.rewards.item = data.item;
      app.rewards.image = data.image;
      app.rewards.sell = data.sell;
      app.rewards.size = data.size;
      app.rewards.price = data.price;
      app.rewards.type = data.type;
      app.page.rewards = true;
      $(".things").css({
          "opacity": 0,
      })
  }, 8500);
}

window.addEventListener('message', function(event) {
    var v = event.data;
    switch (v.type) {
        case "case":
            app.live['case'] = v.cases;
            app.live['standart'] = v.standart;
            app.things = v.things;
            app.gold = v.gold;
            app.categories = v.categories;
            app.sellect = app.live['case'][0].category;
            app.cases.name = app.categories[0].border[0].toUpperCase() + app.categories[0].border.substring(1) + ' Cases ';
            app.page.ui = true;
            break
        case "purchase":
            app.player.gold = v.gold;
            app.player.bank = v.bank;
            app.player.name = v.name;
            app.avatar = v.avatar;
            break
        case "openCase":
            let i = v.caseData
            app.open.items = [];
            var list = [];
            i.items.map(e => {list.push(e)}),
            app.open.items = list, app.variable.background = i.icon, app.variable.size = i.size, app.variable.category = i.category,
            app.variable.name = i.label, app.variable.price = i.price, app.page.open = !0, app.page.home = !1,
            app.page.gold = !1, UserCheck();
            app.page.sell = false
            app.page.ui = true;
            app.variable.rolling = true
            $.post(`https://${GetParentResourceName()}/GetCase`, JSON.stringify({
                case: app.variable
            }), function(e) {
              if (e.check == false){
                  app.notify.message =
                  "Shoma DCoin Kafi Nadarid"
                  app.notify.color = "#FF4D4D", app.notify.shadow = "0px 4px 13px rgba(255, 77, 77, 0.55)", app
                  .notify.header = "ERROR", app.notify.page = !0,
                  setTimeout(() => {
                      app.notify.page = false;
                      app.variable.rolling = false;
                  }, 3000);
              }
                e.check ? (app.page.case = !0, app.page.home = !1, app.page.open = !1, app.page.gold = !1,
                    generate(1e3)) : (app.page.case = !1, app.page.home = !0, app.page.open = !1, app
                    .page.gold = !1), UserCheck()
            });
            break
    }
})

document.onkeyup = function(data) {
  if (data.which == 27) {
      let div = app;
      if (app.variable.rolling) {return;}
      if (div.page.open == true) {
          setTimeout(() => {
              div.page.home = true;
              div.page.open = false;
          }, 5);
      }
      if (div.page.rewards == true) {
          setTimeout(() => {
              app.page.rewards = false;
              app.page.case = false;
              app.page.home = true;
              app.page.open = false;
              app.page.gold = false;
              $.post(`https://${GetParentResourceName()}/give`, JSON.stringify({
                  case: app.rewards
              }));
          }, 5);
      }
      if (div.page.open == false){
          app.page.ui = false;
          $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
      }
  }
};