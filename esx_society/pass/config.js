config = {}

config.debug = true
config.open = 'f7'

config.season = 1
config.base_xp = 1000

config.turf_xp = 1000
config.kill_xp = 1000
config.drug_xp = 1000

config.min_money = 500
config.max_money = 1000

config.items = [
    {
        level: 1,
        image: 'black_money.png',
        label: 'Money',
        type: 'addMoney',
        item: 50000,
        amount: 50000
    },
    {
        level: 2,
        image: '25.png',
        label: 'DCoin',
        type: 'addCoin',
        item: 25,
        amount: 25
    },
    {
        level: 3,
        image: 'wine.png',
        label: 'Sharab',
        type: 'addInventoryItem',
        item: 'wine',
        amount: 10
    },
    {
        level: 4,
        image: 'standarddiamond.png',
        label: 'Standard Diamond Case',
        type: 'addInventoryItem',
        item: 'standarddiamond',
        amount: 1
    },
    {
        level: 5,
        image: 'highrim.png',
        label: 'Laastik',
        type: 'addInventoryItem',
        item: 'highrim',
        amount: 2
    },
    {
        level: 6,
        image: 'bulletproof.png',
        label: 'Armor 50',
        type: 'addInventoryItem',
        item: 'armour',
        amount: 1
    },
    {
        level: 7,
        image: 'black_money.png',
        label: 'Money',
        type: 'addMoney',
        item: 100000,
        amount: 100000
    },
    {
        level: 8,
        image: 'fixkit.png',
        label: 'Kit Taamir',
        type: 'addInventoryItem',
        item: 'fixkit',
        amount: 2
    },
    {
        level: 9,
        image: 'WEAPON_KNUCKLE.png',
        label: 'Panje Box',
        type: 'addWeapon',
        item: 'WEAPON_KNUCKLE',
        amount: 0
    },
    {
        level: 10,
        image: 'standarditem.png',
        label: 'Standard Item Case',
        type: 'addInventoryItem',
        item: 'standarditem',
        amount: 1
    },
    {
        level: 11,
        image: '25.png',
        label: 'DCoin',
        type: 'addCoin',
        item: 25,
        amount: 25
    },
    {
        level: 12,
        image: 'black_money.png',
        label: 'Money',
        type: 'addMoney',
        item: 150000,
        amount: 150000
    },
    {
        level: 13,
        image: 'WEAPON_VINTAGEPISTOL.png',
        label: 'Vintage Pistol',
        type: 'addWeapon',
        item: 'WEAPON_VINTAGEPISTOL',
        amount: 0
    },
    {
        level: 14,
        image: '50.png',
        label: 'DCoin',
        type: 'addCoin',
        item: 50,
        amount: 50
    },
    {
        level: 15,
        image: 'black_money.png',
        label: 'Money',
        type: 'addMoney',
        item: 200000,
        amount: 200000
    },
    {
        level: 16,
        image: 'standarddiamond.png',
        label: 'Standard Diamond Case',
        type: 'addInventoryItem',
        item: 'standarddiamond',
        amount: 2
    },
    {
        level: 17,
        image: 'rccar.png',
        label: 'Mashin Controli',
        type: 'addInventoryItem',
        item: 'rccar',
        amount: 1
    },
    {
        level: 18,
        image: 'standardgun.png',
        label: 'Standard Gun Case',
        type: 'addInventoryItem',
        item: 'standardgun',
        amount: 1
    },
    {
        level: 19,
        image: 'black_money.png',
        label: 'Money',
        type: 'addMoney',
        item: 250000,
        amount: 250000
    },
    {
        level: 20,
        image: '100.png',
        label: 'DCoin',
        type: 'addCoin',
        item: 100,
        amount: 100
    },
    {
        level: 21,
        image: 'radiocar.png',
        label: 'Radio Mashin',
        type: 'addInventoryItem',
        item: 'radiocar',
        amount: 1
    },
    {
        level: 22,
        image: 'WEAPON_HATCHET.png',
        label: 'Hatchet',
        type: 'addWeapon',
        item: 'WEAPON_HATCHET',
        amount: 0
    }, 
    {
        level: 23,
        image: 'standardgun.png',
        label: 'Standard Gun Case',
        type: 'addInventoryItem',
        item: 'standardgun',
        amount: 1
    }, 
    {
        level: 24,
        image: 'skate.png',
        label: 'Skate',
        type: 'addInventoryItem',
        item: 'skate',
        amount: 1
    },
    {
        level: 25,
        image: 'black_money.png',
        label: '300K Money',
        type: 'addMoney',
        item: 300000,
        amount: 300000
    },
    {
        level: 26,
        image: 'fixter.png',
        label: 'Docharkhe Fixter',
        type: 'addCar',
        item: 'fixter',
        amount: 1
    },
    {
        level: 27,
        image: 'lsd.png',
        label: 'LSD',
        type: 'addInventoryItem',
        item: 'lsd',
        amount: 1
    },
    {
        level: 28,
        image: 'gamepad.png',
        label: 'GamePad',
        type: 'addInventoryItem',
        item: 'gamepad',
        amount: 1
    },
    {
        level: 29,
        image: 'enduro.png',
        label: 'Motor Enduro',
        type: 'addCar',
        item: 'enduro',
        amount: 1
    },
    {
        level: 30,
        image: 'standardcar.png',
        label: 'Standard Car Case',
        type: 'addInventoryItem',
        item: 'standardcar.png',
        amount: 1
    },
]

const Delay = (ms) => {
    return new Promise(res => setTimeout(res, ms))
}
const GetItemByLevel = (level) =>{
    const data = config.items.filter((item) => item.level == level)
    return data[0] || false
}
const GetNextItemByLevel = (level) =>{
    const data = config.items.filter((item) => item.level == level + 1)
    return data[0] || false
}
const GetPrevItemByLevel = (level) =>{
    const data = config.items.filter((item) => item.level == level - 1)
    return data[0] || false
}
const calculateRemainingDay = (seconds) => {
    seconds = Number(seconds);
    var d = Math.floor(seconds / (3600 * 24));
    var h = Math.floor(seconds % (3600 * 24) / 3600);
    var m = Math.floor(seconds % 3600 / 60);
    var s = Math.floor(seconds % 60);
    var dDisplay = d + (d == 1 ? " day, " : " days, ");
    var hDisplay = h + (h == 1 ? " hour, " : " hours, ");
    var mDisplay = m + (m == 1 ? " minute, " : " minutes, ");
    var sDisplay = s + (s == 1 ? " second" : " seconds");
    return { display: dDisplay + hDisplay + mDisplay + sDisplay, values: [d, h, m, s] };
}
function randomInteger(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}