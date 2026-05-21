local CalcLib = {}

-- helpers for combine_calculate and other functions, primarily combine_calculate lmao
local function shallow_copy(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k,v in pairs(t) do out[k] = v end
    return out
end

local function is_script_block(v)
    return type(v) == "table" and v.eval == true and type(v.func) == "function"
end

local function keys_sorted(t)
    local ks = {}
    for k in pairs(t) do table.insert(ks, k) end
    table.sort(ks, function(a,b) return tostring(a) < tostring(b) end)
    return ks
end

local function entries_shallow_equal(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a == b
    end
    local ka = {}
    local kb = {}
    for k in pairs(a) do ka[k] = true end
    for k in pairs(b) do kb[k] = true end
    for k in pairs(ka) do if not kb[k] then return false end end
    for k in pairs(kb) do if not ka[k] then return false end end
    
    for k in pairs(ka) do
        local va = a[k]
        local vb = b[k]
        if type(va) == "table" and type(vb) == "table" then
            if is_script_block(va) and is_script_block(vb) then
                if tostring(va.func) ~= tostring(vb.func) then return false end
                local va_vars = va.vars or {}
                local vb_vars = vb.vars or {}
                
                if #va_vars ~= #vb_vars then return false end
                for i=1,#va_vars do if tostring(va_vars[i]) ~= tostring(vb_vars[i]) then return false end end
            else
                if tostring(va) ~= tostring(vb) then return false end
            end
        else
            if tostring(va) ~= tostring(vb) then return false end
        end
    end
    return true
end

-- lua doesnt have any of these apparently
function CalcLib.clamp(value, minv, maxv)
    if minv == nil or maxv == nil then
        return nil
    end
    if minv > maxv then minv, maxv = maxv, minv end
    if value < minv then return minv end
    if value > maxv then return maxv end
    return value
end

function CalcLib.lerp(a, b, t)
    return a + (b - a) * t
end

function CalcLib.unlerp(a, b, v)
    if a == b then return 0 end
    return (v - a) / (b - a)
end

function CalcLib.map(v, a1, b1, a2, b2)
    if a1 == b1 then return nil end
    return a2 + (v - a1) * ((b2 - a2) / (b1 - a1))
end

function CalcLib.map_clamp(v, a1, b1, a2, b2)
    local t = CalcLib.unlerp(a1, b1, v)
    if t <= 0 then return a2 end
    if t >= 1 then return b2 end
    return CalcLib.lerp(a2, b2, t)
end

function CalcLib.sign(x)
    if x > 0 then return 1 elseif x < 0 then return -1 else return 0 end
end

function CalcLib.approx(a, b, eps)
    eps = eps or 1e-9
    return math.abs(a - b) <= eps
end

function CalcLib.wrap(value, minv, maxv)
    local size = maxv - minv
    if size == 0 then return minv end
    local v = (value - minv) % size
    if v < 0 then v = v + size end
    return minv + v
end

function CalcLib.smoothstep(a, b, t)
    t = CalcLib.unlerp(a, b, t)
    if t <= 0 then return 0 end
    if t >= 1 then return 1 end
    return t * t * (3 - 2 * t)
end

function CalcLib.to_rad(d) return d * (math.pi / 180) end
function CalcLib.to_deg(r) return r * (180 / math.pi) end

function CalcLib.dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function CalcLib.hyp(dx, dy)
    return math.sqrt(dx^2 + dy^2)
end

function CalcLib.combine(lists)
    local list = {}

    for _, v_list in pairs(lists) do
        for _, item in pairs(v_list) do
            list[#list + 1] = item
        end
    end

    return list
end

-- Youre welcome, now theres no excuse for making deep ass extra tables
function CalcLib.combine_calculate(list)
    if #list == 0 then return {} end

    local root = nil
    local cursor = nil

    for idx, entry in ipairs(list) do
        local reps = entry.repeats or 1
        local node_payload = shallow_copy(entry)
        node_payload.repeats = nil

        for r = 1, reps do
            local node = {}
            for k, v in pairs(node_payload) do
                if is_script_block(v) then
                    local success, result = pcall(v.func, v.vars)
                    if success then
                        if type(result) == "table"
                        and #result == 1
                        and next(result, 1) == nil then
                            result = result[1]
                        end

                        node[k] = result
                    else
                        error(result) 
                    end
                else
                    node[k] = v 
                end
            end

            if r == 1 then
                local orig = shallow_copy(entry)
                if orig.repeats then
                    orig.repeats = entry.repeats
                end
                node.__orig_entry = orig
            end

            if not root then
                root = node
                cursor = root
            else
                cursor.extra = node
                cursor = node
            end
        end
    end

    return root or {}
end

-- Opposite of combine_calculate, idk when this will be useful because you wont really unpack a combined calculate table, but uh, maybe ill find a use for it
function CalcLib.retrieve_calculate(list, allow_repeats)
    if list == nil then return {} end
    if allow_repeats == nil then allow_repeats = true end

    local out = {}
    local cur = list

    while cur do
        local real = false
        for k in pairs(cur) do
            if k ~= "extra" and k ~= "__orig_entry" then real = true; break end
        end
        if not real and not cur.__orig_entry then
            cur = cur.extra
        else
            if allow_repeats and type(cur.__orig_entry) == "table" and cur.__orig_entry.repeats and cur.__orig_entry.repeats > 1 then
                table.insert(out, shallow_copy(cur.__orig_entry))
                local skip = cur.__orig_entry.repeats - 1
                local next_node = cur
                for i=1, skip do
                    if next_node and next_node.extra then
                        next_node = next_node.extra
                    else
                        next_node = nil
                        break
                    end
                end
                if next_node then cur = next_node.extra else cur = nil end
            elseif allow_repeats then
                local base_entry = {}
                for k, v in pairs(cur) do
                    if k ~= "extra" and k ~= "__orig_entry" then base_entry[k] = v end
                end
                
                local count = 1
                local look = cur.extra
                while look do
                    local look_entry = {}
                    for k, v in pairs(look) do
                        if k ~= "extra" and k ~= "__orig_entry" then look_entry[k] = v end
                    end
                    if entries_shallow_equal(base_entry, look_entry) then
                        count = count + 1
                        look = look.extra
                    else
                        break
                    end
                end
                if count > 1 then
                    local to_insert = shallow_copy(base_entry)
                    to_insert.repeats = count
                    table.insert(out, to_insert)
                    for i = 1, count do
                        if cur then cur = cur.extra end
                    end
                else
                    table.insert(out, base_entry)
                    cur = cur.extra
                end
            else
                local entry = {}
                for k, v in pairs(cur) do
                    if k ~= "extra" and k ~= "__orig_entry" then entry[k] = v end
                end
                table.insert(out, entry)
                cur = cur.extra
            end
        end
    end

    return out
end

-- Gets thou random items from a list, theres like no point in using seed but whatever
function CalcLib.get_random_items(list, amount, seed)
    local finallist

    local n = #list
    if n <= amount then
        return list
    end

    local result = {}
    local used = {}

    while #result < amount do
        local idx = math.floor(pseudorandom(seed) * n) + 1
        if not used[idx] then
            table.insert(result, list[idx])
            used[idx] = true
        end
    end

    return result
end

function CalcLib.smart_play_cards(cards, deduction)
    if G.play and G.play.cards[1] then return end
    --check the hand first

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(cards, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_cards_played', #cards)
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(deduction)
    delay(0.4)

    for i=1, #cards do
        if cards[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
        cards[i].base.times_played = cards[i].base.times_played + 1
        cards[i].ability.played_this_ante = true
        G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
        draw_card(G.hand, G.play, i*100/#cards, 'up', nil, cards[i])
    end

    check_for_unlock({type = 'run_card_replays'})

    if G.GAME.blind:press_play() and G.HUD_blind then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff_1'):juice_up(0.3, 0)
                G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff_2'):juice_up(0.3, 0)
                G.GAME.blind:juice_up()
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))
        delay(0.4)
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            check_for_unlock({type = 'hand_contents', cards = G.play.cards})

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.FUNCS.evaluate_play()
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    check_for_unlock({type = 'play_all_hearts'})
                    G.FUNCS.draw_from_play_to_discard()
                    G.GAME.hands_played = G.GAME.hands_played + 1
                    G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
        end)
    }))
end

function CalcLib.smart_discard_cards(cards, deduction, hook)
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
    local highlighted_count = math.min(#cards, G.discard.config.card_limit - #G.play.cards)
    if highlighted_count > 0 then 
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        table.sort(cards, function(a,b) return a.T.x < b.T.x end)
        inc_career_stat('c_cards_discarded', highlighted_count)
        for j = 1, #G.jokers.cards do
            G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = cards, hook = hook})
        end
        local cards = {}
        local destroyed_cards = {}
        for i=1, highlighted_count do
            cards[i]:calculate_seal({discard = true})
            local removed = false
            for j = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  cards[i], full_hand = cards})
                if eval then
                    if eval.remove then removed = true end
                    card_eval_status_text(G.jokers.cards[j], 'jokers', nil, 1, nil, eval)
                end
            end
            table.insert(cards, cards[i])
            if removed then
                destroyed_cards[#destroyed_cards + 1] = cards[i]
                if cards[i].ability.name == 'Glass Card' then 
                    cards[i]:shatter()
                else
                    cards[i]:start_dissolve()
                end
            else 
                cards[i].ability.discarded = true
                draw_card(G.hand, G.discard, i*100/highlighted_count, 'down', false, cards[i])
            end
        end

        if destroyed_cards[1] then 
            for j=1, #G.jokers.cards do
                eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards})
            end
        end

        G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
        check_for_unlock({type = 'discard_custom', cards = cards})
        if not hook then
            if G.GAME.modifiers.discard_cost then
                ease_dollars(-G.GAME.modifiers.discard_cost)
            end
            ease_discard(deduction)
            G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end
end

return CalcLib