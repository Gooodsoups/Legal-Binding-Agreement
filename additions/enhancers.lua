local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

-- Beige Seal

SMODS.Seal {
    key = "TBOJ_Beige",
    atlas = "Enhancers",
    pos = {
        x = 0,
        y = 0
    },

    loc_txt = {
        name = "Beige Seal",
        label = "Beige Seal",
        text = {
            "Hands played with this seal",
            "count as {C:attention}first hand played{}"
        }
    },

    config = {
        preH = 0,
        preD = 0
    },

    badge_colour = HEX("d98356"),

    calculate = function(self, card, context)
        if context.press_play then
            local passed = false
            for k, v in pairs(G.hand.highlighted) do
                if v == card then
                    passed = true
                end
            end
            if passed then
                G.GAME.modprefix_old_hands_played = G.GAME.current_round.hands_played
                G.GAME.current_round.hands_played = 0
            end
        end
        if context.after and G.GAME.modprefix_old_hands_played then
            G.GAME.current_round.hands_played = G.GAME.modprefix_old_hands_played
            G.GAME.modprefix_old_hands_played = nil
        end
    end
}