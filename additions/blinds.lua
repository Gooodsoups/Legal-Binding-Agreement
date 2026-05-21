local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

SMODS.Blind {
    key = "TBOJ_Fence",
    atlas = "Blinds",
    pos = {
        x = 0,
        y = 0
    },

    dollars = 5,
    mult = 2,

    boss = {
        min = 4
    },

    boss_colour = HEX("40E0D0"),

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card then
                local ranks = {
                    Ace = 0,
                    King = 0,
                    Queen = 0,
                    Jack = 0,
                    ["10"] = 0,
                    ["9"] = 0,
                    ["8"] = 0,
                    ["7"] = 0,
                    ["6"] = 0,
                    ["5"] = 0,
                    ["4"] = 0,
                    ["3"] = 0,
                    ["2"] = 0
                }

                for _, card in pairs(G.playing_cards) do
                    if card.ability.played_this_ante then
                        ranks[card.config.card.value] = ranks[card.config.card.value] + 1
                    end 
                end

                local debuff_rank = ""
                local min = 0

                for key, amount in pairs(ranks) do
                    if amount > min then
                        min = amount
                        debuff_rank = key
                    end
                end

                if context.debuff_card.config.card.value == debuff_rank and min ~= 0 then
                    return {
                        debuff = true
                    }
                end 
            end
        end
    end
}
