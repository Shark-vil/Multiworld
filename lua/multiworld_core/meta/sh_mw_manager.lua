--[[

    Description:
    The functionality of this meta table is responsible for 
    managing between players and virtual worlds.

--]]

local PlayerWorlds = {};
local RegistredEntity = {};

local Meta = {

    JoinWorld = function( self, ply, world_name, world_password )

        if ( world_name == nil or string.len( string.Replace( world_name, ' ', '') ) == 0 ) then
            return false;
        end;

        local World = MWorld.Worlds:GetWorld( world_name );

        if ( ply:IsAdmin() or ply:IsSuperAdmin() ) then
            self:SetPlayerWorld( ply, world_name );
            return true;
        else
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

        PlayerWorlds[ ply ] = world_name;
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

    RegisterEntity = function( self, ent )
        table.insert( RegistredEntity, ent );

        if ( SERVER ) then
            net.Start( MWorld.Prefix .. '_RegisterEntity' );
            net.WriteInt( ent:EntIndex(), 32 );
            net.Broadcast();
        end;
    end,

    GetRegistredEntities = function( self )
        return RegistredEntity;
    end,

    EntityExistsInWorld = function( self, ply, ent )
        if ( table.HasValue( RegistredEntity, ent ) ) then
            local World = self:GetPlayerWorld( ply );

            if ( World ~= nil and not table.HasValue( World:GetEntities(), ent ) ) then
                return false;
            end;
        end;

        return true;
    end,

    Syns = function( self, ply, world_name, syns_regent )

        if ( CLIENT ) then return; end;

        if ( syns_regent ~= nil and tobool( syns_regent ) ) then
            local RegistredEntityIds = {};

            for _, ent in pairs( RegistredEntity ) do
                table.insert( RegistredEntityIds, ent:EntIndex() );
            end;

            net.Start( MWorld.Prefix .. '_SynsRegisterEntity' );
            net.WriteTable( RegistredEntityIds );
            net.Send( ply );
        end;

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

        net.Start( MWorld.Prefix .. '_SynsWorld' );
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