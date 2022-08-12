--[[

Jukebox program
By The Juice
Edited by Out-Feu

version 1.3.1

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect some drives with music disks
and an advanced monitor(at least two blocks wide)
in any way and start this program

--]]


function loadPref()
    if not fs.exists("jukeboxconfig") then
     setColors.text=colors.white
     setColors.background=colors.black
     setColors.skip=colors.blue
     setColors.enabled=colors.green
     setColors.disabled=colors.red
     setColors.selected=colors.green
     setColors.progress1=colors.lightBlue
     setColors.progress2=colors.cyan
     setColors.progress3=colors.blue
     setColors.prefBack=colors.blue
     setColors.prefText=colors.white
     
    else
     local fil=fs.open("jukeboxconfig","r")
     
     setColors.text=tonumber(fil.readLine())
     setColors.background=tonumber(fil.readLine())
     setColors.skip=tonumber(fil.readLine())
     setColors.enabled=tonumber(fil.readLine())
     setColors.disabled=tonumber(fil.readLine())
     setColors.selected=tonumber(fil.readLine())
     setColors.progress1=tonumber(fil.readLine())
     setColors.progress2=tonumber(fil.readLine())
     setColors.progress3=tonumber(fil.readLine())
     setColors.prefBack=tonumber(fil.readLine())
     setColors.prefText=tonumber(fil.readLine())
       
     playing=fil.readLine()=="true"
     shuffle=fil.readLine()=="true"
     loop=fil.readLine()=="true"
     playingDefault=playing
     shuffleDefault=shuffle
     loopDefault=loop
     
     fil.close()
    end
   end
   
   function savePref()
    fil=fs.open("jukeboxconfig","w")
    fil.writeLine(setColors.text)
    fil.writeLine(setColors.background)
    fil.writeLine(setColors.skip)
    fil.writeLine(setColors.enabled)
    fil.writeLine(setColors.disabled)
    fil.writeLine(setColors.selected)
    fil.writeLine(setColors.progress1)
    fil.writeLine(setColors.progress2)
    fil.writeLine(setColors.progress3)
    fil.writeLine(setColors.prefBack)
    fil.writeLine(setColors.prefText) 
    
    fil.writeLine(playingDefault)
    fil.writeLine(shuffleDefault)
    fil.writeLine(loopDefault)
    
    fil.close()
   end
   
   function changePref()
    while true do
     mon.setBackgroundColor(colors.black)
     mon.setTextColor(colors.white)
     mon.clear()
     
     mon.setCursorPos(1,1)
     mon.write("Preferences")
     
     mon.setCursorPos(1,3)
     mon.write("Edit colors")
     
     mon.setCursorPos(1,4)
     if playingDefault then
      mon.setBackgroundColor(colors.green)
     else
      mon.setBackgroundColor(colors.red)
     end
     mon.write("Play by default")
     
     mon.setCursorPos(1,5)
     if shuffleDefault then
      mon.setBackgroundColor(colors.green)
     else
      mon.setBackgroundColor(colors.red)
     end
     mon.write("Shuffle by default")
     
     mon.setCursorPos(1,6)
     if loopDefault then
      mon.setBackgroundColor(colors.green)
     else
      mon.setBackgroundColor(colors.red)
     end
     mon.write("Loop by default")
     
     mon.setCursorPos(1, 12)
     if playing then
      mon.setBackgroundColor(colors.green)
     else
      mon.setBackgroundColor(colors.red)
     end
     mon.write("Cacophony")
     
     mon.setBackgroundColor(colors.black)
     
     mon.setCursorPos(1,8)
     mon.write("Save")
     
     mon.setCursorPos(1,9)
     mon.write("Load")
     
     mon.setCursorPos(1,10)
     mon.write("Back")
     
     mon.setCursorPos(1,14)
     mon.write("Close jukebox")
     
     local eve,id,cx,cy
     eve,id,cx,cy=os.pullEvent("monitor_touch")
     
     if cy==3 then
      changeColors()
     elseif cy==4 then
      playingDefault = not playingDefault
     elseif cy==5 then
      shuffleDefault = not shuffleDefault
     elseif cy==6 then
     loopDefault = not loopDefault
     elseif cy==8 then
      savePref()
     elseif cy==9 then
      loadPref()
     elseif cy==10 then
      stop()
      return false
     elseif cy==12 then
      if playing then
       stop()
      else
       playAll()
      end
     elseif cy==14 then
      stop()
      return true
     end
     
    end
   end
   
   function changeColors()
    while true do
     mon.setBackgroundColor(colors.black)
     mon.clear()
     
     
     mon.setCursorPos(1,1)
     mon.setTextColor(setColors.text)
     if setColors.text==colors.black then
      mon.setBackgroundColor(colors.white)
     end
     mon.write("Text")
     
     mon.setCursorPos(1,2)
     mon.setBackgroundColor(setColors.background)
     if setColors.background==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Background")
     
     mon.setCursorPos(1,3)
     mon.setBackgroundColor(setColors.skip)
     if setColors.skip==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Skip buttons")
     
     mon.setCursorPos(1,4)
     mon.setBackgroundColor(setColors.enabled)
     if setColors.enabled==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Enabled")
     
     mon.setCursorPos(1,5)
     mon.setBackgroundColor(setColors.disabled)
     if setColors.disabled==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Disabled")
     
     mon.setCursorPos(1,6)
     mon.setBackgroundColor(setColors.selected)
     if setColors.selected==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Selected track")
     
     mon.setCursorPos(1,7)
     mon.setBackgroundColor(setColors.progress1)
     if setColors.progress1==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Progress1")
     
     mon.setCursorPos(1,8)
     mon.setBackgroundColor(setColors.progress2)
     if setColors.progress2==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Progress2")
     
     mon.setCursorPos(1,9)
     mon.setBackgroundColor(setColors.progress3)
     if setColors.progress3==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("Progress3")
     
     mon.setCursorPos(1,10)
     mon.setBackgroundColor(setColors.prefBack)
     if setColors.prefBack==colors.white then
      mon.setTextColor(colors.black)
     else
      mon.setTextColor(colors.white)
     end
     mon.write("p button backgnd")
     
     mon.setCursorPos(1,11)
     mon.setTextColor(setColors.prefText)
     if setColors.prefText==colors.black then
      mon.setBackgroundColor(colors.white)
     else
      mon.setBackgroundColor(colors.black)
     end
     mon.write("p button text")
     
     mon.setCursorPos(1,13)
     mon.setBackgroundColor(colors.black)
     mon.setTextColor(colors.white)
     mon.write("back")
     
     
     local eve,id,cx,cy
     eve,id,cx,cy=os.pullEvent("monitor_touch")
     
     if cy==1 then
      setColors.text=colorPicker()
     elseif cy==2 then
      setColors.background=colorPicker()
     elseif cy==3 then
      setColors.skip=colorPicker()
     elseif cy==4 then
      setColors.enabled=colorPicker()
     elseif cy==5 then
      setColors.disabled=colorPicker()
     elseif cy==6 then
      setColors.selected=colorPicker()
     elseif cy==7 then
      setColors.progress1=colorPicker()
     elseif cy==8 then
      setColors.progress2=colorPicker()
     elseif cy==9 then
      setColors.progress3=colorPicker()
     elseif cy==10 then
      setColors.prefBack=colorPicker()
     elseif cy==11 then
      setColors.prefText=colorPicker()
     elseif cy==13 then
      return
     end
     
    end
   end
   
   function colorPicker()
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
    
    
    local eve,id,cx,cy
    repeat
     eve,id,cx,cy=os.pullEvent("monitor_touch")
    until cx>=15 and cy<=4 and cx<=18 and cy>=1
    cx=cx-14
    
    if cx==1 and cy==1 then
     return colors.white
    elseif cx==2 and cy==1 then
     return colors.lightGray
    elseif cx==3 and cy==1 then
     return colors.gray
    elseif cx==4 and cy==1 then
     return colors.black
    elseif cx==1 and cy==2 then
     return colors.blue
    elseif cx==2 and cy==2 then
     return colors.cyan
    elseif cx==3 and cy==2 then
     return colors.lightBlue
    elseif cx==4 and cy==2 then
     return colors.brown
    elseif cx==1 and cy==3 then
     return colors.green
    elseif cx==2 and cy==3 then
     return colors.lime
    elseif cx==3 and cy==3 then
     return colors.orange
    elseif cx==4 and cy==3 then
     return colors.yellow
    elseif cx==1 and cy==4 then
     return colors.red
    elseif cx==2 and cy==4 then
     return colors.purple
    elseif cx==3 and cy==4 then
     return colors.magenta
    elseif cx==4 and cy==4 then
     return colors.pink
    else
     error("uh oh! tell my daddy im broke!")
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
   end
   
   function play() --starts playback
    playing=true
    timer=os.startTimer(lengths[disks[track]])
    tickTimer=os.startTimer(0.25)
    drives[track].playAudio()
   end
   
   function skip() --skips to the next track
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
    restart() --see?
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
   -- Modded discs --
   lengths["LudoCrypt - Thime"]=315 --Alex's Mobs
   lengths["LudoCrypt - Daze"]=193 --Alex's Mobs
   lengths["Tim Rurkowski - Wanderer"]=179 --Biomes O' Plenty
   lengths["???"]=190 --Biomes O' Plenty
   lengths["Jonathing - Blinding Rage"]=232 --Blue Skies
   lengths["Jonathing - Defying Starlight"]=148 --Blue Skies
   lengths["Jonathing - Venomous Encounter"]=155 --Blue Skies
   lengths["Lachney - Population"]=238 --Blue Skies
   lengths["Kain Vinosec - Endure Emptiness"]=204 --Botania
   lengths["Kain Vinosec - Fight For Quiescence"]=229 --Botania
   lengths["izofar - Wither Waltz"]=254 --Bygone Nether
   lengths["BooWho - coconut"]=110 --Ecologics
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
   lengths["Llama Song"]=92 --Industrial Agriculture
   lengths["Cama - Slither"]=122 --Integrated Dungeons and Structures
   lengths["Cama - Calidum"]=196 --Integrated Dungeons and Structures
   lengths["Valve - Still Alive"]=180 --Portal Gun
   lengths["Valve - Radio Loop"]=22 --Portal Gun
   lengths["Valve - Want You Gone"]=140 --Portal Gun
   lengths["Water Droplets"]=20 --Quark
   lengths["Ocean Waves"]=16 --Quark
   lengths["Rainy Mood"]=5 --Quark
   lengths["Heavy Wind"]=13 --Quark
   lengths["Soothing Cinders"]=16 --Quark
   lengths["Tick-Tock"]=1 --Quark
   lengths["Cricket Song"]=1 --Quark
   lengths["Packed Venue"]=10 --Quark
   lengths["Kain Vinosec - Endermosh"]=190 --Quark
   lengths["FantomenK - Playing With Power"]=290 --Tetra Pak
   lengths["Rimsky Korsakov - Flight of the Bumblebee"]=206 --The Bumblezone
   lengths["Rat Faced Boy - Honey Bee"]=218 --The Bumblezone
   lengths["Jesterguy - Delve Deeper"]=230 --The Conjurer
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
   
   names={} --modded discs with incorrect item descriptions
   names["item.blue_skies.blinding_rage.desc"] = "Jonathing - Blinding Rage"
   names["item.blue_skies.defying_starlight.desc"] = "Jonathing - Defying Starlight"
   names["item.blue_skies.venomous_encounter.desc"] = "Jonathing - Venomous Encounter"
   names["item.blue_skies.population.desc"] = "Lachney - Population"
   names["item.conjurer_illager.music_disc_delve_deeper.desc"] = "Jesterguy - Delve Deeper"
   
   per=peripheral.getNames()
   drives={} --all the drives with audio wrapped in one variable. handy, right?
   for k,v in pairs(per) do
    if peripheral.getType(v)=="drive" then
     if peripheral.wrap(v).hasAudio() then
      if lengths[getAudioTitle(peripheral.wrap(v))] ~= nil then
       drives[#drives+1]=peripheral.wrap(v)
      else
       term.setTextColor(colors.red)
       print("Track not found '" .. getAudioTitle(peripheral.wrap(v)) .. "'")
       term.setTextColor(colors.white)
      end
     end
    elseif peripheral.getType(v)=="monitor" then
     mon=peripheral.wrap(v)
    end
   end
   per=nil
   
   table.sort(drives, sortDriveByTitle)
   disks={} --the name of the disk in the drive in the same corresponding 'drives' drive
   for k,v in pairs(drives) do
    disks[k]=getAudioTitle(drives[k])
   end
   print("Loaded " .. table.getn(disks) .. " tracks")
   
   setColors={}
   
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
   minSize=21 --size under which buttons labels are shorten
   displayStart=0 --track to start the display on
   tooManyDiscs=false  --set to true when the number of discs is greater than the height of the monitor
   
   loadPref()
   
   
   --------------------------------------------------------------------------------
   
   if shuffle then
    skip()
   end
   if playing then
    play()
   end
   
   repeat --main loop
    
    --refresh display
    w, h = mon.getSize()
    miniMode = w < minSize
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
      if k==track then
       mon.setBackgroundColor(setColors.progress3)
       local leng=string.len(v)
       local blueLeng=(elapsed)/lengths[disks[track]]*leng
       for n=1,leng do
        if n>math.ceil(blueLeng) then
            mon.setBackgroundColor(colors.green)
           elseif n==math.ceil(blueLeng) then
            if n-blueLeng<.3333 then
             mon.setBackgroundColor(setColors.progress3)
            elseif n-blueLeng<.6666 then
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
    
    mon.setCursorPos(w,1)
    mon.setBackgroundColor(setColors.prefBack)
    mon.setTextColor(setColors.prefText)
    mon.write("p")
    
    
    --wait for event
    local eve,id,cx,cy
    repeat
     eve,id,cx,cy=os.pullEvent()
    until eve=="timer" or eve=="monitor_touch"
    
    
    --test event
    if eve=="timer" then --the timer ended
     if id==timer then
      skip()
     elseif id==tickTimer then
      tickTimer=os.startTimer(0.25)
      elapsed=elapsed+0.25
     end
     
    else --the monitor was pressed
     if cy>1 then --a track was pressed
      if cy>2 and cy<#disks+3 then
       if tooManyDisks then
        skipto(cy-2+displayStart)
       else
        skipto(cy-2)
       end
      end
     elseif cx<=2 then --back was pressed
      back()
     elseif cx==4 then --stop/play was pressed
      if playing then
       stop()
      else
       play()
      end
     elseif cx==6 or cx==7 then --skip was pressed
      skip()
     elseif cx>=9 and (not miniMode and cx<=15 or miniMode and cx<=10) then --shuffle was pressed
      shuffle = not shuffle
     elseif (not miniMode and cx>=17 and cx<=20) or (miniMode and cx==12) then --loop was pressed
      loop = not loop 
     elseif tooManyDisks and cx==w-4 and displayStart>0 then --up was pressed
      displayStart = displayStart - 1
     elseif tooManyDisks and cx==w-2 and displayStart<#disks-(h-2) then --down was pressed
      displayStart = displayStart + 1
     elseif cx==w then --preferences button was pressed
      stop()
      if changePref() then
       return
      end
     end
    end
    
   until false