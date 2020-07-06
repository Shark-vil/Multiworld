hook.Add( MWorld.Prefix .. '_PlayerInitialSpawn', 'Main', function( ply )

    timer.Simple( 0.1, function()

        MWorld.Manager:Syns( ply, 'master', true );

        timer.Simple( 0.2, function()
            MWorld.Manager:SetPlayerWorld( ply, 'master' );

            local Worlds = MWorld.Worlds:GetWorlds();
            for WorldName, World in pairs( Worlds ) do
                if ( WorldName ~= 'master' ) then
                    timer.Simple( 0.1, function()
                        MWorld.Manager:Syns( ply, WorldName );
                    end );
                end;
            end;
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