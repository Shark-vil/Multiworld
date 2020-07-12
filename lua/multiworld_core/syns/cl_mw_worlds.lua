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
    MWorld.Manager:RegisterEntity( ent );

end );

net.Receive( MWorld.Prefix .. '_AddEntity', function( len )

    local world_name = net.ReadString();
    local ent = Entity( net.ReadInt( 32 ) );
    -- local ropes = net.ReadTable();

    local World = MWorld.Worlds:GetWorld( world_name );
    World:AddEntity( ent );

    -- if ( ropes ~= nil and istable( ropes ) and table.Count( ropes ) ~= 0 ) then
    --     for _, ropeIndex in pairs( ropes ) do
    --         local rope = Entity( ropeIndex );
    --         if ( IsValid( rope ) ) then
    --             World:AddEntity( rope );
    --         end;
    --     end;
    -- end;

end );