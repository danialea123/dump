import importTemplate from  '../../../../js/util/importTemplate.js' 


export default {
    template: await importTemplate('./pages/body/component/nose/index.html'),
    components: {
        
    },
    data: () => ({
        noseData : [
            {
                name : 'nose_1',
                label : 'Nose Width',
                value : 0,
            },
            {
                name : 'nose_2',
                label : 'Nose Height',
                value : 0,
            },
            {
                name : 'nose_3',
                label : 'Nose Size',
                value : 0,
            },
            {
                name : 'nose_4',
                label : 'Nose Bone Height',
                value : 0,
            },
            {
                name : 'nose_5',
                label : 'Nose Peak Height',
                value : 0,
            },
            {
                name : 'nose_6',
                label : 'Nose Bone Twist',
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
