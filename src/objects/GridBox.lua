GridBox = Class{};

function GridBox:init(params)
    self.scoreGot = 0;
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

    -- has animation on grid
    self.hasAnim = false;
end

-- receive candies list. If the table has empties. A candy will be filled to it
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
    self.scoreGot = 0;
    -- Knife timer update
    Timer.update(dt);

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

    -- scan all grid to find match when grid no anim
    if (not self.hasAnim) then
        for i = 1, self.rows do
            for j = 1, self.cols do
                -- when not empty slot
                if not (self.gridCandies[i][j].type == -1) then
                    self:detectMatch(i, j);    
                end
            end
        end 
    end

    -- update empty slot
    for i = self.rows, 1, -1 do
        for j = self.cols, 1, -1 do
            if (self.gridCandies[i][j].type == -1) then
                self:updateGrid(i, j);         
            end
        end
    end
end

-- if slot (i, j) is empty find above candy to fall down. If it has no candy above create new one.
function GridBox:updateGrid(i, j) 
    -- findI is id of candy above slot(i, j)
    local findI = i;
    while (findI > 0 and self.gridCandies[findI][j].type == -1) do
        findI = findI - 1;
    end

    -- findJ > 0 -> has candy. If not -> create new one to insert that slot
    if (findI > 0) then
        self.gridCandies[i][j] = self.gridCandies[findI][j];
        self.gridCandies[findI][j] = Candy({type = -1});
    else
        local newCandy = Candy({type = math.random(1, 5)});
        newCandy:changePos({
            x = self.x + (j - 1) * 32,
            y = -32
        });
        self.gridCandies[i][j] = newCandy;
    end

    -- Animation for new candy move to new position
    Timer.tween(0.5, {
        [self.gridCandies[i][j]] = {
            y = self.y + (i - 1) * 32;
        }
    })
end

-- detect candy(i, j) whether it matchs with each other or not
function GridBox:detectMatch(i, j)
    -- matchJ and matchI is the furthest candy id match with candy(i, j)
    local matchJ = j;
    local matchI = i;

    -- detect horizontal
    while (matchJ + 1 <= self.cols) and
        (self.gridCandies[i][matchJ].type == self.gridCandies[i][matchJ + 1].type) do
        matchJ = matchJ + 1;
    end

    -- detect vertical
    while (matchI + 1 <= self.rows) and
        (self.gridCandies[matchI][j].type == self.gridCandies[matchI + 1][j].type) do
        matchI = matchI + 1;
    end

    -- resolve when match set candies type to -1 (aka destroyed) after animation move
    -- when candy became -1 scoreGot increase 1
    -- horizontal
    if (matchJ - j > 1) then
        self.hasAnim = true;
        Timer.after(0.5, function ()
            for k = j, matchJ do
                self.gridCandies[i][k].type = -1;
                self.scoreGot = self.scoreGot + 1;
            end    
            self.hasAnim = false;
        end)
    end
    -- vertical
    if (matchI - i > 1) then
        self.hasAnim = true;
        Timer.after(0.5, function ()
            for k = i, matchI do
                self.gridCandies[k][j].type = -1;
                self.scoreGot = self.scoreGot + 1;
            end
            self.hasAnim = false;
        end)
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
    -- animation move candy to new position
    Timer.tween(0.5, {
        [self.gridCandies[firstId.y][firstId.x]] = {
            x = self.gridCandies[secondId.y][secondId.x].x,
            y = self.gridCandies[secondId.y][secondId.x].y
        },
        [self.gridCandies[secondId.y][secondId.x]] = {
            x = self.gridCandies[firstId.y][firstId.x].x,
            y = self.gridCandies[firstId.y][firstId.x].y
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
