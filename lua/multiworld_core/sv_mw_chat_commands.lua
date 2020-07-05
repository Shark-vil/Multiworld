local function IsCommand( text, command_name )
    return string.find(string.lower(text),"^/".. command_name .. " ");
end;

hook.Add( 'PlayerSay', MWorld.Prefix .. '_Chat_Commands', function( ply, text, isTeanChat )

    if ( IsCommand( text, 'mw create' ) ) then

        ply:Kill();

    end;

end );