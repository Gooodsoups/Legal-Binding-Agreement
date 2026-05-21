return {
    descriptions = {
        Joker = {
            j_TBOJ_HeartItem = {
                name = "Breakfast",
                text = {
                    "{C:blue}+1{} hand and {C:red}+1{} discard every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}Finally a 'unique' item"
                }
            },

            j_TBOJ_1up = {
                name = "1up!",
                text = {
                    "Prevents you from Death",
                    "{C:blue}+1{} hand on the next round",
                    "{C:red,E:TBOJ_shake}self destructs"
                }
            },

            j_TBOJ_2020 = {
                name = "20/20",
                text = {
                    "All Jokers are {C:dark_edition,E:TBOJ_orbit}retriggered{} {C:attention}once",
                    "{C:red,E:TBOJ_shake}played cards will not score"
                }
            },

            j_TBOJ_3Bill = {
                name = "3 Dollar Bill",
                text = {
                    "Give a {E:TBOJ_orbit}random amount{} of",
                    "{C:chips}Chips{}, {C:mult}Mult{} or {X:mult,C:white}XMult"
                }
            },

            j_TBOJ_Batterypack = {
                name = "Battery Pack",
                text = {
                    "For {C:attention}#1#{} rerolls, they cost {C:money}$0",
                    "this Joker gains a charge each round",
                    "{C:inactive,E:TBOJ_orbit}(Charges capped at 4)"
                }
            },

            j_TBOJ_Dollar = {
                name = "A Dollar?",
                text = {
                    "Sell this Joker to get {C:money}$100"
                }
            },

            j_TBOJ_Quarter = {
                name = "A Quarter?",
                text = {
                    "Sell this Joker to get {C:money}$25"
                }
            },

            --[[j_TBOJ_Thunkyard = {
                name = "Thunkyard",
                text = {
                    "Sell this {C:attention}Joker{} to add",
                    "{C:attention}#1#{} more Jimbos"
                }
            },]]

            j_TBOJ_Brimstone = {
                name = "Brimstone",
                text = {
                    "Give {C:mult}+1{}-{C:mult}#1#{} Mult {C:attention}10{} times",
                    "give {X:mult,C:white}X#2#{} at the end"
                }
            },

            j_TBOJ_Fatesreward = {
                name = "Fate's Reward",
                text = {
                    "Automatically play a hand",
                    "with {C:attention}5{} random cards",
                    "{C:red,E:TBOJ_orbit}The hand will not be consumed",
                    "{C:red,E:TBOJ_shake}Doesn't work on boss blinds"
                }
            },

            j_TBOJ_Snack = {
                name = "A Snack",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}Very repetitive I know"
                }
            },

            j_TBOJ_Breakfast = {
                name = "Breakfast",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}Deal with it"
                }
            },

            j_TBOJ_Dessert = {
                name = "Dessert",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}I'm so open minded"
                }
            },

            j_TBOJ_Dinner = {
                name = "Dinner",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}What a delicacy"
                }
            },

            j_TBOJ_Lunch = {
                name = "Lunch",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}Did you look at the wiki?"
                }
            },

            j_TBOJ_Midnightsnack = {
                name = "Midnight Snack",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}A hand????? How cool!"
                }
            },

            j_TBOJ_Rottenmeat = {
                name = "Rotten Meat",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}Yummie"
                }
            },

            j_TBOJ_Supper = {
                name = "Supper",
                text = {
                    "{C:blue}+1{} hand every blind",
                    "{S:0.8,C:inactive,E:TBOJ_orbit}Don't expect me to add unique effects to these "
                }
            },

            j_TBOJ_Crownoflight = {
                name = "Crown of Light",
                text = {
                    "{X:mult,C:white}X2{} Mult if no hands or",
                    "discards were used this round"
                }
            },

            j_TBOJ_Stopwatch = {
                name = "Stopwatch",
                text = {
                    "Gain half the amount of Hands played",
                    "last round as Discards",
                    "{C:inactive}(Currently: {C:red}+#1#{}{C:inactive} Discards)"
                }
            },

            j_TBOJ_Fedora = {
                name = "Seigneur's Fedora",
                text = {
                    "Adjacent jokers have some",
                    "of their values {C:attention,E:TBOJ_orbit}doubled",
                    "{C:red,E:TBOJ_shake}Owning multiple copies debuffs it",
                    "{C:inactive,E:TBOJ_orbit}(May not work with all jokers)"
                }
            },

            j_TBOJ_NotchedAxe = {
                name = "Notched Axe",
                text = {
                    "Played {C:attention,E:TBOJ_orbit}stone{} cards give",
                    "this {E:TBOJ_orbit}Joker{} {C:mult}+#1#-#2#{} Mult, played",
                    "{C:attention,E:TBOJ_orbit}stone{} cards are {C:red,E:TBOJ_shake}destroyed",
                    "{C:inactive}(Currently: {C:red}+#3#{}{C:inactive} Mult)",
                    "{C:inactive,E:TBOJ_orbit}(Mult is given first, not gained)"
                }
            }
        },

        Spectral = {
            c_TBOJ_Revolution = {
                name = "Revolution",
                text = {
                    "Add a {V:1}Beige Seal{}",
                    "to {C:attention}1{} selected",
                    "card in your hand",
                },
            }
        },

        Blind = {
            bl_TBOJ_Fence = {
                name = "The Fence",
                text = {
                    "Most played rank",
                    "this Ante is debuffed"
                }
            }
        },

        Voucher = {
            
        },

        Enhanced = {
            
        },

        Edition = {
            
        },

        Stake = {
            
        },

        Other = {
            
        }
    },

    misc = {
        labels = {
            
        },

        dictionary = {
            k_common = "Quality 1",
            k_uncommon = "Quality 2",
            k_rare = "Quality 3",
            k_legendary = "Quality 4"
        }
    }
}