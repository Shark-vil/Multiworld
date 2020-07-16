hook.Add( "PlayerSpawnedProp", MWorld.Prefix .. "_PlayerSpawnedProp", function( ply, model, ent )

    local World = MWorld.Manager:GetPlayerWorld( ply );
    local Delay = 0.2;
    
    if ( World ~= nil ) then
        MWorld.Manager:RegisterEntity( ent, World:GetName() );
    else
        MWorld.Manager:RegisterEntity( ent, 'master' );
    end;

end );