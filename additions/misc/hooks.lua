local game_start_run_ref = Game.start_run

-- Adds the CardTriggering flag which is primarily used for Fate's Reward to ensure it doesn't overlap
function Game:start_run(args)
    game_start_run_ref(self, args)

    G.GAME.CardTriggering = false
end