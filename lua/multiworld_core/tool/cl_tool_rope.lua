hook.Add( "CanTool", MWorld.Prefix .. "_CanTool_RopeDetected", function( ply, tr, tool )

    timer.Simple( 0.3, function()

        if ( tool ~= "rope" ) then return; end;

        local World = MWorld.Manager:GetPlayerWorld( ply );

        if ( World ~= nil ) then
            World:RopeSync();
        end;

    end );

end );