--[[

    Description:
    The functionality of this meta table is responsible for 
    managing between players and virtual worlds.

--]]

local Meta = {

};

MWorld.Manager = {};

Meta.__index = Meta;
setmetatable( MWorld.Manager, Meta );