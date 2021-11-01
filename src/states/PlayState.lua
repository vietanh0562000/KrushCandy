PlayState = Class{__includes = BaseState};

function PlayState:init()
    self.gridBox = {};

    -- info of player
    self.point = 0;
    self.time = 100;
    self.infoContainer = {
        y = -50;
    }

    -- set all animation
    self:setAnimation();
end

-- Set animation for this screen
function PlayState:setAnimation()
    Timer.tween(2, {
        [self.infoContainer] = {
            y = 20;
        }
    })
end

-- Enter params value to variables
function PlayState:enter(params)
    self.gridBox = params.gridBox;
end

function PlayState:update(dt)
    self.gridBox:update(dt);
end

function PlayState:render()
    -- render grid
    self.gridBox:render();

    -- render info table
    love.graphics.setColor(80 / 255, 119 / 255, 181 / 255, 0.8);
    love.graphics.rectangle('fill', 10, self.infoContainer.y, 80, 50);
end
