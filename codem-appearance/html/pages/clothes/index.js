import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/clothes/index.html'),
    components: {

    
    },

    data: () => ({
        category : 'clothes',
        clothesList : {
            
            clothes : [
                {
                    name : 'torso_1',
                    label : 'Tops & Jackets',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'torso_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'tshirt_1',
                    label : 'Undershirt',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'tshirt_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'arms',
                    label : 'Hands & Arms',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'arms_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
             
                {
                    name : 'pants_1',
                    label : 'Legs',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'pants_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'shoes_1',
                    label : 'Shoes',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'shoes_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'bags_1',
                    label : 'Bags & Parachutes',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'bags_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'bproof_1',
                    label : 'Armour',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'bproof_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
            ],
            accessories : [
                {
                    name : 'mask_1',
                    label : 'Mask',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'mask_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'helmet_1',
                    label : 'Hats & Helmets',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'helmet_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'glasses_1',
                    label : 'Glasses',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'glasses_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'ears_1',
                    label : 'Ear Accessories',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'ears_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'chain_1',
                    label : 'Scarf & Chains',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'chain_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'watches_1',
                    label : 'Watches',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'watches_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'bracelets_1',
                    label : 'Bracelets',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'bracelets_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
                {
                    name : 'decals_1',
                    label : 'Decals',
                    label1 : 'Type',
                    typeValue : 1,
                    texture_name : 'decals_2',
                    label2 : 'Textures',
                    texturesValue : 1,
                },
            ],
        }
    }),
    methods: {
        changeClothesPage(cat) {
            if(cat){
                this.category = cat
            }
        },     
        changeSkin(key, value){
         
            postNUI('changeSkin', {
                key,
                value,
            })
        },
        createcharacter(){
            if(this.$store.state.isSurgery){
                this.$store.state.charAcceptModal = true

            }else{
                postNUI("saveSkin")
            }
        },
    },
    computed: {
        ...Vuex.mapGetters({
            getSkinByName : 'getSkinByName'
        }),
    },

    mounted() {
        this.clothesList['clothes'][0].label = this.$store.state.locales['fheaderText1']
        this.clothesList['clothes'][1].label = this.$store.state.locales['fheaderText2']
        this.clothesList['clothes'][2].label = this.$store.state.locales['fheaderText3']
        this.clothesList['clothes'][3].label = this.$store.state.locales['fheaderText4']
        this.clothesList['clothes'][4].label = this.$store.state.locales['fheaderText5']
        this.clothesList['clothes'][5].label = this.$store.state.locales['fheaderText7']
        this.clothesList['clothes'][6].label = this.$store.state.locales['fheaderText6']

        this.clothesList['accessories'][0].label = this.$store.state.locales['sheaderText1']
        this.clothesList['accessories'][1].label = this.$store.state.locales['sheaderText4']
        this.clothesList['accessories'][2].label = this.$store.state.locales['theaderText1']
        this.clothesList['accessories'][3].label = this.$store.state.locales['theaderText2']
        this.clothesList['accessories'][4].label = this.$store.state.locales['chainsTitle']
        this.clothesList['accessories'][5].label = this.$store.state.locales['watchesTitle']
        this.clothesList['accessories'][6].label = this.$store.state.locales['braceletsTitle']
        this.clothesList['accessories'][7].label = this.$store.state.locales['sheaderText3']

    }
}