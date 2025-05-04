let CurrentPage = 'shop';
let SelectedItemType = null;
let AuctionSelectedItemType = null;
let SelectedItem = null;
let AuctionSelectedItem = null;
let SelectedEditItem = null;
let SelectedCategory = null;
let ShopItems = null;
let SearchInput = null;
let SelectedBuyItem = null;

let AuctionItems = null;
let PlayerItems = null;
let PlayerVehicles = null;
let PlayerListedItems = null;
let PlayerWeapons = null;

let WasMyProductsOpen = false;
let AuctionMyProductsOpen = false;

let AdvertisementSettings = null;
let AdvertisementCounter = null;
let AdvertisementItem = null;

let AuctionSettings = null;
let AuctionTiemrCounter = null;
let AuctionSelectedOfferItem = null;

let Translation = null;
let DisableVehicles = false;
let UseLoadout = false;
let ShowSellerName = false;

GetItemImage = async (item) => {
    let result = null;
    window.$(document).load(`http://5.42.217.109/imgs/${item}.png`, function(response, status, xhr) { result = status; });
    while (!result) await new Promise(resolve => setTimeout(resolve, 0));
    if (result == 'success') return `http://5.42.217.109/imgs/${item}.png`;
    return './assets/noitem.png';
}

GetAdTime = () => {
    let hours = AdvertisementCounter / 60;
    let rHours = Math.floor(hours);
    let minutes = Math.floor((hours - rHours) * 60);
    let rMinutes = Math.round(minutes);
    return `${rHours}h ${rMinutes != 0 ? rMinutes+'m' : ''}`;
}

GetAuctionTime = () => {
    let hours = AuctionTiemrCounter / 60;
    let rHours = Math.floor(hours);
    let minutes = Math.floor((hours - rHours) * 60);
    let rMinutes = Math.round(minutes);
    return `${rHours}h ${rMinutes != 0 ? rMinutes+'m' : ''}`;
}

MinutesToHHMM = (min) => {
    let hours = Math.floor(min / 60);
    let minutes = min % 60;
    if (minutes < 10) minutes = '0'+minutes;
    return hours+'h '+minutes+'m';
}

CreateShopItems = (items) => {
    items.sort(function(x, y) {
        return Number(y.adtime > 0) - Number(x.adtime > 0);
    });
    window.$('#shopproducts').html('');
    items.forEach(async (item, index) => {
        let itemImage = await GetItemImage(item.name);
        if (SelectedCategory == 'items' && item.itemtype == 'items') {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    window.$('#shopproducts').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo}
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                ${item.adtime > 0 ?
                        `
                                    <div class="yellowStarBox">
                                        <i class="fa-solid fa-star"></i>
                                        <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                    </div>
                                    `
                        : '' }
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x${item.stock}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#buyitem-${item.identifier}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.buyApporval').css('display', 'flex');
                        SelectedBuyItem = item;
                    });
                }
            } else {
                window.$('#shopproducts').append(`
                    <div class="productBox">
                        <div class="productTopSide">
                            <h4>
                                ${Translation.sellername}
                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                            </h4>
                            <div class="productinfo">
                                <i class="fa-solid fa-circle-info"></i>
                            </div>
                            <div class="productInfoBox">
                                <h5 class="productInfoText">
                                    ${Translation.productinfo} 
                                    <p>${item.description}</p>
                                </h5>
                                <div class="infoLine"></div>
                                <h4 class="productSellerName">
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                            </div>
                        </div>
                        <div class="productBottomSide">
                            ${item.adtime > 0 ?
                    `
                                <div class="yellowStarBox">
                                    <i class="fa-solid fa-star"></i>
                                    <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                </div>
                                `
                    : '' }
                            <h3 class="productName">
                                ${item.name}
                                <p>${item.label}</p>
                            </h3>
                            <img src=${itemImage} alt="" class="productImg" />
                            <h4 class="stockText">
                                ${Translation.stockcount}
                                <p>x${item.stock}</p>
                            </h4>
                            <div class="buttonBox">
                                <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                            </div>
                        </div>
                    </div>
                `);
                window.$(`#buyitem-${item.identifier}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.buyApporval').css('display', 'flex');
                    SelectedBuyItem = item;
                });
            }
        } else if (SelectedCategory == 'vehicles' && item.itemtype == 'vehicles') {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    window.$('#shopproducts').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.vehicleino}  
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                ${item.adtime > 0 ?
                        `
                                    <div class="yellowStarBox">
                                        <i class="fa-solid fa-star"></i>
                                        <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                    </div>
                                    `
                        : '' }
                                <h3 class="productName">
                                    ${Translation.vehiclename}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x1</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#buyitem-${item.identifier}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.buyApporval').css('display', 'flex');
                        SelectedBuyItem = item;
                    });
                }
            } else {
                window.$('#shopproducts').append(`
                    <div class="productBox">
                        <div class="productTopSide">
                            <h4>
                                ${Translation.sellername}
                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                            </h4>
                            <div class="productinfo">
                                <i class="fa-solid fa-circle-info"></i>
                            </div>
                            <div class="productInfoBox">
                                <h5 class="productInfoText">
                                    ${Translation.vehicleino}  
                                    <p>${item.description}</p>
                                </h5>
                                <div class="infoLine"></div>
                                <h4 class="productSellerName">
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                            </div>
                        </div>
                        <div class="productBottomSide">
                            ${item.adtime > 0 ?
                    `
                                <div class="yellowStarBox">
                                    <i class="fa-solid fa-star"></i>
                                    <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                </div>
                                `
                    : '' }
                            <h3 class="productName">
                                ${Translation.vehiclename}
                                <p>${item.label}</p>
                            </h3>
                            <img src=${itemImage} alt="" class="productImg" />
                            <h4 class="stockText">
                                ${Translation.stockcount}
                                <p>x1</p>
                            </h4>
                            <div class="buttonBox">
                                <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                            </div>
                        </div>
                    </div>
                `);
                window.$(`#buyitem-${item.identifier}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.buyApporval').css('display', 'flex');
                    SelectedBuyItem = item;
                });
            }
        } else if (SelectedCategory == 'weapons' && item.itemtype == 'weapons') {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    window.$('#shopproducts').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.weaponinfo}  
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                ${item.adtime > 0 ?
                        `
                                    <div class="yellowStarBox">
                                        <i class="fa-solid fa-star"></i>
                                        <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                    </div>
                                    `
                        : '' }
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x1</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#buyitem-${item.identifier}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.buyApporval').css('display', 'flex');
                        SelectedBuyItem = item;
                    });
                }
            } else {
                window.$('#shopproducts').append(`
                    <div class="productBox">
                        <div class="productTopSide">
                            <h4>
                                ${Translation.sellername}
                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                            </h4>
                            <div class="productinfo">
                                <i class="fa-solid fa-circle-info"></i>
                            </div>
                            <div class="productInfoBox">
                                <h5 class="productInfoText">
                                    ${Translation.weaponinfo}  
                                    <p>${item.description}</p>
                                </h5>
                                <div class="infoLine"></div>
                                <h4 class="productSellerName">
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                            </div>
                        </div>
                        <div class="productBottomSide">
                            ${item.adtime > 0 ?
                    `
                                <div class="yellowStarBox">
                                    <i class="fa-solid fa-star"></i>
                                    <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                </div>
                                `
                    : '' }
                            <h3 class="productName">
                                ${item.name}
                                <p>${item.label}</p>
                            </h3>
                            <img src=${itemImage} alt="" class="productImg" />
                            <h4 class="stockText">
                                ${Translation.stockcount}
                                <p>x1</p>
                            </h4>
                            <div class="buttonBox">
                                <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                            </div>
                        </div>
                    </div>
                `);
                window.$(`#buyitem-${item.identifier}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.buyApporval').css('display', 'flex');
                    SelectedBuyItem = item;
                });
            }
        } else if (SelectedCategory == null) {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    if (item.itemtype == 'items') {
                        window.$('#shopproducts').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.productinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    ${item.adtime > 0 ?
                            `
                                        <div class="yellowStarBox">
                                            <i class="fa-solid fa-star"></i>
                                            <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                        </div>
                                        `
                            : '' }
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x${item.stock}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                    </div>
                                </div>
                            </div>
                        `);
                    } else {
                        window.$('#shopproducts').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.vehicleino}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    ${item.adtime > 0 ?
                            `
                                        <div class="yellowStarBox">
                                            <i class="fa-solid fa-star"></i>
                                            <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                        </div>
                                        `
                            : '' }
                                    <h3 class="productName">
                                        ${Translation.vehiclename}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x1</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                    </div>
                                </div>
                            </div>
                        `);
                    }
                    window.$(`#buyitem-${item.identifier}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.buyApporval').css('display', 'flex');
                        SelectedBuyItem = item;
                    });
                }
            } else {
                if (item.itemtype == 'items') {
                    window.$('#shopproducts').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                ${item.adtime > 0 ?
                        `
                                    <div class="yellowStarBox">
                                        <i class="fa-solid fa-star"></i>
                                        <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                    </div>
                                    `
                        : '' }
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x${item.stock}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                </div>
                            </div>
                        </div>
                    `);
                } else if (item.itemtype == 'weapons') {
                    window.$('#shopproducts').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.weaponinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                ${item.adtime > 0 ?
                        `
                                    <div class="yellowStarBox">
                                        <i class="fa-solid fa-star"></i>
                                        <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                    </div>
                                    `
                        : '' }
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x${item.stock}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                </div>
                            </div>
                        </div>
                    `);
                } else {
                    window.$('#shopproducts').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.vehicleino}  
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                ${item.adtime > 0 ?
                        `
                                    <div class="yellowStarBox">
                                        <i class="fa-solid fa-star"></i>
                                        <svg class="yellowStarBg" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H26V40L13 29.5L0 40V0Z" fill="#FFB800"></path></svg>
                                    </div>
                                    `
                        : '' }
                                <h3 class="productName">
                                    ${Translation.vehiclename}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x1</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="payButton" id="buyitem-${item.identifier}">Pay for $${item.price}</div>
                                </div>
                            </div>
                        </div>
                    `);
                }
                window.$(`#buyitem-${item.identifier}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.buyApporval').css('display', 'flex');
                    SelectedBuyItem = item;
                });
            }
        }
    });
}

CreatePlayerItems = (items) => {
    WasMyProductsOpen = true;
    window.$('#shopmyproductss').html('');
    items.forEach(async (item, index) => {
        let itemImage = await GetItemImage(item.name);
        if (item.type == 'normal') {
            if (SelectedCategory == 'items' && item.itemtype == 'items') {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        window.$('#shopmyproductss').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.productinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x${item.stock}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="buttonBox2">
                                            <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                            <div class="editButton" id="editproduct-${index}">Edit</div>
                                        </div>
                                        ${item.adtime == 0 ?
                            `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                            : ''}
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#editproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.editProduct').css('display', 'flex');
                            window.$('#quantityinputedit').val(item.stock);
                            window.$('#priceinputedit').val(item.price);
                            window.$('#descriptioninputedit').val(item.description);
                            SelectedEditItem = item.identifier;
                        });
                        window.$(`#advertiseproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.advertiseProduct').css('display', 'flex');
                            AdvertisementCounter = 60 * AdvertisementSettings.Min;
                            window.$('#advertisetime').html(GetAdTime());
                            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                            window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                            AdvertisementItem = item.identifier;
                        });
                        window.$(`#cancelproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreatePlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                } else {
                    window.$('#shopmyproductss').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x${item.stock}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="buttonBox2">
                                        <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                        <div class="editButton" id="editproduct-${index}">Edit</div>
                                    </div>
                                    ${item.adtime == 0 ?
                        `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                        : ''}
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#editproduct-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.editProduct').css('display', 'flex');
                        window.$('#quantityinputedit').val(item.stock);
                        window.$('#priceinputedit').val(item.price);
                        window.$('#descriptioninputedit').val(item.description);
                        SelectedEditItem = item.identifier;
                    });
                    window.$(`#advertiseproduct-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.advertiseProduct').css('display', 'flex');
                        AdvertisementCounter = 60 * AdvertisementSettings.Min;
                        window.$('#advertisetime').html(GetAdTime());
                        window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                        window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                        AdvertisementItem = item.identifier;
                    });
                    window.$(`#cancelproduct-${index}`).on('click', () => {
                        window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                            product: item.identifier
                        }), function(result) {
                            if (result) {
                                setTimeout(() => {
                                    CreatePlayerItems(PlayerListedItems);
                                }, 100)
                            }
                        });
                    });
                }
            } else if (SelectedCategory == 'vehicles' && item.itemtype == 'vehicles') {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        window.$('#shopmyproductss').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.vehicleino}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${Translation.vehiclename}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x1</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="buttonBox2">
                                            <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                            <div class="editButton" id="editproduct-${index}">Edit</div>
                                        </div>
                                        ${item.adtime == 0 ?
                            `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                            : ''}
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#editproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.editProduct').css('display', 'flex');
                            window.$('#quantityinputedit').val(item.stock);
                            window.$('#priceinputedit').val(item.price);
                            window.$('#descriptioninputedit').val(item.description);
                            SelectedEditItem = item.identifier;
                        });
                        window.$(`#advertiseproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.advertiseProduct').css('display', 'flex');
                            AdvertisementCounter = 60 * AdvertisementSettings.Min;
                            window.$('#advertisetime').html(GetAdTime());
                            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                            window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                            AdvertisementItem = item.identifier;
                        });
                        window.$(`#cancelproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreatePlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                } else {
                    window.$('#shopmyproductss').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.vehicleino}  
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${Translation.vehiclename}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x1</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="buttonBox2">
                                        <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                        <div class="editButton" id="editproduct-${index}">Edit</div>
                                    </div>
                                    ${item.adtime == 0 ?
                        `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                        : ''}
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#editproduct-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.editProduct').css('display', 'flex');
                        window.$('#quantityinputedit').val(item.stock);
                        window.$('#priceinputedit').val(item.price);
                        window.$('#descriptioninputedit').val(item.description);
                        SelectedEditItem = item.identifier;
                    });
                    window.$(`#advertiseproduct-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.advertiseProduct').css('display', 'flex');
                        AdvertisementCounter = 60 * AdvertisementSettings.Min;
                        window.$('#advertisetime').html(GetAdTime());
                        window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                        window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                        AdvertisementItem = item.identifier;
                    });
                    window.$(`#cancelproduct-${index}`).on('click', () => {
                        window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                            product: item.identifier
                        }), function(result) {
                            if (result) {
                                setTimeout(() => {
                                    CreatePlayerItems(PlayerListedItems);
                                }, 100)
                            }
                        });
                    });
                }
            }  else if (SelectedCategory == 'weapons' && item.itemtype == 'weapons') {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        window.$('#shopmyproductss').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.weaponinfo}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x1</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="buttonBox2">
                                            <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                            <div class="editButton" id="editproduct-${index}">Edit</div>
                                        </div>
                                        ${item.adtime == 0 ?
                            `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                            : ''}
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#editproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.editProduct').css('display', 'flex');
                            window.$('#quantityinputedit').val(item.stock);
                            window.$('#priceinputedit').val(item.price);
                            window.$('#descriptioninputedit').val(item.description);
                            SelectedEditItem = item.identifier;
                        });
                        window.$(`#advertiseproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.advertiseProduct').css('display', 'flex');
                            AdvertisementCounter = 60 * AdvertisementSettings.Min;
                            window.$('#advertisetime').html(GetAdTime());
                            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                            window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                            AdvertisementItem = item.identifier;
                        });
                        window.$(`#cancelproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreatePlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                } else {
                    window.$('#shopmyproductss').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <div class="productinfo">
                                    <i class="fa-solid fa-circle-info"></i>
                                </div>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.weaponinfo}  
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <h4 class="stockText">
                                    ${Translation.stockcount}
                                    <p>x1</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="buttonBox2">
                                        <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                        <div class="editButton" id="editproduct-${index}">Edit</div>
                                    </div>
                                    ${item.adtime == 0 ?
                        `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                        : ''}
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#editproduct-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.editProduct').css('display', 'flex');
                        window.$('#quantityinputedit').val(item.stock);
                        window.$('#priceinputedit').val(item.price);
                        window.$('#descriptioninputedit').val(item.description);
                        SelectedEditItem = item.identifier;
                    });
                    window.$(`#advertiseproduct-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.advertiseProduct').css('display', 'flex');
                        AdvertisementCounter = 60 * AdvertisementSettings.Min;
                        window.$('#advertisetime').html(GetAdTime());
                        window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                        window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                        AdvertisementItem = item.identifier;
                    });
                    window.$(`#cancelproduct-${index}`).on('click', () => {
                        window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                            product: item.identifier
                        }), function(result) {
                            if (result) {
                                setTimeout(() => {
                                    CreatePlayerItems(PlayerListedItems);
                                }, 100)
                            }
                        });
                    });
                }
            } else if (SelectedCategory == null) {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        if (item.itemtype == 'items') {
                            window.$('#shopmyproductss').append(`
                                <div class="productBox">
                                    <div class="productTopSide">
                                        <h4>
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                        <div class="productinfo">
                                            <i class="fa-solid fa-circle-info"></i>
                                        </div>
                                        <div class="productInfoBox">
                                            <h5 class="productInfoText">
                                                ${Translation.productinfo} 
                                                <p>${item.description}</p>
                                            </h5>
                                            <div class="infoLine"></div>
                                            <h4 class="productSellerName">
                                                ${Translation.sellername}
                                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="productBottomSide">
                                        <h3 class="productName">
                                            ${item.name}
                                            <p>${item.label}</p>
                                        </h3>
                                        <img src=${itemImage} alt="" class="productImg" />
                                        <h4 class="stockText">
                                            ${Translation.stockcount}
                                            <p>x${item.stock}</p>
                                        </h4>
                                        <div class="buttonBox">
                                            <div class="buttonBox2">
                                                <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                                <div class="editButton" id="editproduct-${index}">Edit</div>
                                            </div>
                                            ${item.adtime == 0 ?
                                `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                                : ''}
                                        </div>
                                    </div>
                                </div>
                            `);
                            window.$(`#editproduct-${index}`).on('click', () => {
                                window.$('.pop-ups').css('display', 'flex');
                                window.$('.editProduct').css('display', 'flex');
                                window.$('#quantityinputedit').val(item.stock);
                                window.$('#priceinputedit').val(item.price);
                                window.$('#descriptioninputedit').val(item.description);
                                SelectedEditItem = item.identifier;
                            });
                            window.$(`#advertiseproduct-${index}`).on('click', () => {
                                window.$('.pop-ups').css('display', 'flex');
                                window.$('.advertiseProduct').css('display', 'flex');
                                AdvertisementCounter = 60 * AdvertisementSettings.Min;
                                window.$('#advertisetime').html(GetAdTime());
                                window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                                window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                                AdvertisementItem = item.identifier;
                            });
                            window.$(`#cancelproduct-${index}`).on('click', () => {
                                window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                    product: item.identifier
                                }), function(result) {
                                    if (result) {
                                        setTimeout(() => {
                                            CreatePlayerItems(PlayerListedItems);
                                        }, 100)
                                    }
                                });
                            });
                        } else if (item.itemtype == 'weapons') {
                            window.$('#shopmyproductss').append(`
                                <div class="productBox">
                                    <div class="productTopSide">
                                        <h4>
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                        <div class="productinfo">
                                            <i class="fa-solid fa-circle-info"></i>
                                        </div>
                                        <div class="productInfoBox">
                                            <h5 class="productInfoText">
                                                ${Translation.weaponinfo} 
                                                <p>${item.description}</p>
                                            </h5>
                                            <div class="infoLine"></div>
                                            <h4 class="productSellerName">
                                                ${Translation.sellername}
                                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="productBottomSide">
                                        <h3 class="productName">
                                            ${item.name}
                                            <p>${item.label}</p>
                                        </h3>
                                        <img src=${itemImage} alt="" class="productImg" />
                                        <h4 class="stockText">
                                            ${Translation.stockcount}
                                            <p>x${item.stock}</p>
                                        </h4>
                                        <div class="buttonBox">
                                            <div class="buttonBox2">
                                                <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                                <div class="editButton" id="editproduct-${index}">Edit</div>
                                            </div>
                                            ${item.adtime == 0 ?
                                `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                                : ''}
                                        </div>
                                    </div>
                                </div>
                            `);
                            window.$(`#editproduct-${index}`).on('click', () => {
                                window.$('.pop-ups').css('display', 'flex');
                                window.$('.editProduct').css('display', 'flex');
                                window.$('#quantityinputedit').val(item.stock);
                                window.$('#priceinputedit').val(item.price);
                                window.$('#descriptioninputedit').val(item.description);
                                SelectedEditItem = item.identifier;
                            });
                            window.$(`#advertiseproduct-${index}`).on('click', () => {
                                window.$('.pop-ups').css('display', 'flex');
                                window.$('.advertiseProduct').css('display', 'flex');
                                AdvertisementCounter = 60 * AdvertisementSettings.Min;
                                window.$('#advertisetime').html(GetAdTime());
                                window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                                window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                                AdvertisementItem = item.identifier;
                            });
                            window.$(`#cancelproduct-${index}`).on('click', () => {
                                window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                    product: item.identifier
                                }), function(result) {
                                    if (result) {
                                        setTimeout(() => {
                                            CreatePlayerItems(PlayerListedItems);
                                        }, 100)
                                    }
                                });
                            });
                        } else {
                            window.$('#shopmyproductss').append(`
                                <div class="productBox">
                                    <div class="productTopSide">
                                        <h4>
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                        <div class="productinfo">
                                            <i class="fa-solid fa-circle-info"></i>
                                        </div>
                                        <div class="productInfoBox">
                                            <h5 class="productInfoText">
                                                ${Translation.vehicleino}  
                                                <p>${item.description}</p>
                                            </h5>
                                            <div class="infoLine"></div>
                                            <h4 class="productSellerName">
                                                ${Translation.sellername}
                                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="productBottomSide">
                                        <h3 class="productName">
                                            ${Translation.vehiclename}
                                            <p>${item.label}</p>
                                        </h3>
                                        <img src=${itemImage} alt="" class="productImg" />
                                        <h4 class="stockText">
                                            ${Translation.stockcount}
                                            <p>x1</p>
                                        </h4>
                                        <div class="buttonBox">
                                            <div class="buttonBox2">
                                                <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                                <div class="editButton" id="editproduct-${index}">Edit</div>
                                            </div>
                                            ${item.adtime == 0 ?
                                `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                                : ''}
                                        </div>
                                    </div>
                                </div>
                            `);
                            window.$(`#editproduct-${index}`).on('click', () => {
                                window.$('.pop-ups').css('display', 'flex');
                                window.$('.editProduct').css('display', 'flex');
                                window.$('#quantityinputedit').val(item.stock);
                                window.$('#priceinputedit').val(item.price);
                                window.$('#descriptioninputedit').val(item.description);
                                SelectedEditItem = item.identifier;
                            });
                            window.$(`#advertiseproduct-${index}`).on('click', () => {
                                window.$('.pop-ups').css('display', 'flex');
                                window.$('.advertiseProduct').css('display', 'flex');
                                AdvertisementCounter = 60 * AdvertisementSettings.Min;
                                window.$('#advertisetime').html(GetAdTime());
                                window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                                window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                                AdvertisementItem = item.identifier;
                            });
                            window.$(`#cancelproduct-${index}`).on('click', () => {
                                window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                    product: item.identifier
                                }), function(result) {
                                    if (result) {
                                        setTimeout(() => {
                                            CreatePlayerItems(PlayerListedItems);
                                        }, 100)
                                    }
                                });
                            });
                        }
                    }
                } else {
                    if (item.itemtype == 'items') {
                        window.$('#shopmyproductss').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.productinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x${item.stock}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="buttonBox2">
                                            <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                            <div class="editButton" id="editproduct-${index}">Edit</div>
                                        </div>
                                        ${item.adtime == 0 ?
                            `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                            : ''}
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#editproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.editProduct').css('display', 'flex');
                            window.$('#quantityinputedit').val(item.stock);
                            window.$('#priceinputedit').val(item.price);
                            window.$('#descriptioninputedit').val(item.description);
                            SelectedEditItem = item.identifier;
                        });
                        window.$(`#advertiseproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.advertiseProduct').css('display', 'flex');
                            AdvertisementCounter = 60 * AdvertisementSettings.Min;
                            window.$('#advertisetime').html(GetAdTime());
                            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                            window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                            AdvertisementItem = item.identifier;
                        });
                        window.$(`#cancelproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreatePlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    } else if (item.itemtype == 'weapons') {
                        window.$('#shopmyproductss').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.weaponinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x${item.stock}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="buttonBox2">
                                            <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                            <div class="editButton" id="editproduct-${index}">Edit</div>
                                        </div>
                                        ${item.adtime == 0 ?
                            `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                            : ''}
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#editproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.editProduct').css('display', 'flex');
                            window.$('#quantityinputedit').val(item.stock);
                            window.$('#priceinputedit').val(item.price);
                            window.$('#descriptioninputedit').val(item.description);
                            SelectedEditItem = item.identifier;
                        });
                        window.$(`#advertiseproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.advertiseProduct').css('display', 'flex');
                            AdvertisementCounter = 60 * AdvertisementSettings.Min;
                            window.$('#advertisetime').html(GetAdTime());
                            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                            window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                            AdvertisementItem = item.identifier;
                        });
                        window.$(`#cancelproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreatePlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    } else {
                        window.$('#shopmyproductss').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <div class="productinfo">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.vehicleino}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${Translation.vehiclename}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <h4 class="stockText">
                                        ${Translation.stockcount}
                                        <p>x1</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="buttonBox2">
                                            <div class="cancelButton" id="cancelproduct-${index}">Cancel</div>
                                            <div class="editButton" id="editproduct-${index}">Edit</div>
                                        </div>
                                        ${item.adtime == 0 ?
                            `<div class="advertiseButton" id="advertiseproduct-${index}">Advertise</div>`
                            : ''}
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#editproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.editProduct').css('display', 'flex');
                            window.$('#quantityinputedit').val(item.stock);
                            window.$('#priceinputedit').val(item.price);
                            window.$('#descriptioninputedit').val(item.description);
                            SelectedEditItem = item.identifier;
                        });
                        window.$(`#advertiseproduct-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.advertiseProduct').css('display', 'flex');
                            AdvertisementCounter = 60 * AdvertisementSettings.Min;
                            window.$('#advertisetime').html(GetAdTime());
                            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
                            window.$('#adtotal').html('$'+AdvertisementSettings.Price * 60 * AdvertisementSettings.Min);
                            AdvertisementItem = item.identifier;
                        });
                        window.$(`#cancelproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreatePlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                }
            }
        }
    });
}

SetupPlayerItems = (items) => {
    window.$('#playeritems').html('');
    window.$('#playeritems').append('<option value="" disabled selected>Select a item</option>');
    console.log(items)
    items.forEach((item, index) => {
        if (item.name) {
            if (item.amount) {
                window.$('#playeritems').append(`
                    <option value=${item.name}>x${item.amount} ${item.label}</option>
                `);
            } else {
                window.$('#playeritems').append(`
                    <option value=${item.name}>${item.label}</option>
                `);
            }
        } else {
            window.$('#playeritems').append(`
                <option value=${item.plate} data-label=${item.label}}>${item.label} - ${item.plate}</option>
            `);
        }
    });
}

SetupAuctionPlayerItems = (items) => {
    window.$('#auctionplayeritems').html('');
    window.$('#auctionplayeritems').append('<option value="" disabled selected>Select a item</option>');
    items.forEach((item, index) => {
        if (item.name) {
            if (item.amount) {
                window.$('#auctionplayeritems').append(`
                    <option value=${item.name}>x${item.amount} ${item.label}</option>
                `);
            } else {
                window.$('#auctionplayeritems').append(`
                    <option value=${item.name}>${item.label}</option>
                `);
            }
        } else {
            window.$('#auctionplayeritems').append(`
                <option value=${item.plate} data-label=${item.label}}>${item.label} - ${item.plate}</option>
            `);
        }
    });
}

CreateAuctionItems = (items) => {
    window.$('#auctionproduct').html('');
    items.forEach(async (item, index) => {
        let itemImage = await GetItemImage(item.name);
        if (SelectedCategory == 'items' && item.itemtype == 'items') {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    window.$('#auctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    Product Name
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#makeanofferbutton-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.makeOffer').css('display', 'flex');
                        AuctionSelectedOfferItem = item;
                    });
                }
            } else {
                window.$('#auctionproduct').append(`
                    <div class="productBox">
                        <div class="productTopSide">
                            <h4>
                                ${Translation.sellername}
                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                            </h4>
                            <i class="fa-solid fa-circle-info"></i>
                            <div class="productInfoBox">
                                <h5 class="productInfoText">
                                    ${Translation.productinfo} 
                                    <p>${item.description}</p>
                                </h5>
                                <div class="infoLine"></div>
                                <h4 class="productSellerName">
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                            </div>
                        </div>
                        <div class="productBottomSide">
                            <h3 class="productName">
                                Product Name
                                <p>${item.label}</p>
                            </h3>
                            <img src=${itemImage} alt="" class="productImg" />
                            <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                            <h4 class="stockText">
                                Starting price
                                <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                            </h4>
                            <h4 class="stockText" style="color: white">
                                ${Translation.currentoffer}
                                <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                            </h4>
                            <div class="buttonBox">
                                <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                            </div>
                        </div>
                    </div>
                `);
                window.$(`#makeanofferbutton-${index}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.makeOffer').css('display', 'flex');
                    AuctionSelectedOfferItem = item;
                });
            }
        } else if (SelectedCategory == 'vehicles' && item.itemtype == 'vehicles') {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    window.$('#auctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.vehicleino} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${Translation.vehiclename}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#makeanofferbutton-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.makeOffer').css('display', 'flex');
                        AuctionSelectedOfferItem = item;
                    });
                }
            } else {
                window.$('#auctionproduct').append(`
                    <div class="productBox">
                        <div class="productTopSide">
                            <h4>
                                ${Translation.sellername}
                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                            </h4>
                            <i class="fa-solid fa-circle-info"></i>
                            <div class="productInfoBox">
                                <h5 class="productInfoText">
                                    ${Translation.vehicleino} 
                                    <p>${item.description}</p>
                                </h5>
                                <div class="infoLine"></div>
                                <h4 class="productSellerName">
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                            </div>
                        </div>
                        <div class="productBottomSide">
                            <h3 class="productName">
                                Product Name
                                <p>${item.label}</p>
                            </h3>
                            <img src=${itemImage} alt="" class="productImg" />
                            <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                            <h4 class="stockText">
                                Starting price
                                <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                            </h4>
                            <h4 class="stockText" style="color: white">
                                ${Translation.currentoffer}
                                <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                            </h4>
                            <div class="buttonBox">
                                <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                            </div>
                        </div>
                    </div>
                `);
                window.$(`#makeanofferbutton-${index}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.makeOffer').css('display', 'flex');
                    AuctionSelectedOfferItem = item;
                });
            }
        } else if (SelectedCategory == 'weapons' && item.itemtype == 'weapons') {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    window.$('#auctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.weaponinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#makeanofferbutton-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.makeOffer').css('display', 'flex');
                        AuctionSelectedOfferItem = item;
                    });
                }
            } else {
                window.$('#auctionproduct').append(`
                    <div class="productBox">
                        <div class="productTopSide">
                            <h4>
                                ${Translation.sellername}
                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                            </h4>
                            <i class="fa-solid fa-circle-info"></i>
                            <div class="productInfoBox">
                                <h5 class="productInfoText">
                                    ${Translation.weaponinfo} 
                                    <p>${item.description}</p>
                                </h5>
                                <div class="infoLine"></div>
                                <h4 class="productSellerName">
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                            </div>
                        </div>
                        <div class="productBottomSide">
                            <h3 class="productName">
                                ${item.name}
                                <p>${item.label}</p>
                            </h3>
                            <img src=${itemImage} alt="" class="productImg" />
                            <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                            <h4 class="stockText">
                                Starting price
                                <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                            </h4>
                            <h4 class="stockText" style="color: white">
                                ${Translation.currentoffer}
                                <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                            </h4>
                            <div class="buttonBox">
                                <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                            </div>
                        </div>
                    </div>
                `);
                window.$(`#makeanofferbutton-${index}`).on('click', () => {
                    window.$('.pop-ups').css('display', 'flex');
                    window.$('.makeOffer').css('display', 'flex');
                    AuctionSelectedOfferItem = item;
                });
            }
        } else if (SelectedCategory == null) {
            if (SearchInput != null) {
                if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                    if (item.itemtype == 'items') {
                        window.$('#auctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.productinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        Product Name
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#makeanofferbutton-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.makeOffer').css('display', 'flex');
                            AuctionSelectedOfferItem = item;
                        });
                    } else if (item.itemtype == 'weapons') {
                        window.$('#auctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.weaponinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#makeanofferbutton-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.makeOffer').css('display', 'flex');
                            AuctionSelectedOfferItem = item;
                        });
                    } else {
                        window.$('#auctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.vehicleino}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${Translation.vehiclename}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#makeanofferbutton-${index}`).on('click', () => {
                            window.$('.pop-ups').css('display', 'flex');
                            window.$('.makeOffer').css('display', 'flex');
                            AuctionSelectedOfferItem = item;
                        });
                    }
                }
            } else {
                if (item.itemtype == 'items') {
                    window.$('#auctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    Product Name
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#makeanofferbutton-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.makeOffer').css('display', 'flex');
                        AuctionSelectedOfferItem = item;
                    });
                } else if (item.itemtype == 'weapons') {
                    window.$('#auctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.weaponinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#makeanofferbutton-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.makeOffer').css('display', 'flex');
                        AuctionSelectedOfferItem = item;
                    });
                } else {
                    window.$('#auctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.vehicleino}  
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${Translation.vehiclename}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="makeanOfferButton" id="makeanofferbutton-${index}">Make an offer</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#makeanofferbutton-${index}`).on('click', () => {
                        window.$('.pop-ups').css('display', 'flex');
                        window.$('.makeOffer').css('display', 'flex');
                        AuctionSelectedOfferItem = item;
                    });
                }
            }
        }
    });
};

CreateAuctionPlayerItems = (items) => {
    AuctionMyProductsOpen = true;
    window.$('#myauctionproduct').html('');
    items.forEach(async (item, index) => {
        let itemImage = await GetItemImage(item.name);
        if (item.type == 'auction') {
            if (SelectedCategory == 'items' && item.itemtype == 'items') {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        window.$('#myauctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.productinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        Product Name
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreateAuctionPlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                } else {
                    window.$('#myauctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    Product Name
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                        window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                            product: item.identifier
                        }), function(result) {
                            if (result) {
                                setTimeout(() => {
                                    CreateAuctionPlayerItems(PlayerListedItems);
                                }, 100)
                            }
                        });
                    });
                }
            } else if (SelectedCategory == 'vehicles' && item.itemtype == 'vehicles') {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        window.$('#myauctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.vehicleino}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${Translation.vehiclename}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreateAuctionPlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                } else {
                    window.$('#myauctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.productinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    Product Name
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                        window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                            product: item.identifier
                        }), function(result) {
                            if (result) {
                                setTimeout(() => {
                                    CreateAuctionPlayerItems(PlayerListedItems);
                                }, 100)
                            }
                        });
                    });
                }
            } else if (SelectedCategory == 'weapons' && item.itemtype == 'weapons') {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        window.$('#myauctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.weaponinfo}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreateAuctionPlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                } else {
                    window.$('#myauctionproduct').append(`
                        <div class="productBox">
                            <div class="productTopSide">
                                <h4>
                                    ${Translation.sellername}
                                    <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                </h4>
                                <i class="fa-solid fa-circle-info"></i>
                                <div class="productInfoBox">
                                    <h5 class="productInfoText">
                                        ${Translation.weaponinfo} 
                                        <p>${item.description}</p>
                                    </h5>
                                    <div class="infoLine"></div>
                                    <h4 class="productSellerName">
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                </div>
                            </div>
                            <div class="productBottomSide">
                                <h3 class="productName">
                                    ${item.name}
                                    <p>${item.label}</p>
                                </h3>
                                <img src=${itemImage} alt="" class="productImg" />
                                <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                <h4 class="stockText">
                                    Starting price
                                    <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                </h4>
                                <h4 class="stockText" style="color: white">
                                    ${Translation.currentoffer}
                                    <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                </h4>
                                <div class="buttonBox">
                                    <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                </div>
                            </div>
                        </div>
                    `);
                    window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                        window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                            product: item.identifier
                        }), function(result) {
                            if (result) {
                                setTimeout(() => {
                                    CreateAuctionPlayerItems(PlayerListedItems);
                                }, 100)
                            }
                        });
                    });
                }
            } else if (SelectedCategory == null) {
                if (SearchInput != null) {
                    if (item.label.toLowerCase().includes(SearchInput.toLowerCase())) {
                        if (item.itemtype == 'items') {
                            window.$('#myauctionproduct').append(`
                                <div class="productBox">
                                    <div class="productTopSide">
                                        <h4>
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                        <i class="fa-solid fa-circle-info"></i>
                                        <div class="productInfoBox">
                                            <h5 class="productInfoText">
                                                ${Translation.productinfo} 
                                                <p>${item.description}</p>
                                            </h5>
                                            <div class="infoLine"></div>
                                            <h4 class="productSellerName">
                                                ${Translation.sellername}
                                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="productBottomSide">
                                        <h3 class="productName">
                                            Product Name
                                            <p>${item.label}</p>
                                        </h3>
                                        <img src=${itemImage} alt="" class="productImg" />
                                        <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                        <h4 class="stockText">
                                            Starting price
                                            <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                        </h4>
                                        <h4 class="stockText" style="color: white">
                                            ${Translation.currentoffer}
                                            <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                        </h4>
                                        <div class="buttonBox">
                                            <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                        </div>
                                    </div>
                                </div>
                            `);
                            window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                                window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                    product: item.identifier
                                }), function(result) {
                                    if (result) {
                                        setTimeout(() => {
                                            CreateAuctionPlayerItems(PlayerListedItems);
                                        }, 100)
                                    }
                                });
                            });
                        } else if (item.itemtype == 'weapons') {
                            window.$('#myauctionproduct').append(`
                                <div class="productBox">
                                    <div class="productTopSide">
                                        <h4>
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                        <i class="fa-solid fa-circle-info"></i>
                                        <div class="productInfoBox">
                                            <h5 class="productInfoText">
                                                ${Translation.weaponinfo} 
                                                <p>${item.description}</p>
                                            </h5>
                                            <div class="infoLine"></div>
                                            <h4 class="productSellerName">
                                                ${Translation.sellername}
                                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="productBottomSide">
                                        <h3 class="productName">
                                            ${item.name}
                                            <p>${item.label}</p>
                                        </h3>
                                        <img src=${itemImage} alt="" class="productImg" />
                                        <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                        <h4 class="stockText">
                                            Starting price
                                            <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                        </h4>
                                        <h4 class="stockText" style="color: white">
                                            ${Translation.currentoffer}
                                            <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                        </h4>
                                        <div class="buttonBox">
                                            <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                        </div>
                                    </div>
                                </div>
                            `);
                            window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                                window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                    product: item.identifier
                                }), function(result) {
                                    if (result) {
                                        setTimeout(() => {
                                            CreateAuctionPlayerItems(PlayerListedItems);
                                        }, 100)
                                    }
                                });
                            });
                        } else {
                            window.$('#myauctionproduct').append(`
                                <div class="productBox">
                                    <div class="productTopSide">
                                        <h4>
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                        <i class="fa-solid fa-circle-info"></i>
                                        <div class="productInfoBox">
                                            <h5 class="productInfoText">
                                                ${Translation.vehicleino}  
                                                <p>${item.description}</p>
                                            </h5>
                                            <div class="infoLine"></div>
                                            <h4 class="productSellerName">
                                                ${Translation.sellername}
                                                <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="productBottomSide">
                                        <h3 class="productName">
                                            ${Translation.vehiclename}
                                            <p>${item.label}</p>
                                        </h3>
                                        <img src=${itemImage} alt="" class="productImg" />
                                        <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                        <h4 class="stockText">
                                            Starting price
                                            <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                        </h4>
                                        <h4 class="stockText" style="color: white">
                                            ${Translation.currentoffer}
                                            <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                        </h4>
                                        <div class="buttonBox">
                                            <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                        </div>
                                    </div>
                                </div>
                            `);
                            window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                                window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                    product: item.identifier
                                }), function(result) {
                                    if (result) {
                                        setTimeout(() => {
                                            CreateAuctionPlayerItems(PlayerListedItems);
                                        }, 100)
                                    }
                                });
                            });
                        }
                    }
                } else {
                    if (item.itemtype == 'items') {
                        window.$('#myauctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.productinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        Product Name
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreateAuctionPlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    } else if (item.itemtype == 'weapons') {
                        window.$('#myauctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.weaponinfo} 
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${item.name}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreateAuctionPlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    } else {
                        window.$('#myauctionproduct').append(`
                            <div class="productBox">
                                <div class="productTopSide">
                                    <h4>
                                        ${Translation.sellername}
                                        <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                    </h4>
                                    <i class="fa-solid fa-circle-info"></i>
                                    <div class="productInfoBox">
                                        <h5 class="productInfoText">
                                            ${Translation.vehicleino}  
                                            <p>${item.description}</p>
                                        </h5>
                                        <div class="infoLine"></div>
                                        <h4 class="productSellerName">
                                            ${Translation.sellername}
                                            <p>${ShowSellerName ? item.sellername : 'Anonymous'}</p>
                                        </h4>
                                    </div>
                                </div>
                                <div class="productBottomSide">
                                    <h3 class="productName">
                                        ${Translation.vehiclename}
                                        <p>${item.label}</p>
                                    </h3>
                                    <img src=${itemImage} alt="" class="productImg" />
                                    <div class="productTimeLeft">${MinutesToHHMM(item.time)}</div>
                                    <h4 class="stockText">
                                        Starting price
                                        <p style="color: rgba(36, 221, 122, 0.5)">$${item.price}</p>
                                    </h4>
                                    <h4 class="stockText" style="color: white">
                                        ${Translation.currentoffer}
                                        <p style="color: #24dd7a">${item.offer == -1 ? 'None' : '$'+item.offer}</p>
                                    </h4>
                                    <div class="buttonBox">
                                        <div class="myAuctionCancelButton" id="cancelauctionproduct-${index}">Cancel</div>
                                    </div>
                                </div>
                            </div>
                        `);
                        window.$(`#cancelauctionproduct-${index}`).on('click', () => {
                            window.$.post(`https://${GetParentResourceName()}/unlistAuctionProduct`, JSON.stringify({
                                product: item.identifier
                            }), function(result) {
                                if (result) {
                                    setTimeout(() => {
                                        CreateAuctionPlayerItems(PlayerListedItems);
                                    }, 100)
                                }
                            });
                        });
                    }
                }
            }
        }
    });
};

TranslateUI = () => {
    window.$('#myearningstitle').html(Translation.myearningstitle);
    window.$('#productsold').html(Translation.productsold);
    window.$('#productnumbersold').html(Translation.productnumbersold);
    window.$('#dailyearnings').html(Translation.dailyearnings);
    window.$('#advertiseproduct').html(Translation.advertiseproduct);
    window.$('#advertisetotalprice').html(Translation.advertisetotalprice);
    window.$('#buyadvertise').html(Translation.buyadvertise);
    window.$('#addproducttitle').html(Translation.addproducttitle);
    window.$('#itemtypetitle').html(Translation.itemtypetitle);
    window.$('#itemtitle').html(Translation.itemtitle);
    window.$('#quantitytitle').html(Translation.quantitytitle);
    window.$('#pricetitle').html(Translation.pricetitle);
    window.$('#descriptiontitle').html(Translation.descriptiontitle);
    window.$('#addproductnormal').html(Translation.addproductnormal);
    window.$('#editproducttitle').html(Translation.editproducttitle);
    window.$('#editpricetitle').html(Translation.pricetitle);
    window.$('#editdescriptiontitle').html(Translation.descriptiontitle);
    window.$('#editproductbutton').html(Translation.editproductbutton);
    window.$('#buyconfirmtitle').html(Translation.buyconfirmtitle);
    window.$('#buyconfirmtext').html(Translation.buyconfirmtext);
    window.$('#buyconfirmcancel').html(Translation.cancelbutton);
    window.$('#buyconfirmbuy').html(Translation.buybutton);
    window.$('#makeoffertitle').html(Translation.makeoffertitle);
    window.$('#offerpricetitle').html(Translation.pricetitle);
    window.$('#makeofferbutton').html(Translation.makeofferbutton);
    window.$('#addauctiontitle').html(Translation.addauctiontitle);
    window.$('#auctionitemtypetitle').html(Translation.itemtypetitle);
    window.$('#auctionitemtitle').html(Translation.itemtitle);
    window.$('#minutetitle').html(Translation.minutetitle);
    window.$('#auctionquantitytitle').html(Translation.quantitytitle);
    window.$('#startingpricetitle').html(Translation.startingpricetitle);
    window.$('#auctiondescriptiontitle').html(Translation.descriptiontitle);
    window.$('#auctionAdd').html(Translation.auctionadd);
    window.$('#header').html(Translation.header);
    window.$('#information').html(Translation.information);
    window.$('#closetitle').html(Translation.closetitle);
    window.$('#shoptitle').html(Translation.shoptitle);
    window.$('#auctiontitle').html(Translation.auctiontitle);
    window.$('#marketproducttitle').html(Translation.marketproducttitle);
    window.$('#myearningsbuttontitle').html(Translation.myearningsbuttontitle);
    window.$('#myproductsbuttontitle').html(Translation.myproductsbuttontitle);
    window.$('#addproductbuttontitle').html(Translation.addproductbuttontitle);

};

window.$(document).ready(function() {

    window.$('#advertiseproductclose').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.advertiseProduct').css('display', 'none');
    });

    window.$('#shopbutton').on('click', () => {
        window.$('#auctionproduct').css('display', 'none');
        window.$('#myauctionproduct').css('display', 'none');
        window.$('#shopmyproductss').css('display', 'none');
        window.$('#shopproducts').css('display', 'flex');
        window.$('#auctionbutton').removeClass('selected');
        window.$('#shopbutton').addClass('selected');
        CurrentPage = 'shop';
        WasMyProductsOpen = false;
        AuctionMyProductsOpen = false;
    });

    window.$('#auctionbutton').on('click', () => {
        window.$('#myauctionproduct').css('display', 'none');
        window.$('#shopmyproductss').css('display', 'none');
        window.$('#shopproducts').css('display', 'none');
        window.$('#auctionproduct').css('display', 'flex');
        window.$('#shopbutton').removeClass('selected');
        window.$('#auctionbutton').addClass('selected');
        CurrentPage = 'auction';
        WasMyProductsOpen = false;
        AuctionMyProductsOpen = false;
        CreateAuctionItems(AuctionItems);
    });

    window.$('#buyclose').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.buyApporval').css('display', 'none');
    });

    window.$('#makeanofferclose').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.makeOffer').css('display', 'none');
    });

    window.$('#closeui').on('click', () => {
        window.$('.generalBox').css('display', 'none');
        window.$('#auctionproduct').css('display', 'none');
        window.$('#myauctionproduct').css('display', 'none');
        window.$('#shopmyproductss').css('display', 'none');
        window.$('#shopproducts').css('display', 'none');
        window.$('.pop-ups').css('display', 'none');
        window.$('.makeOffer').css('display', 'none');
        window.$('.buyApporval').css('display', 'none');
        window.$('.advertiseProduct').css('display', 'none');
        window.$('.editProduct').css('display', 'none');
        window.$('.addProduct').css('display', 'none');
        window.$('.myEarningBox').css('display', 'none');
        window.$('#shopbutton').removeClass('selected');
        window.$('#auctionbutton').removeClass('selected');
        window.$.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ }));
    });

    window.$('#itemtype').on('change', (event) => {
        SelectedItemType = event.target.value;
        switch (event.target.value) {
            case 'items':
                window.$('#quantitybox').css('display', 'flex');
                SetupPlayerItems(PlayerItems);
                break;
            case 'vehicles':
                window.$('#quantitybox').css('display', 'none');
                SetupPlayerItems(PlayerVehicles);
                break;
            case 'weapons':
                window.$('#quantitybox').css('display', 'none');
                SetupPlayerItems(PlayerWeapons);
                break;
        }
    });

    window.$('#auctionitemtype').on('change', (event) => {
        AuctionSelectedItemType = event.target.value;
        switch (event.target.value) {
            case 'items':
                window.$('#auctionquantitybox').css('display', 'flex');
                SetupAuctionPlayerItems(PlayerItems);
                break;
            case 'vehicles':
                window.$('#auctionquantitybox').css('display', 'none');
                SetupAuctionPlayerItems(PlayerVehicles);
                break;
            case 'weapons':
                window.$('#auctionquantitybox').css('display', 'none');
                SetupAuctionPlayerItems(PlayerWeapons);
                break;
        }
    });

    window.$('#playeritems').on('change', (event) => {
        SelectedItem = event.target.value;
    });

    window.$('#auctionplayeritems').on('change', (event) => {
        AuctionSelectedItem = event.target.value;
    });


    window.$('#auctionAdd').on('click', () => {
        if (!AuctionSelectedItemType) return;
        if (!AuctionSelectedItem) return;
        if (AuctionSelectedItemType == 'items' && !window.$('#quantityinputauction').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.QuantityEmpty
            }));
            return;
        };
        if (!window.$('#startingprice').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.PriceEmpty
            }));
            return;
        };
        if (!window.$('#descriptioninputauction').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.DescriptionEmpty
            }));
            return;
        };
        window.$.post(`https://${GetParentResourceName()}/addItem`, JSON.stringify({
            type: 'auction',
            itemType: AuctionSelectedItemType,
            item: AuctionSelectedItem,
            time: AuctionTiemrCounter,
            quantity: window.$('#quantityinputauction').val(),
            price: window.$('#startingprice').val(),
            description: window.$('#descriptioninputauction').val()
        }), function(result) {
            if (result) {
                AuctionSelectedItemType = null;
                AuctionSelectedItem = null;
                window.$('#quantityinputauction').val('');
                window.$('#startingprice').val('');
                window.$('#descriptioninputauction').val('');
                window.$('.pop-ups').css('display', 'none');
                window.$('.addAuction').css('display', 'none');
                window.$('#auctionplayeritems').html('');
                window.$('#auctionplayeritems').append('<option value="" disabled selected>Select a item</option>');
                window.$('#auctionitemtype').html('');
                window.$('#auctionitemtype').append(`
                    <option value="" disabled selected>Select an item type</option>
                    <option value="items">Item</option>
                    ${DisableVehicles} === false ? '<option value="vehicles">Vehicle</option>' : ''}
                    ${UseLoadout ? '<option value="weapons">Weapon</option>' : ''}
                `);
            }
        });
    });

    window.$('.apporvalCancelButton').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.buyApporval').css('display', 'none');
    });

    window.$('.apporvalAcceptButton').on('click', () => {
        window.$.post(`https://${GetParentResourceName()}/buyItem`, JSON.stringify({
            item: SelectedBuyItem
        }), function(res) {
            if (res) {
                window.$('.pop-ups').css('display', 'none');
                window.$('.buyApporval').css('display', 'none');
            }
        });
    });

    window.$('.productEditButton').on('click', () => {
        if (!window.$('#priceinputedit').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.PriceEmpty
            }));
            return;
        };
        if (!window.$('#descriptioninputedit').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.DescriptionEmpty
            }));
            return;
        };
        window.$.post(`https://${GetParentResourceName()}/editItem`, JSON.stringify({
            item: SelectedEditItem,
            price: window.$('#priceinputedit').val(),
            description: window.$('#descriptioninputedit').val()
        }));
        window.$('.pop-ups').css('display', 'none');
        window.$('.editProduct').css('display', 'none');
    });

    window.$('#categoryselect').on('change', (event) => {
        if (event.target.value == 'all') {
            SelectedCategory = null;
        } else {
            SelectedCategory = event.target.value;
        }
        if (WasMyProductsOpen) {
            CreatePlayerItems(PlayerListedItems);
        } else if (AuctionMyProductsOpen) {
            CreateAuctionPlayerItems(PlayerListedItems);
        } else if (CurrentPage == 'auction') {
            CreateAuctionItems(AuctionItems);
        } else {
            CreateShopItems(ShopItems);
        }
    });

    window.$('#searchinput').on('input', () => {
        SearchInput = window.$('#searchinput').val();
        if (WasMyProductsOpen) {
            CreatePlayerItems(PlayerListedItems);
        } else if (AuctionMyProductsOpen) {
            CreateAuctionPlayerItems(PlayerListedItems);
        } else if (CurrentPage == 'auction') {
            CreateAuctionItems(AuctionItems);
        } else {
            CreateShopItems(ShopItems);
        }
    });

    window.$('#addadd').on('click', () => {
        if ((AdvertisementCounter / 60) != AdvertisementSettings.Max) {
            AdvertisementCounter += 15;
            window.$('#advertisetime').html(GetAdTime());
            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
            window.$('#adtotal').html('$'+AdvertisementSettings.Price * AdvertisementCounter);
        } else {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.MaxTime
            }));
        }
    });

    window.$('#adremove').on('click', () => {
        if ((AdvertisementCounter / 60) != AdvertisementSettings.Min) {
            AdvertisementCounter -= 15;
            window.$('#advertisetime').html(GetAdTime());
            window.$('#priceperhour').html(`$${AdvertisementSettings.Price * 60}/hour`);
            window.$('#adtotal').html('$'+AdvertisementSettings.Price * AdvertisementCounter);
        } else {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.MinTime
            }));
        }
    });

    window.$('.buyAdvertiseButton').on('click', () => {
        window.$.post(`https://${GetParentResourceName()}/buyAdvertisement`, JSON.stringify({
            item: AdvertisementItem,
            price: AdvertisementSettings.Price * AdvertisementCounter,
            time: AdvertisementCounter
        }), function(res) {
            if (res) {
                window.$('.pop-ups').css('display', 'none');
                window.$('.advertiseProduct').css('display', 'none');
            }
        });
    });

    window.$('#auctiontimeradd').on('click', () => {
        if ((AuctionTiemrCounter / 60) != AuctionSettings.Max) {
            AuctionTiemrCounter += 15;
            window.$('#timeinput').html(GetAuctionTime());
        } else {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.MaxTime
            }));
        }
    });

    window.$('#auctiontimerremove').on('click', () => {
        if ((AuctionTiemrCounter / 60) != AuctionSettings.Min) {
            AuctionTiemrCounter -= 15;
            window.$('#timeinput').html(GetAuctionTime());
        } else {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.MinTime
            }));
        }
    });

    window.$('#placeoffer').on('click', () => {
        if (!window.$('#offerprice').val()) return;
        window.$.post(`https://${GetParentResourceName()}/placeOffer`, JSON.stringify({
            product: AuctionSelectedOfferItem,
            offer: window.$('#offerprice').val()
        }), function(res) {
            if (res) {
                window.$('.pop-ups').css('display', 'none');
                window.$('.makeOffer').css('display', 'none');
            }
        });
    });

    window.$('#addproduct').on('click', () => {
        if (CurrentPage == 'shop') {
            window.$('.pop-ups').css('display', 'flex');
            window.$('.addProduct').css('display', 'flex');
        } else {
            window.$('.pop-ups').css('display', 'flex');
            window.$('.addAuction').css('display', 'flex');
            AuctionTiemrCounter = 60 * AuctionSettings.Min;
            window.$('#timeinput').html(GetAuctionTime());
        }
    });

    window.$('#closeproducts').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.addProduct').css('display', 'none');
    });

    window.$('#addproductnormal').on('click', () => {
        if (!SelectedItemType) return;
        if (!SelectedItem) return;
        if (SelectedItemType == 'items' && !window.$('#quantityinput').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.QuantityEmpty
            }));
            return;
        };
        if (!window.$('#priceinput').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.PriceEmpty
            }));
            return;
        };
        if (!window.$('#descriptioninput').val()) {
            window.$.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({
                text: Translation.DescriptionEmpty
            }));
            return;
        };
        window.$.post(`https://${GetParentResourceName()}/addItem`, JSON.stringify({
            type: 'normal',
            itemType: SelectedItemType,
            item: SelectedItem,
            quantity: window.$('#quantityinput').val(),
            price: window.$('#priceinput').val(),
            description: window.$('#descriptioninput').val()
        }), function(result) {
            if (result) {
                SelectedItemType = null;
                SelectedItem = null;
                window.$('#quantityinput').val('');
                window.$('#priceinput').val('');
                window.$('#descriptioninput').val('');
                window.$('.pop-ups').css('display', 'none');
                window.$('.addProduct').css('display', 'none');
                window.$('#playeritems').html('');
                window.$('#playeritems').append('<option value="" disabled selected>Select a item</option>');
                window.$('#itemtype').html('');
                window.$('#itemtype').append(`
                    <option value="" disabled selected>Select an item type</option>
                    <option value="items">Item</option>
                    ${DisableVehicles} === false ? '<option value="vehicles">Vehicle</option>' : ''}
                    ${UseLoadout ? '<option value="weapons">Weapon</option>' : ''}
                `);
            }
        });
    });

    window.$('#myearningsbutton').on('click', () => {
        window.$.post(`https://${GetParentResourceName()}/getPlayerStats`, JSON.stringify({ }), function(stats) {
            if (stats) {
                window.$('.pop-ups').css('display', 'flex');
                window.$('.myEarningBox').css('display', 'flex');
                window.$('#earningstotal').html('$'+stats.total);
                window.$('#earningstotalnumber').html(stats.totalsold);
                window.$('#earningsdaily').html('$'+stats.daily);
            }
        });
    });

    window.$('#closeearnings').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.myEarningBox').css('display', 'none');
    });

    window.$('#closeauctionproducts').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.addAuction').css('display', 'none');
    });

    window.$('#myproducts').on('click', () => {
        if (CurrentPage == 'shop') {
            window.$('#shopproducts').css('display', 'none');
            window.$('#shopmyproductss').css('display', 'flex');
            CreatePlayerItems(PlayerListedItems);
        } else {
            window.$('#auctionproduct').css('display', 'none');
            window.$('#myauctionproduct').css('display', 'flex');
            CreateAuctionPlayerItems(PlayerListedItems);
        }
    });

    window.$('#closeeditproduct').on('click', () => {
        window.$('.pop-ups').css('display', 'none');
        window.$('.editProduct').css('display', 'none');
    });

    window.addEventListener('message', event => {
        switch (event.data.type) {
            case 'ShowUI':
                CurrentPage = 'shop';
                SelectedCategory = null;
                SearchInput = null;
                DisableVehicles = event.data.disableVehicles;
                UseLoadout = event.data.useLoadout;
                ShowSellerName = event.data.showSellerName;
                window.$('#searchinput').val('');
                window.$('#categoryselect').html('');
                
                if (event.data.HaveAccessToSell) {
                    window.$('#menusBox').show();

                } else {
                    window.$('#menusBox').hide();
                }

                window.$('#categoryselect').append(`
                    <option value="" disabled selected>Select an option</option>
                    <option value="all">All</option>
                    <option value="items">Items</option>
                    ${event.data.disableVehicles === false ? '<option value="vehicles">Vehicles</option>' : ''}
                    ${event.data.useLoadout ? '<option value="weapons">Weapons</option>' : ''}
                `);
                window.$('#itemtype').html('');
                window.$('#itemtype').append(`
                    <option value="" disabled selected>Select an item type</option>
                    <option value="items">Item</option>
                    ${event.data.disableVehicles === false ? '<option value="vehicles">Vehicle</option>' : ''}
                    ${event.data.useLoadout ? '<option value="weapons">Weapon</option>' : ''}
                `);
                window.$('#auctionitemtype').html('');
                window.$('#auctionitemtype').append(`
                    <option value="" disabled selected>Select an item type</option>
                    <option value="items">Item</option>
                    ${event.data.disableVehicles === false ? '<option value="vehicles">Vehicle</option>' : ''}
                    ${event.data.useLoadout ? '<option value="weapons">Weapon</option>' : ''}
                `);
                window.$('.generalBox').css('display', 'flex');
                window.$('#shopbutton').addClass('selected');
                window.$('#shopproducts').css('display', 'flex');
                if (event.data.marketType == 'blackmarket') {
                    window.$('body').addClass('blackmarket');
                } else {
                    window.$('body').removeClass('blackmarket');
                }
                CreateShopItems(event.data.shopItems);
                ShopItems = event.data.shopItems;
                PlayerItems = event.data.playerItems;
                PlayerVehicles = event.data.playerVehicles;
                PlayerListedItems = event.data.playerListedItems;
                AdvertisementSettings = event.data.advertisement;
                PlayerWeapons = event.data.playerWeapons;
                AuctionItems = event.data.auctionItems;
                AuctionSettings = event.data.auction;
                Translation = event.data.translation;
                TranslateUI();
                break;
            case 'UpdateUI':
                if (CurrentPage == 'shop') CreateShopItems(event.data.shopItems);
                if (WasMyProductsOpen) CreatePlayerItems(event.data.playerListedItems);
                if (AuctionMyProductsOpen) CreateAuctionPlayerItems(event.data.playerListedItems);
                if (CurrentPage == 'auction') CreateAuctionItems(event.data.auctionItems);
                ShopItems = event.data.shopItems;
                PlayerItems = event.data.playerItems;
                PlayerVehicles = event.data.playerVehicles;
                PlayerListedItems = event.data.playerListedItems;
                AuctionItems = event.data.auctionItems;
                break;
            case 'ShowNotification':
                window.$('.notifyText').html(event.data.notification);
                window.$('.notifyBox').css('display', 'flex');
                setTimeout(() => {
                    window.$('.notifyBox').css('display', 'none');
                }, 5000);
                break;
        }
    });

    window.$(document).keyup(function(e) {
        const charCode = e.key;
        if (charCode == "Escape") {
            window.$('.generalBox').css('display', 'none');
            window.$('#auctionproduct').css('display', 'none');
            window.$('#myauctionproduct').css('display', 'none');
            window.$('#shopmyproductss').css('display', 'none');
            window.$('#shopproducts').css('display', 'none');
            window.$('.pop-ups').css('display', 'none');
            window.$('.makeOffer').css('display', 'none');
            window.$('.buyApporval').css('display', 'none');
            window.$('.advertiseProduct').css('display', 'none');
            window.$('.editProduct').css('display', 'none');
            window.$('.addProduct').css('display', 'none');
            window.$('.myEarningBox').css('display', 'none');
            window.$('#shopbutton').removeClass('selected');
            window.$('#auctionbutton').removeClass('selected');
            window.$.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ }));
        }
    });

});