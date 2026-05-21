TBOJ = SMODS.current_mod

TBOJ.optional_features = {
    retrigger_joker = true,
    post_trigger = true,
    quantum_enhancements = false
}

TBOJ.atlases = {
    placeholders = SMODS.Atlas({
        key = "Placeholders",
        path = "AtlasPlaceholders.png",
        px = 71,
        py = 95
    }):register(),

    enhancers = SMODS.Atlas({
        key = "Enhancers",
        path = "AtlasEnhancers.png",
        px = 71,
        py = 95
    }):register(),

    blinds = SMODS.Atlas({
        key = "Blinds",
        atlas_table = "ANIMATION_ATLAS",
        path = "AtlasChips.png",
        px = 34,
        py = 34,
        frames = 21,
    }):register()
}

-- Jeez, surely this wont cause issues
assert(SMODS.load_file("additions/misc/rarities.lua"))()
assert(SMODS.load_file("additions/misc/textmods.lua"))()
assert(SMODS.load_file("additions/misc/calculate.lua"))()
assert(SMODS.load_file("additions/misc/hooks.lua"))()
assert(SMODS.load_file("additions/misc/sounds.lua"))()

assert(SMODS.load_file("additions/jokers.lua"))()
assert(SMODS.load_file("additions/tarots.lua"))()
assert(SMODS.load_file("additions/planets.lua"))()
assert(SMODS.load_file("additions/spectrals.lua"))()
assert(SMODS.load_file("additions/blinds.lua"))()
assert(SMODS.load_file("additions/enhancers.lua"))()
assert(SMODS.load_file("additions/packs.lua"))()
assert(SMODS.load_file("additions/vouchers.lua"))()
assert(SMODS.load_file("additions/decks.lua"))()
assert(SMODS.load_file("additions/stakes.lua"))()
assert(SMODS.load_file("additions/stickers.lua"))()

local tabs = function()
    return {{
        label = "Credits",
        tab_definition_function = function()
            local allocs_ui = {
                n = G.UIT.R,
                config = {
                    colour = G.C.L_BLACK,
                    align = "cl",
                    minw = 9.7,
                    minh = 1.9,
                    r = 0.15,
                    padding = 0.15
                },
                nodes = {}
            }

            local allocs = {{
                name = "Gooodsoups",
                locs = "Ideas, Art & Code",
                centre = G.P_CENTERS.j_joker
            },{
                name = "Frostbitesmile",
                locs = "Ideas & Art",
                centre = G.P_CENTERS.j_joker
            }, {
                name = "Seigneur32",
                locs = "Ideas",
                centre = G.P_CENTERS.j_joker
            }}

                for i, alloc in ipairs(allocs) do
                local node_type = allocs_ui.nodes
                local alloc_back = G.C.BLACK

                local nodes = {
                    n = G.UIT.C,
                    config = {
                        colour = alloc_back,
                        align = "tm",
                        minw = 2.1,
                        minh = 1.5,
                        r = 0.15,
                        padding = 0.15
                    },
                    nodes = {{
                        n = G.UIT.R,
                        config = {
                            colour = alloc_back,
                            align = "tm",
                            minw = 2.7,
                            minh = 0.0,
                            r = 0.15,
                            padding = 0.05
                        },
                        nodes = {{
                            n = G.UIT.C,
                            config = {
                                colour = G.C.GREY,
                                padding = 0.15,
                                align = "cm",
                                minw = 2.5,
                                maxh = 1.2,
                                r = 0.15,
                                emboss = 0.1
                            },
                            nodes = SMODS.localize_box(loc_parse_string("{s:1.2,E:TBOJ_orbit,C:white}"..alloc.name), {
                                default_col = G.C.UI.TEXT_LIGHT,
                                vars = {}
                            })
                        }}
                    }, {
                        n = G.UIT.R,
                        config = {
                            colour = alloc_back,
                            align = "tm",
                            minw = 2.1,
                            minh = 0.0,
                            r = 0.15,
                            padding = 0.05
                        },
                        nodes = {{
                            n = G.UIT.C,
                            config = {
                                colour = G.C.GREY,
                                padding = 0.15,
                                align = "cm",
                                minw = 2.2,
                                maxh = 1.2,
                                r = 0.15,
                                emboss = 0.1
                            },
                            nodes = SMODS.localize_box(loc_parse_string("{s:0.8,C:white}"..alloc.locs), {
                                default_col = G.C.UI.TEXT_LIGHT,
                                vars = {}
                            })
                        }}
                    }, {
                        n = G.UIT.R,
                        config = {
                            colour = alloc_back,
                            align = "bm",
                            minw = 2.1,
                            minh = 0.0,
                            r = 0.15,
                            padding = 0.05
                        },
                        nodes = {{
                            n = G.UIT.O,
                            config = {
                                padding = 0.15,
                                align = "cm",
                                maxw = 2.1,
                                maxh = 1.2,
                                r = 0.15,
                                object = CardArea(
                                    0, 0,
                                    0.5 * G.CARD_W * 1.3,
                                    0.5 * G.CARD_H * 1.3,
                                    {card_w = 0.5 * G.CARD_W, type = "title", highlight_limit = 0}),
                            },
                        }}
                    }}
                }

                local scale = 0.75
                local area = nodes.nodes[3].nodes[1].config.object
                local card = Card(
                    area.T.x + area.T.w/2, area.T.y,
                    G.CARD_W * scale, G.CARD_H * scale,
                    G.P_CARDS.empty, alloc.centre or G.P_CENTERS.c_empress,
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )

                area:emplace(card)

                card.states.drag.can = false
                
                node_type[#node_type + 1] = nodes
            end

            local nodes = {}

            nodes[#nodes + 1] = allocs_ui

            return {
                n = G.UIT.ROOT,
                config = {
                    emboss = 0.05,
                    minh = 6,
                    r = 0.1,
                    minw = 10,
                    align = "cm",
                    padding = 0.2,
                    colour = G.C.BLACK
                },
                nodes = nodes
            }
        end
    }}
end

TBOJ.extra_tabs = tabs

G.C.BgOne = HEX("c48454")
G.C.BgTwo = HEX("e69e66")
G.C.mid_flash = 0
G.C.vort_time = 7
G.C.vort_speed = 0.4

-- Thank you yahimod for easy accessa 🇫🇷🇫🇷🇫🇷🇫🇷
local game_main_menu_ref = Game.main_menu
Game.main_menu = function(change_context)
	local ret = game_main_menu_ref(change_context)
	G.SPLASH_BACK:define_draw_steps({
			{
				shader = "splash",
				send = {
					{ name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
           			{name = 'vort_speed', val = G.C.vort_speed},
            		{name = 'colour_1', ref_table = G.C, ref_value = 'BgOne'},
            		{name = 'colour_2', ref_table = G.C, ref_value = 'BgTwo'},
            		{name = 'mid_flash', ref_table = G.C, ref_value = 'mid_flash'},
				},
			},
		})
	return ret
end