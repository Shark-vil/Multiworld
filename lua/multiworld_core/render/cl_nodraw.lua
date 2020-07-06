hook.Add( 'MWorld_SetPlayerWorld', MWorld.Prefix .. "_PLayer_ChangeWorld", function( ply, world_name )

    local World = MWorld.Worlds:GetWorld( world_name );
    local Ents = World:GetEntities();

    for _, ent in pairs( MWorld.Manager:GetRegistredEntities() ) do
        if ( IsValid( ent ) ) then
            if ( table.HasValue( Ents, ent ) ) then
                ent:SetNoDraw( false );
            else
                ent:SetNoDraw( true );
            end;
        end;
    end;

end );

hook.Add( 'MWorld_PlayerSpawnedProp', MWorld.Prefix .. '_PlayerSpawnedProp', function( ent, world_name )

    if ( IsValid( ent ) and local_world_name ~= world_name ) then
        ent:SetNoDraw( true );
    end;

end );