import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/job/index.html'),
    components: {


    },

    data: () => ({

        dropDownMenu: [],
        currentClothingItems: [],
        jobClothing: [{ id: 15151151, name: 'testkiyafet' }, { id: 15151151222, name: 'testkiyafet' }, { id: 15151151, name: 'testkiyafet' }, { id: 15151151222, name: 'testkiyafet' }, { id: 15151151, name: 'testkiyafet' }, { id: 15151151222, name: 'testkiyafet' }, { id: 15151151, name: 'testkiyafet' }, { id: 15151151222, name: 'testkiyafet' }],

        edit: false,

    }),
    methods: {
        wearJobClothing(data) {
            postNUI('wearJobClothing', {
                skin : data.outfitData,
            })
        },
        mainClothes(){
            postNUI('mainClothes', {
             
            })
        },

        showDropDownMenu(id) {
            this.dropDownMenu[id] = !this.dropDownMenu[id]
        },
        eventHandler(event) {
            switch (event.data.action) {
                case "SET_JOB_OUTFIT_DATA":
                    this.jobClothing = event.data.payload
                    break
                default:
                    break
            }
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




