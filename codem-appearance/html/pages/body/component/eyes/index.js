import importTemplate from  '../../../../js/util/importTemplate.js' 


export default {
    template: await importTemplate('./pages/body/component/eyes/index.html'),
    components: {
        
    },
    data: () => ({
        noseData : [
           
            {
                name : 'eye_squint',
                label : 'Eye Opening',
                value : 0,
            },
            {
                name : 'lip_thickness',
                label : 'Lip Thickness',
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
