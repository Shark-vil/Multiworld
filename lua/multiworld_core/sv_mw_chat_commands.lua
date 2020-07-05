local function GetCommand( text, command_name )
    return string.find( text, "^/".. command_name );
end;

local function GetCommandArgs( text, startpos )
    return string.Explode( ' ', string.sub( text, startpos ) );
end;

local function CommandExec( cmd_name, text, func )

    local cmd_startpos, cmd_endpos = GetCommand( text, cmd_name );

    if ( tobool( cmd_startpos ) ) then
        local args = GetCommandArgs( text, cmd_endpos + 2 );
        func( cmd_name, args );
        return true;
    end;

    return false;
end;

hook.Add( 'PlayerSay', MWorld.Prefix .. '_Chat_Commands', function( ply, text, isTeanChat )

    local isCommand = false;
    local text = string.lower( text );

    isCommand = CommandExec( 'mw create', text, function( cmd_name, args )

        if ( args[ 1 ] ~= nil ) then
            
            local World = MWorld.Worlds:Create( ply, args[ 1 ], args[ 2 ] );

            if ( World ~= nil ) then
                ply:ChatPrint( '[Multiworld][Sccess] The world has been successfully created!' );
                ply:ChatPrint( 'To enter it, write: /mw join ' .. args[ 1 ] );
            else
                ply:ChatPrint( '[Multiworld][Error] Such a world already exists or incorrect parameters have been set.' )
            end;

        else
            ply:ChatPrint( '[Multiworld][Error] Missing arguments! Template: /' .. cmd_name .. ' <world name> <password (optional)>' )
        end;

    end );

    isCommand = CommandExec( 'mw join', text, function( cmd_name, args )

        if ( args[ 1 ] ~= nil ) then
            
            local IsJoin = MWorld.Manager:JoinWorld( ply, args[ 1 ], args[ 2 ] );

            if ( IsJoin ) then
                ply:ChatPrint( '[Multiworld][Sccess] You have entered the world!' );
            else
                ply:ChatPrint( '[Multiworld][Error] Failed to enter the world. Possibly incorrect data entered.' )
            end;

        else
            ply:ChatPrint( '[Multiworld][Error] Missing arguments! Template: /' .. cmd_name .. ' <world name> <password (optional)>' )
        end;

    end );

    isCommand = CommandExec( 'mw reset', text, function( cmd_name, args )

        local IsReset = MWorld.Manager:SetPlayerWorld( ply );
        ply:ChatPrint( '[Multiworld][Sccess] You are back in the main world.' );

    end );

    if ( isCommand ) then
        return '';
    end;

end );