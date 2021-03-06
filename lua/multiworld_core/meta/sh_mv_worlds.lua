--[[

    Description:
    This meta table is responsible for managing virtual worlds.
    Create, delete, merge, and more.

--]]

local Worlds = {};

local Meta = {

    NormalizeWorldName = function( self, world_name )
        world_name = tostring( world_name );
        local strLower = string.lower( world_name );
        local strReplace = string.Replace( strLower, ' ', '' );
        
        return world_name;
    end,

    Create = function( self, ply, world_name, world_password )

        world_name = self:NormalizeWorldName( world_name );

        if ( string.len( world_name ) == 0 ) then
            return nil;
        end;

        if ( ply ~= nil and world_name == 'master' ) then
            return nil;
        end;

        if ( Worlds[ world_name ] == nil ) then

            local steamid64;

            if ( ply == nil ) then
                steamid64 = 'world';
            else
                steamid64 = ply:SteamID();
            end;

            local World = {
                WorldName = world_name,
                OwnerId = steamid64,
                Players = {},
                Entities = {},
                Password = world_password;

                GetName = function( self )
                    return self.WorldName;
                end,

                GetOwnerId = function( self )
                    return self.OwnerId;
                end,

                GetOwner = function( self )
                    if ( self.OwnerId == 'world' ) then
                        return self.OwnerId;
                    else
                        return player.GetBySteamID64( self.OwnerId );
                    end;
                end,

                IsOwner = function( self, owner )
                    if ( owner == self:GetOwner() ) then
                        return true;
                    end;

                    return false;
                end,

                AddPlayer = function( self, ply )
                    table.insert( self.Players, ply );
                    MWorld.Debug( 'Added player [ ' .. tostring( ply ) .. ' ] to world ' .. self.WorldName );
                end,

                RemovePlayer = function( self, ply )
                    for i = 1, table.Count( self.Players ) do
                        if ( self.Players[ i ] == ply ) then
                            table.remove( self.Players, i );
                            MWorld.Debug( 'Deleted player [ ' .. tostring( ply ) .. ' ] in world ' .. self.WorldName );
                            break;
                        end;
                    end;
                end,

                GetPlayers = function( self )
                    return self.Players;
                end,

                IsExistsPlayer = function( self, ply )
                    return table.HasValue( self.Players, ply );
                end;

                RopeSync = function( self )

                    if ( SERVER ) then return; end;

                    local ropes = ents.FindByClass( "class C_RopeKeyframe" );

                    for _, ent in pairs( self.Entities ) do
                        local isBreak = false;

                        for _, rope in pairs( ropes ) do
                            if ( not table.HasValue( self.Entities, rope ) ) then
                                local entsAtRope = ents.FindInSphere( rope:GetPos(), 0.1 );
                                if ( entsAtRope ~= nil ) then
                                    if ( table.HasValue( entsAtRope, ent ) ) then
                                        table.insert( self.Entities, rope );
                                        isBreak = true;
                                        break;
                                    end;
                                end;
                            end;
                        end;

                        if ( isBreak ) then
                            break;
                        end;
                    end;

                end,

                AddEntity = function( self, ent )
                    table.insert( self.Entities, ent );

                    if ( CLIENT ) then
                        -- local ropes = ents.FindByClass( "keyframe_rope" );
                        local ropes = ents.FindByClass( "class C_RopeKeyframe" );

                        for _, rope in pairs( ropes ) do 
                            if ( not table.HasValue( self.Entities, rope ) ) then
                                local entsAtRope = ents.FindInSphere( rope:GetPos(), 0.1 );
                                if ( entsAtRope ~= nil ) then
                                    if ( table.HasValue( entsAtRope, ent ) ) then
                                        table.insert( self.Entities, rope );
                                        break;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    MWorld.Debug( 'Added entity [ ' .. tostring( ent ) .. ' ] to world ' .. self.WorldName );

                    if ( SERVER ) then
                        net.Start( MWorld.Prefix .. '_AddEntity' );
                        net.WriteString( self.WorldName );
                        net.WriteInt( ent:EntIndex(), 32 );
                        net.Broadcast();

                        hook.Run( "MWorld_AddEntity", ent, self.WorldName );
                    end;
                end,

                GetEntities = function( self )
                    return self.Entities;
                end,

                GetPassword = function( self )
                    return self.Password;
                end,

                SetPassword = function( self, ply, new_password )
                    if ( self:IsOwner( ply ) ) then
                        self.Password = new_password;
                        return true;
                    end;
                    return false;
                end
            };

            Worlds[ world_name ] = {};

            World.__index = World;
            setmetatable( Worlds[ world_name ], World );

            if ( SERVER ) then
                net.Start( MWorld.Prefix .. '_WorldCreated' );
                net.WriteString( steamid64 );
                net.WriteString( world_name );
                net.Broadcast();
            end;

            hook.Run( "MWorld_Created", World );

            MWorld.Debug( 'Created new world - ' .. world_name );
            
            return World;

        end;

        return nil;
    end,

    GetWorld = function( self, world_name )
        world_name = self:NormalizeWorldName( world_name );

        return Worlds[ world_name ];
    end,

    GetAllEntities = function( self )
        local Entities = {};

        for _, world in pairs( Worlds ) do
            table.Merge( Entities, world:GetEntities() );
        end;

        return Entities;
    end,

    IsExists = function( self, world_name )
        world_name = self:NormalizeWorldName( world_name );
        
        if ( Worlds[ world_name ] == nil ) then
            return false;
        end;

        return true;
    end,

    GetWorlds = function( self )
        return Worlds;
    end,

    Delete = function( self, ply, world_name )

        world_name = self:NormalizeWorldName( world_name );

        if ( world_name == 'master' ) then
            return;
        end;

        local World = Worlds[ world_name ];

        if ( World ~= nil ) then

            if ( World:GetOwner() == ply ) then

                hook.Run( "MWorld_Deleted", World );
                Worlds[ world_name ] = nil;

                MWorld.Debug( 'Deleted world - ' .. world_name );

            end;

        end;

    end,

    Clear = function( self, ply )
        
        local DeleteList = {};

        if ( ply ~= nil ) then

            for WorldName, World in pairs( Worlds ) do
                if ( World:GetOwner() == ply ) then
                    table.insert( DeleteList, WorldName );
                end;
            end;

        else

            for WorldName, World in pairs( Worlds ) do
                if ( WorldName ~= 'master' ) then
                    table.insert( DeleteList, WorldName );
                end;
            end;

        end;

        for _, WorldName in pairs( DeleteList ) do
            Worlds[ WorldName ] = nil;
            MWorld.Debug( 'Deleted world - ' .. WorldName );
        end;

    end,

};

MWorld.Worlds = {};

Meta.__index = Meta;
setmetatable( MWorld.Worlds, Meta );