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

    -- id candy is selected;
    self.selectedCandy = {
        x = 0,
        y = 0
    }
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
    -- Knife timer update
    Timer.update(dt);
    print(self.gridCandies[1][1].x.." "..self.gridCandies[1][1].y);
    print(self.gridCandies[1][2].x.." "..self.gridCandies[1][2].y);

    -- get pos mouse in window
    local mouse = {
        x = love.mouse.pressed.x;
        y = love.mouse.pressed.y;
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

-- update all candy of grid follow grid pos
function GridBox:updatePos()
    -- update all candy of gid
    for i = 1, self.rows do
        for j = 1, self.cols do
            self.gridCandies[i][j]:changePos({   
                x = self.x + (j-1) * 32,
                y = self.y + (i-1) * 32
            })
        end
    end
end

-- click to select candy if it has candy is selected swap two candies
function GridBox:selectCandy(candyPos)
    if (self.selectedCandy.x == 0 and self.selectedCandy.y == 0) then
        self.selectedCandy.x = candyPos.x;
        self.selectedCandy.y = candyPos.y;
    else 
        -- swap candy
        self:swapCandy(
            {x = candyPos.x, y = candyPos.y},
            {x = self.selectedCandy.x, y = self.selectedCandy.y}
        )

        self.selectedCandy.x = 0;
        self.selectedCandy.y = 0;
    end
end


-- Animation swap two candy
function GridBox:swapCandy(firstId, secondId)
    -- save position of candy
    local newFirstPos = {
        x = self.gridCandies[secondId.y][secondId.x].x,
        y = self.gridCandies[secondId.y][secondId.x].y
    }
    local newSecondPos = {
        x = self.gridCandies[firstId.y][firstId.x].x,
        y = self.gridCandies[firstId.y][firstId.x].y
    }

    -- animation move candy to new position
    Timer.tween(0.5, {
        [self.gridCandies[firstId.y][firstId.x]] = {
            x = newFirstPos.x,
            y = newFirstPos.y
        }
    });

    Timer.tween(0.5, {
        [self.gridCandies[secondId.y][secondId.x]] = {
            x = newSecondPos.x,
            y = newSecondPos.y
        }
    })

    -- swap two candies in grid
    local tmpCandy = self.gridCandies[secondId.y][secondId.x];
    self.gridCandies[secondId.y][secondId.x] = self.gridCandies[firstId.y][firstId.x];
    self.gridCandies[firstId.y][firstId.x] = tmpCandy;
end

function GridBox:render()
    for i = 1, self.rows do
        for j = 1, self.cols do
            self.gridCandies[i][j]:render();
        end
    end
end
