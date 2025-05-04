import importTemplate from '../../js/util/importTemplate.js';


export default {
    template: await importTemplate('pages/dna/index.html'),
    components: {
    },

    data: () => ({
        dnapage : false,
        familyCategory : 'father',
        familyCategorySkin : 'father',
        familyTable : {
            father : [
                {name : 'CharacterCreator-GTAO-Parent-Male-Benjamin',   index: 0},
                {name : 'CharacterCreator-GTAO-Parent-Male-Daniel',     index: 1},
                {name : 'CharacterCreator-GTAO-Parent-Male-Joshua',     index: 2},
                {name : 'CharacterCreator-GTAO-Parent-Male-Noah',       index: 3},
                {name : 'CharacterCreator-GTAO-Parent-Male-Andrew',     index: 4},
                {name : 'CharacterCreator-GTAO-Parent-Male-Juan',       index: 5},
                {name : 'CharacterCreator-GTAO-Parent-Male-Alex',       index: 6},
                {name : 'CharacterCreator-GTAO-Parent-Male-Isaac',      index: 7},
                {name : 'CharacterCreator-GTAO-Parent-Male-Evan',       index: 8},
                {name : 'CharacterCreator-GTAO-Parent-Male-Ethan',      index: 9},
                {name : 'CharacterCreator-GTAO-Parent-Male-Vincent',    index: 10},
                {name : 'CharacterCreator-GTAO-Parent-Male-Angel',      index: 11},
                {name : 'CharacterCreator-GTAO-Parent-Male-Diego',      index: 12},
                {name : 'CharacterCreator-GTAO-Parent-Male-Adrian',     index: 13},
                {name : 'CharacterCreator-GTAO-Parent-Male-Gabriel',    index: 14},
                {name : 'CharacterCreator-GTAO-Parent-Male-Michael',    index: 15},
                {name : 'CharacterCreator-GTAO-Parent-Male-Santiago',   index: 16},
                {name : 'CharacterCreator-GTAO-Parent-Male-Kevin',      index: 17},
                {name : 'CharacterCreator-GTAO-Parent-Male-Louis',      index: 18},
                {name : 'CharacterCreator-GTAO-Parent-Male-Samuel',     index: 19},
                {name : 'CharacterCreator-GTAO-Parent-Male-Anthony',    index: 20},
                {name : 'CharacterCreator-GTAO-Parent-Male-Claude',     index: 42},
                {name : 'CharacterCreator-GTAO-Parent-Male-Niko',       index: 43},
                {name : 'CharacterCreator-GTAO-Parent-Male-John',       index: 44}
            ],
            mother : [
                {name : 'CharacterCreator-GTAO-Parent-Female-Hannah',   index: 21},
                {name : 'CharacterCreator-GTAO-Parent-Female-Audrey',   index: 22},
                {name : 'CharacterCreator-GTAO-Parent-Female-Jasmine',  index: 23},
                {name : 'CharacterCreator-GTAO-Parent-Female-Giselle',  index: 24},
                {name : 'CharacterCreator-GTAO-Parent-Female-Amelia',   index: 25},
                {name : 'CharacterCreator-GTAO-Parent-Female-Isabella', index: 26},
                {name : 'CharacterCreator-GTAO-Parent-Female-Ava',      index: 27},
                {name : 'CharacterCreator-GTAO-Parent-Female-Zoe',      index: 28},
                {name : 'CharacterCreator-GTAO-Parent-Female-Camila',   index: 29},
                {name : 'CharacterCreator-GTAO-Parent-Female-Violet',   index: 30},
                {name : 'CharacterCreator-GTAO-Parent-Female-Sophia',   index: 31},
                {name : 'CharacterCreator-GTAO-Parent-Female-Evelyn',   index: 32},
                {name : 'CharacterCreator-GTAO-Parent-Female-Nicole',   index: 33},
                {name : 'CharacterCreator-GTAO-Parent-Female-Ashley',   index: 34},
                {name : 'CharacterCreator-GTAO-Parent-Female-Grace',    index: 35},
                {name : 'CharacterCreator-GTAO-Parent-Female-Brianna',  index: 36},
                {name : 'CharacterCreator-GTAO-Parent-Female-Natalie',  index: 37},
                {name : 'CharacterCreator-GTAO-Parent-Female-Olivia',   index: 38},
                {name : 'CharacterCreator-GTAO-Parent-Female-Elizabeth',index: 39},
                {name : 'CharacterCreator-GTAO-Parent-Female-Charlotte',index: 40},
                {name : 'CharacterCreator-GTAO-Parent-Female-Emma',     index: 41},
                {name : 'CharacterCreator-GTAO-Parent-Female-Misty',    index: 45},
             
            ]
      
        },
        selectFamily : [],
        selectFamilySkin : []

    }),
    methods: {
    
        
        changeFamilyCategory(category){
            this.familyCategory = category
        },

        changeFamilyCategorySkin(category){
            this.familyCategorySkin = category
        },
    
        selectMyFamily(name, index){
            
            for(let key in this.selectFamily){
                this.selectFamily[key] = false
            }

            this.selectFamily[name] = !this.selectFamily[name] 
            let key = 'mom'
            if(this.familyCategory == 'father'){
                key = 'dad'
            }
            postNUI('changeSkin', {
                key,
                value : index,
            })
            
        },

        selectMyFamilySkin(name, index){
            
            for(let key in this.selectFamilySkin){
                this.selectFamilySkin[key] = false
            }

            this.selectFamilySkin[name] = !this.selectFamilySkin[name] 
            let key = 'skin_mom'
            if(this.familyCategorySkin == 'father'){
                key = 'skin_dad'
            }
            
            postNUI('changeSkin', {
                key,
                value : index,
            })
            
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
        ...Vuex.mapState({
            skin : state => state.skin
        }),
        ...Vuex.mapGetters({
            getSkinByName : 'getSkinByName'
        }),
    },
    watch:{
   
    },
    mounted() {
        
        this.dnapage = this.$store.state.activePage === 'dnapage' ? true : false
        const mom = this.getSkinByName("mom")
        const dad = this.getSkinByName("dad")
  

        for(let key in this.selectFamily){
            this.selectFamily[key] = false
        }
        
        for(let index in this.familyTable.father){
            const data = this.familyTable.father[index]
            if(data.index == dad){
                this.selectFamily[data.name] = true
            }
        }

        for(let index in this.familyTable.mother){
            const data = this.familyTable.mother[index]
            if(data.index == mom){
         

                this.selectFamily[data.name] = true
            }
        }
    }
}