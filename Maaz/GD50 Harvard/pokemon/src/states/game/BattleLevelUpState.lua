BattleLevelUpState = Class{__includes = BaseState}

function BattleLevelUpState:init(statComponents, onClose, canInput)
    self.statComponents = statComponents

    self.msg = self:CreateStatTable()

    self.textbox = Textbox(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64, self.msg, gFonts['small'])

    -- function to be called once this message is popped
    self.onClose = onClose or function() end

    -- whether we can detect input with this or not; true by default
    self.canInput = canInput

    -- default input to true if nothing was passed in
    if self.canInput == nil then self.canInput = true end
end

function BattleLevelUpState:makeEquation(currentValue, increment, stat)
    total = currentValue + increment
    return "\n" .. stat .. ": " .. currentValue .. " + " .. increment .. " = " .. total
end

function BattleLevelUpState:CreateStatTable()
    statsLevelUpMessage = "Congratulations! Level Up!"

    for stat, value in pairs(self.statComponents) do
        increment = value[1]
        current = value[2]
        statsLevelUpMessage = statsLevelUpMessage .. self:makeEquation(current, increment, stat)
    end

    return statsLevelUpMessage
end


function BattleLevelUpState:update(dt)
    if self.canInput then
        self.textbox:update(dt)

        if self.textbox:isClosed() then
            gStateStack:pop()
            self.onClose()
        end
    end
end

function BattleLevelUpState:render()
    self.textbox:render()
end
