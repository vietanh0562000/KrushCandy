PlayState = Class{__includes = BaseState};

function PlayState:init()
    self.gridBox = {};

    -- info of player
    self.score = 0;
    self.time = 10;
    self.infoContainer = {
        y = -50;
    }

    -- set Time
    Timer.every(1, function ()
        self.time = self.time - 1;
    end)
    -- set all animation
    self:setAnimation();
end

-- Set animation for this screen
function PlayState:setAnimation()
    Timer.tween(1, {
        [self.infoContainer] = {
            y = 50;
        }
    })
end

-- Enter params value to variables
function PlayState:enter(params)
    self.gridBox = params.gridBox;
end

function PlayState:update(dt)
    self.gridBox:update(dt);

    self.score = self.score + self.gridBox.scoreGot;

    if (self.time == 0) then
        gStateMachine:change('GameOver', {score = self.score});
    end
end

function PlayState:render()
    -- render grid
    self.gridBox:render();

    -- render info table
    love.graphics.setColor(80 / 255, 119 / 255, 181 / 255, 0.8);
    love.graphics.rectangle('fill', 10, self.infoContainer.y, 80, 100);
    -- render info
    love.graphics.setColor(255, 255, 255);
    love.graphics.printf('Score: '..self.score, 12, self.infoContainer.y + 2, 90, 'left');
    love.graphics.printf('Time: '..self.time, 12, self.infoContainer.y + 20, 90, 'left');
end
