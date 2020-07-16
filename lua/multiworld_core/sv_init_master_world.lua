hook.Add( "Initialize", MWorld.Prefix .. '_CreateMasterWorld', function()

    MWorld.Worlds:Create( nil, 'master' );
    MWorld.Worlds:Create( nil, 'test' ):SetPassword( 'master', '12345' );

end );

hook.Add( "InitPostEntity", MWorld.Prefix .. '_CreateMasterWorld', function()

    local _ent = ents.Create( "prop_physics" );
    _ent:SetModel( "models/props_borealis/bluebarrel001.mdl" );
    _ent:SetPos( Vector( 218, 192, -12223 ) );
    _ent:Spawn();

    local _ent_2 = ents.Create( "prop_physics" );
    _ent_2:SetModel( "models/props_borealis/bluebarrel001.mdl" );
    _ent_2:SetPos( Vector( 218, 192 + 200, -12223 ) );
    _ent_2:Spawn();

    MWorld.Manager:RegisterEntity( _ent, 'master' );
    MWorld.Manager:RegisterEntity( _ent_2, 'test' );

end );

hook.Add( "MWorld_Created", MWorld.Prefix .. "MWorld_Created_Test", function( World )

    MsgN( "CREATE WORLD - " .. World:GetName() );

end );