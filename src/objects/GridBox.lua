GridBox = Class{};

function GridBox:init(params)
    -- top left position of grid on screen
    self.x = params.x;
    self.y = params.y;

    -- rows and columns of grid
    self.rows = params.rows;
    self.cols = params.cols;

    -- size of gird
    self.width = self.cols * 32;
    self.height = self.rows * 32;

    -- candies
    self.gridCandies = {}
    -- init grid candies
    for i = 1, self.rows do
        self.gridCandies[i] = {};
        for j = 1, self.cols do
            self.gridCandies[i][j] = nil;
        end
    end
end

function GridBox:insertCandy(candies)
    local idCandy = 1;

    for i = 1, self.rows do
        for j = 1, self.cols do
            if self.gridCandies[i][j] == nil then
                -- set pos candy in grid
                candies[idCandy]:changePos({
                    x = self.x + (j-1) * 32,
                    y = self.y + (i-1) * 32
                })

                -- add candy to gird
                self.gridCandies[i][j] = candies[idCandy];

                -- move to next candy in list
                idCandy = idCandy + 1;
            end
        end
    end
end

function GridBox:update(dt)
    if love.mouse.isDown(1) then
        -- get pos mouse in window
        local mouse = {
            x = love.mouse.getX();
            y = love.mouse.getY();
        }

        -- get pos mouse in virtual
        mouse.x, mouse.y = push:toGame(mouse.x, mouse.y);
        -- if click into the grid
        if (mouse.x > self.x and mouse.y > self.y 
            and mouse.x < self.x + self.width
            and mouse.y < self.y + self.height) then
                -- change from postion mouse click to position on grid
                local candyPos = {
                    x = math.floor((mouse.x - self.x) / 32) + 1,
                    y = math.floor((mouse.y - self.y) / 32) + 1
                }
                -- select that candy
                self:selectCandy(candyPos);
            end
    end
end

function GridBox:selectCandy(candyPos)
    self.gridCandies[candyPos.y][candyPos.x].type = 20;
end

function GridBox:render()
    for i = 1, self.rows do
        for j = 1, self.cols do
            self.gridCandies[i][j]:render();
        end
    end
end
