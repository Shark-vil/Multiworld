hook.Add( "Initialize", MWorld.Prefix .. '_CreateMasterWorld', function()

    MWorld.Worlds:Create( nil, 'master' );

end );

hook.Add( "MWorld_Created", MWorld.Prefix .. "MWorld_Created_Test", function( World )

    MsgN( "CREATE WORLD - " .. World:GetName() );

end );