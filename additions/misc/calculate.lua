-- Surely a good place to place all the contexts for this mod

-- card_moved, ran when a card is moved in a cardarea
-- Why this needs 50 lines to do so it? Idk
local node_drag_ref = Node.drag
local node_stop_drag_ref = Node.stop_drag

function Node:drag()
    if not self.drag_start_cached then
        self.drag_start_cached = true

        self.drag_start_area = self.area
        self.drag_start_pos = nil

        if self.area and self.area.cards then
            for i, v in ipairs(self.area.cards) do
                if v == self then
                    self.drag_start_pos = i
                    break
                end
            end
        end
    end

    node_drag_ref(self)
end

function Node:stop_drag()
    local old_pos = self.drag_start_pos
    local old_area = self.drag_start_area

    node_stop_drag_ref(self)

    local new_pos = nil

    if self.area and self.area.cards then
        for i, v in ipairs(self.area.cards) do
            if v == self then
                new_pos = i
                break
            end
        end
    end

    local moved =
        old_pos ~= new_pos or
        old_area ~= self.area

    if self.drag_start_cached and moved then
        SMODS.calculate_context({
            card_moved = true,
            other_card = self,
            cardarea = self.area
        })
    end

    self.drag_start_cached = nil
    self.drag_start_pos = nil
    self.drag_start_area = nil
end

-- card_emplaced, fires when a card is emplaced for any reason
local emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    emplace_ref(self, card, location, stay_flipped)

    SMODS.calculate_context({
        card_emplaced = true,
        other_card = card,
        cardarea = location,
        flipped = stay_flipped
    })
end

-- card_removed, fires when a card is removed for any reason
local remove_card_ref = CardArea.remove_card
function CardArea:remove_card(card, discarded_only)
    local ret_card = remove_card_ref(self, card, discarded_only)

    if card then
        SMODS.calculate_context({
            card_removed = true,
            other_card = ret_card,
            cardarea = ret_card.area
        }) 
    end

    return ret_card
end