-- This file will be so bloated after this god save me

local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

-- <3
SMODS.Joker {
    key = "TBOJ_<3",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_HeartItem"
        }
    end,

    rarity = 2,
    cost = 8,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)
            ease_discard(1)

            return {
                message = "+1 Both",
                colour = G.C.PURPLE
            }
        end
    end
}

-- 1up!
SMODS.Joker {
    key = "TBOJ_1up",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    rarity = 2,
    cost = 7,

    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_1up"
        }
    end,

    config = {
        activated = false
    },

    calculate = function(self, card, context)
        if context.game_over and not card.ability.activated then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')

                    card.ability.activated = true
                    local eval = function(card)
                        return card.ability.activated
                    end

                    juice_card_until(card, eval, true)
                    
                    return true
                end
            }))

            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end

        if context.setting_blind and card.ability.activated then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(1)
                    
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound("tarot1")
                    
                    card:start_dissolve()

                    return true
                end
            }))
        end
    end
}

-- 20/20
SMODS.Joker {
    key = "TBOJ_2020",
    atlas = "Placeholders",
    pos = {
        x = 3,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_2020"
        }
    end,

    rarity = 4,
    cost = 20,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.retrigger_joker_check and context.other_card.config.center_key ~= "j_TBOJ_2020" then
            return {
                repetitions = 1
            }
        end

        if context.modify_scoring_hand then
            return {
                remove_from_hand = true
            }
        end
    end
}

-- 3 Dollar Bill
SMODS.Joker {
    key = "TBOJ_3Bill",
    atlas = "Placeholders",
    pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_3Bill"
        }
    end,

    rarity = 1,
    cost = 4,

    calculate = function(self, card, context)
        if not context.joker_main then
            return
        end

        local type = pseudorandom("3BType", 1, 3)
        local val = pseudorandom("3BVal")

        local outputs = {
            {chips = val * 60 + 15},
            {mult  = val * 25 + 5},
            {xmult = val + 1}
        }

        return outputs[type]
    end
}

-- Battery Pack
SMODS.Joker {
    key = "TBOJ_Batterypack",
    atlas = "Placeholders",
    pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Batterypack",
            vars = {
                card.ability.rerolls
            }
        }
    end,

    config = {
        rerolls = 4,
        inc = 1
    },

    rarity = 1,
    cost = 5,

    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.starting_shop or context.buying_self then
            G.GAME.current_round.free_rerolls = card.ability.rerolls
            calculate_reroll_cost(true)
        end
        
        if context.reroll_shop and card.ability.rerolls ~= 0 then
            card.ability.rerolls = card.ability.rerolls - 1
        end

        if context.setting_blind and card.ability.rerolls + 1 <= 4 then
            card.ability.rerolls = card.ability.rerolls + card.ability.inc
            return {
                message = "+1 Charge"
            }
        end
    end
}

-- A dollar? / Quarter?
SMODS.Joker {
    key = "TBOJ_Dollar",
    atlas = "Placeholders",
    pos = {
        x = 2,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Dollar"
        }
    end,

    rarity = 3,
    cost = 7,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.selling_self then
            ease_dollars(100) -- That's a lot of money
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Quarter",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Quarter"
        }
    end,

    rarity = 2,
    cost = 5,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.selling_self then
            ease_dollars(25)
        end
    end
}

-- Thunkyard
--[[SMODS.Joker {
    key = "TBOJ_Thunkyard",
    atlas = "Placeholders",
    pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Thunkyard",
            vars = {
                card.ability.jimbos
            }
        }
    end,

    config = {
        jimbos = 2
    },

    rarity = 1,
    cost = 4,

    calculate = function(self, card, context)
        if context.selling_self then
            local jimbos_to_create = math.min(card.ability.jimbos, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jimbos_to_create
            G.E_MANAGER:add_event(Event({
                func = function() 
                    for i = 1, jimbos_to_create do
                        local card = create_card("Joker", G.jokers, nil, 0, nil, nil, "j_joker", "thunkyard")
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end
            }))   
            card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, {message = "+"..jimbos_to_create.." Jokers", colour = G.C.BLUE}) 
        end
    end
}]]

-- Brimstone
SMODS.Joker {
    key = "TBOJ_Brimstone",
    atlas = "Placeholders",
    pos = {
        x = 3,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Brimstone",
            vars = {
                card.ability.maxmult,
                card.ability.xmult
            }
        }
    end,

    config = {
        maxmult = 10,
        xmult = 9
    },

    rarity = 4,
    cost = 20,

    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.joker_main then
            local calcTable = {
                {
                    mult = {
                        eval = true,
                        vars = {},
                        func = function(vars)
                            return {
                                math.floor(pseudorandom("brimstone") * card.ability.maxmult) + 1
                            }
                        end
                    },
                    repeats = 10
                },

                {
                    xmult = card.ability.xmult
                }
            }

            local table = CalcLib.combine_calculate(calcTable)
            
            return table
        end
    end
}

-- Fate's reward
SMODS.Joker {
    key = "TBOJ_Fatesreward",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Fatesreward"
        }
    end,

    rarity = 2,
    cost = 7,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not G.GAME.CardTriggering and G.GAME.blind:get_type() ~= "Boss" then -- Weird interaction with bosses so
            G.E_MANAGER:add_event(Event({ -- Pretty hacky implementation, depends on a state to keep them all aligned
                blocking = false,
                func = function()
                    if G.STATE == G.STATES.ROUND_EVAL then
                        G.GAME.CardTriggering = false
                        return true
                    elseif G.STATE == G.STATES.SELECTING_HAND and (G.GAME.STOP_USE or 0) < 1 and not G.CONTROLLER.locked then
                        local cards = CalcLib.get_random_items(G.hand.cards, 5, "fatesreward")
                        G.GAME.CardTriggering = true

                        card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, {message = "You're welcome...", colour = G.C.GOLD})
                        
                        for _, selectedcard in pairs(cards) do
                            highlight_card(selectedcard, 0.5, "up")
                            table.insert(G.hand.highlighted, selectedcard)
                        end

                        card:juice_up(0.5, 0.2)
                        CalcLib.smart_play_cards(cards, 0)

                        G.GAME.CardTriggering = false

                        return true
                    end

                    return false
                end
            }))

            return {}
        end
    end
}

-- The foods [There's not much you can do with coding these]
SMODS.Joker {
    key = "TBOJ_Snack",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Snack"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Breakfast",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Breakfast"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Dessert",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Dessert"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Dinner",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Dinner"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Lunch",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Lunch"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Midnightsnack",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Midnightsnack"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Rottenmeat",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Rottenmeat"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

SMODS.Joker {
    key = "TBOJ_Supper",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Supper"
        }
    end,

    rarity = 2,
    cost = 5,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1)

            return {
                message = "+1 Hands",
                colour = G.C.BLUE
            }
        end
    end
}

-- Crown of Light

SMODS.Joker {
    key = "TBOJ_Crownoflight",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Crownoflight"
        }
    end,

    rarity = 2,
    cost = 6,

    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.active = true
            local eval = function(card)
                return G.GAME.current_round.hands_played + G.GAME.current_round.discards_used == 0
            end

            juice_card_until(card, eval, true)
        end

        if context.joker_main and G.GAME.current_round.hands_played + G.GAME.current_round.discards_used == 0 then
            return {
                xmult = 2
            }
        end
    end
}

-- Stopwatch

SMODS.Joker {
    key = "TBOJ_Stopwatch",
    atlas = "Placeholders",
    pos = {
        x = 1,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Stopwatch",
            vars = {
                math.floor(card.ability.hands_played / 2)
            }
        }
    end,

    rarity = 2,
    cost = 7,

    config = {
        hands_played = 0
    },

    calculate = function(self, card, context)
        if context.before then
            card.ability.hands_played = card.ability.hands_played + 1
        end

        if context.setting_blind and math.floor(card.ability.hands_played / 2) > 0 then
            local discards = math.floor(card.ability.hands_played / 2)
            ease_discard(discards)
            card.ability.hands_played = 0

            return {
                message = "+"..discards.." Discards",
                colour = G.C.RED
            }
        end
    end
}

-- Function to simplify this lump of garbage
local function fedora_apply(joker)
    if not joker then return end

    if joker.ability.fedora_doubled == nil then
        joker.ability.fedora_doubled = false
    end

    if joker.ability.extra and not joker.ability.fedora_doubled then
        if type(joker.ability.extra) == "number" then -- Annoyingly some jokers simply dont even have table extras, just numbers
            joker.ability.extra = joker.ability.extra * 2
            joker.ability.fedora_doubled = true

        elseif type(joker.ability.extra) == "table" then
            local mod = false

            for k, v in pairs(joker.ability.extra) do
                if string.match(k, "_mod$") then
                    mod = true
                end
            end

            for k, v in pairs(joker.ability.extra) do
                if mod then
                    if string.find(k, "_mod$") -- Most jokers use _mod in their extra tables, so I'm going off of that assumption
                    and type(v) == "number" then -- Also very inconsistent as shit, does not work with yorick
                        joker.ability.extra[k] = v * 2
                        joker.ability.fedora_doubled = true
                    end
                else
                    if type(v) == "number" then -- This probably makes this joker even more broken than it already is but i dont care :D
                        joker.ability.extra[k] = v * 2
                        joker.ability.fedora_doubled = true
                    end
                end
            end
        end
    end
end

-- Clearing function
local function fedora_clear(joker)
    if joker.ability.fedora_doubled then
        if type(joker.ability.extra) == "number" then
            joker.ability.extra = joker.ability.extra / 2
            joker.ability.fedora_doubled = false

        elseif type(joker.ability.extra) == "table" then
            local mod = false

            for k, v in pairs(joker.ability.extra) do
                if string.match(k, "_mod$") then
                    mod = true
                end
            end

            for k, v in pairs(joker.ability.extra) do
                if mod then
                    if string.find(k, "_mod$")
                    and type(v) == "number" then
                        joker.ability.extra[k] = v / 2
                        joker.ability.fedora_doubled = false
                    end
                else
                    if type(v) == "number" then
                        joker.ability.extra[k] = v / 2
                        joker.ability.fedora_doubled = false
                    end
                end
            end
        end
    end
end

-- Seigneur's Fedora
SMODS.Joker {
    key = "TBOJ_Fedora",
    atlas = "Placeholders",
    pos = {
        x = 3,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_Fedora"
        }
    end,

    rarity = 4,
    cost = 20,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if (context.card_emplaced or context.card_removed or context.card_moved) and context.cardarea == G.jokers then
            local pos
            
            for i, joker in ipairs(G.jokers.cards) do -- Interesting way to reset the jokers affected by this
                fedora_clear(joker)

                if joker == card then pos = i end
            end

            if pos and G.jokers.cards[pos - 1] then
                local adj = G.jokers.cards[pos - 1]
                fedora_apply(adj)
            end

            if pos and G.jokers.cards[pos + 1] then
                local adj = G.jokers.cards[pos + 1]
                fedora_apply(adj)
            end
        end
    end,

    update = function(self, card, dt)
        if card.area ~= G.jokers then return end

        local copies = 0

        for _, joker in ipairs(G.jokers.cards) do
            if joker.config.center.key == card.config.center.key then
                copies = copies + 1
            end
        end

        if copies > 1 then
            for _, joker in ipairs(G.jokers.cards) do
                fedora_clear(joker)
            end

            card:set_debuff(true)
        elseif copies <= 1 and card.debuff then
            card:set_debuff(false)
            
            local pos

            for i, joker in ipairs(G.jokers.cards) do
                if joker == card then pos = i end
            end

            if pos and G.jokers.cards[pos - 1] then
                local adj = G.jokers.cards[pos - 1]
                fedora_apply(adj)
            end

            if pos and G.jokers.cards[pos + 1] then
                local adj = G.jokers.cards[pos + 1]
                fedora_apply(adj)
            end
        end
    end
}

-- Notched Axe
SMODS.Joker {
    key = "TBOJ_NotchedAxe",
    atlas = "Placeholders",
    pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {
            key = "j_TBOJ_NotchedAxe",
            vars = {
                card.ability.extra.mult_mod,
                card.ability.extra.mult_mod + card.ability.extra.range_mod,
                card.ability.multi
            }
        }
    end,

    config = {
        multi = 0,
        extra = {
            mult_mod = 3,
            range_mod = 3,
        }
    },

    rarity = 1,
    cost = 6,

    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and SMODS.has_enhancement(context.destroying_card, "m_stone") and not context.blueprint then
            local mult_gain = card.ability.extra.mult_mod + math.floor(pseudorandom("TBOJ_Rusty") * card.ability.extra.range_mod + 1)
            card.ability.multi = card.ability.multi + mult_gain

            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                func = function()
                    card:juice_up(0.5, 0.2)
                    context.destroying_card:juice_up(0.5, 0.2)
                    play_sound("TBOJ_stone")

                    return true
                end
            }))

            return {
                remove = true
            }
        end

        if context.joker_main then
            return {
                mult = card.ability.multi
            }
        end
    end
}