SMODS.Rarity {
    key = "TBOJ_LowCommon",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0.0,
    badge_colour = HEX("e3dc82"),
    loc_txt = {
        name = "Quality 0"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "TBOJ_Locust",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0,
    badge_colour = HEX("9c2900"),
    loc_txt = {
        name = "Locust"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}