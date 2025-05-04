import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/wardrobe/index.html'),
    components: {


    },

    data: () => ({
        playerCategory: [],
        dropDownMenu: [],
        currentClothingItems: [],
        unnamedClothing: [],

        edit: false,

    }),
    methods: {
        
        deleteClothing(id) {
            postNUI('DeleteSavedClothing', {
                id
            })
        },
        deleteCategory(id) {
            postNUI('DeleteClothingCategory', {
                id
            })
        },
        editButton(val) {
            this.edit = val
        },
        showDropDownMenu(id) {
            this.dropDownMenu[id] = !this.dropDownMenu[id]
        },
        eventHandler(event) {
            switch (event.data.action) {
                case "SET_CLOTHING_CATEGORIES":
                    this.playerCategory = event.data.payload
                    this.SyncCategory()
                    break
                case "SET_SAVED_CLOTHINGS":
                    this.unnamedClothing = event.data.payload

                    this.SyncCategory()
                    break
                default:
                    break
            }
        },
        SyncCategory(){
         
            this.playerCategory.forEach((data) =>{
                data.items = []
                let clothings = this.unnamedClothing.filter((el) => el.categoryId == data.id)
                
                if(clothings.length > 0){
                    clothings.forEach((el) =>{
                        data.items.push(el)
                    })
                }
                this.unnamedClothing = this.unnamedClothing.filter((el) => el.categoryId != data.id)
            })
                
        },
        clothingBox(val) {

            if (!this.currentClothingItems[val.id]) {

                for (let key in this.currentClothingItems) {
                    this.currentClothingItems[key] = false
                }
            }
            this.currentClothingItems[val.id] = !this.currentClothingItems[val.id]

            if (!this.currentClothingItems[val.id]) {

            } else {
                postNUI('wearClothing', {
                    skin :  val.skin,
                })
            }


        },
    },

    computed: {



    },

    mounted() {
        window.addEventListener('message', this.eventHandler)


    },
    beforeDestroy() {
        window.removeEventListener('message', this.eventHandler)
    }
}




