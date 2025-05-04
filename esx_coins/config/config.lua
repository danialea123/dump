cfg = cfg or {}

-- local isServer = IsDuplicityVersion()

cfg.storeUrl = "https://loja.cidadebela.com"

cfg.columnName = "coins"

cfg.commands = {
  openUi = "loja" --[[ /loja ]],
  admin = {
    give = {
      command = "givecoin",
      permission = "dono.permissao"
    },
    remove = {
      command = "removecoin",
      permission = "dono.permissao"
    },
    set = {
      command = "setcoin",
      permission = "donodono.permissao"
    },
    giveall = {
      command = "coinstoall",
      permission = "dono.permissao",
    }
  }
}

-- if isServer then 
   
-- end


cfg.roulette = {
  price = 50,
  types = {
    ["lendario"] = {
      porcent = 0.1,
      notifyAll = {
        chat = {
          enabled = true,
          message = "{nome} {sobrenome} pegou um item LENDÁRIO na Roleta da Sorte! ({item})",
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(255, 200, 0, 1) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>'
        }, 
        notify = true
      },
    },
    ["epico"] = {
      porcent = 0.2,
      notifyAll = {
        chat = {
          enabled = true,
          message = "{nome} {sobrenome} pegou um item ÉPICO na Roleta da Sorte! ({item})",
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(255, 0, 43, 0.8) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>'
        }, 
        notify = true
      },
    },
    ["raro"] = {
      porcent = 0.3,
      notifyAll = {
        chat = {
          enabled = true,
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, #00ddff 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>',
          message = "{nome} {sobrenome} pegou um item RARO na Roleta da Sorte! ({item})"
        }, 
        notify = true
      },
    },
    ["normal"] = {
      porcent = 0.99,
      notifyAll = {
        chat = {
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(42,255,142,1) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>',
          enabled = false,
          message = "{nome} {sobrenome} pegou um item NORMAL na Roleta da Sorte! ({item})"
        }, 
        notify = true
      },
    }
  },
  items = {
      {
        productType = "coin",
        idname = "50",
        name = "50 dCoin",
        amount = 50,
        type = "normal",
      }, 
      {
        productType = "coin",
        idname = "100",
        name = "100 dCoin",
        amount = 100,
        type = "normal",
      },
      {
        productType = "coin",
        idname = "25",
        name = "25 dCoin",
        amount = 25,
        type = "normal",
      }, 
      {
        productType = "money",
        idname = "100000",
        name = "100 K",
        amount = 1,
        type = "raro",
      },
      {
        productType = "item",
        idname = "rccar",
        name = "Mashin Controli",
        amount = 1,
        type = "raro",
      }, 
      {
        productType = "item",
        idname = "fixkit",
        name = "Kit Taamir",
        amount = 1,
        type = "raro",
      },
      {
        productType = "money",
        idname = "1000000",
        name = "1 Million",
        amount = 1,
        type = "raro",
      },
      {
        productType = "money",
        idname = "4000000",
        name = "4 Million",
        amount = 1,
        type = "epico",
      },
      {
        productType = "weapon",
        idname = "WEAPON_KNIFE",
        name = "Knife",
        amount = 1,
        type = "raro",
      },
      {
        productType = "item",
        idname = "vodka",
        name = "Vodka",
        amount = 1,
        type = "raro",
      },
      {
        productType = "item",
        idname = "whisky",
        name = "Whisky",
        amount = 1,
        type = "raro",
      },
      {
        productType = "weapon",
        idname = "WEAPON_ASSAULTRIFLE_MK2",
        name = "Assault Rifle",
        amount = 1,
        type = "epico",
      },
      {
        productType = "item",
        idname = "highrim",
        name = "Laastik",
        amount = 1,
        type = "epico",
      },
      {
        productType = "item",
        idname = "radiocar",
        name = "Radio Mashin",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "money",
        idname = "7000000",
        name = "7 Million",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "weapon",
        idname = "WEAPON_KNUCKLE",
        name = "Panje Box",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "item",
        idname = "lsd",
        name = "LSD",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "item",
        idname = "switch",
        name = "Nintendo",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "item",
        idname = "gpsdetector",
        name = "GPS Detector",
        amount = 1,
        type = "normal",
      },
      {
        productType = "item",
        idname = "gpspanel",
        name = "GPS Panel",
        amount = 1,
        type = "normal",
      },
      {
        productType = "item",
        idname = "cargps",
        name = "Vehicle GPS",
        amount = 1,
        type = "lendario",
      },
      --[[{
        productType = "item",
        idname = "vipouro",
        name = "vipouro",
        amount = 1,
        type = 'epico',
        onBuy = function(source,user_id)
          if isServer then 
            local user_id = vRP.getUserId(source)
            vRP.addUserGroup(user_id,"Platinum")
            vRP.giveMoney(user_id,10000)
            cfg.giveCar({user_id = user_id, model = "x6m"})
            --execute this content server-side after buy action
          else 
            --execute this content client-side after buy action
          end
        end,
        temporary = {
          enable = true,
          days = 10,
          onRemove = function(source,user_id)
            if isServer then 
            vRP.removeUserGroup(user_id,"Platinum")
            vRP.removeUserGroup(user_id,"Barco")
            end
          end
        },
      },]]--
      --[[{
        productType = "item",
        idname = "vipdiamante",
        name = "vipdiamante",
        amount = 1,
        type = 'lendario',
        onBuy = function(source,user_id)
          if isServer then 
            local user_id = vRP.getUserId(source)
            vRP.addUserGroup(user_id,"Diamond")
            vRP.giveMoney(user_id,100000)
            --execute this content server-side after buy action
          else 
            --execute this content client-side after buy action
          end
        end,
        temporary = {
          enable = true,
          days = 10,
          onRemove = function(source,user_id)
          end
        },
      },]]--
  }
}


cfg.coinName = 'Coins'

cfg.products = {
  ["Items"] = {
    {
      productType = "item",
      idname = "gpspanel",
      name = "GPS Panel",
      amount = 1,
      price = 100,
    },
    {
      productType = "item",
      idname = "cargps",
      name = "Vehicle GPS",
      amount = 1,
      price = 2,
    },
    {
      productType = "item",
      idname = "binoculars",
      name = "Doorbin",
      amount = 1,
      price = 400,
    },
    {
      productType = "item",
      idname = "cardgame",
      name = "Uno",
      amount = 1,
      price = 100,
    },
    {
      productType = "item",
      idname = "rccar",
      amount = 1,
      name = "Mashin Controli",
      price = 100,
    },
    {
      productType = "item",
      idname = "monk_punk",
      amount = 1,
      name = "Monkey Punk",
      price = 750,
    },
    {
      productType = "item",
      idname = "pig_angel",
      amount = 1,
      name = "Pig Angel",
      price = 750,
    },
    {
      productType = "item",
      idname = "monky",
      amount = 1,
      name = "Monky",
      price = 600,
    },
    {
      productType = "item",
      idname = "buttercup",
      amount = 1,
      name = "Buttercup",
      price = 600,
    },
    {
      productType = "item",
      idname = "boombox",
      amount = 1,
      name = "BoomBox",
      price = 300,
    },
    {
      productType = "item",
      idname = "adr",
      amount = 1,
      name = "Adrenaline",
      price = 15,
    },
    {
      productType = "item",
      idname = "dino",
      amount = 1,
      name = "Dino",
      price = 400,
    },
    {
      productType = "item",
      idname = "notebook",
      amount = 1,
      name = "Daftarche",
      price = 10,
    },
    --[[{
      productType = "item",
      idname = "vipdiamante",
      name = "VIP Diamante",
      amount = 10,
      price = 3000,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          vRP.addUserGroup(user_id,"Platina")
          vRP.giveMoney(user_id,1000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end,
      temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },
    },]]--
      {
      productType = "item",
      idname = "lsd",
      name = "LSD",
      amount = 1,
      price = 7,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          vRP.addUserGroup(user_id,"InstaVerify")
          --vRP.giveMoney(user_id,1000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "yusuf",
      name = "Skin Talaei",
      amount = 1,
      price = 7,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          --vRP.addUserGroup(user_id,"InstaVerify")
          vRP.giveMoney(user_id,2000000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "phone",
      name = "Gooshi",
      amount = 1,
      price = 7,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          --vRP.addUserGroup(user_id,"InstaVerify")
          vRP.giveMoney(user_id,5000000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "gamepad",
      name = "GamePad",
      amount = 1,
      price = 300,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          --vRP.addUserGroup(user_id,"InstaVerify")
          vRP.giveMoney(user_id,5000000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "campfire",
      amount = 1,
      name = "Camp Fire",
      price = 3,
    },
    {
      productType = "item",
      idname = "m_bags_1_120_0",
      amount = 1,
      name = "Shamshir (M)",
      price = 400,
    },
    {
      productType = "item",
      idname = "m_chain_1_178_0",
      amount = 1,
      name = "Shamshir (M)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "m_chain_1_178_1",
      amount = 1,
      name = "Shamshir (M)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "m_chain_1_178_2",
      amount = 1,
      name = "Shamshir (M)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "m_chain_1_178_3",
      amount = 1,
      name = "Shamshir (M)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "m_chain_1_178_4",
      amount = 1,
      name = "Shamshir (M)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "m_chain_1_221_0",
      amount = 1,
      name = "Tabar (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_tshirt_1_242_0",
      amount = 1,
      name = "AK Jelo (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_tshirt_1_242_1",
      amount = 1,
      name = "AK Jelo (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_tshirt_1_242_3",
      amount = 1,
      name = "AK Jelo (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_tshirt_1_242_5",
      amount = 1,
      name = "AK Jelo (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_tshirt_1_242_8",
      amount = 1,
      name = "AK Jelo (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_tshirt_1_242_11",
      amount = 1,
      name = "AK Jelo (M)",
      price = 200,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_0",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_1",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_2",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_3",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_4",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_5",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "m_torso_1_645_6",
      amount = 1,
      name = "Lebas (M)",
      price = 500,
    },
    {
      productType = "item",
      idname = "f_bags_1_148_0",
      amount = 1,
      name = "Shamshir (F)",
      price = 400,
    },
    {
      productType = "item",
      idname = "f_chain_1_208_0",
      amount = 1,
      name = "Shamshir (F)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "f_chain_1_208_1",
      amount = 1,
      name = "Shamshir (F)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "f_chain_1_208_2",
      amount = 1,
      name = "Shamshir (F)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "f_chain_1_208_3",
      amount = 1,
      name = "Shamshir (F)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "f_chain_1_208_4",
      amount = 1,
      name = "Shamshir (F)",
      price = 1000,
    },
    {
      productType = "item",
      idname = "f_chain_1_205_0",
      amount = 1,
      name = "Tabar (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_tshirt_1_311_0",
      amount = 1,
      name = "AK Jelo (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_tshirt_1_311_1",
      amount = 1,
      name = "AK Jelo (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_tshirt_1_311_3",
      amount = 1,
      name = "AK Jelo (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_tshirt_1_311_5",
      amount = 1,
      name = "AK Jelo (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_tshirt_1_311_8",
      amount = 1,
      name = "AK Jelo (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_tshirt_1_311_11",
      amount = 1,
      name = "AK Jelo (F)",
      price = 200,
    },
    {
      productType = "item",
      idname = "f_torso_1_688_0",
      amount = 1,
      name = "Lebas (F)",
      price = 500,
    },
    {
      productType = "item",
      idname = "f_torso_1_688_1",
      amount = 1,
      name = "Lebas (F)",
      price = 500,
    },
    {
      productType = "item",
      idname = "f_torso_1_688_2",
      amount = 1,
      name = "Lebas (F)",
      price = 500,
    },

    {
      productType = "item",
      idname = "fixkit",
      amount = 1,
      name = "Kit Taamir",
      price = 5,
    },
    {
      productType = "item",
      idname = "radio",
      amount = 1,
      name = "Radio",
      price = 5,
    },
    {
        productType = "item",
        idname = "highrim",
        amount = 1,
        name = "Lastik Mashin",
        price = 4,
    },
    {
      productType = "item",
      idname = "shark_boi",
      amount = 1,
      name = "shark boi",
      price = 700,
    },
    {
        productType = "item",
        idname = "rockstar_editor",
        amount = 1,
        name = "Rockstar Editor",
        price = 100,
      },
    {
      productType = "item",
      idname = "skate",
      amount = 1,
      name = "SkateBoard",
      price = 100,
  },
    {
        productType = "item",
        idname = "radiocar",
        amount = 1,
        name = "Radio Mashin",
        price = 180,
      },
      {
        productType = "item",
        idname = "contract",
        amount = 1,
        name = "Contract",
        price = 15,
      },
  },
  ["Guns"] = {
    {
        productType = "weapon",
        idname = "WEAPON_KNUCKLE",
        amount = 1,
        name = "Panje Box",
        price = 100,
    },
    {
      productType = "weapon",
      idname = "WEAPON_ASSAULTRIFLE_MK2",
      amount = 1,
      name = "Assault Rifle MK2",
      price = 310,
    },
    {
      productType = "weapon",
      idname = "WEAPON_MILITARYRIFLE",
      amount = 1,
      name = "Military Rifle",
      price = 720,
    },
    {
      productType = "weapon",
      idname = "WEAPON_BULLPUPRIFLE_MK2",
      amount = 1,
      name = "Bullpup Rifle MK2",
      price = 330,
    },
    {
      productType = "weapon",
      idname = "WEAPON_POOLCUE",
      amount = 1,
      name = "Pool Cue",
      price = 120,
    },
    {
      productType = "weapon",
      idname = "WEAPON_HATCHET",
      amount = 1,
      name = "Tabar",
      price = 130,
    },
    {
      productType = "weapon",
      idname = "WEAPON_REVOLVER",
      amount = 1,
      name = "Revolver",
      price = 290,
    },
    {
      productType = "weapon",
      idname = "WEAPON_WRENCH",
      amount = 1,
      name = "Wrench",
      price = 140,
    },
    {
      productType = "weapon",
      idname = "WEAPON_AKVALO1",
      amount = 1,
      name = "VLOG",
      price = 800,
    },
    {
      productType = "weapon",
      idname = "WEAPON_HKG",
      amount = 1,
      name = "HKG",
      price = 800,
    },
    {
      productType = "weapon",
      idname = "WEAPON_RHRIF",
      amount = 1,
      name = "HS2",
      price = 720,
    },
    {
      productType = "weapon",
      idname = "WEAPON_MACHINEPISTOL",
      amount = 1,
      name = "Machine Pistol",
      price = 340,
    },
    {
      productType = "weapon",
      idname = "WEAPON_PISTOLGOLD",
      amount = 1,
      name = "Gold Pistol",
      price = 320,
    },
    {
      productType = "weapon",
      idname = "WEAPON_PISTOLLUXE",
      amount = 1,
      name = "Luxe Pistol",
      price = 310,
    },
    {
      productType = "weapon",
      idname = "WEAPON_AKDIAMOND",
      amount = 1,
      name = "Diamond AK",
      price = 600,
    },
    {
      productType = "weapon",
      idname = "WEAPON_DIAMONDCHROME",
      amount = 1,
      name = "AK D1",
      price = 620,
    },
    {
      productType = "weapon",
      idname = "WEAPON_M16G",
      amount = 1,
      name = "M16 G",
      price = 440,
    },
    {
      productType = "weapon",
      idname = "WEAPON_MINISMG",
      amount = 1,
      name = "Mini SMG",
      price = 360,
    },
    {
      productType = "weapon",
      idname = "WEAPON_MUSKET",
      amount = 1,
      name = "Musket",
      price = 800,
    },
    {
      productType = "weapon",
      idname = "WEAPON_COMBATMG",
      amount = 1,
      name = "Combat MG",
      price = 820,
    },
    {
      productType = "weapon",
      idname = "WEAPON_COMBATMG_MK2",
      amount = 1,
      name = "COMBATMG MK2",
      price = 850,
    },
    {
      productType = "weapon",
      idname = "WEAPON_MG",
      amount = 1,
      name = "MG",
      price = 820,
    },
  },
  ["Vehicles"] = {
    {
      productType = "car",
      model = "wolfsbane",
      name = "wolfsbane",
      price = 400,
    },
    {
      productType = "car",
      model = "hakuchou",
      name = "hakuchou",
      price = 550,
    },
    {
      productType = "car",
      model = "lwcla45",
      name = "AMG A45",
      price = 2400,
    },
    {
      productType = "car",
      model = "jp12",
      name = "jp12",
      price = 2800,
    },
    {
      productType = "car",
      model = "dm1200",
      name = "dm1200",
      price = 1400,
    },
    {
      productType = "car",
      model = "mule5",
      name = "mule5",
      price = 6000,
    },
    {
      productType = "car",
      model = "nero",
      name = "nero",
      price = 1200,
    },
    {
      productType = "car",
      model = "vigero2",
      name = "vigero2",
      price = 1000,
    },
    {
      productType = "car",
      model = "surfer3",
      name = "surfer3",
      price = 700,
    },
    {
      productType = "car",
      model = "double",
      name = "double",
      price = 700,
    },
    {
      productType = "car",
      model = "paragon",
      name = "paragon",
      price = 1100,
    },
    {
      productType = "car",
      model = "drafter",
      name = "drafter",
      price = 500,
    },
    {
      productType = "car",
      model = "reever",
      name = "reever",
      price = 400,
    },

    {
      productType = "car",
      model = "gomez",
      name = "Gomez",
      price = 750,
    },
    {
      productType = "car",
      model = "gazi",
      name = "Gazi",
      price = 750,
    },
    {
      productType = "car",
      model = "bikelete",
      name = "Bikelete",
      price = 800,
    },
    {
      productType = "car",
      model = "rmodbmwi8",
      name = "rmodbmwi8",
      price = 3800,
    },
    {
      productType = "car",
      model = "rmodpagani",
      name = "rmodpagani",
      price = 5100,
    },
    {
      productType = "car",
      model = "audis8om",
      name = "audis8om",
      price = 3200,
    },
    {
      productType = "car",
      model = "dena",
      name = "dena",
      price = 3100,
    },
    {
      productType = "car",
      model = "rs6c8",
      name = "rs6c8",
      price = 3450,
    },
    {
      productType = "car",
      model = "s65amg",
      name = "s65amg",
      price = 3500,
    },
    {
      productType = "car",
      model = "206",
      name = "206",
      price = 3200,
    },
    {
      productType = "car",
      model = "q820",
      name = "q820",
      price = 2950,
    },
    {
      productType = "car",
      model = "fescape",
      name = "FordScape",
      price = 2750,
    },
    {
      productType = "car",
      model = "370z",
      name = "NissanNismo",
      price = 3150,
    },
    {
      productType = "car",
      model = "frodygtr35",
      name = "frodygtr35",
      price = 8500,
    },
    {
      productType = "car",
      model = "evoque",
      name = "Evoque",
      price = 3070,
    },
    {
      productType = "car",
      model = "zl12017",
      name = "chevroletZL",
      price = 3000,
    },
    {
      productType = "car",
      model = "p207",
      name = "P207",
      price = 2950,
    },
    {
      productType = "car",
      model = "psabafn",
      name = "Pride",
      price = 2650,
    },
    {
      productType = "car",
      model = "m3f80",
      name = "m3f80",
      price = 3250,
    },
  },
}

cfg.imagesUrl = "./images/"


cfg.identity = {
  sobrenome = "firstname", --[[ Nome do campo de sobrenome, nome baseado nas tabelas.]]
  nome      = "name",
}


cfg.onlyNotifyPlayersOnStore = true --

cfg.webhooks = {
  buy = "https://discord.com/api/webhooks/859133813480488980/1fZ1AHJaQqv4IocEFk6mvvMze8i6nqjsinh9uhqv0ZBi_eBsqbfVYJK-9w3lb9dTjERA",
  roulette = "https://discord.com/api/webhooks/859133892363943938/wbWIW2Hseh3zf3haCaJ83iv5zZLYHnx9peABK86qShT3n-Rqym6hYoW19Yhf5mokVQap",
  commands = "https://discord.com/api/webhooks/859133734790889542/aRVOA_lolJRfcj0hmCI1wKVTQMXnHP_IH4vwLnsdeXUoKib4qjGqlcrZ11EVORdXK6PR",
  onremove = "https://discord.com/api/webhooks/859133667455926273/aGWQSaLlgMldYqJ79-hNjUTeIhq8l9azVxhMy0tyUXC6jVx-NA4PM5hyK8HgBvJAwiEP",
  info = {
    title  = 'Coins',
    footer = ''
  }
}

return cfg