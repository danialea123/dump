let ESX = null;
let cam = null;
let battlePassData = [];
let uiOpen = false;
const rndAnimations = [
    {
        anim: 'idle',
        dict: 'anim@heists@heist_corona@team_idles@male_a',
    },
    {
        anim: 'idle_b',
        dict: 'amb@world_human_hang_out_street@male_b@idle_a',
    },
    {
        anim: 'idle_a',
        dict: 'random@countrysiderobbery',
    },
];
let esxTick = setTick(() => {
    if (ESX) return clearTick(esxTick);
    emit('esx:getSharedObject', (obj) => (ESX = obj));
});
if (config.debug) {
    SetTimecycleModifier('default')
    FreezeEntityPosition(PlayerPedId(), false)
    DisplayRadar(true)
}
const ParticleEffect = async (dict, particleName, coords, scale, time) => {
    let particleInterval = setInterval(() =>{
        RequestNamedPtfxAsset(dict)
        if(HasNamedPtfxAssetLoaded(dict)){
            clearInterval(particleInterval)
        }
    }, 1000)
	UseParticleFxAssetNextCall(dict)
    let particleHandle = StartNetworkedParticleFxLoopedOnEntity(particleName, PlayerPedId(), 0.0, 0.0, -3.0, 0.0, 0.0, 0.0, scale, false, false, false)
	SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
    await Delay(time)
	StopParticleFxLooped(particleHandle, false)
	return particleHandle
}
const PlayUIAnim = () => {
    const selectedAnimIndex = Math.floor(Math.random() * rndAnimations.length)
    const selectedAnim = rndAnimations[selectedAnimIndex]
    let animInterval = setInterval(() => {
        RequestAnimDict(selectedAnim.dict)
        if (HasAnimDictLoaded(selectedAnim.dict)) {
            clearInterval(animInterval)
        }
    }, 1000)
    TaskPlayAnim(PlayerPedId(), selectedAnim.dict, selectedAnim.anim, 2.0, 2.5, -1, 49, 0, 0, 0, 0)
}
const setPlayerCamera = () => {
    if (cam) {
        RenderScriptCams(false, true, 1000, true, false)
        DestroyCam(cam, true)
        cam = null
    }
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
    let [x, y, z] = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.65)
    let [x2, y2, z2] = GetEntityCoords(PlayerPedId())
    SetCamCoord(cam, x, y, z)
    PointCamAtCoord(cam, x2, y2, z2 + 0.65)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 100, true, true)
}
const toggleUI = (toggle) => {
    //if(battlePassData){
        //if(battlePassData.battlePass != null){
            uiOpen = toggle;
            if (toggle) {
                DoScreenFadeOut(100)
                DisplayRadar(false)
                PlayUIAnim()
                setTimeout(() => {
                    SendNuiMessage(JSON.stringify({
                        type: 'TOGGLE_UI',
                        toggle: toggle,
                    }))
                    SendNuiMessage(JSON.stringify({
                        type: 'SET_REWARDS',
                        rewards: config.items,
                    }))
                    SetNuiFocus(true, true)
                    FreezeEntityPosition(PlayerPedId(), true)
                    SetTimecycleModifier("spectator3")
                    setPlayerCamera()
                    DoScreenFadeIn(10)
                    emit("openBattlePass")
                }, 750)
            } else {
                SetTimecycleModifier('default')
                FreezeEntityPosition(PlayerPedId(), false)
                DisplayRadar(true)
                SetNuiFocus(false, false)
                ClearPedTasks(PlayerPedId())
                if (cam) {
                    RenderScriptCams(false, true, 1000, true, false)
                    DestroyCam(cam, true)
                    cam = null
                }
                SendNuiMessage(JSON.stringify({
                    type: 'TOGGLE_UI',
                    toggle: toggle,
                }))
            }
        //}
    //}
}
const LevelUP = (level) => {
    let [x,y,z] = GetEntityCoords(PlayerPedId())
    z -= 6.0
    const coords = {x,y,z}
    ParticleEffect('scr_indep_fireworks', 'scr_indep_firework_trailburst', coords, 3.0, 7000)
    setTimeout(() =>{
        ParticleEffect('scr_indep_fireworks', 'scr_indep_firework_shotburst', coords, 3.0, 7000)
    }, 1000)
    SendNuiMessage(JSON.stringify({
        type : 'TOGGLE_LEVELUP', 
        newLevel : level,
        nextReward : GetItemByLevel(level),
        currentReward : GetPrevItemByLevel(level)
    }))
    PlaySoundFrontend(-1, "RANK_UP", "HUD_AWARDS", 1)
}
const SetCurrentXp = (xp) =>{
    SendNuiMessage(JSON.stringify({
        type : 'SET_CURRENT_XP',
        xp : xp
    }))
}
const SetCurrentLevel = (level) => {
    SendNuiMessage(JSON.stringify({
        type : 'SET_CURRENT_LEVEL',
        level : level
    }))
}
const SetTakenRewards = (amount) =>{
    SendNuiMessage(JSON.stringify({
        type : 'SET_TAKEN_REWARDS',
        amount : amount
    }))
}
const SetCurrentSeason = () => {
    SendNuiMessage(JSON.stringify({
        type : 'SET_SEASON',
        season : config.season
    }))
}

onNet('js:OpenMenu', () =>{
    toggleUI(true)
});

onNet('fullycustom-bp:SetTakenRewards', SetTakenRewards);
onNet('fullycustom-bp:LevelIncreased', LevelUP);
onNet('fullycustom-bp:AddXp', (type) => {
    let xpAmount = 0;
    switch (type) {
        case 'turf_xp':
            xpAmount = config.turf_xp;
            break;
        case 'kill_player':
            xpAmount = config.kill_xp;
            break;
        case 'drugs':
            xpAmount = config.drug_xp;
            break;
        default:
            return;
    }
    emitNet('fullycustom-bp:Server:Addxp', xpAmount);
});
onNet('fullycustom-bp:GetData', (data) => {
    battlePassData = data;
    SetCurrentSeason();
    SetCurrentXp(battlePassData.xp);
    SetCurrentLevel(battlePassData.level);
});
onNet('fullycustom-bp:LevelsClaimed', (levelsClaimed) => {
    config.items.forEach(item => {
        const levelClaimed = levelsClaimed.filter((x) => x.level == item.level);
        item.canClaimItem = levelClaimed[0].canClaimItem;
    });
});
onNet('fullycustom-bp:battlePassEnded', () => {
    battlePassData = null;
});
onNet('fullycustom-bp:SetCurrentXp', SetCurrentXp);
RegisterNuiCallbackType('ClaimReward')
on('__cfx_nui:ClaimReward', (data, cb) => {
    emitNet('fullycustom-bp:ClaimReward', data);

});
RegisterNuiCallbackType('Close')
on('__cfx_nui:Close', (data, cb) => {
    toggleUI(false);
});

RegisterNuiCallbackType('NUIReady')
on('__cfx_nui:NUIReady', (data, cb) => {
    SendNuiMessage(JSON.stringify({
        type: 'SET_REWARDS',
        rewards: config.items,
    }))
});