local IRON_DOOR_OPEN = {
    "Iron_Door_open1.ogg",
    "Iron_Door_open2.ogg",
    "Iron_Door_open3.ogg",
    "Iron_Door_open4.ogg",
}

local IRON_DOOR_CLOSE = {
    "Iron_Door_close1.ogg",
    "Iron_Door_close2.ogg",
    "Iron_Door_close3.ogg",
    "Iron_Door_close4.ogg",
}

local CHEST_OPEN = { "chestopen.oga" }
local CHEST_CLOSE = { "chestclosed.oga" }

local COPPER_WALK = {
    "Copper_step1.ogg",
    "Copper_step2.ogg",
    "Copper_step3.ogg",
    "Copper_step4.ogg",
    "Copper_step5.ogg",
    "Copper_step6.ogg",
}

local STONE_PLACE = {
    "stone1.oga",
    "stone2.oga",
    "stone3.oga",
    "stone4.oga"
}

local EQUIP_IRON = {
    "Equip_iron1.ogg",
    "Equip_iron2.ogg",
    "Equip_iron3.ogg",
    "Equip_iron4.ogg",
    "Equip_iron5.ogg",
    "Equip_iron6.ogg"
}

local STONE_PUNCH = {
    "Stone_hit1.ogg",
    "Stone_hit2.ogg",
    "Stone_hit3.ogg",
    "Stone_hit4.ogg",
    "Stone_hit5.ogg",
    "Stone_hit6.ogg",
}

local STONE_JUMP = {
    "Stone_jump1.wav",
    "Stone_jump2.wav",
    "Stone_jump3.wav",
    "Stone_jump4.wav",
}

local GRASS_WALK = {
    "Grass_hit1.ogg",
    "Grass_hit2.ogg",
    "Grass_hit3.ogg",
    "Grass_hit4.ogg",
    "Grass_hit5.ogg",
    "Grass_hit6.ogg",
}

local BUNDLE_INSERT = {
    "Bundle_insert1.ogg",
    "Bundle_insert2.ogg",
    "Bundle_insert3.ogg"
}

local BUNDLE_DROP = {
    "Bundle_drop_contents1.ogg",
    "Bundle_drop_contents2.ogg",
    "Bundle_drop_contents3.ogg"
}

local TRAPDOOR_OPEN = {
    "Iron_trapdoor_open1.ogg",
    "Iron_trapdoor_open2.ogg",
    "Iron_trapdoor_open3.ogg",
    "Iron_trapdoor_open4.ogg",
}

local TRAPDOOR_CLOSE = {
    "Iron_trapdoor_close1.ogg",
    "Iron_trapdoor_close2.ogg",
    "Iron_trapdoor_close3.ogg",
    "Iron_trapdoor_close4.ogg",
}

local WET_SPONGE_STEP = {
    "Wet_sponge_step1.ogg",
    "Wet_sponge_step2.ogg",
    "Wet_sponge_step3.ogg",
    "Wet_sponge_step4.ogg"
}

local GRAVEL_DIG = {
    "Gravel_dig1.ogg",
    "Gravel_dig2.ogg",
    "Gravel_dig3.ogg",
    "Gravel_dig4.ogg",
}

local CROP_PLACE = {
    "Crop_place1.ogg",
    "Crop_place2.ogg",
    "Crop_place3.ogg",
    "Crop_place4.ogg",
    "Crop_place5.ogg",
    "Crop_place6.ogg",
}

local REEL_IN = {
    "Fishing_rod_reel_in1.ogg",
    "Fishing_rod_reel_in2.ogg",
}

return require "lazier" {
    "EggbertFluffle/beepboop.nvim",
    dir = "~/clones/beepboop.nvim",
    enabled = false,
    config = function()
        local beepboop = require("beepboop")
        beepboop.setup({
            audio_player = "play",
            max_sounds = 10,
            sound_map = {
                { auto_command = "VimEnter", sounds = IRON_DOOR_OPEN },
                -- { auto_command = "WinClosed", sounds = IRON_DOOR_CLOSE },
                { auto_command = "VimLeave", sounds = IRON_DOOR_CLOSE },
                { auto_command = "TextChangedI", sounds = STONE_PLACE },
                { auto_command = "TextChanged", sounds = STONE_PLACE },
                { auto_command = "BufWrite", sounds = EQUIP_IRON },
                -- { auto_command = "CursorMoved", sounds = STONE_PUNCH },
                { auto_command = "TextYankPost", sounds = BUNDLE_INSERT },
                { auto_command = "CmdlineEnter", sounds = TRAPDOOR_OPEN },
                { auto_command = "CmdlineLeave", sounds = TRAPDOOR_CLOSE },
                { auto_command = "InsertEnter", sounds = REEL_IN },
                -- { auto_command = "InsertLeave", sounds = REEL_IN },
                { key_map = { mode = "n", key_chord = "p" }, sounds = BUNDLE_DROP },
            }
        })
        local function now()
            local reltime = vim.fn.reltimefloat(vim.fn.reltime())
            return reltime * 1000
        end
        local lastMove = 0
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function ()
                if now() - lastMove > 100 then
                    lastMove = now()
                    local mode = vim.fn.mode()
                    if mode == "v" or mode == "V" or mode == "\x16" then
                        beepboop.audio_player_callback(COPPER_WALK, 75)
                    else
                        beepboop.audio_player_callback(STONE_PUNCH, 75)
                    end
                end
            end
        })
    end,
    lazy = false,
    event = "VeryLazy",
}
