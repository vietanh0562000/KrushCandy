--[[
    This file contains all global function
]]

-- return quad of all candies from match3.png. See that image to understand well
function GetQuadsCandy(atlas)
    local quads = {};

    -- number candies
    local counter = 0;

    for i = 0, 8 do
        for j = 0, 11 do
            counter = counter + 1;

            -- i * 32 and j * 32 are positions of candies
            quads[counter] = love.graphics.newQuad(j * 32, i * 32, 32, 32, atlas:getDimensions());
        end
    end

    return quads;
end
