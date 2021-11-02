GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.score = 0;
end

function GameOverState:enter(params)
    self.score = params.score;
end

function GameOverState:update(dt)
    if (love.keyboard.wasPress('return')) then
        gStateMachine:change('BeginningPlay');
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large']);
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center');
    love.graphics.printf(self.score, 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center');
    love.graphics.setFont(gFonts['small']);
    love.graphics.printf('Press enter to play again', 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'center');
end
