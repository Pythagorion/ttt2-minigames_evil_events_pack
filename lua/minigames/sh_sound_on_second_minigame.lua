--This event has been adopted from Wasted's 'sosig'-Event. Credits go to him.

if SERVER then 
    AddCSLuaFile()
    util.AddNetworkString("ttt2_chosen_trigger")
end 

local zetrosSounds = {
    "weapons/ChrisBall.mp3",
    "weapons/HardiRage.mp3"
}

local chosenSound = Sound(zetrosSounds[math.random(1, #zetrosSounds)], 1000)

MINIGAME.author = "aPythagorion & Zetros"

if CLIENT then 
    MINIGAME.lang = {
        name = {
            en = "Sound on Second"
            de = "Zielen mit Hindernissen"
        },
        desc = {
            en = "The brand new weapon collection now has a soundboard included."
            de ="Die neue Waffenkollektion hat nun ein Sound-mit-an-Board."
        }
    }
else
    function MINIGAME:OnActivation()
        net.Start("ttt2_chosen_trigger")
        net.Broadcast()
        local plys = player.GetAll()

        for i=1, #plys do
            local sweps = plys[i]:GetWeapons()
            for j=1, #sweps do
                weps[j].Secondary.Sound = chosenSound
            end
        end

        hook.Add("WeaponEquip", "ttt2_SoSMG_equip", function(wep, ply)
            if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("WeaponEquip", "ttt2_SoSMG_equip") end
            timer.Create("SoSMGdly", 0.1, 1, function()
                if GetRoundState() ~= ROUND_ACTIVE then timer.Remove("SoSMGdly") end

                net.Start("ttt2_chosen_trigger")
                net.Send(ply)

                for i=1, #plys do
                    local sweps = plys[i]:GetWeapons()
                    for j=1, #sweps do
                        if not sweps[j].Secondary then continue end
                        sweps[j].Secondary.Sound = chosenSound
                    end
                end
            end)
        end)
    end

    function MINIGAME:OnDeactivation()
        hook.Remove("WeaponEquip", "ttt2_SoSMG_equip")
    end
end 

if CLIENT then
    net.Receive("ttt2_chosen_trigger", function()
        local sweps = LocalPlayer():GetWeapons()
        for i=1, #sweps do
            sweps[i].Secondary.Sound = chosenSound
        end
    end)
end