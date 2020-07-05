--[[

    Description:
    The functionality of this meta table is responsible for 
    managing between players and virtual worlds.

--]]

local PlayerWorlds = {};

local Meta = {

    JoinWorld = function( self, ply, world_name, world_password )

        local World = MWorld.Worlds:GetWorld( world_name );

        if ( ply:IsAdmin() or ply:IsSuperAdmin() ) then
            self.SetPlayerWorld( ply, world_name );
            return true;
        else
            if ( World:GetPassword() == world_password ) then
                self.SetPlayerWorld( ply, world_name );
                return true;
            end;
        end;

        return false;
    end,

    SetPlayerWorld = function( self, ply, world_name )

        PlayerWorlds[ ply ] = world_name;
        hook.Run( 'MWorld_SetPlayerWorld', ply, world_name );

    end,

    GetPlayerWorld = function( ply )
        return PlayerWorlds[ ply ];
    end,

};

MWorld.Manager = {};

Meta.__index = Meta;
setmetatable( MWorld.Manager, Meta );