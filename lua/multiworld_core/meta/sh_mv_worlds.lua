--[[

    Description:
    This meta table is responsible for managing virtual worlds.
    Create, delete, merge, and more.

--]]

local Worlds = {};

local Meta = {

    Create = function( self, ply, world_name, world_password )

        local world_name = tostring( string.Replace( string.lower( world_name ), ' ', '' ) );

        if ( string.len( world_name ) == 0 ) then
            return nil;
        end;

        if ( Worlds[ world_name ] == nil ) then

            local World = {
                OwnerId = ply:SteamID64(),
                Players = {},
                Entities = {},
                Password = world_password;

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

                SetPassword = function( self, ply, new_password )
                    if ( ply == self.GetOwner( ply ) ) then
                        self.Password = new_password;
                        return true;
                    end;
                    return false;
                end
            };

            Worlds[ world_name ] = {};

            World.__index = World;
            setmetatable( Worlds[ world_name ], World );

            hook.Run( "MWorld_Created", World );
            return World;

        end;

        return nil;
    end,

    GetWorld = function( self, world_name )
        return Worlds[ world_name ];
    end,

    GetWorlds = function( self )
        return Worlds;
    end,

    Delete = function( self, ply, world_name )

        local World = Worlds[ world_name ];

        if ( World ~= nil ) then

            if ( World:GetOwner() == ply ) then

                hook.Run( "MWorld_Deleted", World );
                Worlds[ world_name ] = nil;

            end;

        end;

    end,

    Clear = function( self, ply )
        
        if ( ply ~= nil ) then

            local DeleteList = {};

            for WorldName, World in pairs( Worlds ) do
                if ( World:GetOwner() == ply ) then
                    table.insert( DeleteList, WorldName );
                end;
            end;

            for _, WorldName in pairs( DeleteList ) do
                Worlds[ WorldName ] = nil;
            end;

        else
            table.Empty( Worlds );
        end;

    end,

};

MWorld.Worlds = {};

Meta.__index = Meta;
setmetatable( MWorld.Worlds, Meta );