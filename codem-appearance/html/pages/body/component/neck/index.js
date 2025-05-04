import importTemplate from  '../../../../js/util/importTemplate.js' 


export default {
    template: await importTemplate('./pages/body/component/neck/index.html'),
    components: {
        
    },
    data: () => ({
        neckData : [
            {
                name : 'neck_thickness',
                label : 'Neck Thickness',
                value : 0,
            },
        ]
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
