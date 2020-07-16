--[[

    Description:
    The functionality of this meta table is responsible for 
    managing between players and virtual worlds.

--]]

local PlayerWorlds = {};

local Meta = {

    JoinWorld = function( self, ply, world_name, world_password )

        if ( world_name == nil or string.len( string.Replace( world_name, ' ', '') ) == 0 ) then
            return false;
        end;

        if ( not MWorld.Worlds:IsExists( world_name ) ) then
            return false;
        end;

        if ( ply:IsAdmin() or ply:IsSuperAdmin() ) then
            self:SetPlayerWorld( ply, world_name );
            return true;
        else
            local World = MWorld.Worlds:GetWorld( world_name );
            if ( World:GetPassword() == world_password ) then
                self:SetPlayerWorld( ply, world_name );
                return true;
            end;
        end;

        return false;
    end,

    SetPlayerWorld = function( self, ply, world_name )

        if ( world_name == nil ) then
            world_name = 'master';
        end;

        local World = MWorld.Worlds:GetWorld( world_name );

        if ( World == nil ) then return; end;

        if ( PlayerWorlds[ ply ] ~= nil ) then
            local CurrentWorld = MWorld.Worlds:GetWorld( PlayerWorlds[ ply ] );
            CurrentWorld:RemovePlayer( ply );
        end;

        PlayerWorlds[ ply ] = world_name;

        local CurrentWorld = MWorld.Worlds:GetWorld( world_name );
        CurrentWorld:AddPlayer( ply );

        hook.Run( 'MWorld_SetPlayerWorld', ply, world_name );

        MWorld.Debug( 'Parrent player [ ' .. tostring( ply ) .. ' ] to world ' .. world_name );

        if ( SERVER ) then
            net.Start( MWorld.Prefix .. '_PlayerSetWorld' );
            net.WriteString( ply:SteamID() );
            net.WriteString( world_name );
            net.Broadcast();
        end;

    end,

    GetPlayerWorldName = function( self, ply )
        return PlayerWorlds[ ply ];
    end,

    GetPlayerWorld = function( self, ply )
        return MWorld.Worlds:GetWorld( PlayerWorlds[ ply ] );
    end,

    RegisterEntity = function( self, ent, world_name, delay )
        if ( delay == nil ) then
            delay = 0.2;
        end;

        timer.Simple( delay, function()
            if ( SERVER ) then
                ent:SetCustomCollisionCheck( true );

                if ( world_name ~= nil ) then
                    if ( MWorld.Worlds:IsExists( world_name ) ) then
                        MWorld.Worlds:GetWorld( world_name ):AddEntity( ent );
                    end;
                end;
            end;

            if ( SERVER ) then
                net.Start( MWorld.Prefix .. '_RegisterEntity' );
                net.WriteInt( ent:EntIndex(), 32 );
                net.Broadcast();
            end;
        end );
    end,

    EntityExistsInWorld = function( self, ent )
        
        if ( table.HasValue( MWorld.Worlds:GetAllEntities(), ent ) ) then
            return true;
        end;

        return false;
    end,

    EntityExistsInPlayerWorld = function( self, ply, ent )
        local World = self:GetPlayerWorld( ply );

        if ( World ~= nil and table.HasValue( World:GetEntities(), ent ) ) then
            return true;
        end;

        return false;
    end,

    SyncAll = function( self, ply )

        if ( CLIENT ) then return; end;

        for _, world in pairs( MWorld.Worlds:GetWorlds() ) do
            self:Sync( ply, world:GetName() );
        end

    end,

    Sync = function( self, ply, world_name )

        if ( CLIENT ) then return; end;

        local World = MWorld.Worlds:GetWorld( world_name );

        local PlayersIds = {};
        local EntitiesIds = {};

        local Players = World:GetPlayers();
        for _, ply in pairs( Players ) do
            table.insert( PlayersIds, ply:SteamID() );
        end;

        local Entities = World:GetEntities();
        for _, ent in pairs( Entities ) do
            table.insert( EntitiesIds, ent:EntIndex() );
        end;

        net.Start( MWorld.Prefix .. '_SyncWorld' );
        net.WriteString( World:GetName() );
        net.WriteString( World:GetOwnerId() );
        net.WriteTable( PlayersIds );
        net.WriteTable( EntitiesIds );
        net.Send( ply );

    end,

};

MWorld.Manager = {};

Meta.__index = Meta;
setmetatable( MWorld.Manager, Meta );