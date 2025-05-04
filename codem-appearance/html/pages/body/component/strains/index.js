import importTemplate from  '../../../../js/util/importTemplate.js' 


export default {
    template: await importTemplate('./pages/body/component/strains/index.html'),
    components: {
        
    },
    data: () => ({
        noseData : [
            {
                name : 'noseWidth',
                label : 'Nose Width',
                value : 0,
            },
            {
                name : 'noseHeight',
                label : 'Nose Height',
                value : 0,
            },
            {
                name : 'noseSize',
                label : 'Nose Size',
                value : 0,
            },
            {
                name : 'noseBoneHeight',
                label : 'Nose Bone Height',
                value : 0,
            },
            {
                name : 'nosePeakHeight',
                label : 'Nose Peak Height',
                value : 0,
            },
            {
                name : 'noseBoneTwist',
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
