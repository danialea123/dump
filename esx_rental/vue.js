const app = new Vue({
  el: '#app',
  data: {
    notify:false, // start extra
    tolerance:60,
    ui:false,
    minutes:1,
    seconds:0,
    secondsLeft: 0,
    timer: null,
    payment:'cash', // cash or bank
    value: 40,
    selectBuy:false,
    selectedItem: null,
    backgroundImageStyle: { backgroundImage: "url('assets/img/background.svg')"},
    car:{
      search:'',
      select:'',
      label:'',
      model:'',
      firstprice: 0,
      price:200,
        features:{
        'speed':{
          label:'Speed',
          value: 40,
        },
          'brake':{
            label:'Brake',
            value: 40,
        },
        'gasoline':{
          label:'Gasoline',
          value: 40,
        },
        'fuel':{
          label:'Fuel',
          value: 80,
        }
      },
      list:[]
    }
    
    },
  methods: { 
    animateListItems() {
      this.filteredList.forEach((_, index) => {
        let listItem = this.$refs[`listItem-${index}`][0];
        anime({
          targets: listItem,
          opacity: [0, 1], 
          delay: index * 100, 
          easing: 'easeOutCubic'
        });
      });
    },
    buyMenu(type, item) {
      this.selectBuy = item;
      if (type === 'done') {
        $.post(`https://${GetParentResourceName()}/start`, JSON.stringify({time:this.minutes, model:this.car.model, price:(this.car.firstprice*this.minutes), type:this.payment}), (data) => {
          if (data) {
            this.startCountDown();
            this.notify = 'start';
            this.ui = false;
            $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
          }
        });
      } else {
        this.stopCountDown();
      }
    },
    
    //------------------------------------------------------------------------

      startCountDown() {
        if (this.timer) {
            this.stopCountDown();
        }
    
        let totalSeconds = this.minutes * 60 + this.seconds;
        let negativeDuration = 0;
        this.timer = setInterval(() => {
            totalSeconds--;
    
            if (totalSeconds === 0) {
                this.notify = 'extra';
                this.stopCountDown();
            }
    
            if (totalSeconds < 0) {
                negativeDuration++;
    
                if (negativeDuration > this.tolerance) {
                    this.stopCountDown();
                    return;
                }
    
                if (this.seconds === 0) {
                    this.minutes--;
                    this.seconds = 59;
                } else {
                    this.seconds--;
                }
            } else {
                this.minutes = Math.floor(totalSeconds / 60);
                this.seconds = totalSeconds % 60;
            }
        }, 1000);
    },
  
  
  stopCountDown() {
      if (this.timer) {
          clearInterval(this.timer);
          this.timer = null;
          this.tolerance = null;
          this.minutes = 1;
          this.seconds = 0;
          this.notify = false;
          $.post(`https://${GetParentResourceName()}/delete`, JSON.stringify({}));
      }
  },
  
    
    beforeDestroy() {
      this.stopCountDown();
    },
    
    animatePosition(item) {
      let target, translateValue;
      if (item === 'left') {
        target = this.$refs.leftArrow;
        translateValue = "+=10";
      } else if (item === 'right') {
        target = this.$refs.rightArrow;
        translateValue = "-=10";
      }
      anime({
        targets: target,
        translateX: [0, translateValue, 0],
        duration: 600,
        easing: 'easeInOutQuad'
      });
      this.getPosition(item);
    },
    
    getPosition(item) {
      if (item === 'left') {
        this.minutes += 1;
      } else if (item === 'right') {
        if (this.minutes > 1) {
          this.minutes -= 1;
        }
      }
      this.car.price = this.minutes * this.car.firstprice
      this.notify = 'start'
    },
    

    //------------------------------------------------------------------------

    getPayment(item){
      this.payment = item;
      this.selectBuy = true;
    },

    getWidth(featureKey) {
      let featureValue = this.car.features[featureKey].value;
      let width = featureValue / 100 * 100; 
      return width > 80 ? 80 : width;
    },

    formatPrice(price) {
      let formatted = Number(price).toLocaleString('de-DE');
      return formatted.replace(',', '.');
   },

   matchesSearch(label) {
    return label.toLowerCase().includes(this.car.search.toLowerCase());
  },
  


  select(item) {
    this.selectedItem = item;
    this.car.select = item.model;
    this.car.label = item.label;
    this.car.description = item.description;
    this.car.price = item.price * this.minutes;
    this.car.firstprice = item.price
    this.car.model = item.model;
    this.notify = 'start'

    $.post(`https://${GetParentResourceName()}/features`, JSON.stringify({model:item.model}), function(data){
      console.log(JSON.stringify(data))
      app.car.features['speed'].value = Math.floor(data.maxSpeed);
      app.car.features['brake'].value = Math.floor(data.brake);
      app.car.features['fuel'].value = Math.floor(data.fuel);
      app.car.features['gasoline'].value = 50 + Math.random() * (80 - 50);
      // app.speed = Math.floor(data.speed),
      // app.fuel = Math.floor(data.fuel),
      // app.traction = Math.floor(data.traction),
      // app.acceleration = Math.floor(data.acceleration)
    })


    anime({
      targets: this.$refs.image0_681_236,
      translateY: [-100, 0], 
      scale: [0.5, 1],  
      opacity: [0, 1], 
      duration: 600,
      easing: 'easeOutElastic(1, .8)',  
    });

    anime({
      targets: [this.$refs.rect1, this.$refs.rect2, this.$refs.rect3, this.$refs.rect4],
      opacity: [0, 1],  
      duration: 500,
      easing: 'linear'
    });

    anime({
      targets: [this.$refs.text1, this.$refs.text2, this.$refs.text3, this.$refs.text4],
      opacity: [0, 1], 
      translateX: [-50, 0],
      rotate: [-5, 0],  
      duration: 1200, 
      easing: 'easeOutBack',
      delay: anime.stagger(150)
    });
    

  }
    
  },

  created() {
    self = this;
    // self.notify = 'start'
    window.addEventListener('message', event => {
      const item = event.data;
      if (item.type == 'CARS') {
        self.ui = true;
        self.car.list = item.cars;
        self.car.select = item.cars[0].model;
        self.car.label = item.cars[0].label;
        self.car.description = item.cars[0].description;
      }else if (item.type == 'STOP'){
        self.stopCountDown()
      }else if (item.type == 'PAUSE'){
        self.notify = item.args;
      }else if (item.type == 'CLOSE'){
        self.ui = false;
        $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
      }
    });
  },
  
  
  watch: {
    selectBuy(newVal, oldVal) {
      if (newVal && !oldVal) {
        this.$nextTick(() => {
          anime({
            targets: [this.$refs.done, this.$refs.cancelText], 
            opacity: [0, 1],
            translateY: ['-1em', 0],
            duration: 600,
            easing: 'easeOutElastic(1, .8)',
          });
        });
      }
    },
    'car.search': {
        immediate: true,
        handler(newValue) {
            this.filteredList.forEach((eyes, index) => {
                let listItem = this.$refs[`listItem-${index}`][0];
                if (newValue && newValue.trim() !== '' && this.matchesSearch(eyes.label)) {
                    anime({
                        targets: listItem,
                        scale: [0.95, 1], 
                        opacity: [0, 1], 
                        duration: 500,
                        easing: 'easeOutCubic'
                    });
                } else {
                    anime({
                        targets: listItem,
                        scale: 1,
                        opacity: 1,
                        duration: 500,
                        easing: 'easeOutCubic'
                    });
                }
            });
        }
    }
},

  computed: {
    filteredList() {
      return this.car.list.filter(eyes => this.matchesSearch(eyes.label));
    },
    backgroundStyle() {
      if (this.notify === 'start') {
        return "linear-gradient(90.26deg, #4C4388 -1%, #100F1E 100.94%)";
      } else if (this.notify === 'extra') {
        return "linear-gradient(90.26deg, #8E4747 -1%, #210F0F 100.94%";
      } else {
        return "linear-gradient(90.26deg, #4C4388 -1%, #100F1E 100.94%)"; 
      }
    },
    timeStyle() {
      if (this.notify === 'start') {
        return {
          background: "radial-gradient(114.29% 114.29% at 50% 50%, rgba(116, 151, 59, 0.25) 0%, rgba(106, 140, 49, 0.25) 100%)",
          border: "1px solid #B1FF33"
        };
      } else if (this.notify === 'extra') {
        return {
          background: "radial-gradient(114.29% 114.29% at 50% 50%, rgba(151, 59, 59, 0.25) 0%, rgba(151, 59, 59, 0.25) 100%)",
          border: "1px solid #973B3B"
        };
      } else {
        return {};
      }
    },
    priceStyle() {
      if (this.notify === 'start') {
        return {
          background: "radial-gradient(114.29% 114.29% at 50% 50%, #74973B 0%, #6A8C31 100%)",
        };
      } else if (this.notify === 'extra') {
        return {
          background: "radial-gradient(114.29% 114.29% at 50% 50%, #973B3B 0%, #8C3131 100%)",
        };
      } else {
        return {};
      }
    }
  },

  mounted() {
    this.animateListItems();
    document.onkeyup = data => {
      if (data.which == 27) {
        this.ui = false;
        this.notify = false;
        $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
      }
    };
  }
});
