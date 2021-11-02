-- library draw game at virtual resolution but keep window size
push = require('libs/push');

-- library create base Class in lua
Class = require('libs/class');

-- library knife
Timer = require('libs/knife/timer');

-- all constants in game
require('src/Constants');

-- load state machine and all state in game
require('src/StateMachine');
require('src/states/BaseState');
require('src/states/WelcomeState');
require('src/states/PlayState');
require('src/states/BeginningPlayState');
require('src/states/GameOverState');

-- file has all global function
require('src/Util');

-- create items in each level
require('src/LevelMaker');

-- all objects in game
require('src/objects/Candy');
require('src/objects/GridBox');