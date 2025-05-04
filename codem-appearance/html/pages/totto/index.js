import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/totto/index.html'),
    components: {

    
    },

    data: () => ({
        currentCategory : 'body',
        categorys :{
            body : {
                label : 'Torso',
                zones : ["ZONE_TORSO"],
            },
            head : {
                label : 'Head',
                zones : ["ZONE_HEAD"],

            },
            arms  : {
                label : 'Arms',
                zones : ["ZONE_RIGHT_ARM", "ZONE_LEFT_ARM"],
            },
            legs : {
                label : 'Legs',
                zones : ["ZONE_RIGHT_LEG", "ZONE_LEFT_LEG"],

            },
        },
        currentTattoos:[],
        tattooBasket : [],
        tattoos : {
            ["torso"] : [],
            ["head"] : [],
            ["leftarm"] : [],
            ["rightarm"] : [],
            ["leftleg"] : [],
            ["rightleg"] : [],
        },
        values : {
            ["torso"] : 0,
            ["head"] : 0,
            ["leftarm"] : 0,
            ["rightarm"] : 0,
            ["leftleg"] : 0,
            ["rightleg"] : 0, 
        },

        clothingCategory : {
            body : [
                {
                    name : 'torso',
                    text : 'Torso',
                    label: 'Tattoos',
                    value : 0,
                },
            
            ],
            head : [
                {
                    name : 'head',
                    text : 'Head',
                    label: 'Tattoos',
                    value : 0,
                },
           
            ],
            arms : [
                {
                    name : 'leftarm',
                    text : 'Left Arm',
                    label: 'Tattoos',
                    value : 0,
                },
                {
                    name : 'rightarm',
                    text : 'Right Arm',
                    label: 'Tattoos',
                    value : 0,
                },
            ],
            legs : [
                {
                    name : 'leftleg',
                    text : 'Left Leg',
                    label: 'Tattoos',
                    value : 0,
                },
                {
                    name : 'rightleg',
                    text : 'Right Leg',
                    label: 'Tattoos',
                    value : 0,
                },
            ],
        },
        summaryData : [
            {name : 'torso', label : 'Torso', price : 0},
            {name : 'head', label : 'Head', price : 0},
            {name : 'leftarm', label : 'Left Arm', price : 0},
            {name : 'rightarm', label : 'Right Arm', price : 0},
            {name : 'leftleg', label : 'Left Leg', price : 0},
            {name : 'rightleg', label : 'Right Leg', price : 0},
        ],
           
        buyModal : false
    }),
    methods: {
        changeCategory(category){
            this.currentCategory = category
        },
        buynow(val){
            this.buyModal = val
        },
        toggleTattoBasket(type, tattoName){
            let tattoo =  this.tattoos[type][this.values[type]]

            if(!this.CheckAlreadyPurchased(tattoo.HashNameMale, tattoo.HashNameFemale)){
                const data = this.tattooBasket.find(el => el.Name == tattoName)
                if(data){
                    this.tattooBasket = this.tattooBasket.filter(el => el.Name != tattoName)
                }else{
                    tattoo.type = type
                    this.tattooBasket.push(tattoo)
                }
                
                postNUI('getTattooBasketData', {
                    basket:this.tattooBasket
                })
                this.SetBasketPrices()
            }else{
                postNUI('removeTattoo', {
                    tattoo
                })
            }

        },
        RemoveTattoo(zones){
            postNUI('RemoveTattooZone', {
                zones
            })
        },
        CheckBasket(name){
            const data = this.tattooBasket.find(el => el.Name == name)
            if(data){
                return true
            }
            return false
        },
        CheckAlreadyPurchased(hash_1, hash_2){
            const data = this.currentTattoos.find(el => el.hash ? el.hash == hash_1 || el.hash == hash_2 : false) 
            if(data){
                return true
            }

            return false
        },
        async Buy(){
            const data = await postNUI('buyTattoo', {
                basket:this.tattooBasket
            })
            if(data){
                this.tattooBasket = []
            }
        },
        SetBasketPrices(){
            for(let index in this.summaryData){
                let data = this.summaryData[index]
                const name = data.name
                let basket = this.tattooBasket.filter((el) => el.type == name)
                let total = 0
                basket.forEach((el) =>{
                    total += el.Price
                })
                data.price = total
            }
        },
    
        IncreaseValue(type){
            if(this.values[type] < this.tattoos[type].length - 1){
                this.values[type] += 1
            }else{
                this.values[type] = 0
            }
            postNUI('previewTatto', {
                tattoo:this.tattoos[type][this.values[type]]
            })
        },
        DecreaseValue(type){
            if(this.values[type] > 0){
                this.values[type] -= 1
            }else{
                this.values[type] = this.tattoos[type].length - 1
            }
            
            postNUI('previewTatto', {
                tattoo:this.tattoos[type][this.values[type]]
            })
        },
        eventHandler(event){
            switch (event.data.action) {
                case "SET_TATTOOS":
                    this.tattoos = event.data.payload
                    break
                case "SET_CURRENT_TATTOOS":
                    this.currentTattoos = event.data.payload
                    break
                default:
                    break
            }
        },
    },

    computed: {
        GetTotalBasketPrice(){
            let total = 0
            this.tattooBasket.forEach((el) =>{
                total += el.Price
            })
            return total
        }
    },

    mounted() {
        window.addEventListener('message', this.eventHandler)
        
        postNUI('getTattooBasketData', {
            basket:this.tattooBasket
        })
   

        this.summaryData[0].label =  this.$store.state.locales['torsoTitle1']
        this.summaryData[1].label =  this.$store.state.locales['torsoTitle3']
        this.summaryData[2].label =  this.$store.state.locales['torsoTitle5']
        this.summaryData[3].label =  this.$store.state.locales['torsoTitle6']
        this.summaryData[4].label =  this.$store.state.locales['torsoTitle7']
        this.summaryData[5].label =  this.$store.state.locales['torsoTitle8']
    },
    beforeDestroy(){
        window.removeEventListener('message', this.eventHandler)
    }
}




