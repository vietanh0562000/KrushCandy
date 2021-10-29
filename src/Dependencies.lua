-- library draw game at virtual resolution but keep window size
push = require('libs/push');

-- library create base Class in lua
Class = require('libs/class');

-- all constants in game
require('src/Constants');

-- load state machine and all state in game
require('src/StateMachine');
require('src/states/BaseState');
require('src/states/WelcomeState');