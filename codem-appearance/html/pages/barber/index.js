import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/barber/index.html'),
    components: {

    
    },

    data: () => ({
        currentCategory : 'hair',
        categorys :{
            hair : 'Torso',
            beard : 'Head',
            eyebrows : 'Arms',
            makeup : 'Legs',
            blush : 'Legs',
            lipstick : 'Legs',
        },

        summaryData : [
            {name : 'hair', label : 'Hair', price : 0},
            {name : 'beard', label : 'Beard', price : 0},
            {name : 'eyebrows', label : 'Eyebrows', price : 0},
            {name : 'makeup', label : 'General Makeup', price : 0},
            {name : 'blush', label : 'Blushes', price : 0},
            {name : 'lipstick', label : 'Lipstick', price : 0},


         
        ],
        wearUnwear : [
        
            {name : 'mask_1', icon : 'maskcategory'},
            {name : 'helmet_1', icon : 'hatcategory'},
            {name : 'glasses_1', icon : 'glassescategory'},
            {name : 'ears_1', icon : 'braceletcategory'},
        ],
    
           
        buyModal : false
    }),
    methods: {
        changeCategory(category){
            this.currentCategory = category
        },
        ToggleAccessory(name){
            postNUI('ToggleAccessory', {name})
            
        },
        Save(){
            postNUI('saveSkin')
        },
        buynow(val){
            this.buyModal = val
        },
        eventHandler(event){
            switch (event.data.action) {
                case "SET_BARBER_BASKET":
                    const basket = event.data.payload
                    this.summaryData.forEach((el) =>{
                        el.price = 0
                    })

                    for(let key in basket){
                        let data = basket[key]
                        for(let key2 in data){
                            let price = data[key2]
                            let summaryData = this.summaryData.find((el) => el.name == key)
                            if(summaryData){
                                summaryData.price += price
                            }
                        }
                    }
                    break
                default:
                    break
            }
        },
        changeSkin(key, value){
         
            postNUI('changeSkin', {
                key,
                value,
            })
        },
    },

    computed: {
        ...Vuex.mapGetters({
            getSkinByName : 'getSkinByName'
        }),
        totalPrice(){
            let total = 0
            this.summaryData.forEach(el => {
                total += el.price
            });
            return total
        },
    },

    mounted() {
        window.addEventListener('message', this.eventHandler)
    },
    beforeDestroy(){
        window.removeEventListener('message', this.eventHandler)
    }
}




