StateMachine = Class{};

function StateMachine:init(states)
    self.empty = {
        init = function() end,
        enter = function() end,
        update = function() end,
        render = function() end,
        exit = function() end,
    }

    self.states = states or {};
    self.currentState = self.empty;
end

function StateMachine:change(stateName, params)
    assert(self.states[stateName]);
    self.currentState:exit();
    self.currentState = self.states[stateName]();
    self.currentState:enter(params);
end


function StateMachine:update(dt)
    self.currentState:update(dt);
end

function StateMachine:render()
    self.currentState:render();
end
