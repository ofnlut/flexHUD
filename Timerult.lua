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

Timerult =
{
};
registerWidget("Timerult");

local function sortDescending(a, b)
	return a.score > b.score;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function GetDeltaColorAndText()
	
    local textColor = Color(255,255,255,255);
    local frameColor = Color(48,48,48,255);
	local deltaScore = 0;

	-- team game?
	local gameMode = gamemodes[world.gameModeIndex];
	if gameMode.hasTeams then
		local teamToDisplayFrom;
		
		-- displaying from a player POV or global POV?
		if (playerIndexCameraAttachedTo > 0) and (players[playerIndexCameraAttachedTo].state == PLAYER_STATE_INGAME) then
			-- displaying from this players POV
			teamToDisplayFrom = players[playerIndexCameraAttachedTo].team;
		else
			-- display from winners POV			
			teamToDisplayFrom = world.teams[1].score > world.teams[2].score and 1 or 2;
		end
		
		-- displaying from this players POV
		frameColor = teamColors[teamToDisplayFrom];
		deltaScore = world.teams[1].score - world.teams[2].score;
		if (teamToDisplayFrom == 2) then
			deltaScore = -deltaScore;
		end

	else

		local playersSorted = {};
		local playersSortedCount = 0;
		
		-- gather players that are connected & their score
		local playerCount = 0;
		for k, v in pairs(players) do
			playerCount = playerCount + 1;
		end
		for playerIndex = 1, playerCount do
			local player = players[playerIndex];
			if player.connected and (player.state == PLAYER_STATE_INGAME) then
				--consolePrint(v.score);
				playersSortedCount = playersSortedCount + 1;
				playersSorted[playersSortedCount] = {};
				playersSorted[playersSortedCount].score = player.score;
				playersSorted[playersSortedCount].index = playerIndex;
			end
		end

		-- sort accordingly
		table.sort(playersSorted, sortDescending);
		
		-- displaying from a player POV or global POV?
		if (playerIndexCameraAttachedTo > 0) and (players[playerIndexCameraAttachedTo].state == PLAYER_STATE_INGAME) then
			
			-- displaying from this players POV
			local playerScore = players[playerIndexCameraAttachedTo].score;
			if playersSorted[1].index == playerIndexCameraAttachedTo then
				-- winning..
				if playersSortedCount > 1 then
					-- by how much..?
					deltaScore = playerScore - playersSorted[2].score;
				end
			else
				deltaScore = playerScore - playersSorted[1].score;
			end

		else
		
			-- display from winners POV	
			if playersSortedCount > 1 then
				deltaScore = playersSorted[1].score - playersSorted[2].score;
			end

		end
	end

	-- format nicely
	if deltaScore == -0 then deltaScore = 0 end;
	if deltaScore > 0 then
		deltaScore = "+"..deltaScore;
	end

	-- set light/dark text color based on adaptive luminance
    local a = 1 - ( 0.299 * frameColor.r + 0.587 * frameColor.g + 0.114 * frameColor.b) / 255;

	if (a < 0.5) then
		textColor = Color(0,0,0,255);
	else
		textColor = Color(255,255,255,255);
	end
	
	return textColor, frameColor, deltaScore;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function GetTimeColorAndText()

    local frameColor = Color(0,0,0,64);
    local textColor = Color(255,255,255,255);
	local text = "";
	local size = 52;

	if (world.gameState == GAME_STATE_ACTIVE) or (world.gameState == GAME_STATE_ROUNDACTIVE) then

		local timeRemaining = world.gameTimeLimit - world.gameTime;
		if timeRemaining < 0 then
			timeRemaining = 0;
		end

		local t = FormatTime(timeRemaining);
		text = string.format("%d:%02d", t.minutes, t.seconds);
		
        local lowTime = 30000; -- in milliseconds

        if timeRemaining < lowTime then
			frameColor = Color(200,0,0,64);
			textColor = Color(255,255,255,255);
        end

	else
		text = "Warmup";
		size = 36;
	end

	return textColor, frameColor, text, size;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Timerult:draw()

    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;
	
	local timeColor, timeFrameColor, timeText, timeSize = GetTimeColorAndText();
	local deltaColor, deltaFrameColor, deltaText = GetDeltaColorAndText();

	local fontSize = 50;
	local frameX = 0;
	local frameY = 0;

    -- background time
    nvgBeginPath();
    nvgRect(-fontSize*1.7, 2, fontSize * 2.5, fontSize*1.5);
    nvgFillColor(timeFrameColor);
    nvgFill();

	-- background delta
    -- nvgBeginPath();
    -- nvgRect(fontSize*.9, 0, fontSize, fontSize);
    -- nvgFillColor(deltaFrameColor);
    -- nvgFill();

	-- Text
	nvgFontFace("alte-din-1451-mittelschrift-regular");
	nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
	nvgFontBlur(0);
	
    nvgFontSize(timeSize);
	nvgFillColor(timeColor);
	nvgText(-fontSize*.45, fontSize*.5, timeText);
	
 --    nvgFontSize(fontSize);
	-- nvgFillColor(deltaColor);
	-- nvgText(fontSize, fontSize*.5, deltaText);
end
