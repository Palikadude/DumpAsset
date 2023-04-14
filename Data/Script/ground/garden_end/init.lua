--[[
    init.lua
    Created: 10/09/2021 15:46:48
    Description: Autogenerated script file for the map garden_end.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local garden_end = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---garden_end.Init
--Engine callback function
function garden_end.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  GROUND:RefreshPlayer()
end

---garden_end.Enter
--Engine callback function
function garden_end.Enter(map)
  if SV.garden_end.ExpositionComplete or GAME:InRogueMode() then
    garden_end.PrepareReturnVisit()
  end
  
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(30)
  UI:WaitHideTitle(20)
  GAME:FadeIn(20)
  
  -- if exposition complete, hide the cutscene trigger
  
end


--------------------------------------------------
-- Map Setup Functions
--------------------------------------------------
function garden_end.PrepareReturnVisit()
  GROUND:Hide("Cutscene_Trigger")
  GROUND:Hide("Shaymin")
  GROUND:Hide("Berry_Basket_Red")
  GROUND:Hide("Berry_Basket_Blue_1")
  GROUND:Hide("Berry_Basket_Blue_2")
  GROUND:Hide("Berry_Basket_Blue_3")
  GROUND:Hide("Berry_Basket_Blue_4")
  GROUND:Unhide("Gracidea")
end


-------------------------------
-- Entities Callbacks
-------------------------------


function garden_end.Cutscene_Trigger_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local shaymin = CH('Shaymin')
  
  
  GAME:CutsceneMode(true)
  -- move camera up a little more: center at 196, 264
  GAME:MoveCamera(204, 248, 30, false)
  
  local turnTime = 4
  GAME:WaitFrames(30)
  -- turn left
  GROUND:CharAnimateTurnTo(shaymin, Direction.UpLeft, turnTime)
  GAME:WaitFrames(40)
  -- turn right
  GROUND:CharAnimateTurnTo(shaymin, Direction.UpRight, turnTime)
  GAME:WaitFrames(40)
  -- turn left
  GROUND:CharAnimateTurnTo(shaymin, Direction.UpLeft, turnTime)
  GAME:WaitFrames(40)
  -- exclaim
  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  GROUND:CharSetEmote(shaymin, "exclaim", 1)
  -- turn around
  GROUND:CharAnimateTurnTo(shaymin, Direction.Down, turnTime)
  
  -- oh, a visitor?
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "shaymin", 0, "normal", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_001']))
  
  GROUND:CharSetEmote(shaymin, "glowing", 4)
  GAME:WaitFrames(30)
  -- introduce self
  UI:SetSpeaker(shaymin)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_002'], shaymin:GetDisplayName()))
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_003']))
  
  -- get ready for picnic
  GAME:FadeOut(false, 30)
  GROUND:TeleportTo(shaymin, 176, 216, Direction.Right)
  GROUND:TeleportTo(activator, 216, 216, Direction.Left)
  GROUND:Hide("Berry_Basket_Blue_1")
  GROUND:Hide("Berry_Basket_Blue_2")
  GROUND:Unhide("Berry_Basket_Blue_3")
  GROUND:Unhide("Berry_Basket_Blue_4")
  
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  
  if GAME:InRogueMode() then
    -- TODO
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_001']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_001']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_001']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_020']))
    -- if in rogue mode, give different dialogue and bank money
    GAME:AddToPlayerMoneyBank(100000)
  else
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_004']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_005']))
	GROUND:CharSetAnim(activator, "Walk", false)
    GAME:WaitFrames(60)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_006'], _DATA.Save.ActiveTeam.Name))
    GROUND:CharSetEmote(shaymin, "glowing", 4)
    GAME:WaitFrames(60)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_007']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_008']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_009']))
    UI:SetSpeakerEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_010']))
    GAME:WaitFrames(60)
    GROUND:CharAnimateTurnTo(shaymin, Direction.Up, turnTime)
    GAME:WaitFrames(30)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_011']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_012']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_013']))
    GROUND:CharAnimateTurnTo(shaymin, Direction.Right, turnTime)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_014']))
    GROUND:CharAnimateTurnTo(shaymin, Direction.DownRight, turnTime)
	GROUND:CharSetAnim(shaymin, "Walk", false)
    GAME:WaitFrames(30)
    GROUND:CharAnimateTurnTo(shaymin, Direction.Right, turnTime)
	GROUND:CharSetAnim(shaymin, "Walk", false)
    GAME:WaitFrames(60)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_015']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_016']))
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_017']))
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_018']))
	
    GROUND:CharSetEmote(shaymin, "glowing", 4)
    GAME:WaitFrames(30)
	
    -- if not in rogue mode, have them join the team
    local mon_id = RogueEssence.Dungeon.MonsterID("shaymin", 0, "normal", Gender.Genderless)
	local recruit = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0)
	COMMON.JoinTeamWithFanfare(recruit, false)
	
    GAME:WaitFrames(30)
  
    UI:SetSpeaker(shaymin)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_019']))
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Expo_Cutscene_Line_020']))
    -- By the way, have you seen my Gracidea?  It should be deeper in the garden...
	-- Ah, it's nothing...
    -- UI:WaitShowDialogue("By the way, have you seen any Gracidea?")
    -- UI:WaitShowDialogue("They are said to bloom deep in the garden...")
	-- By the way, that Gracidea you have there...
	-- I'm thankful that you've found it.
	-- When I use that flower, my appearance changes! I can show you when we go on an adventure together.
  end
  
  SV.garden_end.ExpositionComplete = true
  
  SOUND:FadeOutBGM()
  GAME:FadeOut(false, 30)
  GAME:CutsceneMode(false)
  GAME:WaitFrames(90)

  COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'guildmaster_island', -1, 3, 2)
end

function garden_end.Gracidea_Action(obj, activator)
  local player = CH('PLAYER')
  SOUND:PlayFanfare("Fanfare/Treasure")
  local receive_item = RogueEssence.Dungeon.InvItem("loot_gracidea")
  COMMON.GiftItemFull(player, receive_item, false, false)
  GROUND:Hide("Gracidea")
  _DATA.Save:RogueUnlockMonster("shaymin")
  
  SOUND:FadeOutBGM()
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(90)
  COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'guildmaster_island', -1, 3, 2)
end

function garden_end.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  -- ask to complete the dungeon and go back
  UI:ResetSpeaker()
  UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_EXIT_DUNGEON"), false)
  UI:WaitForChoice()
  ch = UI:ChoiceResult()
  if ch then
    SOUND:FadeOutBGM()
    GAME:FadeOut(false, 30)
    GAME:WaitFrames(120)
    
    if GAME:InRogueMode() then
      GAME:AddToPlayerMoneyBank(100000)
    end
    COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'guildmaster_island', -1, 3, 2)
  end
end

return garden_end

