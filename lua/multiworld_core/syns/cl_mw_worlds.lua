net.Receive( MWorld.Prefix .. '_WorldCreated', function( len )

    local ownerId = net.ReadString();
    local world_name = net.ReadString();

    local ply = nil;
    if ( ownerId ~= 'master' ) then
        ply = player.GetBySteamID( ownerId );
    end;
    
    MWorld.Worlds:Create( ply, world_name );

end );

net.Receive( MWorld.Prefix .. '_RegisterEntity', function( len )

    local ent = Entity( net.ReadInt( 32 ) );
    
    --[[
    local entMeta = getmetatable( ent );
    local originalSetNoDraw = entMeta.SetNoDraw;

    entMeta.SetNoDraw = function( self, BooleanValue )

        if ( not IsValid( self ) ) then return; end;

        if ( not MWorld.Manager:EntityExistsInWorld( LocalPlayer(), self ) ) then
            originalSetNoDraw( self, true );
            return;
        end;
        
        originalSetNoDraw( self, BooleanValue );

    end;
    --]]

    MWorld.Manager:RegisterEntity( ent );

end );

net.Receive( MWorld.Prefix .. '_AddEntity', function( len )

    local world_name = net.ReadString();
    local ent = Entity( net.ReadInt( 32 ) );

    local World = MWorld.Worlds:GetWorld( world_name );
    World:AddEntity( ent );

end );