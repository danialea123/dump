var progressBarHud
var generalspeed = 0
var resourceNames 

window.addEventListener("message", function (event) {
    var item = event.data;
    switch (item.type) {
        case "startTrade":
            app.getTrade(item.targetId,item.myId,item.tradeData,item.inventory,item.tradeId)
        break
        case "offerAccept":
            app.offerAcceptStatus()
        break;
        case "closePage":
            app.closePage()
        break;
        case "updateOtherInventory":
            app.otherItem(item.items)
        break;
        case "SetLanguages":
            app.SetLanguage(item.value)
        break;
        case "send_response":
            app.GetResponse(item.resourceName)
        break;
        default:

        break;
    }
});
var myInventoryItemUI = [], myInventoryItemClient = [];
var itemAmount = 0;
var tradeID = 0;
var playerAcceptButton2 = false
var offerAcceptButton2 = false



const app = new Vue({
    el: "#app",

    data: {
        show: false,
        playersTradeHeaderMenu : [],
        playeritemAmount : "",
        playerAcceptButton : false,
        offerAcceptButton : false,
        otherInventory : [],
        Language  : '',
        resourceName : '',

     
    },
    watch: {
        playeritemAmount: function (newVal, oldVal) {
            this.onItemAmountChange(newVal, oldVal);
        }
    },

    computed: {
        myInventoryItem(val){
         
            return val => {
       
                if (val) {
                    $(".playerInvSlot").remove();
                    for (let index = 0; index < 50; index++) {
                        let v = val[index] || {};
                        if(v.count >0){
                            let image = v.name ? "http://test.diamondrp.ir/imgs/" + v.name + ".png" : '';
                            
                            const content = `
                            <div data-itemdata='${JSON.stringify({
                                itemname: v.name || '',
                                itemcount: v.count || 0,
                                itemlabel: v.label || '',
                                currentContainer: "inventory",
                                info  : v.info || {}
                            })}' class="w-[19.5%]  h-[27%] mt-1 ml-0.5 playerInvSlot" style="border-radius: 0.5vw; cursor: pointer; background-color: rgba(217, 217, 217, 0.25);">
                                <div class="w-full h-[20%] flex items-center justify-end">
                                    ${v.count ? '<h2 class="mr-2 text-white" style="font-size:0.6vw;">' + v.count + 'x</h2>' : ''}
                                </div>
                                <div class="w-full h-[60%] relative flex items-center justify-center" >
                                    ${image ? '<img class="w-[80%] h-[80%]" style="object-fit: contain;" style="z-index:10" src="' + image + '" alt="">' : ''}
                                </div>
                                <div class="w-full h-[20%] flex items-center justify-center" style="background: rgba(0, 0, 0, 0.65); border-bottom-left-radius: 0.5vw;border-bottom-right-radius: 0.5vw;">
                                    ${v.label ? '<h2 class="text-white textItemName mt-0.5 " style="font-family: Proxima Nova; font-size:0.7vw;">' + v.label + '</h2>' : ''}
                                </div>
                            </div>
                            `;
                    
                            $(".myInventoryAppend").append(content);
                            handleDragDrop();
                        }else{
          
                            const content = `
                            <div class="w-[19.5%]  h-[27%] mt-1 ml-0.5 playerInvSlot" style="border-radius: 0.5vw; cursor: pointer; background-color: rgba(217, 217, 217, 0.25);">
                                <div class="w-full h-[20%] flex items-center justify-end">
                                    <h2 class="mr-2 text-white" style="font-size:0.6vw;"></h2>'
                                </div>
                                <div class="w-full h-[60%] relative flex items-center justify-center" >
                              
                                </div>
                                <div class="w-full h-[20%] flex items-center justify-center" style="background: rgba(0, 0, 0, 0.65); border-bottom-left-radius: 0.5vw;border-bottom-right-radius: 0.5vw;">
                                  <h2 class="text-white textItemName mt-0.5 " style="font-family: Proxima Nova; font-size:0.7vw;"></h2>
                                </div>
                            </div>
                            `;
                    
                            $(".myInventoryAppend").append(content);
                            handleDragDrop();
                        }
                      
                    }
                }
            };
            
        },
    
        myOffersItem(val) {
            return val => {
                if (val) {
                    $(".offersItemSlot").remove();
                    $.each(val, function (k, v) {
                        if(v.itemcount > 0){
                            let image =  v.itemname ? "http://test.diamondrp.ir/imgs/" +  v.itemname + ".png" : '';
                            const content = `
                            <div data-itemdata='${JSON.stringify({
                                itemname:   v.itemname  || '',
                                itemcount:  v.itemcount || 0,
                                itemlabel:  v.itemlabel || '',
                                currentContainer: "other",
                                info  : v.info || {}
                            })}' class="w-[19.5%] h-[85%]  mt-1 ml-0.5 offersItemSlot" style="border-radius: 0.5vw; cursor: pointer; background: rgba(217, 217, 217, 0.25);">
                                <div class="w-full h-[20%] flex items-center justify-end">
                               
                                    ${v.itemcount ? '<h2 class="mr-2 text-white" style="font-size:0.6vw;">' + v.itemcount + 'x</h2>' : ''}
                                </div>
                                <div class="w-full h-[60%] flex items-center justify-center">
                                    ${image ? '<img class="w-[80%] h-[80%]" style="object-fit: contain; " src="' + image + '" alt="">' : ''}
                                </div>
                                <div class="w-full h-[20%] flex items-center justify-center" style="background: rgba(0, 0, 0, 0.65);border-bottom-left-radius: 0.5vw;border-bottom-right-radius: 0.5vw; ">
               
                                    ${v.itemlabel ? '<h2 class="text-white mt-0.5 textItemName " style="font-family: Proxima Nova; font-size:0.7vw;">' + v.itemlabel + '</h2>' : ''}
                                </div>
                            </div>
                            `;
                    
                            $(".playerHeaderInventory").append(content);
                            handleDragDrop();
                        }
                      

                    });
                    
                }
            };
        },
        otherItems(val) {
            return val => {
                
                    $(".otherSlot").remove();
                    if(val){
                        for (let index = 0; index < 50; index++) {
                            let v = val[index] || {};
                                
                                let image = v.itemname ? "http://test.diamondrp.ir/imgs/" + v.itemname + ".png" : '';
                                let backgroundColor = v.itemname ? "rgba(217, 217, 217, 0.25)" : "rgba(0, 0, 0, 0.25)";
                                let color = v.itemname ? "rgba(0, 0, 0, 0.65)" : "transparent";
                                const content = `
                                    <div  class="w-[19.5%]  h-[20%] mt-1 ml-0.5 otherSlot" style="border-radius: 0.5vw; cursor: pointer; background: ${backgroundColor};">
                                    <div class="w-full h-[20%] flex items-center justify-end">
                                        ${v.count ? '<h2 class="mr-2 text-white" style="font-size:0.6vw;">' + v.count + 'x</h2>' : ''}
                                    </div>
                                    <div class="w-full h-[60%] relative flex items-center justify-center" >
                                        ${image ? '<img class="w-[80%] h-[80%]" style="object-fit: contain;" style="z-index:10" src="' + image + '" alt="">' : ''}
                                    </div>
                                    <div class="w-full h-[20%] flex items-center justify-center" style="background: ${color}; border-bottom-left-radius: 0.5vw;border-bottom-right-radius: 0.5vw;">
                                        ${v.itemlabel ? '<h2 class="text-white textItemName mt-0.5 " style="font-family: Proxima Nova; font-size:0.7vw;">' + v.itemlabel + '</h2>' : ''}
                                    </div>
                                </div>
                                `;
                        
                                $(".otherInventory").append(content);
                                handleDragDrop();
                           
                          
                        }
                    }else{
                        for (let index = 0; index < 50; index++) {
                            
                            const content = `
                            <div class="w-[19.5%]  h-[20%] mt-1 ml-0.5 otherSlot" style="border-radius: 0.5vw; cursor: pointer; background: rgba(0, 0, 0, 0.25);">
                               
                            </div>
                            `;
                    
                            $(".otherInventory").append(content);
                            handleDragDrop();
                        }
                    }
                  

                    
                
            };
        },
       
    },
  

    methods: {
        GetResponse(val){
            this.resourceName = val
            resourceNames = val
            $.post(`https://${this.resourceName}/GetResponse`, JSON.stringify({
             
            }));
        },
        SetLanguage(val){
            this.Language = val
        },
        otherItem(val){
           
           this.otherItems(val);
        },
        closePage(){
            this.show = false;
            this.playerAcceptButton = false;
            this.offerAcceptButton = false;
            offerAcceptButton2 = false;
            playerAcceptButton2 = false;
            myInventoryItemUI = [];
            myInventoryItemClient = [];
            itemAmount = 0;
            tradeID = 0;
            this.playersTradeHeaderMenu = [];
            this.playeritemAmount = 0;
            this.myOffersItem(myInventoryItemClient);
            this.myInventoryItem(myInventoryItemUI);
        },
        offerAcceptStatus(){
            this.offerAcceptButton = !this.offerAcceptButton
         
            offerAcceptButton2 = !offerAcceptButton2
        },
        declineTrade(){
            $.post(`https://${this.resourceName}/declineTrade`, JSON.stringify({
                tradeID : tradeID,
            }));
        },
        
        refreshItemCount(){
            itemAmount = 0;
            this.playeritemAmount = 0;
        },
        onItemAmountChange(newVal, oldVal) {
            itemAmount = newVal;
        },
        acceptTrade(){
            this.playerAcceptButton = !this.playerAcceptButton
            playerAcceptButton2 = !playerAcceptButton2
          
            $.post(`https://${this.resourceName}/acceptTrade`, JSON.stringify({
                tradeID : tradeID,
                accept : this.playerAcceptButton
            }));
        },
        getTrade(targetId,myId,tradeData,inventory,tradeid){
            myInventoryItemUI = [];
            myInventoryItemClient = [];
            this.myOffersItem([]);
            this.myInventoryItem([]);
            let myData = null;
            let targetData = null;
            for (const key in tradeData) {
                if (tradeData[key].id === myId) {
                        myData = tradeData[key];
                }else{
                    targetData = tradeData[key];
                }
            }
            console.log(targetData)
            if(!myData || !targetData) {
                console.log('Error Data')
            };
            this.otherItems()

            this.playersTradeHeaderMenu = []
            console.log(targetData.name)
            this.playersTradeHeaderMenu.push({
                id: myId,
                name: myData.name,
                inventory: inventory,
                myPP  : myData.avatar,
                targetPP : targetData.avatar,
                targetName : targetData.name,
                targetId : targetId,
            });
         
            this.show = true
            tradeID = tradeid
     
            this.myInventoryItem(this.playersTradeHeaderMenu[0].inventory)
            myInventoryItemClient = this.playersTradeHeaderMenu[0].inventory
            setTimeout(() => {
                handleDragDrop()
            }, 100);
        },  
        


    },

})

var DraggingData = null;
var OtherInventoryType = "other";
var test = "deneme 1 2 3";
var droppedItems = [];
function handleDragDrop() {

    $(".playerInvSlot").draggable({
        helper: function(event) {
          
            var item = $(this).clone();
            item.css({
                "width": "5.7%",
                "height": "10.5%"
            });
            return item;
        },
        appendTo: ".appendItem",

        scroll: false,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function (event, ui) {
            
            if ($(this).data("itemdata")) {
                DraggingData = $(this).data("itemdata");
            }
         

            // $(".ui-draggable-handle > .item-slot-state").addClass()
        },
        stop: function () {
            
            DraggingData = null;
        }
    });

    // benim envaterimden itemi üst tarafıma taşıdığım zaman
    $(".playerHeaderInventory").droppable({
        hoverClass: "item-slot-hoverClass",
        drop: function (event, ui) {
            if(!playerAcceptButton2 && !offerAcceptButton2){
                if (OtherInventoryType && DraggingData && OtherInventoryType != DraggingData["currentContainer"]) {
                    const itemCheck = myInventoryItemClient.find(playerItem => playerItem.name === DraggingData.itemname);
    
                    if (itemCheck && itemCheck.name === DraggingData.itemname) {
                        if(itemCheck.count >= itemAmount && itemAmount > 0){
                            itemCheck.count -= itemAmount;
                            
    
                            const item = myInventoryItemUI.find(playerItem => playerItem.itemname === DraggingData.itemname);
                            if (item) {
                                item.itemcount = parseInt(item.itemcount) + parseInt(itemAmount);
                            } else {
                                myInventoryItemUI.push({
                                    itemname: DraggingData.itemname,
                                    itemcount: parseInt(itemAmount),
                                    itemlabel: DraggingData.itemlabel,
                                    iteminfo : DraggingData.info,
                                    fromtype: "inventory"
                                });
                            }
                 
                           
                         
                            setTimeout(() => {
                                $(".myInventoryAppend").empty();
                                app.myInventoryItem(myInventoryItemClient);
                                app.myOffersItem(myInventoryItemUI);
    
                            }, 100);
                      
                            $.post(`https://${resourceNames}/ItemDrag`, JSON.stringify({
                                items:  {
                                    itemname :  DraggingData.itemname,
                                    count : itemAmount,
                                    itemlabel : DraggingData.itemlabel,
                                    iteminfo : DraggingData.info,
                                    fromtype : "inventory",
                                },tradeID 
                             
                            }));
                            app.refreshItemCount();
                        
                        }
                    } else {
                        return;
                    }
                }
            }
          

       
        }
    });
    $(".offersItemSlot").draggable({
        helper: function(event) {
          
            var item = $(this).clone();
            item.css({
                "width": "5.7%",
                "height": "10.5%"
            });
            return item;
        },
        appendTo: ".appendItem",

        scroll: false,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function (event, ui) {
           
             DraggingData = $(this).data("itemdata");
          

            // $(".ui-draggable-handle > .item-slot-state").addClass()
        },
        stop: function () {
            
            DraggingData = null;
        }
    });
    $(".myInventoryAppend").droppable({
        hoverClass: "item-slot-hoverClass",
        drop: function (event, ui) {
            if(!playerAcceptButton2 && !offerAcceptButton2){
                if (DraggingData && DraggingData["currentContainer"] == "other") {
            
                    const itemCheck = myInventoryItemUI.find(playerItem => playerItem.itemname === DraggingData.itemname);
                    if (itemCheck && itemCheck.itemname === DraggingData.itemname) {
                        if(itemCheck.itemcount >= itemAmount && itemAmount > 0){
                           
                            itemCheck.itemcount -= itemAmount;
                           
                            const item = myInventoryItemClient.find(playerItem => playerItem.name === DraggingData.itemname);
                        
                            if (item) {
                                item.count = parseInt(item.count) + parseInt(itemAmount);
                            } else {
                                myInventoryItemClient.push({
                                    itemname: itemname,
                                    itemcount: parseInt(count),
                                    itemlabel: itemlabel,
                                    iteminfo : iteminfo,
                                    fromtype: "inventory"
                                });
                            }
                            // app.refreshItemCount();
                            setTimeout(() => {
                                 $(".myInventoryAppend").empty();
                                 app.myOffersItem(myInventoryItemUI);
                                 app.myInventoryItem(myInventoryItemClient);
        
                            }, 100);
                            $.post(`https://${resourceNames}/ItemDragOther`, JSON.stringify({
                                items:  {
                                    itemname :  DraggingData.itemname,
                                    count :     itemAmount,
                                    itemlabel : DraggingData.itemlabel,
                                    fromType :  "inventory",
                                },tradeID 
                             
                            }));
                            app.refreshItemCount();
                        
                        }
        
                        return;
                    }
                }
            }
     
        }
    });
    


    
}



