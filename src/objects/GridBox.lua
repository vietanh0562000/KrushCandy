GridBox = Class{};

function GridBox:init(params)
    -- top left position of grid on screen
    self.x = params.x;
    self.y = params.y;

    -- rows and columns of grid
    self.rows = params.rows;
    self.columns = params.columns;

    -- candies
    self.candies = {};
end

function GridBox:update(dt)
end

function GridBox:render()
end
