WelcomeState = Class{__includes = BaseState}

function WelcomeState:init()
    self.menu = {
        [1] = 'Play',
        [2] = 'Quit'
    }
    self.seletingOption = 1;
end

function WelcomeState:update(dt)
    -- change option selecting
    if (love.keyboard.wasPress('up')) then
        self.seletingOption = math.max(1, self.seletingOption - 1);
    end
    if (love.keyboard.wasPress('down')) then
        self.seletingOption = math.min(#self.menu, self.seletingOption + 1);
    end

    -- go to option
    if (love.keyboard.wasPress('return')) then
        if (self.seletingOption == 1) then
            gStateMachine:change('BeginningPlay');
        end
    end
end

function WelcomeState:render()
    love.graphics.setColor(255, 255, 255, 1);

    -- draw two box menu
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 110, VIRTUAL_HEIGHT / 2 - 60, 220, 60, 6);
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 110, VIRTUAL_HEIGHT / 2 + 10, 220, 60, 6);

    -- print game name
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.setFont(gFonts['large']);
    love.graphics.printf("Krush Candy", 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center');

    -- draw menu
    love.graphics.setFont(gFonts['medium']);
    for i = 1, #self.menu do
        -- set color for each option. If player is chosing it. it turn blue else it turn black
        if (self.seletingOption == i) then
            love.graphics.setColor(44 / 255, 121 / 255, 1, 1);
        else
            love.graphics.setColor(0, 0, 0);    
        end

        -- draw
        love.graphics.printf(self.menu[i], 0, VIRTUAL_HEIGHT / 2 + 20 * i, VIRTUAL_WIDTH, 'center');
    end
end
