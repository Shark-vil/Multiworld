hook.Add( 'MWorld_SetPlayerWorld', MWorld.Prefix .. "_PLayer_ChangeWorld", function( ply, world_name )

    local Worlds = MWorld.Worlds:GetWorlds();

    local function EntityDrawing( ent, IsDrawing )
        if ( IsValid( ent ) and ent:GetClass() == "prop_physics" ) then
            if ( IsDrawing ) then
                ent:SetNoDraw( false );
            else
                ent:SetNoDraw( true );
            end;
        end;
    end;

    local function RopeDrawing( rope, IsDrawing )
        if ( IsValid( rope ) and rope:GetClass() == "class C_RopeKeyframe" ) then
            local RenderMode;
            
            if ( IsDrawing ) then
                RenderMode = RENDERMODE_NORMAL;
            else
                RenderMode = RENDERMODE_TRANSCOLOR;
            end;

            if ( rope:GetRenderMode() ~= RenderMode ) then
                rope:SetRenderMode( RenderMode );
            end;
        end;
    end;

    for _, World in pairs( Worlds ) do
        local IsDrawing = false;

        if ( World:GetName() == world_name ) then
            IsDrawing = true;
        end;

        for _, ent in pairs( World:GetEntities() ) do
            EntityDrawing( ent, IsDrawing );
            RopeDrawing( ent, IsDrawing );
        end;
    end;

end );

hook.Add( 'MWorld_PlayerSpawnedProp', MWorld.Prefix .. '_PlayerSpawnedProp', function( ent, world_name )

    if ( IsValid( ent ) and local_world_name ~= world_name ) then
        ent:SetNoDraw( true );
    end;

end );