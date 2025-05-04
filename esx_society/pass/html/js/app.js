const app = new Vue({
    el : '#app',
    data : {
        show : false,
        showLevelUp: false,
        time : null,
        currentLevel : 2,
        currentXp : BigInt(9007199254740991),
        pedaret : 0,
        rewards : [],
        nextReward : null,
        currentReward : null,
        season : 1,
        takenRewards : 1,
        maximumItems : 0,
        itensSwiper : null,
        itemToClaim : null
    },
    methods: {
        ToggleUI(toggle){
            this.show = toggle;
            if (toggle) {
                setTimeout(() => {
                    this.itensSwiper = new Swiper('#itensSwiper', {
                        slidesPerView: 6,
                        spaceBetween: 20,
                        centeredSlides: true,
                        slideToClickedSlide: true,
                        pagination: {
                            el: ".swiper-pagination",
                            clickable: true,
                        },
                        navigation: {
                            nextEl: ".swiper-button-next",
                            prevEl: ".swiper-button-prev",
                        },
                        on: { slideChange: this.UpdateItemToClaim }
                    });
                    this.itensSwiper.slideTo(this.takenRewards, 500);
                    this.UpdateItemToClaim();
                }, 100);
            } else {
                this.itensSwiper = null;
            }
        },
        UpdateItemToClaim() {
            if (!this.show || this.itensSwiper == null) return;
            let reward = this.rewards[this.itensSwiper.activeIndex];
            if (reward.level >= this.currentLevel) {
                this.itemToClaim = null;
                return;
            }
            if (reward.canClaimItem) {
                this.itemToClaim = this.itensSwiper.activeIndex;
            } else {
                this.itemToClaim = -1;
            }
        },
        SetTakenRewards(amount) {
            this.takenRewards = amount;
        },
        SetSeason(season) {
            this.season = season
        },
        SetCurrentXp(xp, last) {
            this.currentXp = BigInt(xp);
            this.pedaret = last
            this.UpdateItemToClaim();
        },
        SetCurrentLevel(level) {
            this.currentLevel = level;
            this.UpdateItemToClaim();
        },
        SetRewards(rewards) {
            this.rewards = rewards;
            this.maximumItems = rewards.length;
        },
        SetRemainingTime(remainTime) {
            this.time = remainTime
        },
        CloseUI(){
            $.post('https://esx_society/Close');
        },
        ClaimReward() {
            if (this.itemToClaim == null || this.itemToClaim == -1) return;
            let reward = this.rewards[this.itemToClaim];
            if (!reward) return;
            this.itemToClaim = -1;
            reward.canClaimItem = false;
            $.post('https://esx_society/ClaimReward', JSON.stringify(reward.level));
        },
        ToggleLevelUp(item) {
            this.showLevelUp = true;
            this.nextReward = item.nextReward;
            this.currentReward = item.currentReward;
        
            setTimeout(() => {
                this.showLevelUp = false;
            }, 3500);
        }
    },
    computed: {
        GetWidth(){
            return this.pedaret + '%';
        },
        IsPlayerInMaxLevel() {
            return this.currentLevel == this.rewards.length + 1;
        }
    },
    mounted(){ },
})
window.addEventListener('message', (e) => {
    const item = e.data
    switch (item.type) {
        case "TOGGLE_UI":
            app.ToggleUI(item.toggle)
            $('body').show()
            break
        case "SET_SEASON":
            app.SetSeason(item.season)
            break
        case "TOGGLE_LEVELUP":
            app.SetCurrentLevel(item.newLevel)
            app.ToggleLevelUp(item)
            break
        case "SET_TIME":
            app.SetRemainingTime(item.date)
            break
        case "SET_REWARDS":
            app.SetRewards(item.rewards)
            break
        case "SET_CURRENT_XP":
            app.SetCurrentXp(item.xp, item.last)
            break
        case "SET_TAKEN_REWARDS":
            app.SetTakenRewards(item.amount)
            break
        case "SET_CURRENT_LEVEL":
            app.SetCurrentLevel(item.level)
            break
        default:
            break
    }
})

window.ResourceName = 'esx_society'
$(document).ready(function(){
    $('body').show()
    $.post('https://'+ResourceName+'/NUIReady', JSON.stringify({}));
});