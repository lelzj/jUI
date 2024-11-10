-- https://warcraft.wiki.gg/wiki/Patch_11.0.0/API_changes
-- @todo
local AddonName,Addon = ...;

Addon.FRAMES = CreateFrame( 'Frame' );

Addon.FRAMES.Debug = function( self,... )
    local Prefix = CreateColor(
        Addon.Theme.Debug.r,
        Addon.Theme.Debug.g,
        Addon.Theme.Debug.b
    ):WrapTextInColorCode( AddonName..' Debug' );

    _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', Prefix, ... ) );
end

Addon.FRAMES.Notify = function( self,... )
    local Prefix = CreateColor(
        Addon.Theme.Notify.r,
        Addon.Theme.Notify.g,
        Addon.Theme.Notify.b
    ):WrapTextInColorCode( AddonName );

    _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', Prefix, ... ) );
end

Addon.FRAMES.Warn = function( self,... )
    local Prefix = CreateColor(
        Addon.Theme.Warn.r,
        Addon.Theme.Warn.g,
        Addon.Theme.Warn.b
    ):WrapTextInColorCode( AddonName );

    _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', Prefix, ... ) );
end

Addon.FRAMES.Error = function( self,... )
    local Prefix = CreateColor(
        Addon.Theme.Error.r,
        Addon.Theme.Error.g,
        Addon.Theme.Error.b
    ):WrapTextInColorCode( AddonName );

    _G[ 'DEFAULT_CHAT_FRAME' ]:AddMessage( string.join( ' ', Prefix, ... ) );
end

Addon.FRAMES.AddLocked = function( self,VarData,Parent )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.Theme.Font.Family, Addon.Theme.Font.Normal, Addon.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    FontString:SetTextColor( 
        Addon.Theme.Error.r,
        Addon.Theme.Error.g,
        Addon.Theme.Error.b
    );
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    return FontString;
end

Addon.FRAMES.AddLabel = function( self,VarData,Parent,Theme )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.Theme.Font.Family, Addon.Theme.Font.Normal, Addon.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    if( VarData.Flagged ) then
        FontString:SetTextColor( 
            Addon.Theme.Disabled.r,
            Addon.Theme.Disabled.g,
            Addon.Theme.Disabled.b
        );
    else
        FontString:SetTextColor( 
            Theme.r,
            Theme.g,
            Theme.b
        );
    end
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    return FontString;
end

Addon.FRAMES.AddTip = function( self,VarData,Parent,Theme )
    local FontString = Parent:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' );
    FontString:SetFont( Addon.Theme.Font.Family, Addon.Theme.Font.Normal, Addon.Theme.Font.Flags );
    FontString:SetText( VarData.DisplayText );
    if( VarData.Flagged ) then
        FontString:SetTextColor( 
            Addon.Theme.Disabled.r,
            Addon.Theme.Disabled.g,
            Addon.Theme.Disabled.b
        );
    else
        FontString:SetTextColor( 
            Theme.r,
            Theme.g,
            Theme.b
        );
    end
    FontString:SetJustifyH( 'left' );
    FontString:SetJustifyV( 'top' );
    Parent.DataKeys = {
        Name = VarData.Name,
        DisplayText = VarData.DisplayText,
        Description = VarData.Description,
        Parent = FontString
    };
    Parent:SetScript( 'OnEnter',function( self )
        GameTooltip:SetOwner( self.DataKeys.Parent,'ANCHOR_NONE',0,0 );
        GameTooltip:AddLine( self.DataKeys.DisplayText,nil,nil,nil,false );
        GameTooltip:AddLine( self.DataKeys.Description,1,1,1,true );
        GameTooltip:SetPoint( 'topright',self.DataKeys.Parent,'bottomleft',0,0 );
        GameTooltip:Show();
    end );
    Parent:SetScript( 'OnLeave',function( self )
        GameTooltip:Hide();
    end );
    return FontString;
end

Addon.FRAMES.AddSeperator = function( self,Parent )
  local Texture = Parent:CreateTexture( nil,'BACKGROUND',nil,2 );
  Texture:SetColorTexture( 255/255,255/255,255/255,.1 );
  Texture:SetSize( Parent:GetWidth(),.5 );
  return Texture;
end

Addon.FRAMES.AddBackGround = function( self,Parent )
  local Texture = Parent:CreateTexture( nil,'BACKGROUND',nil,2 );
  Texture:SetColorTexture( 41/255,33/255,36/255,.3 );
  return Texture;
end

Addon.FRAMES.AddRange = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Slider',Key..'Range',Parent,'OptionsSliderTemplate' );
    --[[
    local SliderBackdrop  = {
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true, tileSize = 8, edgeSize = 8,
        insets = { left = 3, right = 3, top = 6, bottom = 6 }
    };
    ]]
    Frame:SetMinMaxValues( VarData.KeyPairs.Low.Value,VarData.KeyPairs.High.Value );
    Frame:SetValueStep( VarData.Step );
    Frame:SetHitRectInsets( 0,0,-10,0 );
    --Frame:SetBackdrop( SliderBackdrop );
    Frame:SetThumbTexture( "Interface\\Buttons\\UI-SliderBar-Button-Horizontal" );
    Frame:SetOrientation( 'HORIZONTAL' );
    Frame.minValue,Frame.maxValue = Frame:GetMinMaxValues();

    Frame.Low:SetText( VarData.KeyPairs.Low.Value );
    Frame.High:SetText( VarData.KeyPairs.High.Value );

    local Point,RelativeFrame,RelativePoint,X,Y = Frame.Low:GetPoint();
    Frame.Low:SetPoint( Point,RelativeFrame,RelativePoint,X+5,Y-5 );

    local Point,RelativeFrame,RelativePoint,X,Y = Frame.High:GetPoint();
    Frame.High:SetPoint( Point,RelativeFrame,RelativePoint,X-5,Y-5 );

    local TreatAsMouseEvent = true;
    local Value = Handler:GetVarValue( Key );

    --[[
    local Working,Error = pcall( Frame.SetValue,Value,TreatAsMouseEvent );
    if( not Working ) then
        print( 'FAILED!','Frame:SetValue',Key,Value,Error );
    end
    ]]
    
    Frame:SetValue( Handler:GetVarValue( Key ),TreatAsMouseEvent );
    Frame.keyValue = Key;
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    --[[
    local ManualBackdrop = {
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, edgeSize = 1, tileSize = 5,
    };
    ]]
    Frame.EditBox = CreateFrame( 'EditBox',Key..'SliderEditBox',Frame,'InputBoxTemplate' --[[and BackdropTemplate]] );
    Frame.EditBox:SetSize( 40,15 );
    --Frame.EditBox:GetFontString():SetJustifyH( 'center' );
    Frame.EditBox:ClearAllPoints();
    Frame.EditBox:SetPoint( 'top',Frame,'bottom',0,2 );
    Frame.EditBox:SetText( Handler:GetVarValue( Key ) );
    --Frame.EditBox:SetBackdrop( ManualBackdrop );
    --[[    
    Frame.EditBox:HookScript( 'OnTextChanged',function( self )
        local Value = self:GetText();
        if( tonumber( Value ) ) then
            self:GetParent():SetValue( Value );
        end
    end );
    ]]
    Frame:HookScript( 'OnValueChanged',function( self,Value )
        self.EditBox:SetText( Addon:SliderRound( self:GetValue(),VarData.Step ) );
        Handler:SetVarValue( self.keyValue,Addon:SliderRound( self:GetValue(),VarData.Step ) );
    end );
    Frame.EditBox:Disable();
    Frame:SetHeight( 15 );
    return Frame;
end

Addon.FRAMES.AddToggle = function( self,VarData,Parent )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'CheckButton',Key..'Toggle',Parent,'UICheckButtonTemplate' );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    Frame:SetSize( 25,25 );
    return Frame;
end

Addon.FRAMES.AddVarToggle = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'CheckButton',Key..'Toggle',Parent,'UICheckButtonTemplate' );
    Frame:SetChecked( Addon:Int2Bool( Handler:GetVarValue( Key ) ) );
    Frame.keyValue = Key;
    Frame:HookScript( 'OnClick',function( self )
         Handler:SetVarValue( self.keyValue,Addon:BoolToInt( self:GetChecked() ) );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    Frame:SetSize( 25,25 );
    return Frame;
end

Addon.FRAMES.AddRadio = function( self,VarData,Parent,Handler )
-- @todo: not implemented yet
end

Addon.FRAMES.AddCheckBox = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'CheckButton',Key..'Toggle',Parent,'ChatConfigCheckButtonTemplate' );
    Frame:SetChecked( Addon:Int2Bool( Handler:GetVarValue( Key ) ) );
    Frame.keyValue = Key;
    if( VarData.DisplayText ) then
        Frame.Text:SetText( VarData.DisplayText );
    end
    if( VarData.Description ) then
        Frame.tooltip = VarData.Description;
    end
    Frame:HookScript( 'OnClick',function( self )
         Handler:SetVarValue( self.keyValue,Addon:BoolToInt( self:GetChecked() ) );
    end );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    Frame:SetSize( 25,25 );
    return Frame;
end

Addon.FRAMES.AddButton = function( self,VarData,Parent,Theme )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Button',Key..'Butt',Parent,'UIPanelButtonTemplate' );
    if( VarData.Flagged ) then
        Frame:Disable();
    end

    local TextTheme = Addon.Theme.Text;
    local r,g,b,a = TextTheme.r,TextTheme.g,TextTheme.b,1;
    local Font = Addon.Theme.Font;
    Frame.Text = Frame:CreateFontString( nil,'ARTWORK','GameFontHighlightSmall' )
    Frame.Text:SetFont( Font.Family,Font.Normal,Font.Flags );
    Frame.Text:SetTextColor( r,g,b,a );
    Frame.Text:SetPoint( 'center' );
    Frame.Text:SetText( VarData.DisplayText );

    local r,g,b,a = Theme.r,Theme.g,Theme.b,.6;
    Frame.Texture = Frame:CreateTexture();
    Frame.Texture:SetAllPoints( Frame );
    Frame.Texture:SetColorTexture( r,g,b,a );
    Frame:DisableDrawLayer( 'BACKGROUND' );

    return Frame;
end

Addon.FRAMES.AddEdit = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'EditBox',Key..'Edit',Parent,'InputBoxTemplate' );
    Frame:SetAutoFocus( false );
    Frame:ClearFocus();
    Frame:SetTextInsets( 0,0,3,3 );
    if( VarData.Flagged ) then
        Frame:Disable();
    end
    Frame:SetFont( Addon.Theme.Font.Family, Addon.Theme.Font.Normal, Addon.Theme.Font.Flags );
    Frame:SetText( VarData.Value );
    Frame.keyValue = Key;
    Frame:HookScript( 'OnEnterPressed',function( self )
        local Value = self:GetText();
        if( Value ) then
            Handler:SetVarValue( self.keyValue,Value );
        end
    end );
    Frame:SetScript( 'OnEditFocusGained',function( self )
        self:HighlightText( 0 );
    end );

    local BGTheme = Addon.Theme.Background;
    local r,g,b,a = BGTheme.r,BGTheme.g,BGTheme.b,0.5;

    Frame.Texture = Frame:CreateTexture();
    Frame.Texture:SetAllPoints( Frame );
    Frame.Texture:SetColorTexture( r,g,b,a );

    return Frame;
end

Addon.FRAMES.AddMultiEdit = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'ScrollFrame',Key..'ScrollFrame',Parent,'UIPanelScrollFrameTemplate' );
    Frame:SetPoint( 'topleft',Parent,'topleft',0,0 );

    Frame.Input = CreateFrame( 'EditBox',Key..'Edit',Parent,'InputBoxTemplate' );
    Frame.Input:SetTextInsets( 10,10,10,10 );
    Frame.Input:DisableDrawLayer( 'BACKGROUND' );
    Frame.Input:SetPoint( 'topleft',Frame,'topleft',10,-10 );
    Frame.Input:SetAutoFocus( false );
    Frame.Input:SetMultiLine( true );
    Frame.Input:SetCursorPosition( 0 );
    Frame.Input:SetTextInsets( 0,0,3,3 );
    if( VarData.Flagged ) then
        Frame.Input:Disable();
    end
    Frame.Input:ClearFocus();
    Frame.Input:SetFont( Addon.Theme.Font.Family, Addon.Theme.Font.Normal, Addon.Theme.Font.Flags );
    Frame.Input:SetText( VarData.Value );
    Frame.Input:SetCursorPosition( 0 );
    Frame.Input.keyValue = Key;
    Frame.Input:HookScript( 'OnTextChanged',function( self )
        local Value = self:GetText();
        if( Value ) then

        end
    end );
    Frame.Input:SetScript( 'OnEditFocusGained',function( self )
        self:HighlightText( 0 );
    end );

    local BGTheme = Addon.Theme.Background;
    local r,g,b,a = BGTheme.r,BGTheme.g,BGTheme.b,0.5;

    Frame.Texture = Frame:CreateTexture();
    Frame.Texture:SetAllPoints( Frame );
    Frame.Texture:SetColorTexture( r,g,b,a );
    Frame:SetScrollChild( Frame.Input );

    return Frame;
end

Addon.FRAMES.AddSelect = function( self,VarData,Parent,Handler )
    local TrimString = function( String,Length )
        return String:sub( 1,Length );
    end
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Frame',Key..'Select',Parent,'UIDropDownMenuTemplate' );
    Frame.initialize = function()
        local Info = {};
        for i,Data in pairs( VarData.KeyPairs ) do
            Info.isNotRadio = true;
            Info.text = Data.Description;
            Info.value = Data.Value;
            Info.func = function( self )
                Handler:SetVarValue( Key,self.value );
                Frame:initialize();
            end
            if ( tostring( Handler:GetVarValue( Key ) ) == tostring( Data.Value ) ) then
                Info.checked = true;
                local Text = Info.text;
                local Length = 12;
                if( string.len( Text ) >= Length ) then
                    Text = TrimString( Text,Length );
                end
                local DataVal = '... ['..tostring( Handler:GetVarValue( Key ) )..']';
                if( not( string.len( DataVal ) > 10 ) ) then
                    Text = Text..DataVal;
                end
                Frame.Text:SetText( Text );
            else
                Info.checked = false;
            end
            _G[ 'DropDownList1' ].numButtons = _G[ 'DropDownList1' ].numButtons or 0;
            _G[ 'DropDownList1' ].maxWidth = _G[ 'DropDownList1' ].maxWidth or 0;
            UIDropDownMenu_AddButton( Info );
        end
    end
    Frame:initialize();
    Frame:SetHeight( 20 );
    return Frame;
end

Addon.FRAMES.PopUpMessage = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Frame',Key..'PopUp',Parent or UIParent );
    Frame:SetFrameStrata( 'DIALOG' );
    Frame:SetToplevel( true );
    Frame:SetSize( 300,150 );
    Frame:SetPoint( 'CENTER' );

    local ButtData = {
        Name = Key,
        DisplayText = 'OK',
    };
    Frame.Butt = self:AddButton( ButtData,Frame );
    Frame.Butt:SetSize( 32,32 );
    Frame.Butt:SetScript( 'OnClick',function( self )
        self:GetParent():Hide();
    end );
    Frame.Butt:SetPoint( 'topright',Frame,'topright',-10,-10 );
    Frame.Butt:RegisterForClicks( 'AnyDown','AnyUp' );

    local ButtTheme = Addon.Theme.Blue;
    local r,g,b,a = ButtTheme.r,ButtTheme.g,ButtTheme.b,1;

    Frame.Butt.Texture = Frame:CreateTexture();
    Frame.Butt.Texture:SetAllPoints( Frame.Butt );
    Frame.Butt.Texture:SetColorTexture( r,g,b,a );

    local BGTheme = Addon.Theme.Background;
    local r,g,b,a = BGTheme.r,BGTheme.g,BGTheme.b,0.5;

    Frame.Texture = Frame:CreateTexture();
    Frame.Texture:SetAllPoints( Frame );
    Frame.Texture:SetColorTexture( r,g,b,a );

    local Text = Frame:CreateFontString( nil,'ARTWORK','GameFontRedLarge' );

    local TextTheme = Addon.Theme.Text;
    local r,g,b,a = TextTheme.r,TextTheme.g,TextTheme.b,1;

    Text:SetTextColor( r,g,b,a );
    Text:SetSize( 380,0 );
    Text:SetJustifyH( 'CENTER' );
    Text:SetJustifyV( 'TOP' );
    Text:SetNonSpaceWrap( true );
    Text:SetPoint( 'CENTER' );
    Text:SetText( VarData.Value );
    Frame:Show();
    
    return Frame;
end

Addon.FRAMES.AddMovable = function( self,VarData,Parent,Handler )
    local Key = string.lower( VarData.Name );
    local Frame = CreateFrame( 'Frame',Key..'Moving',Parent or UIParent );
    Frame:SetFrameStrata( 'DIALOG' );
    Frame:SetToplevel( true );
    Frame:SetSize( 300,150 );
    Frame:SetPoint( 'CENTER' );
    Frame:EnableMouse( true );
    Frame:SetMovable( true );
    Frame:SetResizable( true );
    Frame:RegisterForDrag( 'LeftButton' );
    Frame:SetScript( 'OnDragStart',function( self )
        self:StartMoving();
    end );
    Frame:SetScript( 'OnDragStop',function( self )
        self:StopMovingOrSizing();
        self:SetUserPlaced( true );
    end );

    local BGTheme = Addon.Theme.Background;
    local r,g,b,a = BGTheme.r,BGTheme.g,BGTheme.b,0.5;

    Frame.Texture = Frame:CreateTexture();
    Frame.Texture:SetAllPoints( Frame );
    Frame.Texture:SetColorTexture( r,g,b,a );

    local Text = Frame:CreateFontString( nil,'ARTWORK','GameFontRedLarge' );

    local TextTheme = Addon.Theme.Text;
    local r,g,b,a = TextTheme.r,TextTheme.g,TextTheme.b,1;

    Text:SetTextColor( r,g,b,a );
    Text:SetSize( 380,0 );
    Text:SetJustifyH( 'CENTER' );
    Text:SetJustifyV( 'MIDDLE' );
    Text:SetNonSpaceWrap( true );
    Text:SetPoint( 'CENTER' );
    Text:SetText( VarData.Value );

    Frame:Show();

    return Frame;
end

--[[
Example of all types of widget settings:
Range       - Creates slider
List        - Creates dropdown
Color       - Creates colorpicker
Text        - Creates editbox
Toggle      - Creates checkbox

KeyValue    - Lookup key, useful in changeset handling such as onClick, onText, onValue, etc

Example call:
Addon.FRAMES:DrawFromSettings( Addon.WINDOWS:GetSettings(),Addon.WINDOWS );

Example types structure:
Addon.WINDOWS.GetSettings = function( self )
    return {
        nameplateNotSelectedAlpha = {
            Description = 'use this to display the class color in enemy nameplate health bars',
            KeyValue = 'nameplateNotSelectedAlpha',
            DefaultValue = GetCVarDefault( 'nameplateNotSelectedAlpha' ),
            KeyPairs = {
                Option1 = {
                    Value = 0.25,
                    Description = 'Low',
                },
                Option2 = {
                    Value = 1,
                    Description = 'Max',
                },
            },
            Step = 0.25,
            Type = 'Range',
        },
        chatStyle = {
            Description = 'The style of Edit Boxes for the ChatFrame. Valid values: "classic", "im"',
            KeyValue = 'chatStyle',
            DefaultValue = GetCVarDefault( 'chatStyle' ),
            KeyPairs = {
                Option1 = {
                    Value = 'im',
                    Description = 'IM',
                },
                Option2 = {
                    Value = 'classic',
                    Description = 'CLASSIC',
                },
            },
            Type = 'List',
        },
        WatchColor = {
            Description = 'Set the color of alerts in chat',
            KeyValue = 'WatchColor',
            Type = 'Color',
        },
        IgnoreList = {
            Description = 'Set words or phrases which should be omitted in chat',
            KeyValue = 'IgnoreList',
            CSV = true,
            Type = 'Text',
        },
        showtargetoftarget = {
            Description = 'Whether the target of target frame should be shown',
            KeyValue = 'showtargetoftarget',
            DefaultValue = GetCVarDefault( 'showtargetoftarget' ),
            KeyPairs = {
                Option1 = {
                    Value = 0,
                    Description = 'Off',
                },
                Option2 = {
                    Value = 1,
                    Description = 'On',
                },
            },
            Type = 'Toggle',
        },
    };
end
]]

--  Creates dynamic frame elements. Deps: Sushi/Poncho
--  
--  @param      table   Settings:   See above example
--  @param      table   ObjHandler: Reference back to calling library
--
--  @return     void
-- Two named frames. todo: make support only one/make sizing fully dynamic
Addon.FRAMES.DrawFromSettings = function( self,Settings,ObjHandler )

    
    local X,Y = 10,0; 
    local AbsX = X;
    local AbsY = Y;
    local RowHeight = 20;
    -- Increment Y to control vertical spacing
    -- this will afect both columns, all rows

    -- Options scroll frame
    ObjHandler.ScrollFrame = CreateFrame( 'ScrollFrame',nil,ObjHandler.Panel,'UIPanelScrollFrameTemplate' );

    -- Options scrolling content frame
    ObjHandler.ScrollChild = CreateFrame( 'Frame',ObjHandler.Panel:GetName()..'ScrollChild' );

    -- Options scroll frame
    ObjHandler.ScrollFrame:SetPoint( 'TOPLEFT',3,-4 );
    ObjHandler.ScrollFrame:SetPoint( 'BOTTOMRIGHT',-27,4 );

    -- Options scroll content 
    ObjHandler.ScrollFrame:SetScrollChild( ObjHandler.ScrollChild );
    if( Addon:IsClassic() ) then
        ObjHandler.ScrollChild:SetWidth( InterfaceOptionsFramePanelContainer:GetWidth()-18 );
    else
        ObjHandler.ScrollChild:SetWidth( SettingsPanel:GetWidth()-18 );
    end
    ObjHandler.ScrollChild:SetHeight( 20 );

    local AbsParent = ObjHandler.ScrollChild;
    AbsParent.KeyValue = AbsParent:GetName();

    local Iterator = 0;
    local NumPerLine = 3;
    local MyPosition = 'topleft';
    local YourPosition = 'topleft';
    local Children = {};
    local Parent;

    table.insert( Children,AbsParent );

    for Var,VarData in Addon:Sort( Settings ) do
        if( VarData.Type == 'Toggle' ) then

            Parent = Children[ Iterator+1 ];
            
            ObjHandler[ Var ] = LibStub( 'Sushi-3.2' ).Check( Parent );
            ObjHandler[ Var ]:SetChecked( Addon:Int2Bool( ObjHandler:GetValue( VarData.KeyValue ) ) );
            ObjHandler[ Var ]:SetPoint( MyPosition,Children[ Iterator ],YourPosition,X,Y );
            ObjHandler[ Var ]:SetTip( Var,VarData.Description );
            ObjHandler[ Var ]:SetLabel( Var );
            ObjHandler[ Var ].KeyValue = Var;
            ObjHandler[ Var ]:SetSmall( true );
            ObjHandler[ Var ]:SetCall('OnClick',function( self )
                ObjHandler:SetValue( self.KeyValue,Addon:BoolToInt( self:GetValue() ) );
            end );

            print( Var,MyPosition,Parent.KeyValue,YourPosition,X,Y );

            table.insert( Children,ObjHandler[ Var ] );
            Iterator = Iterator+1;

            if( Iterator > 1 ) then
                YourPosition = 'topright';
            end
        elseif( VarData.Type == 'Range' ) then

            Parent = Children[ Iterator+1 ];

            ObjHandler[ Var ] = LibStub( 'Sushi-3.2' ).Slider( Parent );
            ObjHandler[ Var ]:SetPoint( MyPosition,Children[ Iterator ],YourPosition,X,Y );
            ObjHandler[ Var ]:SetTip( Var,VarData.Description );
            ObjHandler[ Var ]:SetValue( ObjHandler:GetValue( VarData.KeyValue ) );
            ObjHandler[ Var ].Edit:SetValue( Addon:SliderRound( ObjHandler:GetValue( VarData.KeyValue ),VarData.Step ) );
            ObjHandler[ Var ]:SetRange( 
                VarData.KeyPairs.Option1.Value,
                VarData.KeyPairs.Option2.Value,
                VarData.KeyPairs.Option1.Description,
                VarData.KeyPairs.Option2.Description 
            );
            ObjHandler[ Var ]:SetStep( VarData.Step );
            ObjHandler[ Var ]:SetLabel( Var );
            ObjHandler[ Var ].KeyValue = Var;
            ObjHandler[ Var ]:SetSmall( true );
            ObjHandler[ Var ]:SetCall('OnValue',function( self )
                ObjHandler:SetValue( self.KeyValue,self:GetValue() );
            end );

            table.insert( Children,ObjHandler[ Var ] );
            Iterator = Iterator+1;

            if( Iterator > 1 ) then
                YourPosition = 'topright';
            end
        elseif( VarData.Type == 'Text' ) then

            Parent = Children[ Iterator+1 ];

            ObjHandler[ Var ] = LibStub( 'Sushi-3.2' ).BoxEdit( Parent );
            ObjHandler[ Var ]:SetPoint( MyPosition,Children[ Iterator ],YourPosition,X,Y );
            ObjHandler[ Var ]:SetTip( Var,VarData.Description );
            ObjHandler[ Var ]:SetMultiLine( true );
            if( VarData.CSV ) then
                ObjHandler[ Var ]:SetValue( table.concat( ObjHandler:GetValue( VarData.KeyValue ),',' ) );
                ObjHandler[ Var ].CSV = true;
            else
                ObjHandler[ Var ]:SetValue( ObjHandler:GetValue( VarData.KeyValue ) );
                ObjHandler[ Var ].CSV = false;
            end
            ObjHandler[ Var ]:SetLabel( Var );
            ObjHandler[ Var ].KeyValue = Var;
            ObjHandler[ Var ]:SetSmall( true );
            ObjHandler[ Var ]:SetCall('OnText',function( self )
                if( self.CSV ) then
                    local Values = Addon:Explode( self:GetValue(),',' );
                    if( type( Values ) == 'table' ) then
                        ObjHandler.persistence[ self.KeyValue ] = {};
                        for i,v in pairs( Values ) do
                            table.insert( ObjHandler.persistence[ self.KeyValue ],Addon:Minify( v ) );
                        end
                    else
                        ObjHandler.persistence[ self.KeyValue ] = {Addon:Minify( Values )};
                    end
                else
                    ObjHandler:SetValue( self.KeyValue,self:GetValue() );
                end
            end );

            table.insert( Children,ObjHandler[ Var ] );
            Iterator = Iterator+1;

            if( Iterator > 1 ) then
                YourPosition = 'topright';
            end
        elseif( VarData.Type == 'Color' ) then

            Parent = Children[ Iterator+1 ];

            ObjHandler[ Var ] = LibStub( 'Sushi-3.2' ).ColorPicker( Parent );
            ObjHandler[ Var ]:SetPoint( MyPosition,Children[ Iterator ],YourPosition,X,Y );
            ObjHandler[ Var ]:SetTip( Var,VarData.Description );
            ObjHandler[ Var ]:SetLabel( Var );
            ObjHandler[ Var ].KeyValue = Var;
            ObjHandler[ Var ]:SetSmall( true );
            ObjHandler[ Var ]:SetValue( CreateColor( unpack( ObjHandler:GetValue( VarData.KeyValue ) ) ) );
            ObjHandler[ Var ]:SetCall('OnColor', function( self )
                ObjHandler.persistence[ self.KeyValue ] = { self.color.r,self.color.g,self.color.b,self.color.a };
            end )
            --ObjHandler[ Var ].hasOpacity = true;

            table.insert( Children,ObjHandler[ Var ] );
            Iterator = Iterator+1;

            if( Iterator > 1 ) then
                YourPosition = 'topright';
            end
        elseif( VarData.Type == 'List' ) then

            Parent = Children[ Iterator+1 ];

            ObjHandler[ Var ] = LibStub( 'Sushi-3.2' ).DropChoice( Parent );
            ObjHandler[ Var ]:SetValue( ObjHandler:GetValue( VarData.KeyValue ) );
            ObjHandler[ Var ]:SetPoint( MyPosition,Children[ Iterator ],YourPosition,X,Y );
            ObjHandler[ Var ]:SetTip( Var,VarData.Description );
            ObjHandler[ Var ]:SetLabel( Var );
            ObjHandler[ Var ].KeyValue = Var;
            ObjHandler[ Var ]:SetSmall( true );
            if( tonumber( ObjHandler:GetValue( VarData.KeyValue ) ) ~= nil ) then
                ObjHandler[ Var ]:SetValue( tonumber( ObjHandler:GetValue( VarData.KeyValue ) ) );
            else
                ObjHandler[ Var ]:SetValue( ObjHandler:GetValue( VarData.KeyValue ) );
            end
            for i,v in pairs( VarData.KeyPairs ) do
                ObjHandler[ Var ]:Add( v.Value,v.Description );
            end
            ObjHandler[ Var ]:SetCall('OnInput',function( self )
                print( self.KeyValue,self:GetValue() )
                ObjHandler:SetValue( self.KeyValue,self:GetValue() );
            end );

            table.insert( Children,ObjHandler[ Var ] );
            Iterator = Iterator+1;
            X = X+ElementWidth;

            if( Iterator > 1 ) then
                YourPosition = 'topright';
            end
        end
        print( Iterator, NumPerLine )
        if( Iterator % NumPerLine == 0 ) then
            Parent = AbsParent;
            YourPosition = 'topleft';
            X = AbsX;
            Y = Y-RowHeight;
            print( 'here yes' )
        else
            Y = AbsY;
        end
        
    end
end