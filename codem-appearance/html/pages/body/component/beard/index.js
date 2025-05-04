import importTemplate from  '../../../../js/util/importTemplate.js' 


export default {
    template: await importTemplate('./pages/body/component/beard/index.html'),
    components: {
        
    },
    data: () => ({
       
    }),
    methods: {
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
    },
}
