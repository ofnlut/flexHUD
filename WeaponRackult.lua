require "base/internal/ui/reflexcore"

WeaponRackult =
{
};
registerWidget("WeaponRackult");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function WeaponRackult:draw()

    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;

    local translucency = 192;
    
    -- Find player
    local player = getPlayer();

    local weaponCount = 9; -- table.maxn(player.ammo);
    local spaceCount = weaponCount - 1;
    
    -- Options
    local verticalRack = false;
    local weaponWidth = 85;
    local weaponHeight = 35;
    local weaponSpacing = 2; -- 0 or -1 to remove spacing
    
    -- Helpers
    local rackWidth = (weaponWidth * weaponCount) + (weaponSpacing * spaceCount);
    local rackLeft = -(rackWidth / 2);
    local weaponX = rackLeft;
    local weaponY = 0;

    if verticalRack == true then
        rackHeight = (weaponHeight * weaponCount) + (weaponSpacing * spaceCount);
        rackTop = -(rackHeight / 2);
        weaponX = 0;
        weaponY = rackTop;
    end

    for weaponIndex = 1, weaponCount do

        local weapon = player.weapons[weaponIndex];
        local color = weapon.color;
    
        -- if we havent picked up the weapon, colour it grey
        if not weapon.pickedup then
            color.r = 128;
            color.g = 128;
            color.b = 128;
        end

        local backgroundColor = Color(0,0,0,128)
        
        -- Frame background
        nvgBeginPath();
        nvgRect(weaponX,weaponY,weaponWidth,weaponHeight);

        if weaponIndex == player.weaponIndexSelected then 
            backgroundColor = Color(0,0,0,210)

            local outlineColor = Color(
                color.r,
                color.g,
                color.b,
                lerp(0, 255, player.weaponSelectionIntensity));

            nvgStrokeWidth(2);
            nvgStrokeColor(outlineColor);
            nvgStroke();
        end

        nvgFillColor(backgroundColor);
        nvgFill();

        -- Icon
        local iconRadius = weaponHeight * 0.35;
        local iconX = weaponX + (weaponHeight - iconRadius);
        local iconY = (weaponHeight / 2);
        local iconColor = color;

        if verticalRack == true then
            iconX = weaponX + iconRadius + 5;
            iconY = weaponY + (weaponHeight / 2);
        end

        
        
        local svgName = "internal/ui/icons/weapon"..weaponIndex;
        nvgFillColor(iconColor);
        nvgSvg(svgName, iconX, iconY, iconRadius);

        -- Ammo
        local ammoX = weaponX + (iconRadius) + (weaponWidth / 1.75);
        local ammoCount = player.weapons[weaponIndex].ammo;

        if verticalRack == true then
            ammoX = weaponX + (weaponWidth / 2) + iconRadius;
        end

        if weaponIndex == 1 then ammoCount = "-" end

        nvgFontSize(30);
        --nvgFontFace("oswald-bold");
        nvgFontFace("alte-din-1451-mittelschrift-regular");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);

        nvgFontBlur(0);
        nvgFillColor(Color(255,255,255));
        nvgText(ammoX, 5, ammoCount);
        
        if verticalRack == true then
            weaponY = weaponY + weaponHeight + weaponSpacing;
        else
            weaponX = weaponX + weaponWidth + weaponSpacing;
        end
       
    end

end
