LevelMaker = Class{};

function LevelMaker:init()
    self.level = 1;
    self.numberType = 10;
end

function LevelMaker:changeLevel(level)
    self.level = level;
end

function LevelMaker:createCandies(quantity)
    local candies = {};
    for i = 1, quantity do
        -- random type
        local type = math.random(1, self.numberType);
        -- create new candy and insert table
        local newCandy = Candy({type= type});
        table.insert( candies, newCandy);
    end

    return candies;
end