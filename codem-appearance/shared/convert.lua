function FormatQBCoreData(data)
    return {
        sex = data.sex and
        (tonumber(data.sex) ~= nil and tonumber(data.sex) or (tonumber(data.sex.item) == nil and 0 or tonumber(data.sex.item))) or
        0,
        dad = data.face and (tonumber(data.face.item) == nil and 0 or tonumber(data.face.item)) or 0,
        skin_color = data.skin_color and (tonumber(data.skin_color.item) == nil and 0 or tonumber(data.skin_color.item)) or
        0,
        skin_opacity = data.skin_opacity and
        (tonumber(data.skin_opacity.item) == nil and 1.0 or tonumber(data.skin_opacity.item)) or 0.2,

        mom = data.face2 and (tonumber(data.face2.item) == nil and 0 or tonumber(data.face2.item)) or 21,
        skin_mom = data.skin_mom and (tonumber(data.skin_mom.item) == nil and 0 or tonumber(data.skin_mom.item)) or 21,
        skin_dad = data.skin_dad and (tonumber(data.skin_dad.item) == nil and 0 or tonumber(data.skin_dad.item)) or 0,
        face_md_weight = data.facemix and
        (tonumber(data.facemix.shapeMix) == nil and 50 or tonumber(data.facemix.shapeMix)) or 50,
        skin_md_weight = data.facemix and
        (tonumber(data.facemix.skinMix) == nil and 50 or tonumber(data.facemix.skinMix)) or 50,
        shoes_1 = data.shoes and (tonumber(data.shoes.item) == nil and 0 or tonumber(data.shoes.item)) or 0,
        shoes_2 = data.shoes and (tonumber(data.shoes.texture) == nil and 0 or tonumber(data.shoes.texture)) or 0,
        pants_1 = data.pants and (tonumber(data.pants.item) == nil and 0 or tonumber(data.pants.item)) or 0,
        pants_2 = data.pants and (tonumber(data.pants.texture) == nil and 0 or tonumber(data.pants.texture)) or 0,
        mask_1 = data.mask and (tonumber(data.mask.item) == nil and 0 or tonumber(data.mask.item)) or 0,
        mask_2 = data.mask and (tonumber(data.mask.texture) == nil and 0 or tonumber(data.mask.texture)) or 0,
        cheeks_1 = data.cheek_1 and (tonumber(data.cheek_1.item) == nil and 0 or tonumber(data.cheek_1.item)) or 0,
        cheeks_2 = data.cheek_2 and (tonumber(data.cheek_2.item) == nil and 0 or tonumber(data.cheek_2.item)) or 0,
        cheeks_3 = data.cheek_3 and (tonumber(data.cheek_3.item) == nil and 0 or tonumber(data.cheek_3.item)) or 0,
        moles_1 = data.moles and (tonumber(data.moles.item) == nil and 0 or tonumber(data.moles.item)) or 0,
        moles_2 = data.moles and (tonumber(data.moles.texture) == nil and 0 or tonumber(data.moles.texture)) or 0,
        blemishes_1 = data.blemishes and (tonumber(data.blemishes.item) == nil and 0 or tonumber(data.blemishes.item)) or
        0,
        blemishes_2 = data.blemishes and
        (tonumber(data.blemishes.texture) == nil and 0 or tonumber(data.blemishes.texture)) or 0,
        chest_1 = data.chest and (tonumber(data.chest.item) == nil and 0 or tonumber(data.chest.item)) or 0,
        chest_2 = data.chest_thickness and
        (tonumber(data.chest_thickness.item) == nil and 0 or tonumber(data.chest_thickness.item)) or 0,
        chest_3 = data.chest and (tonumber(data.chest.texture) == nil and 0 or tonumber(data.chest.texture)) or 0,
        bodyb_1 = data.body_blemishes and
        (tonumber(data.body_blemishes.item) == nil and 0 or tonumber(data.body_blemishes.item)) or 0,
        bodyb_2 = data.body_blemishes and
        (tonumber(data.body_blemishes.texture) == nil and 0 or tonumber(data.body_blemishes.texture)) or 0,
        bodyb_3 = data.body_blemishes_2 and
        (tonumber(data.body_blemishes_2.item) == nil and 0 or tonumber(data.body_blemishes_2.item)) or 0,
        bodyb_4 = data.body_blemishes_2 and
        (tonumber(data.body_blemishes_2.texture) == nil and 0 or tonumber(data.body_blemishes_2.texture)) or 0,
        arms = data.arms and (tonumber(data.arms.item) == nil and 0 or tonumber(data.arms.item)) or 0,
        arms_2 = data.arms and (tonumber(data.arms.texture) == nil and 0 or tonumber(data.arms.texture)) or 0,
        ears_1 = data.ear ~= nil and (tonumber(data.ear.item) == nil and -1 or tonumber(data.ear.item)) or -1,
        ears_2 = data.ear and (tonumber(data.ear.texture) == nil and 0 or tonumber(data.ear.texture)) or 0,
        chin_1 = data.chimp_bone_lowering and
        (tonumber(data.chimp_bone_lowering.item) == nil and 0 or tonumber(data.chimp_bone_lowering.item)) or 0,
        chin_2 = data.chimp_bone_lenght and
        (tonumber(data.chimp_bone_lenght.item) == nil and 0 or tonumber(data.chimp_bone_lenght.item)) or 0,
        chin_3 = data.chimp_bone_width and
        (tonumber(data.chimp_bone_width.item) == nil and 0 or tonumber(data.chimp_bone_width.item)) or 0,
        chin_4 = data.chimp_hole and (tonumber(data.chimp_hole.item) == nil and 0 or tonumber(data.chimp_hole.item)) or 0,
        age_1 = data.ageing and (tonumber(data.ageing.item) == nil and 0 or tonumber(data.ageing.item)) or 0,
        age_2 = data.ageing and (tonumber(data.ageing.texture) == nil and 0 or tonumber(data.ageing.texture)) or 0,
        complexion_1 = data.complexion and
        (tonumber(data.complexion.item) == nil and 0 or tonumber(data.complexion.item)) or 0,
        complexion_2 = data.complexion and
        (tonumber(data.complexion.texture) == nil and 0 or tonumber(data.complexion.texture)) or 0,
        eyebrows_1 = data.eyebrows and (tonumber(data.eyebrows.item) == nil and 0 or tonumber(data.eyebrows.item)) or 0,
        eyebrows_2 = data.eyebrows_2 and (tonumber(data.eyebrows_2.item) == nil and 0 or tonumber(data.eyebrows_2.item)) or
        0,
        eyebrows_3 = data.eyebrows and (tonumber(data.eyebrows.texture) == nil and 0 or tonumber(data.eyebrows.texture)) or
        0,
        eyebrows_5 = data.eyebrown_high and
        (tonumber(data.eyebrown_high.item) == nil and 0 or tonumber(data.eyebrown_high.item)) or 0,
        eyebrows_6 = data.eyebrown_forward and
        (tonumber(data.eyebrown_forward.item) == nil and 0 or tonumber(data.eyebrown_forward.item)) or 0,
        bracelets_1 = data.bracelet ~= nil and
        (tonumber(data.bracelet.item) == nil and -1 or tonumber(data.bracelet.item)) or -1,
        bracelets_2 = data.bracelet and (tonumber(data.bracelet.texture) == nil and 0 or tonumber(data.bracelet.texture)) or
        0,
        jaw_1 = data.jaw_bone_width and
        (tonumber(data.jaw_bone_width.item) == nil and 0 or tonumber(data.jaw_bone_width.item)) or 0,
        jaw_2 = data.jaw_bone_back_lenght and
        (tonumber(data.jaw_bone_back_lenght.item) == nil and 0 or tonumber(data.jaw_bone_back_lenght.item)) or 0,
        bags_1 = data.bag and (tonumber(data.bag.item) == nil and 0 or tonumber(data.bag.item)) or 0,
        bags_2 = data.bag and (tonumber(data.bag.texture) == nil and 0 or tonumber(data.bag.texture)) or 0,
        sun_1 = data.sun and (tonumber(data.sun.item) == nil and 0 or tonumber(data.sun.item)) or 0,
        sun_2 = data.sun and (tonumber(data.sun.texture) == nil and 0 or tonumber(data.sun.texture)) or 0,

        eye_squint = data.eye_opening and
        (tonumber(data.eye_opening.item) == nil and 0 or tonumber(data.eye_opening.item)) or 0,
        chain_1 = data.accessory and (tonumber(data.accessory.item) == nil and 0 or tonumber(data.accessory.item)) or 0,
        chain_2 = data.accessory and (tonumber(data.accessory.texture) == nil and 0 or tonumber(data.accessory.texture)) or
        0,
        glasses_1 = data.glass and (tonumber(data.glass.item) == nil and 0 or tonumber(data.glass.item)) or 0,
        glasses_2 = data.glass and (tonumber(data.glass.texture) == nil and 0 or tonumber(data.glass.texture)) or 0,
        beard_1 = data.beard and (tonumber(data.beard.item) == nil and 0 or tonumber(data.beard.item)) or 0,
        beard_2 = data.beard and (tonumber(data.beard.texture) == nil and 0 or tonumber(data.beard.texture)) or 0,
        beard_3 = data.beard_3 and (tonumber(data.beard_3.item) == nil and 0 or tonumber(data.beard_3.item)) or 0,
        beard_4 = 0,
        bproof_1 = data.vest and (tonumber(data.vest.item) == nil and 0 or tonumber(data.vest.item)) or 0,
        bproof_2 = data.vest and (tonumber(data.vest.texture) == nil and 0 or tonumber(data.vest.texture)) or 0,
        tshirt_1 = data["t-shirt"] and (tonumber(data["t-shirt"].item) == nil and 0 or tonumber(data["t-shirt"].item)) or
        0,
        tshirt_2 = data["t-shirt"] and
        (tonumber(data["t-shirt"].texture) == nil and 0 or tonumber(data["t-shirt"].texture)) or 0,
        nose_1 = data.nose_0 and (tonumber(data.nose_0.item) == nil and 0 or tonumber(data.nose_0.item)) or 0,
        nose_2 = data.nose_1 and (tonumber(data.nose_1.item) == nil and 0 or tonumber(data.nose_1.item)) or 0,
        nose_3 = data.nose_2 and (tonumber(data.nose_2.item) == nil and 0 or tonumber(data.nose_2.item)) or 0,
        nose_4 = data.nose_3 and (tonumber(data.nose_3.item) == nil and 0 or tonumber(data.nose_3.item)) or 0,
        nose_5 = data.nose_4 and (tonumber(data.nose_4.item) == nil and 0 or tonumber(data.nose_4.item)) or 0,
        nose_6 = data.nose_5 and (tonumber(data.nose_5.item) == nil and 0 or tonumber(data.nose_5.item)) or 0,
        lipstick_1 = data.lipstick and (tonumber(data.lipstick.item) == nil and 0 or tonumber(data.lipstick.item)) or 0,
        lipstick_2 = data.lipstick_thickness and
        (tonumber(data.lipstick_thickness.item) == nil and 0 or tonumber(data.lipstick_thickness.item)) or 0,
        lipstick_3 = data.lipstick and (tonumber(data.lipstick.texture) == nil and 0 or tonumber(data.lipstick.texture)) or
        0,
        lipstick_4 = 0,
        makeup_1 = data.makeup ~= nil and (tonumber(data.makeup.item) == nil and 0 or tonumber(data.makeup.item)) or 0,
        makeup_2 = data.makeup ~= nil and (tonumber(data.makeup.texture) == nil and 0 or tonumber(data.makeup.texture)) or
        0,
        makeup_3 = data.makeup_2 ~= nil and (tonumber(data.makeup_2.item) == nil and 0 or tonumber(data.makeup_2.item)) or
        0,
        makeup_4 = data.makeup_2 ~= nil and
        (tonumber(data.makeup_2.texture) == nil and 0 or tonumber(data.makeup_2.texture)) or 0,

        decals_1 = data.decals and (tonumber(data.decals.item) == nil and 0 or tonumber(data.decals.item)) or 0,
        decals_2 = data.decals and (tonumber(data.decals.texture) == nil and 0 or tonumber(data.decals.texture)) or 0,
        watches_1 = data.watch and (tonumber(data.watch.item) == nil and -1 or tonumber(data.watch.item)) or -1,
        watches_2 = data.watch and (tonumber(data.watch.texture) == nil and 0 or tonumber(data.watch.texture)) or 0,
        helmet_1 = data.hat and (tonumber(data.hat.item) == nil and -1 or tonumber(data.hat.item)) or -1,
        helmet_2 = data.hat and (tonumber(data.hat.texture) == nil and 0 or tonumber(data.hat.texture)) or 0,
        hair_1 = data.hair and (tonumber(data.hair.item) == nil and 0 or tonumber(data.hair.item)) or 0,
        hair_2 = data.hair and (tonumber(data.hair.texture) == nil and 0 or tonumber(data.hair.texture)) or 0,
        hair_color_1 = data.hair_color_1 and
        (tonumber(data.hair_color_1.item) == nil and 0 or tonumber(data.hair_color_1.item)) or 0,
        hair_color_2 = data.hair_color_2 and
        (tonumber(data.hair_color_2.item) == nil and 0 or tonumber(data.hair_color_2.item)) or 0,
        lip_thickness = data.lips_thickness and
        (tonumber(data.lips_thickness.item) == nil and 0 or tonumber(data.lips_thickness.item)) or 0,
        blush_1 = data.blush and (tonumber(data.blush.item) == nil and 0 or tonumber(data.blush.item)) or 0,
        blush_2 = data.blush_thickness and
        (tonumber(data.blush_thickness.item) == nil and 0 or tonumber(data.blush_thickness.item)) or 0,
        blush_3 = data.blush and (tonumber(data.blush.texture) == nil and 0 or tonumber(data.blush.texture)) or 0,
        neck_thickness = data.neck_thikness and
        (tonumber(data.neck_thikness.item) == nil and 0 or tonumber(data.neck_thikness.item)) or 0,
        torso_1 = data.torso2 and (tonumber(data.torso2.item) == nil and 0 or tonumber(data.torso2.item)) or 0,
        torso_2 = data.torso2 and (tonumber(data.torso2.texture) == nil and 0 or tonumber(data.torso2.texture)) or 0,
        eye_color = data.eye_color and (tonumber(data.eye_color.item) == nil and 0 or tonumber(data.eye_color.item)) or 0,
    }
end

function FormatDataToQbCore(data)
    return {
        ["sex"] = {
            item = tonumber(data.sex) == nil and 0 or tonumber(data.sex),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["skin_color"] = {
            item = tonumber(data.skin_color) == nil and 0 or tonumber(data.skin_color),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["skin_opacity"] = {
            item = tonumber(data.skin_opacity) == nil and 1.0 or tonumber(data.skin_opacity),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["face"] = {
            item = tonumber(data.dad) == nil and 0 or tonumber(data.dad),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["skin_dad"] = {
            item = tonumber(data.skin_dad) == nil and 0 or tonumber(data.skin_dad),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["face2"] = {
            item = tonumber(data.mom) == nil and 21 or tonumber(data.mom),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["skin_mom"] = {
            item = tonumber(data.skin_mom) == nil and 21 or tonumber(data.skin_mom),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["sun"] = {
            item = tonumber(data.sun_1) == nil and 0 or tonumber(data.sun_1),
            texture = tonumber(data.sun_2) == nil and 0 or tonumber(data.sun_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["facemix"] = {
            skinMix = tonumber(data.skin_md_weight) == nil and 50 or tonumber(data.skin_md_weight),
            shapeMix = tonumber(data.face_md_weight) == nil and 50 or tonumber(data.face_md_weight),
            defaultSkinMix = 0.0,
            defaultShapeMix = 0.0,
        },
        ["blemishes"] = {
            item = tonumber(data.blemishes_1) == nil and 0 or tonumber(data.blemishes_1),
            texture = tonumber(data.blemishes_2) == nil and 0 or tonumber(data.blemishes_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["complexion"] = {

            item = tonumber(data.complexion_1) == nil and 0 or tonumber(data.complexion_1),
            texture = tonumber(data.complexion_2) == nil and 0 or tonumber(data.complexion_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["body_blemishes"] = {
            item = tonumber(data.bodyb_1) == nil and 0 or tonumber(data.bodyb_1),
            texture = tonumber(data.bodyb_2) == nil and 0 or tonumber(data.bodyb_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["body_blemishes_2"] = {
            item = tonumber(data.bodyb_3) == nil and 0 or tonumber(data.bodyb_3),
            texture = tonumber(data.bodyb_4) == nil and 0 or tonumber(data.bodyb_4),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["chest"] = {
            item = tonumber(data.chest_1) == nil and 0 or tonumber(data.chest_1),
            texture = tonumber(data.chest_3) == nil and 0 or tonumber(data.chest_3),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["chest_thickness"] = {
            item = tonumber(data.chest_2) == nil and 0 or tonumber(data.chest_2),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["pants"] = {
            item = tonumber(data.pants_1) == nil and 0 or tonumber(data.pants_1),
            texture = tonumber(data.pants_2) == nil and 0 or tonumber(data.pants_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["hair"] = {
            item = tonumber(data.hair_1) == nil and 0 or tonumber(data.hair_1),
            texture = tonumber(data.hair_2) == nil and 0 or tonumber(data.hair_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["hair_color_1"] = {
            item = tonumber(data.hair_color_1) == nil and 0 or tonumber(data.hair_color_1),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["hair_color_2"] = {
            item = tonumber(data.hair_color_2) == nil and 0 or tonumber(data.hair_color_2),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["eyebrows"] = {
            item = tonumber(data.eyebrows_1) == nil and 0 or tonumber(data.eyebrows_1),
            texture = tonumber(data.eyebrows_3) == nil and 0 or tonumber(data.eyebrows_3),
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["eyebrows_2"] = {
            item = tonumber(data.eyebrows_2) == nil and 0 or tonumber(data.eyebrows_2),
            texture = 0,
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["beard"] = {
            item = tonumber(data.beard_1) == nil and 0 or tonumber(data.beard_1),
            texture = tonumber(data.beard_2) == nil and 0 or tonumber(data.beard_2),
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["beard_3"] = {
            item = tonumber(data.beard_3) == nil and 0 or tonumber(data.beard_3),
            texture = 0,
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["blush"] = {
            item = tonumber(data.blush_1) == nil and 0 or tonumber(data.blush_1),
            texture = tonumber(data.blush_3) == nil and 0 or tonumber(data.blush_3),
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["blush_thickness"] = {
            item = tonumber(data.blush_2) == nil and 0 or tonumber(data.blush_2),
            texture = 1,
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["lipstick"] = {
            item = tonumber(data.lipstick_1) == nil and 0 or tonumber(data.lipstick_1),
            texture = tonumber(data.lipstick_3) == nil and 0 or tonumber(data.lipstick_3),
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["lipstick_thickness"] = {
            item = tonumber(data.lipstick_2) == nil and 0 or tonumber(data.lipstick_2),
            texture = 0,
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["makeup"] = {
            item = tonumber(data.makeup_1) == nil and 0 or tonumber(data.makeup_1),
            texture = tonumber(data.makeup_2) == nil and 0 or tonumber(data.makeup_2),
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["makeup_2"] = {
            item = tonumber(data.makeup_3) == nil and 0 or tonumber(data.makeup_3),
            texture = tonumber(data.makeup_4) == nil and 0 or tonumber(data.makeup_4),
            defaultItem = -1,
            defaultTexture = 1,
        },
        ["ageing"] = {
            item = tonumber(data.age_1) == nil and 0 or tonumber(data.age_1),
            texture = tonumber(data.age_2) == nil and 0 or tonumber(data.age_2),
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["arms"] = {
            item = tonumber(data.arms) == nil and 0 or tonumber(data.arms),
            texture = tonumber(data.arms_2) == nil and 0 or tonumber(data.arms_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["t-shirt"] = {
            item = tonumber(data.tshirt_1) == nil and 0 or tonumber(data.tshirt_1),
            texture = tonumber(data.tshirt_2) == nil and 0 or tonumber(data.tshirt_2),
            defaultItem = 1,
            defaultTexture = 0,
        },
        ["torso2"] = {
            item = tonumber(data.torso_1) == nil and 0 or tonumber(data.torso_1),
            texture = tonumber(data.torso_2) == nil and 0 or tonumber(data.torso_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["vest"] = {
            item = tonumber(data.bproof_1) == nil and 0 or tonumber(data.bproof_1),
            texture = tonumber(data.bproof_2) == nil and 0 or tonumber(data.bproof_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["bag"] = {
            item = tonumber(data.bags_1) == nil and 0 or tonumber(data.bags_1),
            texture = tonumber(data.bags_2) == nil and 0 or tonumber(data.bags_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["shoes"] = {
            item = tonumber(data.shoes_1) == nil and 0 or tonumber(data.shoes_1),
            texture = tonumber(data.shoes_2) == nil and 0 or tonumber(data.shoes_2),
            defaultItem = 1,
            defaultTexture = 0,
        },
        ["mask"] = {
            item = tonumber(data.mask_1) == nil and 0 or tonumber(data.mask_1),
            texture = tonumber(data.mask_2) == nil and 0 or tonumber(data.mask_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["hat"] = {
            item = tonumber(data.helmet_1) == nil and -1 or tonumber(data.helmet_1),
            texture = tonumber(data.helmet_2) == nil and 0 or tonumber(data.helmet_2),
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["glass"] = {
            item = tonumber(data.glasses_1) == nil and 0 or tonumber(data.glasses_1),
            texture = tonumber(data.glasses_2) == nil and 0 or tonumber(data.glasses_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["ear"] = {
            item = tonumber(data.ears_1) == nil and -1 or tonumber(data.ears_1),
            texture = tonumber(data.ears_2) == nil and 0 or tonumber(data.ears_2),
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["watch"] = {
            item = tonumber(data.watches_1) == nil and -1 or tonumber(data.watches_1),
            texture = tonumber(data.watches_2) == nil and 0 or tonumber(data.watches_2),
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["bracelet"] = {
            item = tonumber(data.bracelets_1) == nil and -1 or tonumber(data.bracelets_1),
            texture = tonumber(data.bracelets_2) == nil and 0 or tonumber(data.bracelets_2),
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["accessory"] = {
            item = tonumber(data.chain_1) == nil and 0 or tonumber(data.chain_1),
            texture = tonumber(data.chain_2) == nil and 0 or tonumber(data.chain_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["decals"] = {
            item = tonumber(data.decals_1) == nil and 0 or tonumber(data.decals_1),
            texture = tonumber(data.decals_2) == nil and 0 or tonumber(data.decals_2),
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["eye_color"] = {
            item = tonumber(data.eye_color) == nil and 0 or tonumber(data.eye_color),
            texture = 0,
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["moles"] = {
            item = tonumber(data.moles_1) == nil and 0 or tonumber(data.moles_1),
            texture = tonumber(data.moles_2) == nil and 0 or tonumber(data.moles_2),
            defaultItem = -1,
            defaultTexture = 0,
        },
        ["nose_0"] = {
            item = tonumber(data.nose_1) == nil and 0 or tonumber(data.nose_1),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["nose_1"] = {
            item = tonumber(data.nose_2) == nil and 0 or tonumber(data.nose_2),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["nose_2"] = {
            item = tonumber(data.nose_3) == nil and 0 or tonumber(data.nose_3),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["nose_3"] = {
            item = tonumber(data.nose_4) == nil and 0 or tonumber(data.nose_4),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },

        ["nose_4"] = {
            item = tonumber(data.nose_5) == nil and 0 or tonumber(data.nose_5),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["nose_5"] = {
            item = tonumber(data.nose_6) == nil and 0 or tonumber(data.nose_6),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["cheek_1"] = {
            item = tonumber(data.cheeks_1) == nil and 0 or tonumber(data.cheeks_1),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["cheek_2"] = {
            item = tonumber(data.cheeks_2) == nil and 0 or tonumber(data.cheeks_2),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["cheek_3"] = {
            item = tonumber(data.cheeks_3) == nil and 0 or tonumber(data.cheeks_3),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["eye_opening"] = {
            item = tonumber(data.eye_squint) == nil and 0 or tonumber(data.eye_squint),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["lips_thickness"] = {
            item = tonumber(data.lip_thickness) == nil and 0 or tonumber(data.lip_thickness),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["jaw_bone_width"] = {
            item = tonumber(data.jaw_1) == nil and 0 or tonumber(data.jaw_1),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["eyebrown_high"] = {
            item = tonumber(data.eyebrows_5) == nil and 0 or tonumber(data.eyebrows_5),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["eyebrown_forward"] = {
            item = tonumber(data.eyebrows_6) == nil and 0 or tonumber(data.eyebrows_6),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["jaw_bone_back_lenght"] = {
            item = tonumber(data.jaw_2) == nil and 0 or tonumber(data.jaw_2),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["chimp_bone_lowering"] = {
            item = tonumber(data.chin_1) == nil and 0 or tonumber(data.chin_1),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["chimp_bone_lenght"] = {
            item = tonumber(data.chin_2) == nil and 0 or tonumber(data.chin_2),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["chimp_bone_width"] = {
            item = tonumber(data.chin_3) == nil and 0 or tonumber(data.chin_3),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["chimp_hole"] = {
            item = tonumber(data.chin_4) == nil and 0 or tonumber(data.chin_4),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
        ["neck_thikness"] = {
            item = tonumber(data.neck_thickness) == nil and 0 or tonumber(data.neck_thickness),
            texture = 0,
            defaultItem = 0,
            defaultTexture = 0,
        },
    }
end
