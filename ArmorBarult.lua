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

ArmorBarult =
{
};
registerWidget("ArmorBarult");

-- smoothedHealth += (currentHealth - oldHealth) * deltaTime

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ArmorBarult:initialize()
	-- load data stored in engine
	self.userData = loadUserData();
	
	-- ensure it has what we need
	CheckSetDefaultValue(self, "userData", "table", {});
	CheckSetDefaultValue(self.userData, "showFrame", "boolean", true);
	CheckSetDefaultValue(self.userData, "showIcon", "boolean", true);
	CheckSetDefaultValue(self.userData, "flatBar", "boolean", false);
	CheckSetDefaultValue(self.userData, "colorNumber", "boolean", false);
	CheckSetDefaultValue(self.userData, "colorIcon", "boolean", false);

	CheckSetDefaultValue(self.userData, "barAlpha", "number", 160);
	CheckSetDefaultValue(self.userData, "iconAlpha", "number", 230);	
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ArmorBarult:drawOptions(x, y)

	local sliderWidth = 200;
	local sliderStart = 140;
	local user = self.userData;

	user.showFrame = uiCheckBox(user.showFrame, "Show frame", x, y);
	y = y + 30;
	
	user.showIcon = uiCheckBox(user.showIcon, "Show icon", x, y);
	y = y + 30;

	user.flatBar = uiCheckBox(user.flatBar, "Flat bar style", x, y);
	y = y + 30;

	user.colorNumber = uiCheckBox(user.colorNumber, "Color numbers by armor", x, y);
	y = y + 30;

	user.colorIcon= uiCheckBox(user.colorIcon, "Color icon by armor", x, y);
	y = y + 30;
	
	uiLabel("Bar Alpha:", x, y);
	user.barAlpha = clampTo2Decimal(uiSlider(x + sliderStart, y, sliderWidth, 0, 255, user.barAlpha));
	user.barAlpha = clampTo2Decimal(uiEditBox(user.barAlpha, x + sliderStart + sliderWidth + 10, y, 60));
	y = y + 40;
	
	uiLabel("Icon Alpha:", x, y);
	user.iconAlpha = clampTo2Decimal(uiSlider(x + sliderStart, y, sliderWidth, 1, 255, user.iconAlpha));
	user.iconAlpha = clampTo2Decimal(uiEditBox(user.iconAlpha, x + sliderStart + sliderWidth + 10, y, 60));
	y = y + 40;
	
	saveUserData(user);
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ArmorBarult:draw()

    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;
	if isRaceMode() then return end;

	local player = getPlayer();

    -- Options
    local showFrame = self.userData.showFrame;
    local showIcon = self.userData.showIcon;
    local flatBar = self.userData.flatBar;
    local colorNumber = self.userData.colorNumber;
    local colorIcon = self.userData.colorIcon;
    
    -- Size and spacing
    local frameWidth = 200;
    local frameHeight = 60;
    local framePadding = 5;
    local numberSpacing = 110;
    local iconSpacing;

    if showIcon then iconSpacing = 80
    else iconSpacing = 0;
    end
	
    -- Colors
    local frameColor = Color(0,0,0,128);
    local barAlpha = self.userData.barAlpha
    local iconAlpha = self.userData.iconAlpha

    local barColor;
    if player.armorProtection == 0 then barColor = Color(2,167,46, barAlpha) end
    if player.armorProtection == 1 then barColor = Color(245,215,50, barAlpha) end
    if player.armorProtection == 2 then barColor = Color(236,0,0, barAlpha) end

    local barBackgroundColor;    
    if player.armorProtection == 0 then barBackgroundColor = Color(14,53,9, barAlpha) end
    if player.armorProtection == 1 then barBackgroundColor = Color(122,111,50, barAlpha) end
    if player.armorProtection == 2 then barBackgroundColor = Color(141,30,10, barAlpha) end 

    local frameColor;    
    if player.armorProtection == 0 then frameColor = Color(14,53,9, 128) end
    if player.armorProtection == 1 then frameColor = Color(122,111,50, 128) end
    if player.armorProtection == 2 then frameColor = Color(141,30,10, 128) end  

    -- Helpers
    local frameLeft = 0;
    local frameTop = -frameHeight;
    local frameRight = frameWidth;
    local frameBottom = 0;
 
    local barLeft = frameLeft + iconSpacing + numberSpacing
    local barTop = frameTop + framePadding;
    local barRight = frameRight - framePadding;
    local barBottom = frameBottom - framePadding;

    local barWidth = frameWidth - numberSpacing - framePadding - iconSpacing;
    local barHeight = frameHeight - (framePadding * 2);

    local fontX = barLeft - (numberSpacing / 2);
    local fontY = -(frameHeight / 2);
    local fontSize = frameHeight * 1.40;
 
    if player.armorProtection == 0 then fillWidth = math.min((barWidth / 100) * player.armor, barWidth);
    elseif player.armorProtection == 1 then fillWidth = math.min((barWidth / 150) * player.armor, barWidth);
    elseif player.armorProtection == 2 then fillWidth = (barWidth / 200) * player.armor;
    end

    -- Frame
    if showFrame then
        nvgBeginPath();
        nvgRoundedRect(frameRight, frameBottom, -frameWidth, -frameHeight, 0);
        nvgFillColor(frameColor); 
        nvgFill();
    end

    -- Background
    nvgBeginPath();
    nvgRect(barRight, barBottom , -barWidth, -barHeight);
    nvgFillColor(barBackgroundColor); 
    nvgFill();
    
    -- Bar
    nvgBeginPath();
    nvgRect(barLeft, barBottom, fillWidth, -barHeight);
	nvgFillColor(barColor); 
	nvgFill();
    
    -- Shading
    if flatBar == false then
    
        nvgBeginPath();
        nvgRect(barLeft, barTop, barWidth, barHeight);
        nvgFillLinearGradient(barLeft, barTop, barLeft, barBottom, Color(255,255,255,30), Color(255,255,255,0))
        nvgFill();
    
        nvgBeginPath();
        nvgMoveTo(barLeft, barTop);
        nvgLineTo(barRight, barTop);
        nvgStrokeWidth(1)
        nvgStrokeColor(Color(255,255,255,60));
        nvgStroke();
    
    end
          
    -- Draw numbers
    local fontColor;
    
    if colorNumber then fontColor = barColor
    else fontColor = Color(230,230,230);
    end
    
    nvgFontSize(fontSize);
	nvgFontFace("alte-din-1451-mittelschrift-Bold");
	nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
    
    if not colorNumber then -- Don't glow if the numbers are colored (looks crappy)
    
	    if player.armor <= 30 then
        nvgFontBlur(5);
        nvgFillColor(Color(64, 64, 200));
	    nvgText(fontX, fontY, player.armor);
        end
	       
    end
    
	nvgFontBlur(0);
	nvgFillColor(fontColor);
	nvgText(fontX, fontY, player.armor);
    
    -- Draw icon
    
    if showIcon then
        local iconX = (iconSpacing / 2) + framePadding;
        local iconY = -(frameHeight / 2);
        local iconSize = (barHeight / 2) * 0.9;
        local iconColor;
    
        if colorIcon then iconColor = barColor
        else iconColor = Color(230,230,230, 230);
        end
    
		nvgFillColor(iconColor);
        nvgSvg("internal/ui/icons/armor", iconX, iconY, iconSize);
    end

end
