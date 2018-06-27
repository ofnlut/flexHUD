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

HealthBarult =
{
};
registerWidget("HealthBarult");


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function HealthBarult:draw()
 
    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;
	if isRaceMode() then return end;

    -- Find player 
    local player = getPlayer();

    -- Options
    local showFrame = true;
    local showIcon = true;
    local flatBar = false;
    local colorNumber = false;
    local colorIcon = false;
    
    -- Size and spacing
    local frameWidth = 200;
    local frameHeight = 60;
    local framePadding = 5;
    local numberSpacing = 90;
    local iconSpacing;

    if showIcon then iconSpacing = 80
    else iconSpacing = 0;
    end
	
    -- Colors
    local frameColor = Color(0,0,0,128);
    local barAlpha = 0;
    local iconAlpha = 230;

    local barColor;
    if player.health > 100 then barColor = Color(16,116,217, barAlpha) end
    if player.health <= 100 then barColor = Color(2,167,46, barAlpha) end
    if player.health <= 80 then barColor = Color(255,176,14, barAlpha) end
    if player.health <= 30 then barColor = Color(236,0,0, barAlpha) end

    local barBackgroundColor;    
    if player.health > 100 then barBackgroundColor = Color(10,68,127, barAlpha) end
    if player.health <= 100 then barBackgroundColor = Color(14,53,9, barAlpha) end
    if player.health <= 80 then barBackgroundColor = Color(105,67,4, barAlpha) end
    if player.health <= 30 then barBackgroundColor = Color(141,30,10, barAlpha) end    

    local frameColor;
    if player.health > 100 then frameColor = Color(16,116,217, 128) end
    if player.health <= 100 then frameColor = Color(2,167,46, 128) end
    if player.health <= 80 then frameColor = Color(255,176,14, 128) end
    if player.health <= 30 then frameColor = Color(236,0,0, 128) end

    -- Helpers
    local frameLeft = -frameWidth;
    local frameTop = -frameHeight;
    local frameRight = 0;
    local frameBottom = 0;
 
    local barLeft = frameLeft + framePadding;
    local barTop = frameTop + framePadding;
    local barRight = frameRight - numberSpacing - iconSpacing;
    local barBottom = frameBottom - framePadding;

    local barWidth = frameWidth - numberSpacing - framePadding - iconSpacing;
    local barHeight = frameHeight - (framePadding * 2);

    local fontX = barRight + (numberSpacing / 2);
    local fontY = -(frameHeight / 2);
    local fontSize = frameHeight * 1.40;

    local fillWidth;
    if player.health > 100 then fillWidth = (barWidth / 100) * (player.health - 100);
    else fillWidth = (barWidth / 100) * player.health; end

    -- Frame
    if showFrame then
        nvgBeginPath();
        nvgRoundedRect(frameRight, frameBottom, -frameWidth, -frameHeight, 0);
        nvgFillColor(frameColor); 
        nvgFill();
    end
    
    -- -- Background
    -- nvgBeginPath();
    -- nvgRect(barRight, barBottom , -barWidth, -barHeight);
    -- nvgFillColor(barBackgroundColor); 
    -- nvgFill();

    -- -- Bar
    -- nvgBeginPath();
    -- nvgRect(barRight, barBottom, -fillWidth, -barHeight);
    -- nvgFillColor(barColor); 
    -- nvgFill();

    -- -- Shading
    -- if flatBar == false then
    --     nvgBeginPath();
	   --  nvgRect(barLeft, barTop, barWidth, barHeight);
    --     nvgFillLinearGradient(barLeft, barTop, barLeft, barBottom, Color(255,255,255,30), Color(255,255,255,0))
    --     nvgFill();

    --     nvgBeginPath();
    --     nvgMoveTo(barLeft, barTop);
    --     nvgLineTo(barRight, barTop);
    --     nvgStrokeWidth(1)
    --     nvgStrokeColor(Color(255,255,255,60));
    --     nvgStroke();
    -- end
          
    -- Draw numbers
    local fontColor;

    if colorNumber then fontColor = barColor
    else fontColor = Color(230,230,230);
    end

    nvgFontSize(fontSize);
    nvgFontFace("alte-din-1451-mittelschrift-Bold");
    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
    
    if not colorNumber then -- Don't glow if the numbers are colored (looks crappy)
		if player.health > 100 then
			nvgFontBlur(5);
			nvgFillColor(Color(64, 64, 200));
			nvgText(fontX, fontY, player.health);
		elseif player.health <= 30 then
			nvgFontBlur(10);
			nvgFillColor(Color(200, 64, 64));
			nvgText(fontX, fontY, player.health);
		end
    end
    
    nvgFontBlur(0);
    nvgFillColor(fontColor);
    nvgText(fontX, fontY, player.health);

    -- Draw icon
    if showIcon then
        local iconX = -(iconSpacing / 2) - framePadding;
        local iconY = -(frameHeight / 2);
        local iconSize = (barHeight / 2) * 0.9;
        local iconColor;

        if colorIcon then iconColor = barColor
        else iconColor = Color(230,230,230, iconAlpha);
        end

		nvgFillColor(iconColor);
        nvgSvg("internal/ui/icons/health", iconX, iconY, iconSize)
    end
end
