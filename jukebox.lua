--[[

Jukebox program
By The Juice
Edited by Out-Feu

version 1.5.0

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect some drives with music discs
and an advanced monitor (at least two blocks wide)
in any way and start this program

The monitor must be at least 2 blocks high
to access the basic preferences
or 3 blocks high to access the advanced preferences

--]]

function loadJukebox()
 per = peripheral.getNames()
 drives = {}
 for k,v in pairs(per) do
  if peripheral.getType(v) == "drive" then
   if peripheral.wrap(v).hasAudio() then
    if lengths[getAudioTitle(peripheral.wrap(v))] ~= nil then
     drives[#drives+1] = peripheral.wrap(v)
    else
     term.setTextColor(colors.red)
     print("Track not found '" .. getAudioTitle(peripheral.wrap(v)) .. "'")
     term.setTextColor(colors.white)
    end
   elseif peripheral.wrap(v).isDiskPresent() then
    term.setTextColor(colors.red)
    print("A disk drive contains an invalid item")
    term.setTextColor(colors.white)
   end
  elseif peripheral.getType(v) == "monitor" then
   mon = peripheral.wrap(v)
  end
 end
 per = nil
 table.sort(drives, sortDriveByTitle)
 duplicateDrives = {}
 duplicateCount = 0
 if playDuplicate then
  for i=#drives,2,-1 do
   if getAudioTitle(drives[i]) == getAudioTitle(drives[i-1]) then
    if duplicateDrives[getAudioTitle(drives[i])] == nil then
	 duplicateDrives[getAudioTitle(drives[i])] = {}
	 duplicateCount = duplicateCount + 1
    end
    duplicateDrives[getAudioTitle(drives[i])][#duplicateDrives[getAudioTitle(drives[i])]+1] = drives[i]
    table.remove(drives, i)
   end
  end
 end
 disks = {}
 for k,v in pairs(drives) do
  disks[k] = getAudioTitle(drives[k])
 end
 print("Loaded " .. table.getn(disks) .. " tracks")
 if playDuplicate and duplicateCount > 0 then
  print(duplicateCount .. " of those tracks have duplicates")
 end
end

function loadPref(reloading)
 if not fs.exists(configFile) then
  setColors.text = colors.white
  setColors.background = colors.black
  setColors.skip = colors.blue
  setColors.enabled = colors.green
  setColors.disabled = colors.red
  setColors.selected = colors.green
  setColors.progress1 = colors.lightBlue
  setColors.progress2 = colors.cyan
  setColors.progress3 = colors.blue
  setColors.duplicateText = colors.yellow
  setColors.prefBack = colors.blue
  setColors.prefText = colors.white

 else
  local fil = fs.open(configFile,"r")

  setColors.text = tonumber(fil.readLine())
  setColors.background = tonumber(fil.readLine())
  setColors.skip = tonumber(fil.readLine())
  setColors.enabled = tonumber(fil.readLine())
  setColors.disabled = tonumber(fil.readLine())
  setColors.selected = tonumber(fil.readLine())
  setColors.progress1 = tonumber(fil.readLine())
  setColors.progress2 = tonumber(fil.readLine())
  setColors.progress3 = tonumber(fil.readLine())
  setColors.duplicateText = tonumber(fil.readLine())
  setColors.prefBack = tonumber(fil.readLine())
  setColors.prefText = tonumber(fil.readLine())

  playingDefault = fil.readLine() == "true"
  shuffleDefault = fil.readLine() == "true"
  loopDefault = fil.readLine() == "true"
  playDuplicate = fil.readLine() ~= "false"
  fullProgressLine = fil.readLine() == "true"
  if not reloading then
   playing = playingDefault
   shuffle = shuffleDefault
   loop = loopDefault
  end

  fil.close()
 end
end

function savePref()
 fil=fs.open(configFile,"w")
 fil.writeLine(setColors.text)
 fil.writeLine(setColors.background)
 fil.writeLine(setColors.skip)
 fil.writeLine(setColors.enabled)
 fil.writeLine(setColors.disabled)
 fil.writeLine(setColors.selected)
 fil.writeLine(setColors.progress1)
 fil.writeLine(setColors.progress2)
 fil.writeLine(setColors.progress3)
 fil.writeLine(setColors.duplicateText)
 fil.writeLine(setColors.prefBack)
 fil.writeLine(setColors.prefText) 

 fil.writeLine(playingDefault)
 fil.writeLine(shuffleDefault)
 fil.writeLine(loopDefault)
 fil.writeLine(playDuplicate)
 fil.writeLine(fullProgressLine)

 fil.close()
end

function changePref()
 while true do
  w, h = mon.getSize()
  showColor = h >= minColorSize and w >= minColorSize

  mon.setBackgroundColor(colors.black)
  mon.setTextColor(colors.white)
  mon.clear()

  mon.setCursorPos(1,1)
  mon.write("Preferences")

  if showColor then
   mon.setCursorPos(1,3)
   mon.write("Edit colors")
  end
  
  writePref(4, "Play by default", playingDefault)
  writePref(5, "Shuffle by default", shuffleDefault)
  writePref(6, "Loop by default", loopDefault)
  writePref(14, "Handle duplicates", playDuplicate)
  writePref(15, "Full progress bar", fullProgressLine)
  writePref(17, "Cacophony", playing)

  mon.setBackgroundColor(colors.blue)
  mon.setCursorPos(1, 8)
  mon.write("Reload Jukebox")
  
  mon.setBackgroundColor(colors.black)
  
  mon.setCursorPos(1, 10)
  mon.write("Save")

  mon.setCursorPos(1, 11)
  mon.write("Load")

  mon.setCursorPos(1, 12)
  mon.write("Back")

  mon.setCursorPos(1, 19)
  mon.write("Close jukebox")

  local eve,id,cx,cy
  eve,id,cx,cy=os.pullEvent("monitor_touch")

  if showColor and cy==3 then
   changeColors()
  elseif cy==4 then
   playingDefault = not playingDefault
  elseif cy==5 then
   shuffleDefault = not shuffleDefault
  elseif cy==6 then
  loopDefault = not loopDefault
  elseif cy==8 then
   loadJukebox()
  elseif cy==10 then
   savePref()
  elseif cy==11 then
   loadPref(true)
  elseif cy==12 then
   stop()
   return false
  elseif cy==14 then
   playDuplicate = not playDuplicate
   loadJukebox()
  elseif cy==15 then
   fullProgressLine = not fullProgressLine
  elseif cy==17 then
   if playing then
    stop()
   else
    playAll()
   end
  elseif cy==19 then
   stop()
   return true
  end

 end
end

function writePref(pos, name, active)
  mon.setCursorPos(1, pos)
  if active then
   mon.setBackgroundColor(colors.green)
  else
   mon.setBackgroundColor(colors.red)
  end
  mon.write(name)
end

function changeColors()
 while true do
  mon.setBackgroundColor(colors.black)
  mon.clear()

  mon.setCursorPos(1,1)
  mon.setTextColor(colors.white)
  mon.write("Colors")

  writeColor(3, "Text", setColors.text, false)
  writeColor(4, "Background", setColors.background, true)
  writeColor(5, "Skip buttons", setColors.skip, true)
  writeColor(6, "Enabled", setColors.enabled, true)
  writeColor(7, "Disabled", setColors.disabled, true)
  writeColor(8, "Selected track", setColors.selected, true)
  writeColor(9, "Progress 1", setColors.progress1, true)
  writeColor(10, "Progress 2", setColors.progress2, true)
  writeColor(11, "Progress 3", setColors.progress3, true)
  writeColor(12, "Duplicate track text", setColors.duplicateText, false)
  writeColor(13, "p button background", setColors.prefBack, true)
  writeColor(14, "p button text", setColors.prefText, false)

  mon.setCursorPos(1,16)
  mon.setBackgroundColor(colors.black)
  mon.setTextColor(colors.white)
  mon.write("Back")

  local eve,id,cx,cy
  eve,id,cx,cy=os.pullEvent("monitor_touch")

  if cy >= 3 and cy <= 14 then
   mon.setCursorPos(1,cy)
   mon.write(">")
  end
  if cy == 3 then
   setColors.text = colorPicker(setColors.text)
  elseif cy == 4 then
   setColors.background = colorPicker(setColors.background)
  elseif cy == 5 then
   setColors.skip = colorPicker(setColors.skip)
  elseif cy == 6 then
   setColors.enabled = colorPicker(setColors.enabled)
  elseif cy == 7 then
   setColors.disabled = colorPicker(setColors.disabled)
  elseif cy == 8 then
   setColors.selected = colorPicker(setColors.selected)
  elseif cy == 9 then
   setColors.progress1 = colorPicker(setColors.progress1)
  elseif cy == 10 then
   setColors.progress2 = colorPicker(setColors.progress2)
  elseif cy == 11 then
   setColors.progress3 = colorPicker(setColors.progress3)
  elseif cy == 12 then
   setColors.duplicateText = colorPicker(setColors.duplicateText)
  elseif cy == 13 then
   setColors.prefBack = colorPicker(setColors.prefBack)
  elseif cy == 14 then
   setColors.prefText = colorPicker(setColors.prefText)
  elseif cy == 16 then
   return
  end

 end
end

function writeColor(pos, name, color, background)
 mon.setCursorPos(1,pos)
 mon.setBackgroundColor(colors.black)
 mon.setTextColor(colors.white)
 mon.write("-")
 if background then
  mon.setBackgroundColor(color)
  if color == colors.white then
   mon.setTextColor(colors.black)
  end
 else
  mon.setTextColor(color)
  if color == colors.black then
   mon.setBackgroundColor(colors.white)
  end
 end
 mon.write(name)
end

function colorPicker(defaultColor)
 mon.setCursorPos(15,1)
 mon.setBackgroundColor(colors.white)
 mon.write(" ")
 mon.setBackgroundColor(colors.lightGray)
 mon.write(" ")
 mon.setBackgroundColor(colors.gray)
 mon.write(" ")
 mon.setBackgroundColor(colors.black)
 mon.write(" ")

 mon.setCursorPos(15,2)
 mon.setBackgroundColor(colors.blue)
 mon.write(" ")
 mon.setBackgroundColor(colors.cyan)
 mon.write(" ")
 mon.setBackgroundColor(colors.lightBlue)
 mon.write(" ")
 mon.setBackgroundColor(colors.brown)
 mon.write(" ")

 mon.setCursorPos(15,3)
 mon.setBackgroundColor(colors.green)
 mon.write(" ")
 mon.setBackgroundColor(colors.lime)
 mon.write(" ")
 mon.setBackgroundColor(colors.orange)
 mon.write(" ")
 mon.setBackgroundColor(colors.yellow)
 mon.write(" ")

 mon.setCursorPos(15,4)
 mon.setBackgroundColor(colors.red)
 mon.write(" ")
 mon.setBackgroundColor(colors.purple)
 mon.write(" ")
 mon.setBackgroundColor(colors.magenta)
 mon.write(" ")
 mon.setBackgroundColor(colors.pink)
 mon.write(" ")

 mon.setCursorPos(15,5)
 mon.setBackgroundColor(defaultColor)
 if defaultColor == colors.white then
  mon.setTextColor(colors.black)
 else
 mon.setTextColor(colors.white)
 end
 mon.write("Keep")

 local eve,id,cx,cy
 repeat
  eve,id,cx,cy=os.pullEvent("monitor_touch")
 until cx >= 15 and cy <= 5 and cx <= 18 and cy >= 1
 cx=cx-14
 
 if cx == 1 and cy == 1 then
  return colors.white
 elseif cx == 2 and cy == 1 then
  return colors.lightGray
 elseif cx == 3 and cy == 1 then
  return colors.gray
 elseif cx == 4 and cy == 1 then
  return colors.black
 elseif cx == 1 and cy == 2 then
  return colors.blue
 elseif cx == 2 and cy == 2 then
  return colors.cyan
 elseif cx == 3 and cy == 2 then
  return colors.lightBlue
 elseif cx == 4 and cy == 2 then
  return colors.brown
 elseif cx == 1 and cy == 3 then
  return colors.green
 elseif cx == 2 and cy == 3 then
  return colors.lime
 elseif cx == 3 and cy == 3 then
  return colors.orange
 elseif cx == 4 and cy == 3 then
  return colors.yellow
 elseif cx == 1 and cy == 4 then
  return colors.red
 elseif cx == 2 and cy == 4 then
  return colors.purple
 elseif cx == 3 and cy == 4 then
  return colors.magenta
 elseif cx == 4 and cy == 4 then
  return colors.pink
 elseif cy == 5 then
  return defaultColor
 end
end

function restart() --restarts playback (more useful than it sounds)
 stop()
 play()
end

function stop() --stops playback
 playing=false
 os.cancelTimer(timer)
 os.cancelTimer(tickTimer)
 elapsed=0
 disk.stopAudio()
end

function playAll() --starts all discs
 playing = true
 for k,v in pairs(drives) do
  v.playAudio()
 end
 for k,duplicates in pairs(duplicateDrives) do
  for k,v in pairs(duplicates) do
   v.playAudio()
  end
 end
end

function play() --starts playback
 playing=true
 timer=os.startTimer(lengths[disks[track]])
 tickTimer=os.startTimer(0.25)
 drives[track].playAudio()
 if playDuplicate and duplicateDrives[getAudioTitle(drives[track])] ~= nil then
  for k,v in pairs(duplicateDrives[getAudioTitle(drives[track])]) do
   v.playAudio()
  end
 end
end

function skip(playNext) --skips to the next track
 if not loop and #disks>1 then
  if shuffle then
   local rd
   repeat
    rd=math.random(#drives)
   until rd~=track
   track=rd
  else
   track=track+1
   if track>#disks then
    track=1
   end
  end
  updateDisplayStart()
 end
 if playNext then
  restart() --see?
 end
end

function back() --goes back to the previous track
 if not loop then
  track=track-1
  if track<1 then
   track=#disks
  end
  updateDisplayStart()
 end
 restart()
end

function skipto(tr) --skips to a particular track according to 'tr'
 if tr==track then
  return
 end
 track=tr
 if track>#disks or track<1 then
  return
 end
 restart()
end

function updateDisplayStart()
 if tooManyDisks then
  if track-1 < displayStart then
   displayStart = track-1
  elseif track > displayStart+(h-2) then
   displayStart = track-(h-2)
  end
 end
end

function sortDriveByTitle(dr1, dr2)
 return getAudioTitle(dr1) < getAudioTitle(dr2)
end

function getAudioTitle(drive)
 name = drive.getAudioTitle()
 if names[name] ~= nil then
  return names[name]
 end
 return name 
end

-------------------------------------------------------------------------------

disk.stopAudio() --stop all currently playing disks

lengths={} --length of all the disks in seconds
-- Vanilla discs --
lengths["C418 - 13"]=180
lengths["C418 - cat"]=187
lengths["C418 - blocks"]=347
lengths["C418 - chirp"]=187
lengths["C418 - far"]=176
lengths["C418 - mall"]=199
lengths["C418 - mellohi"]=98
lengths["C418 - stal"]=152
lengths["C418 - strad"]=190
lengths["C418 - ward"]=253
lengths["C418 - 11"]=73
lengths["C418 - wait"]=240
lengths["Lena Raine - Pigstep"]=150
lengths["Lena Raine - otherside"]=197
lengths["Samuel Åberg - 5"]=180
lengths["Aaron Cherof - Relic"]=220
-- Modded discs --
lengths["MissLilitu - Over the Rainbow"]=214 --[Let's Do] Beachparty
lengths["adoghr - 0308"]=122 --Additional Additions
lengths["adoghr - 1007"]=162 --Additional Additions
lengths["adoghr - 1507"]=214 --Additional Additions
lengths["AetherAudio - Aerwhale"]=178 --Aether II
lengths["Moorziey - Demise"]=300 --Aether II
lengths["Emile van Krieken - Approaches"]=275 --Aether II
lengths["Emile van Krieken - ???"]=98 --Aether II
lengths["Lachney - Legacy"]=296 --Aether: Lost Content
lengths["Jesterguy - Sovereign of the Skies"]=221 --The Aether: Lost Content
lengths["Ninni - Fusion"]=238 --Alex's Caves
lengths["LudoCrypt - Thime"]=315 --Alex's Mobs
lengths["LudoCrypt - Daze"]=193 --Alex's Mobs
lengths["Bertsz - Horizon"]=72 --Aquamirae
lengths["Krossy - Forsaken Drownage"]=154 --Aquamirae
lengths["Firel - Aria Biblio"]=252 --Ars Nouveau
lengths["Thistle - The Sound of Glass"]=184 --Ars Nouveau
lengths["Firel - The Wild Hunt"]=120 --Ars Nouveau
lengths["Mista Jub - Fox"]=118 --Berry Good
lengths["RENREN - Fox"]=118 --Berry Good
lengths["Firel - Strange And Alien"]=266 --BetterEnd Forge
lengths["Firel - Grasping At Stars"]=528 --BetterEnd Forge
lengths["Firel - Endseeker"]=462 --BetterEnd Forge
lengths["Firel - Eo Dracona"]=360 --BetterEnd Forge
lengths["Podington Bear - Button Mushrooms"]=110 --Biome Makeover
lengths["Lobo Loco - Ghost Town"]=270 --Biome Makeover
lengths["Isaac Chambers - Swamp Jives"]=267 --Biome Makeover
lengths["Damiano Baldoni - Red Rose"]=138 --Biome Makeover
lengths["Tim Rurkowski - Wanderer"]=179 --Biomes O' Plenty
lengths["???"]=190 --Biomes O' Plenty
lengths["Bleeding Edge of the Hidden Realm"]=215 --Blood Magic
lengths["Jonathing - Blinding Rage"]=232 --Blue Skies
lengths["Jonathing - Defying Starlight"]=148 --Blue Skies
lengths["Jonathing - Venomous Encounter"]=155 --Blue Skies
lengths["Lachney - Population"]=238 --Blue Skies
lengths["Kain Vinosec - Endure Emptiness"]=204 --Botania
lengths["Kain Vinosec - Fight For Quiescence"]=229 --Botania
lengths["izofar - Wither Waltz"]=254 --Bygone Nether
lengths["Cinematic Danger Background Music | No Copyright"]=170 --Cataclysm Mod
lengths["??Symphony - God of Blaze"]=128 --Cataclysm Mod
lengths["??Symphony - vs Titans"]=148 --Cataclysm Mod
lengths["??Symphony - Endless Storm"]=143 --Cataclysm Mod
lengths["Ean Grimm - Eternal"]=148 --Cataclysm Mod
lengths["Sinyells - Monster Fight"]=184 --Cataclysm Mod
lengths["Hippo0824 - Sands of Dominion"]=144 --Cataclysm Mod
lengths["C418 - Minecraft"]=234 --Charm
lengths["C418 - Clark"]=192 --Charm
lengths["C418 - Sweden"]=216 --Charm
lengths["C418 - Subwoofer Lullaby"]=209 --Charm
lengths["C418 - Haggstrom"]=204 --Charm
lengths["C418 - Danny"]=255 --Charm
lengths["C418 - Key"]=65 --Charm
lengths["C418 - Oxygène"]=65 --Charm
lengths["C418 - Dry Hands"]=69 --Charm
lengths["C418 - Wet Hands"]=90 --Charm
lengths["C418 - Biome Fest"]=378 --Charm
lengths["C418 - Blind Spots"]=333 --Charm
lengths["C418 - Haunt Muskie"]=362 --Charm
lengths["C418 - Aria Math"]=310 --Charm
lengths["C418 - Dreiton"]=497 --Charm
lengths["C418 - Taswell"]=516 --Charm
lengths["C418 - Concrete Halls"]=234 --Charm
lengths["C418 - Dead Voxel"]=296 --Charm
lengths["C418 - Warmth"]=239 --Charm
lengths["C418 - Ballad of the Cats"]=276 --Charm
lengths["C418 - Mutation"]=185 --Charm
lengths["C418 - Moog City 2"]=180 --Charm
lengths["C418 - Beginning 2"]=176 --Charm
lengths["C418 - Floating Trees"]=245 --Charm
lengths["C418 - Axolotl"]=303 --Charm
lengths["C418 - Dragon Fish"]=372 --Charm
lengths["C418 - Shuniji"]=244 --Charm
lengths["C418 - Boss"]=346 --Charm
lengths["C418 - The End"]=905 --Charm
lengths["C418 - Mice on Venus"]=282 --Charm --Rats
lengths["C418 - Living Mice"]=178 --Charm --Rats
lengths["LudoCrypt - Luminous Plantation"]=231 --Cinderscapes
lengths["Etorna_Z - Chilling In Hell"]=136 --Cinderscapes
lengths["Shroomy - Drift"]=146 --Cloud Storage
lengths["Dance with Golems -Flan"]=360 --Craft and hunt
lengths["Kevin MacLeod - Casa Bossa Nova"]=188 --Create: Connected
lengths["Kevin MacLeod - Local Forecast - Elevator"]=188 --Create: Connected
lengths["RedWolf - The Bright Side"]=160 --Create Confectionery
lengths["Emile van Krieken - A Morning Wish"]=282--Deep Aether
lengths["Emile van Krieken - Nabooru"]=364 --Deep Aether
lengths["RaltsMC - Ashes"]=94 --Desolation
lengths["Ashes"]=94 --Desolation (Forge)
lengths["F. Chopin - Valse Du Petit Chien (DashieDev)"]=132 --Doggy Talents Next
lengths["J.S. Bach - Art Of Fugue: Contrapunctus XI (Kimiko Ishizaka)"]=288 --Doggy Talents Next
lengths["J.S. Bach - WTC I: Fugue in C# Minor (Kimiko Ishizaka)"]=156 --Doggy Talents Next
lengths["Okami - \"Ryoshima Coast\" (Arr. DashieDev for Organ)"]=110 --Doggy Talents Next
lengths["BooWho - coconut"]=110 --Ecologics
lengths["Kitsune² - Parousia"]=185 --Eidolon
lengths["Ultrasyd - 7F Patterns"]=222 --Embers Rekindled
lengths["_humanoid - sprog"]=86 --Enlightend
lengths["hatsondogs - Leaving Home"]=155 --Environmental
lengths["Mista Jub - Slabrave"]=112 --Environmental
lengths["RENREN - Slabrave"]=112 --Environmental
lengths["Swordland"]=195 --ExtraBotany
lengths["Salvation"]=48 --ExtraBotany
lengths["Mr. Esuoh - Crashing Tides"]=176 --Fins and Tails
lengths["qwertygiy - Banjolic"]=111 --Hardcore Ender Expension
lengths["qwertygiy - In The End"]=224 --Hardcore Ender Expension
lengths["qwertygiy - Asteroid"]=60 --Hardcore Ender Expension
lengths["qwertygiy - Stewed"]=90 --Hardcore Ender Expension
lengths["qwertygiy - Beat The Dragon"]=118 --Hardcore Ender Expension
lengths["qwertygiy - Granite"]=130 --Hardcore Ender Expension
lengths["qwertygiy - Remember This"]=87 --Hardcore Ender Expension
lengths["qwertygiy - Spyder"]=135 --Hardcore Ender Expension
lengths["qwertygiy - Onion"]=210 --Hardcore Ender Expension
lengths["qwertygiy - Crying Soul"]=122 --Hardcore Ender Expension
lengths["Lorian Ross - Kobblestone"]=184 --Kobolds
lengths["Duped Shovels"]=642 --Incubus Core
lengths["Llama Song"]=92 --Industrial Agriculture
lengths["LudoCrypt - flush"]=262 --Infernal Expansion
lengths["LudoCrypt - Soul Spunk"]=234 --Infernal Expansion
lengths["Cama - Slither"]=122 --Integrated Dungeons and Structures
lengths["Cama - calidum"]=196 --Integrated Dungeons and Structures
lengths["Cama - Forlorn"]=144 --Integrated Stronghold
lengths["Cama - sight"]=160 --Integrated Stronghold
lengths["izofar - Bastille Blues"]=200 --It Takes a Pillage
lengths["CF28 - Mournful Abyss"]=289 --Iter RPG
lengths["Construct Dance Mix"]=164 --Mana and Artifice
lengths["Endigo - Big Chungus (Official Main Theme)"]=111 --Marium's Soulslike Weaponry
lengths["BoxCat Games - Trace Route"]=35 --MatterOverdrive
lengths["Monkey Warhol - Magnum"]=90 --Meet Your Fight
lengths["FireMuffin303 - Bouncyslime"]=134 --Muffin's Slime Golem
lengths["LudoCrypt - Petiole"]=160 --Mowzie's Mobs
lengths["Ali Bak?r - soot"]=180 --Mythic Upgrades
lengths["Ali Bak?r - appomattox"]=420 --Mythic Upgrades
lengths["Ali Bak?r - fierce"]=129 --Mythic Upgrades
lengths["Ali Bak?r - nelumbo"]=118 --Mythic Upgrades
lengths["Ali Bak?r - flow of the abyss"]=126 --Mythic Upgrades
lengths["Ali Bak?r - tanker on the levantine's"]=205 --Mythic Upgrades
lengths["RENREN - Hullabaloo"]=135 --Neapolitan
lengths["Dion - The Wanderer"]=167 --NuclearCraft
lengths["Skeeter Davis - The End of the World"]=178 --NuclearCraft
lengths["Dire Straits - Money For Nothing"]=315 --NuclearCraft
lengths["Ur-Quan Master - Hyperspace"]=185 --NuclearCraft
lengths["elgavira - bathysphere"]=127 --Odd Water Mobs
lengths["baggu - coelacanth"]=114 --Odd Water Mobs
lengths["baggu - seapig"]=121 --Odd Water Mobs
lengths["Valve - Still Alive"]=180 --Portal Gun
lengths["Valve - Radio Loop"]=22 --Portal Gun
lengths["Valve - Want You Gone"]=140 --Portal Gun
lengths["Orangery - Coniferus Forest (Main Menu Theme)"]=128 --Prominent
lengths["Mouse.Avi Scream - Unkown Artist"]=9 --Pyrologer And Friends
lengths["Water Droplets"]=20 --Quark
lengths["Ocean Waves"]=16 --Quark
lengths["Rainy Mood"]=5 --Quark
lengths["Heavy Wind"]=13 --Quark
lengths["Soothing Cinders"]=16 --Quark
lengths["Tick-Tock"]=1 --Quark
lengths["Cricket Song"]=1 --Quark
lengths["Packed Venue"]=10 --Quark
lengths["Kain Vinosec - Endermosh"]=190 --Quark
lengths["Bearfan - Nourish"]=130 --Simple Farming
lengths["Luz - Frosty Snig"]=186 --Snow Pig
lengths["STiiX - A Carol"]=160 --Snowy Spirit
lengths["Spectrum Theme"]=120 --Spectrum
lengths["Deeper Down Theme: Radiarc - Irrelevance Fading"]=265 --Spectrum
lengths["Proper Motions - Everreflective"]=288 --Spectrum
lengths["LudoCrypt - scour"]=249 --Sully's Mod
lengths["Partyp - Pancake Music"]=230 --Supplementaries
lengths["FantomenK - Playing With Power"]=290 --Tetra Pak
lengths["Emile van Krieken - Ascending Dawn"]=350 --The Aether --Aether II
lengths["Noisestorm - Aether Tune"]=150 --The Aether
lengths["Voyed - Welcoming Skies"]=217 --The Aether
lengths["Jon Lachney - Legacy"]=296 --The Aether
lengths["RENREN - chinchilla"]=164 --The Aether
lengths["RENREN - high"]=141 --The Aether
lengths["Emile van Krieken - Labyrinth's Vengeance"]=214 --The Aether: Redux
lengths["Voog2 - Astatos"]=366 --The Betweenlands
lengths["Voog2 - Between You And Me"]=300 --The Betweenlands
lengths["Voog2 - Christmas On The Marsh"]=220 --The Betweenlands
lengths["Voog2 - The Explorer"]=400 --The Betweenlands
lengths["Voog2 - Hag Dance"]=280 --The Betweenlands
lengths["Voog2 - Lonely Fire"]=228 --The Betweenlands
lengths["..."]=65 --The Betweenlands
lengths["Voog2 - Ancient"]=182 --The Betweenlands
lengths["Voog2 - Beneath A Green Sky"]=310 --The Betweenlands
lengths["Voog2 - Rave In A Cave"]=228 --The Betweenlands
lengths["Voog2 - Onwards"]=212 --The Betweenlands
lengths["Voog2 - Stuck In The Mud"]=278 --The Betweenlands
lengths["Voog2 - Wandering Wisps"]=205 --The Betweenlands
lengths["Voog2 - Waterlogged"]=196 --The Betweenlands
lengths["Rotch Gwylt - Deep Water"]=155 --The Betweenlands
lengths["Rimsky Korsakov - Flight of the Bumblebee"]=84 --The Bumblezone
lengths["Rat Faced Boy - Honey Bee"]=216 --The Bumblezone
lengths["LudoCrypt - Bee-laxing with the Hom-bees"]=300 --The Bumblezone
lengths["LudoCrypt - La Bee-da Loca"]=176 --The Bumblezone
lengths["LudoCrypt - Bee-ware of the Temple"]=371  --The Bumblezone
lengths["RenRen - Knowing"]=252 --The Bumblezone
lengths["RenRen - Radiance"]=106 --The Bumblezone
lengths["RenRen - Life"]=86 --The Bumblezone
lengths["Punpudle - A Last First Last"]=652 --The Bumblezone
lengths["Jesterguy - Delve Deeper"]=230 --The Conjurer
lengths["Mista Jub - Kilobyte"]=165 --The Endergetic Expansion
lengths["\"Incarnated Evil\" by Rotch Gwylt"]=270 --The Graveyard
lengths["Blue Duck - Galactic Wave"]=157 --The Outer End
lengths["Pyrocide - Unknown Frontier"]=66 --The Outer End
lengths["Rotch Gwylt - Radiance"]=135 --The Twilight Forest
lengths["Rotch Gwylt - Steps"]=195 --The Twilight Forest
lengths["Rotch Gwylt - Superstitious"]=192 --The Twilight Forest
lengths["MrCompost - Home"]=217 --The Twilight Forest
lengths["MrCompost - Wayfarer"]=175 --The Twilight Forest
lengths["MrCompost - Findings"]=198 --The Twilight Forest
lengths["MrCompost - Maker"]=209 --The Twilight Forest
lengths["MrCompost - Thread"]=203 --The Twilight Forest
lengths["MrCompost - Motion"]=171 --The Twilight Forest
lengths["Screem - Mammoth"]=196 --The Undergarden
lengths["Screem - Limax Maximus"]=163 --The Undergarden
lengths["Screem - Relict"]=189 --The Undergarden
lengths["Screem - Gloomper Anthem"]=206 --The Undergarden
lengths["An AI was given an image of a Gloomper and made this song"]=160 --The Undergarden
lengths["Lonesome Avenue (YouTube Audio Library)"]=185 --Tinker I/O
lengths["Emile Van Krieken - The Tribe"]=154 --Tropicraft
lengths["Punchaface - Buried Treasure"]=360 --Tropicraft
lengths["Punchaface - Low Tide"]=342 --Tropicraft
lengths["Frox - Trade Winds"]=240 --Tropicraft
lengths["Frox - Eastern Isles"]=370 --Tropicraft
lengths["Billy Christiansen - Summering"]=295 --Tropicraft
lengths["Mili -  Iron Lotus"]=236 --Twilight Delight
lengths["Parallel - ComaMedia"]=130 --Ulterlands
lengths["Elderwind - Harumachi"]=195 --Ulterlands
lengths["Requiem - BalanceBay"]=625 --Ulterlands
lengths["RedWolf - Endstone Golem Theme"]=182 --Unusual End
lengths["RedWolf - Flying Ships"]=197 --Unusual End
lengths["hatsondogs - Atlantis"]=115 --Upgrade Aquatic
lengths["C418 - dog"]=146 --Variant16x
lengths["C418 - eleven"]=70 --Variant16x
lengths["Bramble"]=122 --ViesCraft Machines
lengths["Castle"]=106 --ViesCraft Machines
lengths["Dire"]=186 --ViesCraft Machines
lengths["Jungle"]=168 --ViesCraft Machines
lengths["Storms"]=98 --ViesCraft Machines
lengths["Timescar"]=145 --ViesCraft Machines
lengths["rose - rain"]=123 --Windswept
lengths["rose - snow"]=120 --Windswept
lengths["rose - bumblebee"]=54 --Windswept

names={} --modded discs with incorrect item descriptions

names["item.record.ascending_dawn.desc"] = "Emile van Krieken - Ascending Dawn"
names["item.record.aether_tune.desc"] = "Noisestorm - Aether Tune"
names["item.record.astatos.desc"] = "Voog2 - Astatos"
names["item.record.between_you_and_me.desc"] = "Voog2 - Between You And Me"
names["item.record.christmas_on_the_marsh.desc"] = "Voog2 - Christmas On The Marsh"
names["item.record.the_explorer.desc"] = "Voog2 - The Explorer"
names["item.record.hag_dance.desc"] = "Voog2 - Hag Dance"
names["item.record.lonely_fire.desc"] = "Voog2 - Lonely Fire"
names["item.record.16612.desc"] = "..."
names["item.record.record_wanderer.desc"] = "Dion - The Wanderer"
names["item.record.record_end_of_the_world.desc"] = "Skeeter Davis - The End of the World"
names["item.record.record_money_for_nothing.desc"] = "Dire Straits - Money For Nothing"
names["item.record.record_hyperspace.desc"] = "Ur-Quan Master - Hyperspace"
names["item.record.ancient.desc"] = "Voog2 - Ancient"
names["item.record.beneath_a_green_sky.desc"] = "Voog2 - Beneath A Green Sky"
names["item.record.dj_wights_mixtape.desc"] = "Voog2 - Rave In A Cave"
names["item.record.onwards.desc"] = "Voog2 - Onwards"
names["item.record.stuck_in_the_mud.desc"] = "Voog2 - Stuck In The Mud"
names["item.record.wandering_wisps.desc"] = "Voog2 - Wandering Wisps"
names["item.record.waterlogged.desc"] = "Voog2 - Waterlogged"
names["item.record.matteroverdrive.transformation.desc"] = "BoxCat Games - Trace Route"
names["item.blue_skies.blinding_rage.desc"] = "Jonathing - Blinding Rage"
names["item.blue_skies.defying_starlight.desc"] = "Jonathing - Defying Starlight"
names["item.blue_skies.venomous_encounter.desc"] = "Jonathing - Venomous Encounter"
names["item.blue_skies.population.desc"] = "Lachney - Population"
names["item.conjurer_illager.music_disc_delve_deeper.desc"] = "Jesterguy - Delve Deeper"
names["item.lost_aether_content.music_disc_legacy.desc"] = "Lachney - Legacy"
names["item.lost_aether_content.music_disc_sovereign_of_the_skies.desc"] = "Jesterguy - Sovereign of the Skies"
names["item.tropicraft.music_disc_the_tribe.desc"] = "Emile Van Krieken - The Tribe"
names["item.tropicraft.music_disc_buried_treasure.desc"] = "Punchaface - Buried Treasure"
names["item.tropicraft.music_disc_low_tide.desc"] = "Punchaface - Low Tide"
names["item.tropicraft.music_disc_trade_winds.desc"] = "Frox - Trade Winds"
names["item.tropicraft.music_disc_eastern_isles.desc"] = "Frox - Eastern Isles"
names["item.tropicraft.music_disc_summering.desc"] = "Billy Christiansen - Summering"
names["block.supplementaries.pancake.desc"] = "Partyp - Pancake Music"
names["duped_shovels.tradetf.exe.ogg"] = "Duped Shovels"
names["AetherAudio - Aerwhale§r"] = "AetherAudio - Aerwhale"
names["Moorziey - Demise§r"] = "Moorziey - Demise"
names["Emile van Krieken - Approaches§r"] = "Emile van Krieken - Approaches"
names["Emile van Krieken - Ascending Dawn§r"] = "Emile van Krieken - Ascending Dawn"
names["Emile van Krieken - ???§r"] = "Emile van Krieken - ???"
names["§5Firel§r - §fStrange And Alien§r"] = "Firel - Strange And Alien"
names["§5Firel§r - §fGrasping At Stars§r"] = "Firel - Grasping At Stars"
names["§5Firel§r - §fEndseeker§r"] = "Firel - Endseeker"
names["§5Firel§r - §fEo Dracona§r"] = "Firel - Eo Dracona"

drives = {} --all the drives with audio wrapped in one variable. handy, right?
disks = {} --the name of the disk in the drive in the same corresponding 'drives' drive
duplicateDrives = {} --if 'playDuplicate' is set to true, store the drives with a track already inside 'drives'
setColors={}

configFile = "jukebox.ini" --name of the config file
playing=false --i'm not going to insult you by explaining this one
shuffle=false --when true; selects a random track when track is over
loop=false --when true; loop the current track
playingDefault=false
shuffleDefault=false
loopDefault=false
track=1 --selected track
timer=0 --token of the timer that signals the end of a track
elapsed=0 --time that track was started
tickTimer=0 --token of the timer that signals to update 'elapsed'
minSize=21 --width under which buttons labels are shorten
minPrefSize=12 --height under which the preference button not shown
minColorSize=16 --height and width under which the color button not shown
displayStart=0 --track to start the display on
tooManyDiscs=false  --set to true when the number of discs is greater than the height of the monitor
playDuplicate=true --play all the duplicates of the same disc at the same time and show the track only once in the list
fullProgressLine=false --use the full width of the monitor to display the current track progress instead of the width of the track name

loadPref(false)
loadJukebox()

--------------------------------------------------------------------------------

if shuffle then
 skip(false)
end
if playing then
 play()
end

repeat --main loop

 --refresh display
 w, h = mon.getSize()
 miniMode = w < minSize
 showPref = h >= minPrefSize
 tooManyDisks = h - 2 < #disks

 mon.setTextColor(setColors.text)
 mon.setBackgroundColor(setColors.background) --clearing
 mon.clear()

 mon.setCursorPos(1,1) --drawing back, play, skip, and suffle
 mon.setBackgroundColor(setColors.skip)
 mon.write("<-")

 mon.setCursorPos(6,1)
 mon.setBackgroundColor(setColors.skip)
 mon.write("->")

 mon.setCursorPos(4,1)
 if playing then
  mon.setBackgroundColor(setColors.enabled)
 else
  mon.setBackgroundColor(setColors.disabled)
 end
 mon.write(">")

 mon.setCursorPos(9,1)
 if shuffle then
  mon.setBackgroundColor(setColors.enabled)
 else
  mon.setBackgroundColor(setColors.disabled)
 end
 if miniMode then
  mon.write("Sh")
 else
  mon.write("Shuffle")
 end

 if loop then
  mon.setBackgroundColor(setColors.enabled)
 else
  mon.setBackgroundColor(setColors.disabled)
 end
 if miniMode then
 mon.setCursorPos(12,1)
  mon.write("L")
 else
 mon.setCursorPos(17,1)
  mon.write("Loop")
 end

 for k,v in pairs(disks) do --drawing tracks
  if k > displayStart then
   mon.setCursorPos(1,k+2-displayStart)
   if playDuplicate and duplicateDrives[v] ~= nil then
    mon.setTextColor(setColors.duplicateText)
   else
    mon.setTextColor(setColors.text)
   end
   if k == track then
    if fullProgressLine then
     v = string.format("%-" .. w .. "s", v);
    end
    mon.setBackgroundColor(setColors.progress3)
    local leng = math.min(string.len(v), w)
    local blueLeng = (elapsed) / lengths[disks[track]] * leng
    for n=1,leng do
     if n > math.ceil(blueLeng) then
      mon.setBackgroundColor(colors.green)
     elseif n == math.ceil(blueLeng) then
      if n - blueLeng < .3333 then
       mon.setBackgroundColor(setColors.progress3)
      elseif n - blueLeng < .6666 then
       mon.setBackgroundColor(setColors.progress2)
      else
       mon.setBackgroundColor(setColors.progress1)
      end
     end
     mon.write(string.sub(v,n,n))
    end
   else
    mon.setBackgroundColor(setColors.background)
    mon.write(v)
   end
  end
 end
 mon.setTextColor(setColors.text)

 if tooManyDisks then
  mon.setCursorPos(w-4,1)
  if displayStart > 0 then
   mon.setBackgroundColor(setColors.skip)
  else
   mon.setBackgroundColor(setColors.background) 
  end
  mon.write("^")

  mon.setCursorPos(w-2,1)
  if displayStart < #disks - (h-2) then
   mon.setBackgroundColor(setColors.skip)
  else
   mon.setBackgroundColor(setColors.background)
  end
  mon.write("v")
 end

 if showPref then
  mon.setCursorPos(w,1)
  mon.setBackgroundColor(setColors.prefBack)
  mon.setTextColor(setColors.prefText)
  mon.write("p")
 end

 --wait for event
 local eve,id,cx,cy
 repeat
  eve,id,cx,cy=os.pullEvent()
 until eve=="timer" or eve=="monitor_touch"

 --test event
 if eve=="timer" then --the timer ended
  if id==timer then
   skip(true)
  elseif id==tickTimer then
   tickTimer=os.startTimer(0.25)
   elapsed=elapsed+0.25
  end

 else --the monitor was pressed
  if cy > 1 then --a track was pressed
   if cy > 2 and cy < #disks + 3 then
    if tooManyDisks then
     skipto(cy - 2 + displayStart)
    else
     skipto(cy - 2)
    end
   end
  elseif cx <= 2 then --back was pressed
   back()
  elseif cx == 4 then --stop/play was pressed
   if playing then
    stop()
   else
    play()
   end
  elseif cx == 6 or cx == 7 then --skip was pressed
   skip(true)
  elseif cx >= 9 and (not miniMode and cx <= 15 or miniMode and cx <= 10) then --shuffle was pressed
   shuffle = not shuffle
  elseif (not miniMode and cx >= 17 and cx <= 20) or (miniMode and cx == 12) then --loop was pressed
   loop = not loop 
  elseif tooManyDisks and cx == w - 4 and displayStart > 0 then --up was pressed
   displayStart = displayStart - 1
  elseif tooManyDisks and cx == w - 2 and displayStart < #disks - (h - 2) then --down was pressed
   displayStart = displayStart + 1
  elseif showPref and cx == w then --preferences button was pressed
   stop()
   if changePref() then
    return
   end
  end
 end

until false
