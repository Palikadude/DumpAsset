require 'common'

local forest_camp = {}
local MapStrings = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function forest_camp.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_forest_camp")
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  
  COMMON.CreateWalkArea("NPC_Camps", 168, 184, 48, 48)
  
  local snorlax = CH('Snorlax')
  GROUND:CharSetAnim(snorlax, "Sleep", true)
end

--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------

function forest_camp.Enter(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  SV.checkpoint = 
  {
    Zone    = 'guildmaster_island', Segment  = -1,
    Map  = 3, Entry  = 1
  }
  
  --when arriving the first time, play this cutscene
  if not SV.forest_camp.ExpositionComplete then
    forest_camp.BeginExposition()
    SV.forest_camp.ExpositionComplete = true
  elseif SV.forest_camp.SnorlaxPhase == 2 then
    forest_camp.Snorlax_Fail()
	SV.forest_camp.SnorlaxPhase = 1
  elseif SV.forest_camp.SnorlaxPhase == 3 then
    forest_camp.Snorlax_Success()
	SV.forest_camp.SnorlaxPhase = 4
  else
    GAME:FadeIn(20)
  end
  
  if SV.forest_camp.SnorlaxPhase == 4 then
    GROUND:Hide("Snorlax")
    GROUND:Hide("NPC_Carry")
    GROUND:Hide("NPC_Deliver")
  end
  
  forest_camp.CheckMissions()
  
  -- TODO: move this back to BeginExposition
  GAME:UnlockDungeon('faded_trail')
  GAME:UnlockDungeon('bramble_woods')
end

function forest_camp.Update(map, time)
end

--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------
function forest_camp.BeginExposition()
  
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(30)
  UI:WaitHideTitle(20)
  GAME:FadeIn(20)
  
  
end

function forest_camp.CheckMissions()
  local quest = SV.missions.Missions["EscortSister"]
  if quest ~= nil then
    if quest.Complete == COMMON.MISSION_COMPLETE then
	  UI:WaitShowDialogue("Escort mission state: Complete.")
	  quest.Complete = COMMON.MISSION_ARCHIVED
	  SV.missions.FinishedMissions["EscortSister"] = quest
	  table.remove(SV.missions.Missions, "EscortSister")
	end
  end

end

--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------
function forest_camp.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local dungeon_entrances = { 'faded_trail', 'bramble_woods', 'trickster_woods', 'overgrown_wilds', 'moonlit_courtyard', 'ambush_forest', 'energy_garden', 'sickly_hollow', 'secret_garden'}
  local ground_entrances = {{Flag=SV.cliff_camp.ExpositionComplete,Zone='guildmaster_island',ID=4,Entry=0},
  {Flag=SV.canyon_camp.ExpositionComplete,Zone='guildmaster_island',ID=5,Entry=0},
  {Flag=SV.rest_stop.ExpositionComplete,Zone='guildmaster_island',ID=6,Entry=0},
  {Flag=SV.final_stop.ExpositionComplete,Zone='guildmaster_island',ID=7,Entry=0},
  {Flag=SV.guildmaster_summit.ExpositionComplete,Zone='guildmaster_island',ID=8,Entry=0}}
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances)
end

function forest_camp.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  local dungeon_entrances = { }
  local ground_entrances = {{Flag=true,Zone='guildmaster_island',ID=1,Entry=3}}
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances)
end

function forest_camp.Assembly_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  COMMON.ShowTeamAssemblyMenu(obj, COMMON.RespawnAllies)
end

function forest_camp.Storage_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON:ShowTeamStorageMenu()
end

function forest_camp.Snorlax_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  UI:ResetSpeaker()
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sleeper_Line_001']))
  
  if SV.Experimental == nil then
    return
  end
  
  UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Sleeper_Line_Ask'], name), true)
  UI:WaitForChoice()
  ch = UI:ChoiceResult()
  
  if ch then
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sleeper_Line_002']))
	SV.forest_camp.SnorlaxPhase = 1
    SOUND:PlayBattleSE("EVT_Battle_Transition")
    GAME:FadeOut(true, 60)
    GAME:EnterDungeon('guildmaster_island', 0, 3, 0, RogueEssence.Data.GameProgress.DungeonStakes.Progress, true, true)
  end
end

function forest_camp.Snorlax_Fail()
  --snorlax collapses back
  --everyone is dead
  GAME:FadeIn(20)
  --ekans: he doesn't like to have his sleep disturbed
  UI:SetSpeaker(CH("NPC_Deliver"))
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sleeper_Line_Fail_001']))
  --move back to position
end

function forest_camp.Snorlax_Success()
  local player = CH('PLAYER')
  
  GAME:FadeIn(20)
  --snorlax runs off
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sleeper_Line_Success_001']))
  GROUND:Hide("Snorlax")
  --the team thanks you, gives you a stock
  UI:SetSpeaker(CH("NPC_Deliver"))
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sleeper_Line_Success_002']))
  local receive_item = RogueEssence.Dungeon.InvItem("food_apple_huge")
  COMMON.GiftItem(player, receive_item)
  --they head off
  UI:SetSpeaker(CH("NPC_Carry"))
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Sleeper_Line_Success_003']))
  GROUND:Hide("NPC_Carry")
  GROUND:Hide("NPC_Deliver")
end

function forest_camp.NPC_Carry_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  GROUND:CharTurnToChar(chara,CH('PLAYER'))
  UI:SetSpeaker(chara)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Carry_Line_001']))
  UI:SetSpeakerEmotion("Stunned")
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Carry_Line_002']))
  GROUND:EntTurn(chara, Direction.Left)
end

function forest_camp.NPC_Deliver_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  GROUND:CharTurnToChar(chara,CH('PLAYER'))
  UI:SetSpeaker(chara)
  UI:SetSpeakerEmotion("Pain")
  
  SOUND:PlayBattleSE("EVT_Emote_Sweating")
  GROUND:CharSetEmote(chara, "sweating", 1)
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Deliver_Line_001']))
  GROUND:EntTurn(chara, Direction.Right)
end

function forest_camp.NPC_Camps_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  GROUND:CharTurnToChar(chara,CH('PLAYER'))
  UI:SetSpeaker(chara)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Camps_Line_001']))
end

function forest_camp.NPC_Parent_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  forest_camp.Parent_Child_Action()
end

function forest_camp.NPC_Child_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  forest_camp.Parent_Child_Action()
end


function forest_camp.Parent_Child_Action()
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  local parent = CH('NPC_Parent')
  local child = CH('NPC_Child')
  local player = CH('PLAYER')
  
  GROUND:CharTurnToChar(player, child)
  UI:SetSpeaker(child)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Parent_Child_Line_001']))
  GROUND:CharTurnToChar(player, parent)
  UI:SetSpeaker(parent)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Parent_Child_Line_002']))
end



function forest_camp.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function forest_camp.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function forest_camp.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

return forest_camp