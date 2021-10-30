Candy = Class{};

function Candy:init(params)
    -- position candy (to draw)
    self.x = 0;
    self.y = 0;

    -- size of candy
    self.width = 32;
    self.height = 32;

    -- candy type
    self.type = params.type;
end

function Candy:changePos(params)
    self.x = params.x;
    self.y = params.y;
end

function Candy:update(dt)
end

function Candy:render()
    love.graphics.draw(gTextures['main'], gSprites['candies'][self.type], self.x, self.y);
end
