net.Receive( MWorld.Prefix .. '_PlayerSetWorld', function( len )

    local ply = player.GetBySteamID( net.ReadString() );
    local world_name = net.ReadString();

    MWorld.Manager:SetPlayerWorld( ply, world_name );

end );