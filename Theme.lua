local _,Addon = ...;

Addon.Theme = {
    Text = {
        Hex = 'ffffff',
    },
    Debug = {
        Hex = 'cccccc',
    },
    Notify = {
        Hex = '009bff',
    },
    Warn = {
        Hex = 'ffbf00',
    },
    Error = {
        Hex = 'ff2d00',
    },
    Disabled = {
        Hex = '999999',
    },
    Background = {
        Hex = '000000',
    },
    Blue = {
        Hex = '009bff',
    },
    Gold = {
        Hex = 'c38b48',
    },
    Font = {
        Family = 'Fonts\\FRIZQT__.TTF',
        Flags = 'OUTLINE, MONOCHROME',
        Large = 14,
        Normal = 10,
        Small = 8,
    },
};

for Key,Data in pairs( Addon.Theme ) do
    if( Key ~= 'Font' ) then
        Addon.Theme[ Key ].r,Addon.Theme[ Key ].g,Addon.Theme[ Key ].b = Addon:Hex2RGB( Data.Hex );
    end
end