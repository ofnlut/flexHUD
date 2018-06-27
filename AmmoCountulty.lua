--------------------------------------------------------------------------------
-- This is an official Reflex script. Do not modify.
--
-- If you wish to customize this widget, please:
--  * clone this file to a new file
--  * rename the widget MyWidget
--  * set this widget to not visible (via options menu)
--  * set your new widget to visible (via options menu)
--
--------------------------------------------------------------------------------

require "base/internal/ui/reflexcore"

AmmoCountulty =
{
};
registerWidget("AmmoCountulty");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function AmmoCountulty:draw()

    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;

	local player = getPlayer();

    -- Options
    local showFrame = true;
    local colorNumber = false;
    
    -- Size and spacing
    local frameWidth = 60;
    local frameHeight = 35;
    local framePadding = 5;
    local numberSpacing = 100;
    local iconSpacing = 40;
	
    -- Colors
    local frameColor = Color(0,0,0,250);

	local weaponIndexSelected = player.weaponIndexSelected;
	local weapon = player.weapons[weaponIndexSelected];
	local ammo = weapon.ammo;

	-- Helpers
    local frameLeft = -frameWidth/2;
    local frameTop = -frameHeight;
    local frameRight = frameLeft + frameWidth;
    local frameBottom = 0;
 
    local fontX = (frameRight - framePadding) + 32;
    local fontY = -(frameHeight / -1.80);
    local fontSize = frameHeight * 1.30;

    -- Frame
    if showFrame then
        nvgBeginPath();
        nvgCircle(frameRight, frameBottom, -frameWidth, -frameHeight);
        nvgFillColor(frameColor); 
        nvgFill();
    end
          
    -- colour changes when low on ammo
	local fontColor = Color(230,230,230);
	local glow = false;
	if ammo == 0 then
		fontColor = Color(230, 0, 0);
		glow = true;
	elseif ammo < weapon.lowAmmoWarning then
		fontColor = Color(230, 230, 0);
		glow = true;
	end

    nvgFontSize(fontSize);
	nvgFontFace("alte-din-1451-mittelschrift-Bold");
	nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_MIDDLE);
    
	-- unlimited ammo if melee, in race mode, or in warmup mode
    if weaponIndexSelected == 1 then ammo = "-" end 
	if isRaceMode() then ammo = "-" end
	if world.gameState == GAME_STATE_WARMUP then ammo = "-" end
    
    if glow then
	    nvgFontBlur(5);
        nvgFillColor(Color(64, 64, 200));
	    nvgText(fontX, fontY, ammo);
    end
    
	nvgFontBlur(0);
	nvgFillColor(fontColor);
	nvgText(fontX, fontY, ammo);
    
    -- Draw icon    
	local iconX = frameLeft + (iconSpacing / 1) + framePadding;
	local iconY = -(frameHeight / 1.95);
	local iconSize = (frameHeight / 1.65) * 1;
	local svgName = "internal/ui/icons/weapon" .. weaponIndexSelected;
	iconColor = player.weapons[weaponIndexSelected].color;
	nvgFillColor(iconColor);
	nvgSvg(svgName, iconX, iconY, iconSize);
end
