hook.Add( "PlayerSpawnedProp", MWorld.Prefix .. "_PlayerSpawnedProp", function( ply, model, ent )

    local World = MWorld.Manager:GetPlayerWorld( ply );
    local Delay = 0.2;
    
    if ( World ~= nil ) then
        timer.Simple( Delay, function()
            MWorld.Manager:RegisterEntity( ent );
            World:AddEntity( ent );
        end );
    else
        timer.Simple( Delay, function()
            MWorld.Manager:RegisterEntity( ent );
        end );
    end;

end );