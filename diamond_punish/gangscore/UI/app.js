
var app = new Vue({
    el: '#app',
    data: {
        playerData: [],
        jobData : [],
        gangData : []
    },
    methods: {
        getBoxShadow : function(job){
            return {
                'box-shadow' : '0px 0px 2px 2px ' + job.color,
                'border' : 'solid 0.2px ' + job.color
            }
        }
    },
    computed : {

    }
})

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function (event) {
            if (event.data.type == "enable") {
                $('body').fadeIn(350);
                app.playerData = event.data.playerData;
                app.jobData = event.data.jobData;
                app.gangData = event.data.gangData
            }
            if (event.data.type == "disable") {
                $('body').fadeOut(350);
            }
        })
    }
}