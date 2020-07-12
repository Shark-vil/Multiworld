hook.Add( "ShouldCollide", MWorld.Prefix .. "_CustomCollisionOnEntity", function( entity_1, entity_2 )

    local ply, ent;

    if ( IsValid( entity_1 ) and entity_1:IsPlayer() ) then
        ply = entity_1;
        ent = entity_2;
    elseif ( IsValid( entity_2 ) and entity_2:IsPlayer() ) then
        ply = entity_2;
        ent = entity_1;
    end;

    if ( IsValid( ply ) and IsValid( ent ) ) then
        local World = MWorld.Manager:GetPlayerWorld( ply );
        
        if ( not MWorld.Manager:EntityExistsInWorld( ply, ent ) ) then
            return false;
        end;
    end;

end );