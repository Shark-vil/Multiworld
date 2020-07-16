hook.Add( MWorld.Prefix .. '_PlayerInitialSpawn', 'Main', function( ply )

    timer.Simple( 0.5, function()

        MWorld.Manager:SyncAll( ply, 'master' );

        timer.Simple( 0.5, function()
            MWorld.Manager:SetPlayerWorld( ply, 'master' );
        end );

    end );

end );

hook.Add( "PlayerInitialSpawn", MWorld.Prefix .. '_PlayerInitialSpawn', function( ply )
    hook.Add( "SetupMove", tostring( ply ), function( ply, mv, cmd )
        if ( not cmd:IsForced() ) then 
            hook.Run( MWorld.Prefix .. '_PlayerInitialSpawn', ply );
            hook.Remove( "SetupMove", tostring( ply ) );
        end;
    end );
end );