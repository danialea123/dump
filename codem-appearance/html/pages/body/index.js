import importTemplate from '../../js/util/importTemplate.js';
import hairCategory from './component/hear/index.js';
import noseCategory from './component/nose/index.js';
import eyebrowsCategory from './component/eyebrows/index.js';
import cheeksCategory from './component/cheeks/index.js';
import eyesCategory from './component/eyes/index.js';
import beardCategory from './component/beard/index.js';
import neckCategory from './component/neck/index.js';

import strainsCategory from './component/strains/index.js';
import makeupCategory from './component/makeup/index.js';


export default {
    template: await importTemplate('pages/body/index.html'),
    components: {
        hairCategory : hairCategory,
        noseCategory : noseCategory,
        eyebrowsCategory : eyebrowsCategory,
        cheeksCategory : cheeksCategory,
        eyesCategory : eyesCategory,
        beardCategory : beardCategory,
        neckCategory : neckCategory,

        strainsCategory : strainsCategory,
        makeupCategory : makeupCategory,

    
    },

    data: () => ({
        components : {
      

        },

        category : 'face',
 
        clothesList : {
            body : [
                {
                    name : 'chesthair',
                    label : 'Chest Hair',
                    label1 : 'Type',
                    typeValue : 1,
                    label2 : 'Intensity',
                    texturesValue : 1,
                    range : true,
                    color : true,
                },
            
                
                
            ],
            face : [
                
            ],
        },
        faceListCategory : false,
        faceListCategoryComponent : false,
        faceList : {
            hair : [

            ],
            nose : [

            ],
            eyebrows : [

            ],
            cheeks : [

            ],
            eyes :[

            ],
            beard : [

            ],
            neck : [

            ]
        },
        currentFaceContainerValue : false,
        currentFaceComponent :false,
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
        changeCategoryFaceList(val){
            if(val){
                this.faceListCategory = val
                this.faceListCategoryComponent = val + 'Category'
            }
        },
        changeContainer(val){
            if(val){
                this.currentFaceComponent = val + 'Category'
                this.currentFaceContainerValue = val
            }
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
        // this.currentFaceComponent = makeupCategory
        // setTimeout(() => {
        // this.pedPageCategory = 'females'
        // this.getBackgroundImage(this.padPageCategory)
    }
}