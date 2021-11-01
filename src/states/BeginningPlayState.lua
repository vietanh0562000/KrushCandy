BeginningPlayState = Class{__includes = BaseState};

function BeginningPlayState:init()
    -- opacity of transition
    self.transition = {
        opacity = 255
    }
    -- time transition
    self.time = 2;
    -- banner level
    self.banner = {
        y = -30
    }
    --[[
        grid of candy
    ]]--
    -- level manager
    self.levelMaker = LevelMaker();
    self.gridBox = GridBox({
        x = VIRTUAL_WIDTH / 2 - 50,
        y = 50,
        rows = 5,
        cols = 5 
    });
    -- init all candies in the level
    self.gridBox:insertCandy(self.levelMaker:createCandies(self.gridBox.rows * self.gridBox.cols));

    self:setAnimation();
end

  --[[
        Set Animation for some components
    ]]
function BeginningPlayState:setAnimation()
    -- tween transition
    Timer.tween(self.time, {
        [self.transition] = {
            opacity = 0
        }
    })
    -- move banner from top to middle. stay for 1s and move to bot
    :finish(function ()
        Timer.tween(0.5, {
            [self.banner] = {
                y = VIRTUAL_HEIGHT / 2 - 10
            }
        })
        :finish(function ()
            -- move grid
            Timer.tween(1, {
                -- animation move for grid
                [self.gridBox] = {
                    x = VIRTUAL_WIDTH / 2 + 50
                }
            });

            -- waiting at middle for a while
            Timer.after(0.6, function ()
                Timer.tween(0.5, {
                    -- move banner to bottom
                    [self.banner] = {
                        y = VIRTUAL_HEIGHT + 30
                    },
                })
                :finish(function ()
                    gStateMachine:change('Play', {gridBox = self.gridBox});
                end)
            end)
        end)
    end)
end

function BeginningPlayState:update(dt)
    Timer.update(dt);

    -- update position of grid
    self.gridBox:updatePos();

end

function BeginningPlayState:render()
    -- grid box candies
    self.gridBox:render();

    -- background transition
    love.graphics.setColor(255, 255, 255, self.transition.opacity / 255);
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT);

    -- banner level
    love.graphics.setColor(31 / 255, 233 / 255, 255 / 255, 1);
    love.graphics.rectangle('fill', 0, self.banner.y, VIRTUAL_WIDTH, 30);
    love.graphics.setColor(255, 255, 255);
    love.graphics.setFont(gFonts['medium']);
    love.graphics.printf('Level 1', 0, self.banner.y + 10, VIRTUAL_WIDTH, 'center');    
end
