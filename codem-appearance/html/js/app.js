import dnaModule from './modules/dna.js';
import pedModule from './modules/ped.js';
import clothesModule from './modules/clothes.js';
import bodyModule from './modules/body.js';
import bincoModule from './modules/binco.js';
import ponsonbysModule from './modules/ponsonbys.js';
import suburbanModule from './modules/suburban.js';
import tottoModule from './modules/totto.js';
import barberModule from './modules/barber.js';
import wardrobeModule from './modules/wardrobe.js';
import jobModule from './modules/job.js';




const Modules = {
    dnapage: dnaModule,
    pedpage: pedModule,
    clothespage: clothesModule,
    bodypage: bodyModule,
    bincopage: bincoModule,
    ponsonbyspage: ponsonbysModule,
    suburbanpage: suburbanModule,
    tottopage: tottoModule,
    barberpage: barberModule,
    wardrobepage: wardrobeModule,
    jobpage: jobModule,


}



import dnapage from '../pages/dna/index.js';
import pedpage from '../pages/ped/index.js';
import clothespage from '../pages/clothes/index.js';
import bodypage from '../pages/body/index.js';
import bincopage from '../pages/binco/index.js';
import ponsonbyspage from '../pages/ponsonbys/index.js';
import tottopage from '../pages/totto/index.js';
import barberpage from '../pages/barber/index.js';
import wardrobepage from '../pages/wardrobe/index.js';
import jobpage from '../pages/job/index.js';
import suburbanpage from '../pages/suburban/index.js';


const store = Vuex.createStore({
    components: {
        'dnapage': dnapage,
        'pedpage': pedpage,
        'clothespage': clothespage,
        'bodypage': bodypage,
        'bincopage': bincopage,
        'ponsonbyspage': ponsonbyspage,
        'tottopage': tottopage,
        'barberpage': barberpage,
        'wardrobepage': wardrobepage,
        'jobpage': jobpage,
        'suburbanpage': suburbanpage,
    },
    state: {
        fullyLoaded : false,
        activePage: '',
        skin: [],
        pp: '',
        playerName: '',
        serverId: 0,
        outfitPrice: 0,
        isSurgery: false,
        surgeryPrice: 0,
        selectedMoneyType : 'bank',
        playerJob: {
            job_label: '',
            job_grade_label: '',
        },
        playerMoney: {
            cash: 0,
            bank: 0,
        },
        locales: '',
        defaultPP: '',
        notifications: [],
        timeout: false,

    },
    getters: {
        getSkinByName(state) {
            return (payload) => {
                const data = state.skin.find((data) => data.name == payload)
                let value = false
                if (data) {
                    value = data.value
                }

                return value
            }
        },
    },
    mutations: {
        setServerId(state, payload) {
            state.serverId = payload
        },
        setOutfitPrice(state, payload) {
            state.outfitPrice = payload
        },
        setPlayerMoney(state, payload) {
            state.playerMoney[payload.type] = payload.amount
        },
        setPlayerJob(state, payload) {
            state.playerJob = payload
        },
        setPlayerName(state, payload) {
            state.playerName = payload
        },
        setActivePage(state, page) {
            state.activePage = page
        },
        setSkin(state, payload) {
            state.skin = payload
        },
        setCharAcceptModal(state, payload) {
            state.charAcceptModal = payload
        }
    },
    actions: {
        notification({ state }, text) {
            const timeout = 3000;
            let id = Date.now();
            // if (state.notifications.length > 0) {
            //     if (state.timeout) {
            //         clearTimeout(state.timeout)
            //         state.timeout = false
            //     }
            //    state.notifications = []
            // }
            state.notifications.push({
                id: id,
                text: text,
                timeout: timeout,
            });
            state.timeout = setTimeout(() => {
                state.notifications = state.notifications.filter(notification => notification.id != id);
            }, timeout);
        }
    },

    modules: Modules
});

const app = Vue.createApp({
    components: {
        'dnapage': dnapage,
        'pedpage': pedpage,
        'clothespage': clothespage,
        'bodypage': bodypage,
        'bincopage': bincopage,
        'ponsonbyspage': ponsonbyspage,
        'tottopage': tottopage,
        'barberpage': barberpage,
        'wardrobepage': wardrobepage,
        'jobpage': jobpage,
        'suburbanpage': suburbanpage,
    },
    data: () => ({
        pageToOpen: false, 
        currentApparenceCategory: false,
        selectedCamera: false,



    }),
    computed: {

        ...Vuex.mapState({
            activePage: state => state.activePage,
            skin: state => state.skin,
            notifications: state => state.notifications,
        })
    },

    watch: {

    },

    beforeDestroy() {
        window.removeEventListener('keyup', this.updateNavbarActive);

    },
    mounted() {
        document.querySelector('#app').style.display = 'block'
        this.setupHeading()
        this.currentApparenceCategory = false
        window.addEventListener('keyup', this.keyHandler);
        window.addEventListener('message', (event) => {
            switch (event.data.action) {
                case "OPEN_MENU":
                    this.selectedCamera = false
                    if (event.data.payload == 'charcreator') {
                        this.pageToOpen = 'createCharacter'
                        this.$store.state.activePage = 'dnapage'
                        this.currentApparenceCategory = 'dnapage'
                        this.$store.state.isSurgery = false
                    } if (event.data.payload == 'surgery') {
                        this.pageToOpen = 'surgery'
                        this.$store.state.activePage = 'dnapage'
                        this.currentApparenceCategory = 'dnapage'
                        this.$store.state.isSurgery = true
                    } else if (event.data.payload == 'barber') {
                        this.pageToOpen = 'barber'
                    } else if (event.data.payload == 'tattoo') {
                        this.pageToOpen = 'totto'
                    } else if (event.data.payload == 'binco') {
                        this.pageToOpen = 'bincoClothing'
                    } else if (event.data.payload == 'ponsonbys') {
                        this.pageToOpen = 'ponsonbysClothing'
                    } else if (event.data.payload == 'suburban') {
                        this.pageToOpen = 'suburbanClothing'
                    } else if (event.data.payload == 'job') {
                        this.pageToOpen = 'job'
                    } else if (event.data.payload == 'wardrobe') {
                        this.pageToOpen = "wardrobe"
                    }

                    break;
                case "SET_SKIN":
                    this.setSkin(event.data.payload)
                    break
                case "CHECK_NUI":
                    postNUI('loaded')
                    break;
                case "CLOSE_PAGE":
                    this.pageToOpen = false
                    this.$store.state.activePage = false
                    this.currentApparenceCategory = false
                    postNUI('close')
                    this.selectedCamera = false
                    break;
                case "SET_DEFAULT_IMAGE":
                    this.$store.state.defaultPP = event.data.payload
                    break
                case "SET_PLAYER_NAME":
                    this.setPlayerName(event.data.payload)
                    break
                case "SET_PLAYER_PP":
                    if (event.data.payload) {
                        this.$store.state.pp = event.data.payload
                    }else {
                        this.$store.state.pp = this.$store.state.defaultPP
                    }
                    break
                case "SET_SERVER_ID":
                    this.setServerId(event.data.paylaod)
                    break
                case "LOAD_PLAYER_JOB":
                    this.setPlayerJob(event.data.payload)
                    break
                case "LOAD_PLAYER_MONEY":
                    this.setPlayerMoney(event.data.payload)
                    break
                case "SELECTED_MONEY_TYPE":
                    this.$store.state.selectedMoneyType = event.data.payload
                    break
                case "SET_OUTFIT_PRICE":
                    this.setOutfitPrice(event.data.payload)
                    break
                case "SET_SURGERY_PRICE":

                    this.$store.state.surgeryPrice = event.data.payload

                    break
                case "SET_LOCALES":
                    this.$store.state.locales = event.data.payload;
                    if (event.data.payload) {
                        postNUI('complateLocales')
                    }
                    break
                case "SET_NOTIFICATION":
                    this.$store.dispatch('notification', event.data.payload);
                    break

                    case "SET_PED_PAGE":
                        this.$store.state.pedpage.pedPageBlock = event.data.payload
                     
                        
                    break
                default:
                    break;
            }

        });
        // setTimeout(() => {
        //     this.$store.dispatch('notification', 'test mesaj');
        // }, 2000);


        //  this.pageToOpen = 'bincoClothing'
    },


    methods: {

        ...Vuex.mapMutations({
            setSkin: 'setSkin',
            setPlayerName: 'setPlayerName',
            setServerId: 'setServerId',
            setPlayerJob: 'setPlayerJob',
            setPlayerMoney: 'setPlayerMoney',
            setOutfitPrice: 'setOutfitPrice',
        }),
        randomize() {
            postNUI("randomize")
        },
        async ChangeCamera(val) {
            const old = this.selectedCamera

            if(this.selectedCamera == val){
                this.selectedCamera = false
            }else{
                this.selectedCamera = val
            }

            const data = await postNUI("changeCamera", {
                value : this.selectedCamera,
            })

            if(!data){
                this.selectedCamera = old
            }
        },
        setupHeading() {
            let holding = false;
            let oldx = 0;
            let ticking = false;
        
            document.addEventListener('mousedown', function (e) {
                holding = true;
            });
        
            document.addEventListener('mouseup', function (e) {
                holding = false;
            });
        
            const mousemovemethod = (e) => {
                if (!ticking && holding) {
                    window.requestAnimationFrame(() => {
                        const direction = e.pageX < oldx ? "left" : "right";
                        oldx = e.pageX;
        
                        if (e.target.classList.contains("mouse-move")) {
                            if (direction == "left") {
                                postNUI("rotateleft");
                            } else if (direction == "right") {
                                postNUI("rotateright");
                            }
                        }
        
                        ticking = false;
                    });
        
                    ticking = true;
                }
            };
        
            document.addEventListener('mousemove', mousemovemethod);
        },
        
        keyHandler(e) {
            if (e.which == 27) {
                if (this.pageToOpen == 'createCharacter') return false;
                postNUI('close')
                this.pageToOpen = ''
            }
        },
        changeAppearancePage(val) {
            if (val) {
                this.currentApparenceCategory = val

                // -- change active page
                this.$store.state.activePage = val
                this.$store.state.charAcceptModal = false
            }
        },
        closeCharModal() {
            this.$store.state.charAcceptModal = false
        },
        createCharacterModal() {
            postNUI("saveSkin")
        }





    },

});

app.use(store).mount('#app');
var resourceName = 'codem-appearance'

if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName()
}

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: 'POST',
            mode: 'cors',
            cache: 'no-cache',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/json'
            },
            redirect: 'follow',
            referrerPolicy: 'no-referrer',
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
        // console.log(error)
    }
}

