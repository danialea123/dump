import importTemplate from  '../../../../js/util/importTemplate.js' 


export default {
    template: await importTemplate('./pages/body/component/cheeks/index.html'),
    components: {
        
    },
    data: () => ({
        noseData : [
            {
                name : 'cheeks_1',
                label : 'Cheeks Bone Height',
                value : 0,
            },
            {
                name : 'cheeks_2',
                label : 'Cheeks Bone Width',
                value : 0,
            },
            {
                name : 'cheeks_3',
                label : 'Cheeks Size',
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
