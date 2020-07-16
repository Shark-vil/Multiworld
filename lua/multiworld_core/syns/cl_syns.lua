net.Receive( MWorld.Prefix .. '_SyncWorld', function( len )

    local world_name = net.ReadString();
    local ownerId = net.ReadString();
    local playerIds = net.ReadTable();
    local entitiesId = net.ReadTable();

    local Owner = nil;
    if ( ownerId ~= 'world' ) then
        Owner = player.GetBySteamID( ownerId );
    end;

    MWorld.Worlds:Create( Owner, world_name );

    local World = MWorld.Worlds:GetWorld( world_name );

    for _, steamid in pairs( playerIds ) do
        World:AddPlayer( player.GetBySteamID( steamid ) );
    end;

    for _, entid in pairs( entitiesId ) do
        World:AddEntity( Entity( entid ) );
    end;

end );