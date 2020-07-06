MWorld = {};
MWorld.Prefix = 'Multiworld';
MWorld.Debug = function( text )
    text = tostring( text );
    MsgN( '[Multiworld][Debug] ' .. text );
end;

MWorld.Debug( 'Initialization of the addon...' );

local function GetAddonFilelist( DirectoryPath )
    local FileList = {};
    local Files, Dirs = file.Find( DirectoryPath .. '/*', 'LUA' );

    for _, FileName in pairs( Files ) do
        local FileType = string.lower( string.sub( FileName, 1, 2 ) );
        FileList[ string.lower( DirectoryPath .. '/' .. FileName ) ] = FileType;
    end;

    for _, DirName in pairs( Dirs ) do
        local FileListTemp = GetAddonFilelist( DirectoryPath .. '/' .. DirName );

        for FilePath, Type in pairs( FileListTemp ) do
            FileList[ FilePath ] = Type;
        end;
    end;

    return FileList;
end;

local AddonFileList = GetAddonFilelist( 'multiworld_core' );

for FilePath, Type in pairs( AddonFileList ) do
    MWorld.Debug( 'Loading script -> ' .. FilePath );

    if ( SERVER ) then
        if ( Type ~= 'sv' ) then
            AddCSLuaFile( FilePath );
        end;
        
        if ( Type == 'sv' or Type == 'sh' ) then
            include( FilePath );
            MWorld.Debug( 'Execute script ---> ' .. FilePath );
        end;
    elseif ( CLIENT ) then
        if ( Type == 'cl' or Type == 'sh' ) then
            include( FilePath );
            MWorld.Debug( 'Execute script ---> ' .. FilePath );
        end;
    end;
end;

MWorld.Debug( 'Addon is initialized!' );

AddonFileList = nil;
GetAddonFilelist = nil;

MWorld.Debug( 'Clearing memory from unnecessary lua functions.' );