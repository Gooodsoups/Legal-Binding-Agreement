local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

-- Revolution [Thanks for la deja vu code nh6574]

SMODS.Consumable {
    key = "TBOJ_revolution",
    set = "Spectral",
    atlas = "Placeholders",
    pos = {
        x = 2,
        y = 2
    },

    config = {
        extra = {
            seal = "TBOJ_Beige"
        },
        max_highlighted = 1
    },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return {
            key = "c_TBOJ_Revolution",
            vars = {
                colours = {
                    HEX("d98356")
                },
                card.ability.max_highlighted
            }
        }
    end,    

    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                conv_card:set_seal("TBOJ_Beige", nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,

    draw = function(self, card, layer)
        if (layer == "card" or layer == "both") and card.sprite_facing == "front" then
            card.children.center:draw_shader("booster", nil, card.ARGS.send_to_shader)
        end
    end
}