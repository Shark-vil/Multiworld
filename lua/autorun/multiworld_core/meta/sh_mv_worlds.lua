--[[

    Description:
    This meta table is responsible for managing virtual worlds.
    Create, delete, merge, and more.

--]]

local _Worlds = {};

local Meta = {

    Create = function( self, ply, world_name )

        if ( _Worlds[ world_name ] == nil ) then

            local World = {
                OwnerId = ply:SteamID64(),
                Players = {},
                Entities = {},
                Password = '';

                GetOwnerId = function( self )
                    return self.OwnerId;
                end,

                GetOwner = function( self )
                    return self.player.GetBySteamID64( OwnerId );
                end,

                GetPlayers = function( self )
                    return self.Players;
                end,

                IsExistsPlayer = function( self, ply )
                    return table.HasValue( self.Players, ply );
                end;

                GetEntities = function( self )
                    return self.Entities;
                end,

                GetPassword = function( self )
                    return self.Password;
                end,

                SetPassword = function( self, new_password )
                    self.Password = new_password;
                end
            };

            _Worlds[ world_name ] = {};

            World.__index = World;
            setmetatable( _Worlds[ world_name ], World );

            hook.Run( "MWorld_Created", World );

        end;

    end,

    GetWorld = function( self, world_name )
        return _Worlds[ world_name ];
    end,

    GetWorlds = function( self )
        return _Worlds;
    end,

    Delete = function( self, ply, world_name )

        local World = _Worlds[ world_name ];

        if ( World ~= nil ) then

            if ( World:GetOwner() == ply ) then

                hook.Run( "MWorld_Deleted", World );
                _Worlds[ world_name ] = nil;

            end;

        end;

    end;

};

MWorld.Worlds = {};

Meta.__index = Meta;
setmetatable( MWorld.Worlds, Meta );