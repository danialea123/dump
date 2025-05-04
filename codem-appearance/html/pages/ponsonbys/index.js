import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/ponsonbys/index.html'),
    components: {

    
    },

    data: () => ({
      headerText : 'All Binco Clothes',
      selectedClothing : false,
      thirstCategoryValue : false,
      buynowModal : false,
      unpaidOutfits : [
        // {name : 'Outfit 1',id : '21321321' },
        // {name : 'Outfit 2', id : '21321321222' },
        // {name : 'Outfit 3', id : '2132132122222' },
      ],
      shareOutfitData : null,
      firstCategory : [
        {
            name : 'jacket',
            model_name : 'torso_1',
            texture_name : 'torso_2',
            icon : 'jacketcategory',
            headerText : 'Tops & Jackets'
        },
        {
            name : 'undershirt',
            model_name : 'tshirt_1',
            texture_name : 'tshirt_2',
            icon : 'undershirtcategory',
            headerText : 'Undershirt'
        },
        {
            name : 'armor',
            model_name : 'bproof_1',
            texture_name : 'bproof_2',
            icon : 'armorcategory',
            headerText : 'Body Armor'
        },
        {
            name : 'bags',
            model_name : 'bags_1',
            texture_name : 'bags_2',
            icon : 'bagscategory',
            headerText : 'Bags & Parachutes'
        },
        {
            name : 'hand',
            model_name : 'arms',
            texture_name : 'arms_2',
            icon : 'handcategory',
            headerText : 'Hands & Arms'
        },
        {
            name : 'legs',
            model_name : 'pants_1',
            texture_name : 'pants_2',
            icon : 'legscategory',
            headerText : 'Legs'
        },
        {
            name : 'shoes',
            model_name : 'shoes_1',
            texture_name : 'shoes_2',
            icon : 'shoescategory',
            headerText : 'Shoes'
        },
      ],
      
      secondCategory : [
        {
            name : 'mask',
            model_name : 'mask_1',
            texture_name : 'mask_2',
            icon : 'maskcategory',
            headerText : 'Masks'
        },
        {
            name : 'scarfs',
            model_name : 'chain_1',
            texture_name : 'chain_2',
            icon : 'scarfscategory',
            headerText : 'Scarfs & Chains'
        },
        {
            name : 'decals',
            model_name : 'decals_1',
            texture_name : 'decals_2',
            icon : 'decalscategory',
            headerText : 'Decals'
        },
      
        {
            name : 'hat',
            model_name : 'helmet_1',
            texture_name : 'helmet_2',
            icon : 'hatcategory',
            headerText : 'Hats & Helmets'
        },
      ],
      thirstCategory : [
        {
            name : 'glasses',
            model_name : 'glasses_1',
            texture_name : 'glasses_2',
            icon : 'glassescategory',
            headerText : 'Glassess'
        },
        {
            name : 'ear',
            model_name : 'ears_1',
            texture_name : 'ears_2',
            icon : 'earcategory',
            headerText : 'Ear Accessories'
        },
        {
            name : 'watch',
            model_name : 'watches_1',
            texture_name : 'watches_2',
            icon : 'watchcategory',
            headerText : 'Watches'
        },
      
        {
            name : 'bracelet',
            model_name : 'bracelets_1',
            texture_name : 'bracelets_2',
            icon : 'braceletcategory',
            headerText : 'Bracelets'
        },
      ],
    
      bincoClothing: [
        {
            name : 'torso_1',
            texture_name : 'torso_2',
            label : 'Tops & Jackets',
            background : 'topsjackets',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'tshirt_1',
            texture_name : 'tshirt_2',
            label : 'Undershirt',
            background : 'undershirt',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'bproof_1',
            texture_name : 'bproof_2',
            label : 'Body Armor',
            background : 'armor',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'bags_1',
            texture_name : 'bags_2',
            label : 'Bags & Parachutes',
            background : 'bags',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'arms',
            texture_name : 'arms_2',
            label : 'Hans & Arms',
            background : 'handsarms',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'pants_1',
            texture_name : 'pants_2',
            label : 'Legs',
            background : 'legs',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'shoes_1',
            texture_name : 'shoes_2',
            label : 'Shoes',
            background : 'shoes',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'mask_1',
            texture_name : 'mask_2',
            label : 'Mask',
            background : 'mask',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'chain_1',
            texture_name : 'chain_2',
            label : 'Scarfs & Chains',
            background : 'scarfs',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'decals_1',
            texture_name : 'decals_2',
            label : 'Decals',
            background : 'decals',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'helmet_1',
            texture_name : 'helmet_2',
            label : 'Hats & Helmets', 
            background : 'hat',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'glasses_1',
            texture_name : 'glasses_2',
            label : 'Glasses', 
            background : 'glases',
            typeValue : 0,
            variationsValue : 0,
        },
   
        {
            name : 'ears_1',
            texture_name : 'ears_2',
            label : 'Ear Accessories', 
            background : 'ear',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'watches_1',
            texture_name : 'watches_2',
            label : 'Watches', 
            background : 'watch',
            typeValue : 0,
            variationsValue : 0,
        },
        {
            name : 'bracelets_1',
            texture_name : 'bracelets_2',
            label : 'Bracelets', 
            background : 'bracalets',
            typeValue : 0,
            variationsValue : 0,
        },
    ],
    summaryData : [
        {name : 'jacket', label : 'Tops & Jackets', model : '1', texture : '0'},
        {name : 'undershirt', label : 'Undershirt', model : '0', texture : '0'},
        {name : 'handsarms', label : 'Hans & Arms', model : '0', texture : '0'},
        {name : 'legs', label : 'Legs', model : '0', texture : '0'},
        {name : 'shoes', label : 'Shoes', model : '0', texture : '0'},
        {name : 'mask', label : 'Mask', model : '0', texture : '0'},
        {name : 'scarf', label : 'Scarfs & Chains', model : '0', texture : '0'},
        {name : 'decals', label : 'Decals', model : '0', texture : '0'},
        {name : 'hat', label : 'Hats & Helmets', model : '0', texture : '0'},
        {name : 'glases', label : 'Glasses', model : '0', texture : '0'},
        {name : 'ear', label : 'Ear Accessories', model : '0', texture : '0'},
        {name : 'watch', label : 'Watches', model : '0', texture : '0'},
        {name : 'bracelet', label : 'Bracelets', model : '0', texture : '0'},
        {name : 'bag', label : 'Bags & Parachutes', model : '0', texture : '0'},
        {name : 'armor', label : 'Body Armor', model : '0', texture : '0'},
    ],

    createNewCategoryModal : false,
    createCategoryModalInput : '',
    crateClothingModal : false,
    createClothingModalInput : '',
    playerCategory : [
        {id : 31, name : 'test', items :[]}
    ],
    unnamedClothing : [{id : 15151151 , name : 'testkiyafet'},{id : 15151151222 , name : 'testkiyafet'}],
    isDragInitialized: false,
    isDragInitializedClothing: false,
    currentCategory : 'saved',
    savedCatetory : 'saved', 
    currentClothingItems : [], // sol tarafta  clothing boxları tıkladığında background imageyi değiştirir
    currentClothingItemsValue : false, // sol tarafta clothing boxları tıkladığında ordaki value buna tanımlanır ve nearby playersi modelini açar
    sharingModal : false,
    
    nearbyPlayers : [{id :1, name : 'Aiakos Aiakos'}, {id : 2, name : 'Thac'},{id : 3, name : 'Lucid'} ],
    cameraData :[
        {
            id : 1,
        },
        {   
            id : 2,
        },
        {
            id : 3,
        },
    ],
    cameraActive : null,

    wearNow : false,
    deleteUnpaidCloting : false,

    deleteClothingId : false,
   
    dropDownMenu : [],

    openSharingModal : false,
    }),
    methods: {
        SharingModalValue(val){
            this.sharingModal = val
        },
        showDropDownMenu(id){
            this.dropDownMenu[id] = !this.dropDownMenu[id]
        },
        saveUnpaidOutfit(){
            postNUI("saveUnpaidOutfit")
        },
        showInput(val){
            this.crateClothingModal = val
        },
        async ChangeCamera(id){
            const old = this.cameraActive

            if(this.cameraActive == id){
                this.cameraActive = false
                
            }else{
                this.cameraActive = id
            }
            const data = await postNUI("changeCamera", {
                value : this.cameraActive,
            })

            if(!data){
                this.cameraActive = old
            }
        },
        closeSharingModal(){
            this.openSharingModal = false
        },
        openSharingModalVal(){
            this.openSharingModal = true
        },
        WearClothing(){
            postNUI('wearClothing', {
                skin :  this.selectedClothing,
            })
        },
        clothingBox(val){
            this.currentClothingItemsValue = val
            if(!this.currentClothingItems[val.id]){
                
             for(let key in this.currentClothingItems){
                this.currentClothingItems[key] = false
             }
            }
            this.currentClothingItems[val.id] = !this.currentClothingItems[val.id]

            if(!this.currentClothingItems[val.id]){
                this.selectedClothing = false
                this.currentClothingItemsValue = false
                this.wearNow = false
                this.deleteClothingId = false
            }else{
                this.wearNow = true
                this.deleteClothingId = val.id
                this.selectedClothing = val.skin
            }  
        
            
        },
        unpaidClothing(val){
            if(!this.currentClothingItems[val.id]){
                for(let key in this.currentClothingItems){
                   this.currentClothingItems[key] = false
                }
            }
            this.currentClothingItems[val.id] = !this.currentClothingItems[val.id]
            if(!this.currentClothingItems[val.id]){
                this.deleteUnpaidCloting = false      
                    
                postNUI('loadSkin')             
            }else{
                this.deleteUnpaidCloting = true
                postNUI('selectUnpaidOutfit', {
                    skin : val.skin,
                })
            }  
        },
        deleteUnpaidOutfit(){
            if(this.currentClothingItemsValue){
                // savecategory için
                if(this.deleteClothingId){
                    postNUI('DeleteSavedClothing', {
                        id : this.deleteClothingId
                    })
                }
                  

            }else{
                // unpaid category için 
                for (let key in this.currentClothingItems){
                    const data = this.currentClothingItems[key]
                    if(data){
                        postNUI('deleteUnpaidOutfit', {
                            id : key,
                        })
                    }
                }
            }


           
        },
        changeSavedCategory(val){
            setTimeout(() => {  
                this.savedCatetory = val
                this.currentClothingItemsValue = false
                this.deleteClothingId = false
               
                    this.InitDrop()
                    this.InitDrag()
                    this.InitDropClothing()
                    this.InitDragClothing()
             
                for(let key in this.dropDownMenu){
                   this.dropDownMenu[key] = false
                }
            }, 150);
         
         
           
   
        },
        changeSkin(key, value){
         
            postNUI('changeSkin', {
                key,
                value,
            })
        },
        changeCategory(category,text){
            if(category){
                this.currentCategory = category
                this.currentClothingItemsValue = false
                
                this.headerText = text
                for(let key in this.currentClothingItems){
                    this.currentClothingItems[key] = false
                 }
                 this.wearNow = false
            }
        },
        thirsCategoryButton(){
            this.thirstCategoryValue = !this.thirstCategoryValue
        },
        buynow(val){
            this.buynowModal = val
        },

        uuidv4() {
            return new Date().getTime();
        },
        saveSkin(){
            postNUI('saveSkin', {
                saveClothing : this.crateClothingModal,
                clothingName : this.createClothingModalInput, 
            })
        },
        createCategory(val){
            if(val.length > 3 && val.length < 20 ){
            // this.playerCategory.push({id : this.uuidv4() , name : val, items : []})
            postNUI('CreateClothingCategory', {
                name : val,
            })
            setTimeout(() => {
                this.InitDrop()
                this.InitDrag()
                this.InitDropClothing()
                this.InitDragClothing()
            }, 100);
            }else{
                console.log('min 3 max 20 character')
            }
        },
        deleteCategory(id){
            postNUI('DeleteClothingCategory', {
                id
            })
        },
        createCategoryModel(val){
            this.createNewCategoryModal = val
            
        
        
        },
        SendShareRequest(id){
            // postNUI("SendShareRequest", {
            //     id,
            //     skin : this.currentClothingItemsValue.skin,
            //     skinName : this.currentClothingItemsValue.name,
            // })
        },
        handleMouseOver() {
            if (!this.isDragInitialized) {
                this.isDragInitialized = true;
                setTimeout(() => {

                    this.InitDrag();
                }, 10);
            }
        },
        handleMouseLeave() {
            if (this.isDragInitialized) {
                this.isDragInitialized = false;
            }
        },
        InitDrop() {
            for(let key in this.currentClothingItems){
                this.currentClothingItems[key] = false
            }
            this.wearNow = false
            $('.droppableContainer').droppable({
                
                  // berkay burası unnamdecategorideki itemi sürükleyip kategoriye bıraktığım yer
                drop: (event, ui) => {
               
                    let droppedItemId = $(ui.draggable).attr('data-id');
                    let droppableId = $(event.target).attr('data-id'); 
            
                                
                    let droppedItemIndex = this.unnamedClothing.findIndex(item => item.id === parseInt(droppedItemId)); 
                    let droppedItem = this.unnamedClothing[droppedItemIndex];
                    if(droppedItem){
                        let dropLocation = this.playerCategory.find(cat => cat.id === parseInt(droppableId));
                        
                        if(dropLocation){
                          
                            postNUI("ChangeClothingCategory", {
                                categoryId:droppableId,
                                clothingId:droppedItemId,
                            })
                        
                            
                        }
                    } else {
               
                    
                        let dropLocation = this.playerCategory.find(cat => cat.id === parseInt(droppableId));
                    
                        if(dropLocation){
                            let dropItem = false;
                      
                            postNUI("ChangeClothingCategory", {
                                categoryId:droppableId,
                                clothingId:droppedItemId,
                            })
                        }
                    }
                }
            });
        },

        handleMouseOverClothing() {
            if (!this.isDragInitializedClothing) {
                this.isDragInitializedClothing = true;
                setTimeout(() => {

                    this.InitDragClothing();
                }, 100);
            }
        },
        
        handleMouseLeaveClothing() {
            if (this.isDragInitializedClothing) {
                this.isDragInitializedClothing = false;
            }
        },
        InitDropClothing() {
              // berkay burası kategoriden çıkartıp unnamedclothinge bıraktığım yer
              for(let key in this.currentClothingItems){
                this.currentClothingItems[key] = false
            }
            this.wearNow = false
            $('.droppaleContainerUnClothing').droppable({
                drop: (event, ui) => {
                    let droppedItemId = parseInt($(ui.draggable).attr('data-id'));
                
                    postNUI("ChangeClothingCategory", {
                        categoryId:null,
                        clothingId:droppedItemId,
                    })
               
                }
            });
     
        },
        InitDrag() {

            if (!this.isDragInitialized) return;
            $('.dragPanel').draggable({
                helper: "clone",
                revertDuration: 0,
                revert: false,
                cancel: ".item-nodrag",
                containment: "body",
                scroll: false,
                start: function (event, ui) { },
                drag: function (event, ui) { },
                stop: (event, ui) => {
                    setTimeout(() => {
                        
                        this.InitDrop()
                    }, 100);
                }
            });
        },
        InitDragClothing() {

            if (!this.isDragInitializedClothing) return;
            $('.draggeableClothing').draggable({
                helper: "clone",
                revertDuration: 0,
                revert: false,
                cancel: ".item-nodrag",
                containment: "body",
                scroll: false,
                start: function (event, ui) { },
                drag: function (event, ui) { },
                stop: (event, ui) => {
                    
                    this.InitDropClothing()
                }
            });
        },
        LoadClothingValues(){
            for(let index in this.bincoClothing){
                let data = this.bincoClothing[index]
                data.typeValue = this.getSkinByName(data.name)
                data.variationsValue = this.getSkinByName(data.texture_name)
            }
            for(let index in this.summaryData){
                let data = this.summaryData[index]
                if(data.name == 'jacket'){                    
                    data.model = this.getSkinByName("torso_1")
                    data.texture = this.getSkinByName("torso_2")
                }else if(data.name == 'undershirt'){
                    data.model = this.getSkinByName("tshirt_1")
                    data.texture = this.getSkinByName("tshirt_2")
                }else if(data.name == 'handsarms'){
                    data.model = this.getSkinByName("arms")
                    data.texture =  this.getSkinByName("arms_2")
                }else if(data.name == 'legs'){
                    data.model = this.getSkinByName("pants_1")
                    data.texture = this.getSkinByName("pants_2")
                }else if(data.name == 'shoes'){
                    data.model = this.getSkinByName("shoes_1") 
                    data.texture = this.getSkinByName("shoes_2")
                }else if(data.name == 'mask'){
                    data.model = this.getSkinByName("mask_1")
                    data.texture = this.getSkinByName("mask_2")
                }else if(data.name == 'scarf'){                    
                    data.model = this.getSkinByName("chain_1")
                    data.texture = this.getSkinByName("chain_2")
                }else if(data.name == 'decals'){                                             
                    data.model = this.getSkinByName("decals_1")
                    data.texture = this.getSkinByName("decals_2")
                }else if(data.name == 'hat'){
                    data.model = this.getSkinByName("helmet_1")
                    data.texture = this.getSkinByName("helmet_2")
                }else if(data.name == 'glases'){
                    data.model = this.getSkinByName("glasses_1")
                    data.texture = this.getSkinByName("glasses_2")                    
                }else if(data.name == 'ear'){
                    data.model = this.getSkinByName("ears_1")
                    data.texture = this.getSkinByName("ears_2")
                }else if(data.name == 'watch'){
                    data.model = this.getSkinByName("watches_1") 
                    data.texture = this.getSkinByName("watches_2")
                }else if(data.name == 'bracelet'){
                    data.model = this.getSkinByName("bracelets_1")
                    data.texture = this.getSkinByName("bracelets_2")
                }else if (data.name == 'bag'){
                    data.model = this.getSkinByName("bproof_1")
                    data.texture = this.getSkinByName("bproof_2")
                }else if (data.name == 'armor'){
                    data.model = this.getSkinByName("bags_1")
                    data.texture = this.getSkinByName("bags_2")
                }
            }
        },
        AccepOutfitSharing(){
            // postNUI("AcceptOutfitSharing")
        },
        eventHandler(event){

            switch (event.data.action) {
                case "SET_CLOTHING_CATEGORIES":
                    this.playerCategory = event.data.payload
                    this.SyncCategory()
                    break
                case "SET_SAVED_CLOTHINGS":
                    this.unnamedClothing = event.data.payload
                    
                    this.SyncCategory()
                    break
                case "SET_UNPAID_OUTFITS":
                    this.unpaidOutfits = event.data.payload
                    break
                case "ON_SHARE_REQUEST":
                    this.shareOutfitData = event.data.payload
                    if(event.data.payload){
                        this.sharingModal = true
                    }else{
                        this.sharingModal = false
                    }
               
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
         
            setTimeout(() => {
                this.InitDrop()
                this.InitDrag()
                this.InitDropClothing()
                this.InitDragClothing()
         
            }, 500);
       
        },
    },

    computed: {
        ...Vuex.mapGetters({
            getSkinByName : 'getSkinByName'
        }),
        ...Vuex.mapState({
            skin : 'skin',
           
        }),
        getModelName(){
            let data = this.firstCategory.find((el) => el.name == this.currentCategory)
            let data_2 = this.secondCategory.find((el) => el.name == this.currentCategory)
            let data_3 = this.thirstCategory.find((el) => el.name == this.currentCategory)
            if(data){
                return data.model_name
            }
            if(data_2){
                return data_2.model_name

            }
            if(data_3){
                return data_3.model_name
            }

            
        },
        getTextureName(){
            let data = this.firstCategory.find((el) => el.name == this.currentCategory)
            let data_2 = this.secondCategory.find((el) => el.name == this.currentCategory)
            let data_3 = this.thirstCategory.find((el) => el.name == this.currentCategory)
            if(data){
                return data.texture_name
            }
            if(data_2){
                return data_2.texture_name
            }
            if(data_3){
                return data_3.texture_name
            }
        },
     
      
    },

    mounted() {
  
        this.InitDrop()
        this.InitDrag()
        this.LoadClothingValues()       
        window.addEventListener('message', this.eventHandler)
        

        this.firstCategory[0].headerText = this.$store.state.locales['fheaderText1']
        this.firstCategory[1].headerText = this.$store.state.locales['fheaderText2']
        this.firstCategory[2].headerText = this.$store.state.locales['fheaderText6']
        this.firstCategory[3].headerText = this.$store.state.locales['fheaderText7']
        this.firstCategory[4].headerText = this.$store.state.locales['fheaderText3']
        this.firstCategory[5].headerText = this.$store.state.locales['fheaderText4']
        this.firstCategory[6].headerText = this.$store.state.locales['fheaderText5']
        
        this.secondCategory[0].headerText = this.$store.state.locales['sheaderText1']
        this.secondCategory[1].headerText = this.$store.state.locales['sheaderText2']
        this.secondCategory[2].headerText = this.$store.state.locales['sheaderText3']
        this.secondCategory[3].headerText = this.$store.state.locales['sheaderText4']

        this.thirstCategory[0].headerText = this.$store.state.locales['theaderText1']
        this.thirstCategory[1].headerText = this.$store.state.locales['theaderText2']
        this.thirstCategory[2].headerText = this.$store.state.locales['theaderText3']
        this.thirstCategory[3].headerText = this.$store.state.locales['theaderText4']

        this.summaryData[0].label = this.$store.state.locales['fheaderText1']
        this.summaryData[1].label = this.$store.state.locales['fheaderText2']
        this.summaryData[2].label = this.$store.state.locales['fheaderText3']
        this.summaryData[3].label = this.$store.state.locales['fheaderText4']
        this.summaryData[4].label = this.$store.state.locales['fheaderText5']
        this.summaryData[5].label = this.$store.state.locales['sheaderText1']
        this.summaryData[6].label = this.$store.state.locales['sheaderText2']
        this.summaryData[7].label = this.$store.state.locales['sheaderText3']
        this.summaryData[8].label = this.$store.state.locales['sheaderText4']
        this.summaryData[9].label = this.$store.state.locales['theaderText1']
        this.summaryData[10].label = this.$store.state.locales['theaderText2']
        this.summaryData[11].label = this.$store.state.locales['theaderText3']
        this.summaryData[12].label = this.$store.state.locales['theaderText4']
        this.summaryData[13].label = this.$store.state.locales['fheaderText6']
        this.summaryData[14].label = this.$store.state.locales['fheaderText7']
    },
    beforeDestroy(){
        window.removeEventListener('message', this.eventHandler)
    },
    watch:{
        skin(val){
            this.LoadClothingValues()        
        },
        async currentClothingItemsValue(val){
            if(val){
                const data = await postNUI("getNearbyPlayers")
                this.nearbyPlayers = data
            }
        },
    },
}




