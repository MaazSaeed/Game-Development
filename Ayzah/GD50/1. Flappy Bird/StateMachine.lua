StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) -- Ensures the state we want to change to exists
    self.current:exit() -- clean up before the state change
    self.current = self.states[stateName]() -- Sets to new instance of state corresponding to stateName
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end