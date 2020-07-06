net.Receive( MWorld.Prefix .. '_SynsWorld', function( len )

    local world_name = net.ReadString();
    local ownerId = net.ReadString();
    local playerIds = net.ReadTable();
    local entitiesId = net.ReadTable();

    local Owner = nil;
    if ( ownerId ~= 'master' ) then
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

net.Receive( MWorld.Prefix .. '_SynsRegisterEntity', function( len )

    local RegistredEntityIds = net.ReadTable();

    for _, id in pairs( RegistredEntityIds ) do
        local ent = Entity( id );

        if ( IsValid( ent ) ) then
            MWorld.Worlds:RegisterEntity( ent );
        end;
    end;

end );