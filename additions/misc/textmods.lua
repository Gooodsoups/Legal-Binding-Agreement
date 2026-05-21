local CalcLib = assert(SMODS.load_file("libs/calc_lib.lua"))()
local DebugLib = assert(SMODS.load_file("libs/debug_lib.lua"))()

SMODS.DynaTextEffect {
    key = "orbit",
    func = function (self, index, letter)
        local calculation = G.TIMERS.REAL * -5 + index * 0.3
        local strength = 8
        
        letter.offset = {
            x = math.sin(calculation) * strength,
            y = math.cos(calculation) * strength
        }
    end
}

SMODS.DynaTextEffect {
    key = "shake",
    func = function (self, index, letter)
        local strength = 8

        letter.offset = {
            x = pseudorandom("shake") * strength,
            y = pseudorandom("shake") * strength
        }
    end
}