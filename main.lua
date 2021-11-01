if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end
require('src/Dependencies');

function love.load()
    -- set title for game
    love.window.setTitle('Krush Candy');

    -- set filter to draw nicer
    love.graphics.setDefaultFilter('nearest', 'nearest');

    -- set up push screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    });

    -- load all fonts for game
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    }

    -- load textures in game
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/match3.png')
    }

    -- load all sprites from texture
    gSprites = {
        ['candies'] = GetQuadsCandy(gTextures['main'])
    }

    -- Init State machine
    gStateMachine = StateMachine({
        ['Welcome'] = function() return WelcomeState() end,
        ['Play'] = function() return PlayState() end,
        ['BeginningPlay'] = function() return BeginningPlayState() end,
    })

    gStateMachine:change('Welcome');

    -- Init input table
    love.keyboard.keyPressed = {};

    -- Init mouse input
    love.mouse.pressed = {
        x = 0,
        y = 0
    }
end

function love.update(dt)
    gStateMachine:update(dt);

    -- reset input
    love.keyboard.keyPressed = {};
    love.mouse.pressed = {
        x = 0,
        y = 0
    }
end

-- save key was pressed
function love.keypressed(key) 
    love.keyboard.keyPressed[key] = true;
end

-- return whether key was pressed ?
function love.keyboard.wasPress(key)
    return love.keyboard.keyPressed[key];
end

-- get position mouse pressed
function love.mousepressed(x, y, button, istouch)
    if (button == 1) then
        love.mouse.pressed = {
            x = x,
            y = y
        }
    end
end

function love.draw()
    push:apply('start');

    -- draw background
    love.graphics.draw(gTextures['background'],
        -- position
        0, 0,
        -- rotation
        0);

    -- state render
    gStateMachine:render();    
    push:apply('end');
end

function love.conf(t)
    t.console = true;
end
