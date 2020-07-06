net.Receive( MWorld.Prefix .. '_Player_SetWorld', function( len )

    local world_name = net.ReadString();
    hook.Run( 'MWorld_SetPlayerWorld', LocalPlayer(), world_name );

end );