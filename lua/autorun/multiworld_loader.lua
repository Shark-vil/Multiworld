MWorld = {};

print( '[Multiworld] Initialization of the addon...' );

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
    print( '[Multiworld] Loading script -> ' .. FilePath );

    if ( SERVER ) then
        if ( Type ~= 'sv' ) then
            AddCSLuaFile( FilePath );
        end;
        
        if ( Type == 'sv' or Type == 'sh' ) then
            include( FilePath );
            print( '[Multiworld] Execute script ---> ' .. FilePath );
        end;
    elseif ( CLIENT ) then
        if ( Type == 'cl' or Type == 'sh' ) then
            include( FilePath );
            print( '[Multiworld] Execute script ---> ' .. FilePath );
        end;
    end;
end;

print( '[Multiworld] Addon is initialized!' );

AddonFileList = nil;
GetAddonFilelist = nil;

print( '[Multiworld] Clearing memory from unnecessary lua functions.' );