local _Entity = FindMetaTable( "Entity" );
local _SetNoDraw = _Entity.SetNoDraw;

function _Entity:SetNoDraw( BooleanValue )

    if ( not IsValid( self ) ) then return; end;

    if ( not MWorld.Manager:EntityExistsInWorld( LocalPlayer(), self ) ) then
        _SetNoDraw( self, true );
        return;
    end;
    
    _SetNoDraw( self, BooleanValue );

end;