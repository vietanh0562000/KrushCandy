PlayState = Class{__includes = BaseState};

function PlayState:init()
    self.levelMaker = LevelMaker();
    self.gridBox = GridBox({
        x = VIRTUAL_WIDTH / 2 + 50,
        y = 50,
        rows = 5,
        cols = 5 
    });

    self.gridBox:insertCandy(self.levelMaker:createCandies(self.gridBox.rows * self.gridBox.cols));
end

function PlayState:update(dt)
    self.gridBox:update(dt);
end

function PlayState:render()
    self.gridBox:render();
end
