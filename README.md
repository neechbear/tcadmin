# tcadmin
TrinityCore Administrative Command Line Tool

This script requires that you have the worldserver SOAP RPC API enabled, and that you have the `curl` and `xml2` commands available. There is an optional dependency upon the `mysql` client.

## TODO

 * Make command help only display help for commands that you have permissions to execute.
 * Attempt to pull command help from SOAP RPC API before trying MySQL query, before falling back to hard-coded internal list.
 * Make sub-command help display if you enter incorrect syntax or invalid arguments.
 * Write bash autocompletion so that you can build a full command line with tab completion that looks up commands, subcommands, players, items, spells etc for you.
 * Try and remove `xml2` and `sed` dependency.
 * Document use of the script as a library (which is already possible simply by sourcing the script from another bash script and calling the appropriate functions yourself).
 * Document some interesting examples of use from your crontab.
 * Remove ^M characters from database output.

## Example Usage

```
nicolaw@qp:~$ tcadmin --version
tcadmin v1.0
nicolaw@qp:~$
```

```
nicolaw@qp:~$ tcadmin lookup item Shadowmourn
50815 - Shadowmourne Monster Offhand
49623 - Shadowmourne
nicolaw@qp:~$
```

```
nicolaw@qp:~$ tcadmin my_silly_invalid_command
/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:executeCommandResponse/result=There is no such command
nicolaw@qp:~$
```

```
nicolaw@qp:~$ tcadmin lookup item love | grep -vi glove
50250 - Big Love Rocket
49943 - Lovely Silvermoon City Card
49941 - Lovely Thunder Bluff Card
49937 - Lovely Undercity Card
49939 - Lovely Orgrimmar Card
49942 - Lovely Exodar Card
49938 - Lovely Darnassus Card
51804 - Winking Eye of Love
50320 - Faded Lovely Greeting Card
49940 - Lovely Ironforge Card
49936 - Lovely Stormwind Card
49927 - Love Token
49916 - Lovely Charm Bracelet
50196 - Love's Prisoner
37467 - A Steamy Romance Novel: Forbidden Love
37169 - War Mace of Unrequited Love
36901 - Goldclover
34258 - Love Rocket
22280 - Lovely Purple Dress
22279 - Lovely Black Dress
22278 - Lovely Blue Dress
22276 - Lovely Red Dress
22261 - Love Fool
21815 - Love Token
21032 - Meridith's Love Letter
14679 - Of Love and Family
51943 - Halion, Staff of Forgotten Love
51799 - Halion, Staff of Forgotten Love
50163 - Lovely Rose
50160 - Lovely Dress Box
49715 - Forever-Lovely Rose
49661 - Lovely Charm Collector's Kit
49655 - Lovely Charm
49641 - Faded Lovely Greeting Card
7128 - Uncloven Satyr Hoof
45468 - Leggings of Lost Love
5869 - Cloven Hoof
42438 - Lovely Cake
42434 - Lovely Cake Slice
1208 - Maybell's Love Letter
nicolaw@qp:~$ tcadmin send
Incorrect syntax.
The command  uses the following subcommands:
    items
    mail
    message
    money
nicolaw@qp:~$ tcadmin send items Frith "Love You" "Love the Frith millions. XXXXX" 21815:5 50163:1 42438:3 22280:1
Syntax: .send items #playername "#subject" "#text" itemid1[:count1] itemid2[:count2] ... itemidN[:countN]

Send a mail to a player. Subject and mail text must be in "". If for itemid not provided related count values then expected 1, if count > max items in stack then items will be send in required amount stacks. All stacks amount in mail limited to 12.
nicolaw@qp:~$ tcadmin send items Frith '"Love You"' '"Love the Frith millions. XXXXX"' 21815:5 50163:1 42438:3 22280:1
Mail sent to Frith
nicolaw@qp:~$
```

See also: https://nicolaw.uk/tcadmin.

```
tcadmin - Trinity Core World Server Administration Tool

Usage: tcadmin [db_args] [soap_args] <--help|--version|command> [options]

DB Arguments:
  Optional arguments to specify Trinity Core database paramaters. These are
  used to query the world database to provide better command line help and
  validation.

  --dbhost=<host>     Specify database hostname or IP.  Defaults to
                      'localhost' or $TCDBHOST environment variable.
                    
  --dbport=<port>     Specify database TCP port number.  Defaults to
                      '3306' or $TCDBPORT environment variable.
                    
  --dbuser=<user>     Specify database username.  Defaults to
                      'tcadmin' or $TCDBUSER environment variable.

  --dbpass=<pass>     Specify database password.  Defaults to
                      'tcadmin' or $TCDBPASS environment variable.

  --dbname=<name>     Specify world database name.  Defaults to
                      'world' or $TCDBNAME environment variable.

  See "Configuring Database Credentials" below for instructions on how to
  configure read-only database access.

SOAP Arguments:
  Optional arguments to specify Trinity Core worlserver SOAP RPC API interface
  connection information.

  --soaphost=<host>   Specify SOAP RPC API hostname or IP.  Defaults to
                      'localhost' or $TCSOAPHOST environment variable.
                    
  --soapport=<port>   Specify SOAP RPC API TCP port number.  Defaults to
                      '7878' or $TCSOAPPORT environment variable.
                    
  --soapuser=<user>   Specify SOAP RPC API username.  Defaults to
                      'tcadmin' or $TCSOAPUSER environment variable.

  --soappass=<pass>   Specify SOAP RPC API password.  Defaults to
                      'tcadmin' or $TCSOAPPASS environment variable.

  This command communicates with the Trinity Core worldserver process via the
  SOAP RPC API. Ensure SOAP.Enabled, SOAP.IP and SOAP.Port are configured
  correctly in your worldserver configuration file, and that these values are
  reflected in these SOAP arguments if they differ from the indicated default.

  See "Configuring SOAP RPC API Credentials" below for instuctions on how to
  configure access.

Commands:
  rbac
    Syntax: bf $subcommand
    Type .rbac to see a list of possible subcommands
    or .help bf $subcommand to see info on the subcommand.

  rbac account
    Syntax: rbac account $subcommand
    Type .rbac account to see a list of possible subcommands
    or .help rbac account $subcommand to see info on the subcommand.

  rbac account list
    Syntax: rbac account list [$account]
    View permissions of selected player or given account
    Note: Only those that affect current realm

  rbac account grant
    Syntax: rbac account grant [$account] #id [#realmId]
    Grant a permission to selected player or given account.
    #reamID may be -1 for all realms.

  rbac account deny
    Syntax: rbac account deny [$account] #id [#realmId]
    Deny a permission to selected player or given account.
    #reamID may be -1 for all realms.

  rbac account revoke
    Syntax: rbac account revoke [$account] #id
    Remove a permission from an account
    Note: Removes the permission from granted or denied permissions

  rbac list
    Syntax: rbac list [$id]
    View list of all permissions. If $id is given will show only info for that permission.

  account
    Syntax: .account
    Display the access level of your account and the email adress if you possess the necessary permissions.

  account addon
    Syntax: .account addon #addon
    Set expansion addon level allowed. Addon values: 0 - normal, 1 - tbc, 2 - wotlk.

  account create
    Syntax: .account create $account $password
    Create account and set password to it.

  account delete
    Syntax: .account delete $account
    Delete account with all characters.

  account lock
    Syntax: .account lock [on|off]
    Allow login from account only from current used IP or remove this requirement.

  account lock country
    Syntax: .account lock country [on|off]
    Allow login from account only from current used Country or remove this requirement.

  account lock ip
    Syntax: .account lock ip [on|off]
    Allow login from account only from current used IP or remove this requirement.

  account onlinelist
    Syntax: .account onlinelist
    Show list of online accounts.

  account password
    Syntax: .account password $old_password $new_password $new_password [$email]
    Change your account password. You may need to check the actual security mode to see if email input is necessary.

  account set
    Syntax: .account set $subcommand
    Type .account set to see the list of possible subcommands or .help account set $subcommand to see info on subcommands

  account set addon
    Syntax: .account set addon [$account] #addon
    Set user (possible targeted) expansion addon level allowed. Addon values: 0 - normal, 1 - tbc, 2 - wotlk.

  account set gmlevel
    Syntax: .account set gmlevel [$account] #level [#realmid]
    Set the security level for targeted player (can't be used at self) or for account $name to a level of #level on the realm #realmID.
    #level may range from 0 to 3.
    #reamID may be -1 for all realms.

  account set password
    Syntax: .account set password $account $password $password
    Set password for account.

  achievement
    Syntax: .achievement $subcommand
    Type .achievement to see the list of possible subcommands or .help achievement $subcommand to see info on subcommands

  achievement add
    Syntax: .achievement add $achievement
    Add an achievement to the targeted player.
    $achievement: can be either achievement id or achievement link

  arena
    Syntax: arena $subcommand
    Type .arena to see a list of possible subcommands
    or .help arena $subcommand to see info on the subcommand.

  arena captain
    Syntax: .arena captain #TeamID $name
    A command to set new captain to the team $name must be in the team

  arena create
    Syntax: .arena create $name "arena name" #type
    A command to create a new Arena-team in game. #type  = [2/3/5]

  arena disband
    Syntax: .arena disband #TeamID
    A command to disband Arena-team in game.

  arena info
    Syntax: .arena info #TeamID
    A command that show info about arena team

  arena lookup
    Syntax: .arena lookup $name
    A command that give a list of arenateam with the given $name

  arena rename
    Syntax: .arena rename "oldname" "newname"
    A command to rename Arena-team name.

  ban
    Syntax: .ban $subcommand
    Type .ban to see the list of possible subcommands or .help ban $subcommand to see info on subcommands

  ban account
    Syntax: .ban account $Name $bantime $reason
    Ban account kick player.
    $bantime: negative value leads to permban, otherwise use a timestring like "4d20h3s".

  ban character
    Syntax: .ban character $Name $bantime $reason
    Ban character and kick player.
    $bantime: negative value leads to permban, otherwise use a timestring like "4d20h3s".

  ban ip
    Syntax: .ban ip $Ip $bantime $reason
    Ban IP.
    $bantime: negative value leads to permban, otherwise use a timestring like "4d20h3s".

  ban playeraccount
    Syntax: .ban playeraccount $Name $bantime $reason
    Ban account and kick player.
    $bantime: negative value leads to permban, otherwise use a timestring like "4d20h3s".

  baninfo
    Syntax: .baninfo $subcommand
    Type .baninfo to see the list of possible subcommands or .help baninfo $subcommand to see info on subcommands

  baninfo account
    Syntax: .baninfo account $accountid
    Watch full information about a specific ban.

  baninfo character
    Syntax: .baninfo character $charactername 
    Watch full information about a specific ban.

  baninfo ip
    Syntax: .baninfo ip $ip
    Watch full information about a specific ban.

  banlist
    Syntax: .banlist $subcommand
    Type .banlist to see the list of possible subcommands or .help banlist $subcommand to see info on subcommands

  banlist account
    Syntax: .banlist account [$Name]
    Searches the banlist for a account name pattern or show full list account bans.

  banlist character
    Syntax: .banlist character $Name
    Searches the banlist for a character name pattern. Pattern required.

  banlist ip
    Syntax: .banlist ip [$Ip]
    Searches the banlist for a IP pattern or show full list of IP bans.

  unban
    Syntax: .unban $subcommand
    Type .unban to see the list of possible subcommands or .help unban $subcommand to see info on subcommands

  unban account
    Syntax: .unban account $Name
    Unban accounts for account name pattern.

  unban character
    Syntax: .unban character $Name
    Unban accounts for character name pattern.

  unban ip
    Syntax : .unban ip $Ip
    Unban accounts for IP pattern.

  unban playeraccount
    Syntax:

  bf
    Syntax: bf $subcommand
    Type .bf to see a list of possible subcommands
    or .help bf $subcommand to see info on the subcommand.

  bf start
    Syntax: .bf start #battleid

  bf stop
    Syntax: .bf stop #battleid

  bf switch
    Syntax: .bf switch #battleid

  bf timer
    Syntax: .bf timer #battleid #timer

  bf enable
    Syntax: .bf enable #battleid

  account email
    Syntax: .account email $oldemail $currentpassword $newemail $newemailconfirmation
    Change your account email. You may need to check the actual security mode to see if email input is necessary for password change

  account set sec
    Syntax:

  account set sec email
    Syntax: .account set sec email $accountname $email $emailconfirmation
    Set the email for entered player account.

  account set sec regmail
    Syntax: .account set sec regmail $account $regmail $regmailconfirmation
    Sets the regmail for entered player account.

  cast
    Syntax: .cast #spellid [triggered]
    Cast #spellid to selected target. If no target selected cast to self. If 'trigered' or part provided then spell casted with triggered flag.

  cast back
    Syntax: .cast back #spellid [triggered]
    Selected target will cast #spellid to your character. If 'trigered' or part provided then spell casted with triggered flag.

  cast dist
    Syntax: .cast dist #spellid [#dist [triggered]]
    You will cast spell to pint at distance #dist. If 'trigered' or part provided then spell casted with triggered flag. Not all spells can be casted as area spells.

  cast self
    Syntax: .cast self #spellid [triggered]
    Cast #spellid by target at target itself. If 'trigered' or part provided then spell casted with triggered flag.

  cast target
    Syntax: .cast target #spellid [triggered]
    Selected target will cast #spellid to his victim. If 'trigered' or part provided then spell casted with triggered flag.

  cast dest
    Syntax: .cast dest #spellid #x #y #z [triggered]
    Selected target will cast #spellid at provided destination. If 'trigered' or part provided then spell casted with triggered flag.

  character
    Syntax: character $subcommand
    Type .character to see a list of possible subcommands
    or .help character $subcommand to see info on the subcommand.

  character customize
    Syntax: .character customize [$name]
    Mark selected in game or by $name in command character for customize at next login.

  character changefaction
    Syntax: .character changefaction $name
    Change character faction.

  character changerace
    Syntax: .character changerace $name
    Change character race.

  character deleted
    Syntax: character deleted $subcommand
    Type .character deleted to see a list of possible subcommands
    or .help character deleted $subcommand to see info on the subcommand.

  character deleted delete
    Syntax: .character deleted delete #guid|$name
    Completely deletes the selected characters.
    If $name is supplied, only characters with that string in their name will be deleted, if #guid is supplied, only the character with that GUID will be deleted.

  character deleted list
    Syntax: .character deleted list [#guid|$name]
    Shows a list with all deleted characters.
    If $name is supplied, only characters with that string in their name will be selected, if #guid is supplied, only the character with that GUID will be selected.

  character deleted restore
    Syntax: .character deleted restore #guid|$name [$newname] [#new account]
    Restores deleted characters.
    If $name is supplied, only characters with that string in their name will be restored, if $guid is supplied, only the character with that GUID will be restored.
    If $newname is set, the character will be restored with that name instead of the original one. If #newaccount is set, the character will be restored to specific account character list. This works only with one character!

  character deleted old
    Syntax: .character deleted old [#keepDays]
    Completely deletes all characters with deleted time longer #keepDays. If #keepDays not provided the  used value from mangosd.conf option 'CharDelete.KeepDays'. If referenced config option disabled (use 0 value) then command can't be used without #keepDays.

  character erase
    Syntax: .character erase $name
    Delete character $name. Character finally deleted in case any deleting options.

  character level
    Syntax: .character level [$playername] [#level]
    Set the level of character with $playername (or the selected if not name provided) by #numberoflevels Or +1 if no #numberoflevels provided). If #numberoflevels is omitted, the level will be increase by 1. If #numberoflevels is 0, the same level will be restarted. If no character is selected and name not provided, increase your level. Command can be used for offline character. All stats and dependent values recalculated. At level decrease talents can be reset if need. Also at level decrease equipped items with greater level requirement can be lost.

  character rename
    Syntax: .character rename [$name] [$newName]
    Mark selected in game or by $name in command character for rename at next login.
    If $newName then the player will be forced rename.

  character reputation
    Syntax: .character reputation [$player_name]
    Show reputation information for selected player or player find by $player_name.

  character titles
    Syntax: .character titles [$player_name]
    Show known titles list for selected player or player find by $player_name.

  levelup
    Syntax: .levelup [$playername] [#numberoflevels]
    Increase/decrease the level of character with $playername (or the selected if not name provided) by #numberoflevels Or +1 if no #numberoflevels provided). If #numberoflevels is omitted, the level will be increase by 1. If #numberoflevels is 0, the same level will be restarted. If no character is selected and name not provided, increase your level. Command can be used for offline character. All stats and dependent values recalculated. At level decrease talents can be reset if need. Also at level decrease equipped items with greater level requirement can be lost.

  pdump
    Syntax: .pdump $subcommand
    Type .pdump to see the list of possible subcommands or .help pdump $subcommand to see info on subcommands

  pdump load
    Syntax: .pdump load $filename $account [$newname] [$newguid]
    Load character dump from dump file into character list of $account with saved or $newname, with saved (or first free) or $newguid guid.

  pdump write
    Syntax: .pdump write $filename $playerNameOrGUID
    Write character dump with name/guid $playerNameOrGUID to file $filename.

  cheat
    Syntax: .cheat $subcommand
    Type .cheat to see the list of possible subcommands or .help cheat $subcommand to see info on subcommands

  cheat casttime
    Syntax: .cheat casttime [on/off]
    Enables or disables your character's spell cast times.

  cheat cooldown
    Syntax: .cheat cooldown [on/off]
    Enables or disables your character's spell cooldowns.

  cheat explore
    Syntax: .cheat explore #flag
    Reveal or hide all maps for the selected player. If no player is selected, hide or reveal maps to you.
    Use a #flag of value 1 to reveal, use a #flag value of 0 to hide all maps.

  cheat god
    Syntax: .cheat god [on/off]
    Enables or disables your character's ability to take damage.

  cheat power
    Syntax: .cheat power [on/off]
    Enables or disables your character's spell cost (e.g mana).

  cheat status
    Syntax: .cheat status
    Shows the cheats you currently have enabled.

  cheat taxi
    Syntax: .cheat taxi on/off
    Temporary grant access or remove to all taxi routes for the selected character.
    If no character is selected, hide or reveal all routes to you.Visited taxi nodes sill accessible after removing access.

  cheat waterwalk
    Syntax: .cheat waterwalk on/off
    Set on/off waterwalk state for selected player or self if no player selected.

  debug
    Syntax: .debug $subcommand
    Type .debug to see the list of possible subcommands or .help debug $subcommand to see info on subcommands

  debug anim
    Syntax:

  debug areatriggers
    Syntax: .debug areatriggers
    Toggle debug mode for areatriggers. In debug mode GM will be notified if reaching an areatrigger

  debug arena
    Syntax: .debug arena
    Toggle debug mode for arenas. In debug mode GM can start arena with single player.

  debug bg
    Syntax: .debug bg
    Toggle debug mode for battlegrounds. In debug mode GM can start battleground with single player.

  debug entervehicle
    Syntax:

  debug getitemstate
    Syntax:

  debug getitemvalue
    Syntax:

  debug getvalue
    Syntax:

  debug hostil
    Syntax:

  debug itemexpire
    Syntax:

  debug lootrecipient
    Syntax:

  debug los
    Syntax:

  debug Mod32Value
    Syntax: .debug Mod32Value #field #value
    Add #value to field #field of your character.

  debug moveflags
    Syntax: .debug moveflags [$newMoveFlags [$newMoveFlags2]]
    No params given will output the current moveflags of the target

  debug play
    Syntax:

  debug play cinematic
    Syntax: .debug play cinematic #cinematicid
    Play cinematic #cinematicid for you. You stay at place while your mind fly.

  debug play movie
    Syntax: .debug play movie #movieid
    Play movie #movieid for you.

  debug play sound
    Syntax: .debug play sound #soundid
    Play sound with #soundid.
    Sound will be play only for you. Other players do not hear this.
    Warning: client may have more 5000 sounds...

  debug send
    Syntax:

  debug send buyerror
    Syntax:

  debug send channelnotify
    Syntax:

  debug send chatmessage
    Syntax:

  debug send equiperror
    Syntax:

  debug send largepacket
    Syntax:

  debug send opcode
    Syntax:

  debug send qinvalidmsg
    Syntax:

  debug send qpartymsg
    Syntax:

  debug send sellerror
    Syntax:

  debug send setphaseshift
    Syntax:

  debug send spellfail
    Syntax:

  debug setaurastate
    Syntax:

  debug setbit
    Syntax:

  debug setitemvalue
    Syntax:

  debug setvalue
    Syntax:

  debug setvid
    Syntax:

  debug spawnvehicle
    Syntax:

  debug threat
    Syntax:

  debug update
    Syntax:

  debug uws
    Syntax:

  wpgps
    Syntax: .wpgps
    Output current position to sql developer log as partial SQL query to be used in pathing

  deserter
    Syntax: deserter $subcommand
    Type .deserter to see a list of possible subcommands
    or .help deserter $subcommand to see info on the subcommand.

  deserter bg
    Syntax:

  deserter bg add
    Syntax: .deserter bg add $time
    Adds the bg deserter debuff to your target with $time duration.

  deserter bg remove
    Syntax: .deserter bg remove
    Removes the bg deserter debuff from your target.

  deserter instance
    Syntax:

  deserter instance add
    Syntax: .deserter instance add $time
    Adds the instance deserter debuff to your target with $time duration.

  deserter instance remove
    Syntax: .deserter instance remove
    Removes the instance deserter debuff from your target.

  disable
    Syntax: disable $subcommand
    Type .disable to see a list of possible subcommands
    or .help disable $subcommand to see info on the subcommand.

  disable add
    Syntax:

  disable add achievement_criteria
    Syntax: .disable add achievement_criteria $entry $flag $comment

  disable add battleground
    Syntax: .disable add battleground $entry $flag $comment

  disable add map
    Syntax: .disable add map $entry $flag $comment

  disable add mmap
    Syntax: .disable add mmap $entry $flag $comment

  disable add outdoorpvp
    Syntax: .disable add outdoorpvp $entry $flag $comment

  disable add quest
    Syntax: .disable add quest $entry $flag $comment

  disable add spell
    Syntax: .disable add spell $entry $flag $comment

  disable add vmap
    Syntax: .disable add vmap $entry $flag $comment

  disable remove
    Syntax:

  disable remove achievement_criteria
    Syntax: .disable remove achievement_criteria $entry

  disable remove battleground
    Syntax: .disable remove battleground $entry

  disable remove map
    Syntax: .disable remove map $entry

  disable remove mmap
    Syntax: .disable remove mmap $entry

  disable remove outdoorpvp
    Syntax: .disable remove outdoorpvp $entry

  disable remove quest
    Syntax: .disable remove quest $entry

  disable remove spell
    Syntax: .disable remove spell $entry

  disable remove vmap
    Syntax: .disable remove vmap $entry

  event info
    Syntax: .event info #event_id
    Show details about event with #event_id.

  event activelist
    Syntax: .event activelist
    Show list of currently active events.

  event start
    Syntax: .event start #event_id
    Start event #event_id. Set start time for event to current moment (change not saved in DB).

  event stop
    Syntax: .event stop #event_id
    Stop event #event_id. Set start time for event to time in past that make current moment is event stop time (change not saved in DB).

  gm
    Syntax: .gm [on/off]
    Enable or Disable in game GM MODE or show current state of on/off not provided.

  gm chat
    Syntax: .gm chat [on/off]
    Enable or disable chat GM MODE (show gm badge in messages) or show current state of on/off not provided.

  gm fly
    Syntax: .gm fly [on/off]
    Enable/disable gm fly mode.

  gm ingame
    Syntax: .gm ingame
    Display a list of available in game Game Masters.

  gm list
    Syntax: .gm list
    Display a list of all Game Masters accounts and security levels.

  gm visible
    Syntax: .gm visible on/off
    Output current visibility state or make GM visible(on) and invisible(off) for other players.

  go creature
    Syntax: .go creature #creature_guid
    Teleport your character to creature with guid #creature_guid.
    .gocreature #creature_name
    Teleport your character to creature with this name.
    .gocreature id #creature_id
    Teleport your character to a creature that was spawned from the template with this entry.
    *If* more than one creature is found, then you are teleported to the first that is found inside the database.

  go graveyard
    Syntax: .go graveyard #graveyardId
    Teleport to graveyard with the graveyardId specified.

  go grid
    Syntax: .go grid #gridX #gridY [#mapId]
    Teleport the gm to center of grid with provided indexes at map #mapId (or current map if it not provided).

  go object
    Syntax: .go object #object_guid
    Teleport your character to gameobject with guid #object_guid

  go taxinode
    Syntax: .go taxinode #taxinode
    Teleport player to taxinode coordinates. You can look up zone using .lookup taxinode $namepart

  go ticket
    Syntax: .go ticket #ticketid
    Teleports the user to the location where $ticketid was created.

  go trigger
    Syntax: .go trigger #trigger_id
    Teleport your character to areatrigger with id #trigger_id. Character will be teleported to trigger target if selected areatrigger is telporting trigger.

  go xyz
    Syntax: .go xyz #x #y [#z [#mapid [#orientation]]]
    Teleport player to point with (#x,#y,#z) coordinates at map #mapid with orientation #orientation. If z is not provided, ground/water level will be used. If mapid is not provided, the current map will be used. If #orientation is not provided, the current orientation will be used.

  go zonexy
    Syntax: .go zonexy #x #y [#zone]
    Teleport player to point with (#x,#y) client coordinates at ground(water) level in zone #zoneid or current zone if #zoneid not provided. You can look up zone using .lookup area $namepart

  gobject
    Syntax: .gobject $subcommand
    Type .gobject to see the list of possible subcommands or .help gobject $subcommand to see info on subcommands

  gobject activate
    Syntax: .gobject activate #guid
    Activates an object like a door or a button.

  gobject add
    Syntax: .gobject add #id <spawntimeSecs>
    Add a game object from game object templates to the world at your current location using the #id.
    spawntimesecs sets the spawntime, it is optional.
    Note: this is a copy of .gameobject.

  gobject add temp
    Adds a temporary gameobject that is not saved to DB.

  gobject delete
    Syntax: .gobject delete #go_guid
    Delete gameobject with guid #go_guid.

  gobject info
    Syntax: .gobject info [$entry|$link | guid [$guid|$link]  Query Gameobject information for given gameobject entry, guid or link.For example .gobject info 36or .gobject info guid 100

  gobject move
    Syntax: .gobject move #goguid [#x #y #z]
    Move gameobject #goguid to character coordinates (or to (#x,#y,#z) coordinates if its provide).

  gobject near
    Syntax: .gobject near  [#distance]
    Output gameobjects at distance #distance from player. Output gameobject guids and coordinates sorted by distance from character. If #distance not provided use 10 as default value.

  gobject set
    Syntax:

  gobject set phase
    Syntax: .gobject set phase #guid #phasemask
    Gameobject with DB guid #guid phasemask changed to #phasemask with related world vision update for players. Gameobject state saved to DB and persistent.

  gobject set state
    Syntax:

  gobject target
    Syntax: .gobject target [#go_id|#go_name_part]
    Locate and show position nearest gameobject. If #go_id or #go_name_part provide then locate and show position of nearest gameobject with gameobject template id #go_id or name included #go_name_part as part.

  gobject turn
    Syntax: .gobject turn [guid|link] [oz [oy [ox]]]
    Set the orientation of the gameobject to player's orientation or the given orientation.

  debug transport
    Syntax: .debug transport [start/stop]
    Allows to stop a transport at its nearest wait point and start movement of a stopped one. Not all transports can be started or stopped.

  guild
    Syntax: .guild $subcommand
    Type .guild to see the list of possible subcommands or .help guild $subcommand to see info on subcommands

  guild create
    Syntax: .guild create [$GuildLeaderName] "$GuildName"
    Create a guild named $GuildName with the player $GuildLeaderName (or selected) as leader.  Guild name must in quotes.

  guild delete
    Syntax: .guild delete "$GuildName"
    Delete guild $GuildName. Guild name must in quotes.

  guild invite
    Syntax: .guild invite [$CharacterName] "$GuildName"
    Add player $CharacterName (or selected) into a guild $GuildName. Guild name must in quotes.

  guild uninvite
    Syntax: .guild uninvite [$CharacterName]
    Remove player $CharacterName (or selected) from a guild.

  guild rank
    Syntax: .guild rank [$CharacterName] #Rank
    Set for player $CharacterName (or selected) rank #Rank in a guild.

  guild rename
    Syntax: .guild rename "$GuildName" "$NewGuildName"
    Rename a guild named $GuildName with $NewGuildName. Guild name and new guild name must in quotes.

  honor
    Syntax: .honor $subcommand
    Type .honor to see the list of possible subcommands or .help honor $subcommand to see info on subcommands

  honor add
    Syntax: .honor add $amount
    Add a certain amount of honor (gained today) to the selected player.

  honor add kill
    Syntax: .honor add kill
    Add the targeted unit as one of your pvp kills today (you only get honor if it's a racial leader or a player)

  honor update
    Syntax: .honor update
    Force the yesterday's honor fields to be updated with today's data, which will get reset for the selected player.

  instance
    Syntax: .instance $subcommand
    Type .instance to see the list of possible subcommands or .help instance $subcommand to see info on subcommands

  instance listbinds
    Syntax: .instance listbinds
    Lists the binds of the selected player.

  debug raidreset
    Syntax: .debug raidreset mapid [difficulty]
    Forces a global reset of the specified map on all difficulties (or only the specific difficulty if specified). Effectively the same as setting the specified map's reset timer to now.

  instance unbind
    Syntax: .instance unbind <mapid|all> [difficulty]
    Clear all/some of player's binds

  instance stats
    Syntax: .instance stats
    Shows statistics about instances.

  instance savedata
    Syntax: .instance savedata
    Save the InstanceData for the current player's map to the DB.

  learn
    Syntax: .learn #spell [all]
    Selected character learn a spell of id #spell. If 'all' provided then all ranks learned.

  learn all
    Syntax:

  learn all my
    Syntax:

  learn all my class
    Syntax: .learn all my class
    Learn all spells and talents available for his class.

  learn all my pettalents
    Syntax: .learn all my pettalents
    Learn all talents for your pet available for his creature type (only for hunter pets).

  learn all my spells
    Syntax: .learn all my spells
    Learn all spells (except talents and spells with first rank learned as talent) available for his class.

  learn all my talents
    Syntax: .learn all my talents
    Learn all talents (and spells with first rank learned as talent) available for his class.

  learn all gm
    Syntax: .learn all gm
    Learn all default spells for Game Masters.

  learn all crafts
    Syntax: .learn crafts
    Learn all professions and recipes.

  learn all default
    Syntax: .learn all default [$playername]
    Learn for selected/$playername player all default spells for his race/class and spells rewarded by completed quests.

  learn all lang
    Syntax: .learn all lang
    Learn all languages

  learn all recipes
    Syntax: .learn all recipes [$profession]Learns all recipes of specified profession and sets skill level to max.Example: .learn all recipes enchanting

  unlearn
    Syntax: .unlearn #spell [all]
    Unlearn for selected player a spell #spell.  If 'all' provided then all ranks unlearned.

  lfg
    Syntax: lfg $subcommand
    Type .lfg to see a list of possible subcommands
    or .help lfg $subcommand to see info on the subcommand.

  lfg player
    Syntax: .lfg player
    Shows information about player (state, roles, comment, dungeons selected).

  lfg group
    Syntax: .lfg group
    Shows information about all players in the group  (state, roles, comment, dungeons selected).

  lfg queue
    Syntax: .lfg queue
    Shows info about current lfg queues.

  lfg clean
    Syntax: .flg clean
    Cleans current queue, only for debugging purposes.

  lfg options
    Syntax: .lfg options [new value]
    Shows current lfg options. New value is set if extra param is present.

  list
    Syntax: .list $subcommand
    Type .list to see the list of possible subcommands or .help list $subcommand to see info on subcommands

  list creature
    Syntax: .list creature #creature_id [#max_count]
    Output creatures with creature id #creature_id found in world. Output creature guids and coordinates sorted by distance from character. Will be output maximum #max_count creatures. If #max_count not provided use 10 as default value.

  list item
    Syntax: .list item #item_id [#max_count]
    Output items with item id #item_id found in all character inventories, mails, auctions, and guild banks. Output item guids, item owner guid, owner account and owner name (guild name and guid in case guild bank). Will be output maximum #max_count items. If #max_count not provided use 10 as default value.

  list object
    Syntax: .list object #gameobject_id [#max_count]
    Output gameobjects with gameobject id #gameobject_id found in world. Output gameobject guids and coordinates sorted by distance from character. Will be output maximum #max_count gameobject. If #max_count not provided use 10 as default value.

  list auras
    Syntax: .list auras
    List auras (passive and active) of selected creature or player. If no creature or player is selected, list your own auras.

  list mail
    Syntax: .list mail $character
    List of mails the character received.

  lookup
    Syntax: .lookup $subcommand
    Type .lookup to see the list of possible subcommands or .help lookup $subcommand to see info on subcommands

  lookup area
    Syntax: .lookup area $namepart
    Looks up an area by $namepart, and returns all matches with their area ID's.

  lookup creature
    Syntax: .lookup creature $namepart
    Looks up a creature by $namepart, and returns all matches with their creature ID's.

  lookup event
    Syntax: .lookup event $name
    Attempts to find the ID of the event with the provided $name.

  lookup faction
    Syntax: .lookup faction $name
    Attempts to find the ID of the faction with the provided $name.

  lookup item
    Syntax: .lookup item $itemname
    Looks up an item by $itemname, and returns all matches with their Item ID's.

  lookup itemset
    Syntax: .lookup itemset $itemname
    Looks up an item set by $itemname, and returns all matches with their Item set ID's.

  lookup object
    Syntax: .lookup object $objname
    Looks up an gameobject by $objname, and returns all matches with their Gameobject ID's.

  lookup quest
    Syntax: .lookup quest $namepart
    Looks up a quest by $namepart, and returns all matches with their quest ID's.

  lookup player
    Syntax:

  lookup player ip
    Syntax: .lookup player ip $ip ($limit) 
    Searchs players, which account ast_ip is $ip with optional parametr $limit of results.

  lookup player account
    Syntax: .lookup player account $account ($limit) 
    Searchs players, which account username is $account with optional parametr $limit of results.

  lookup player email
    Syntax: .lookup player email $email ($limit) 
    Searchs players, which account email is $email with optional parametr $limit of results.

  lookup skill
    Syntax: .lookup skill $$namepart
    Looks up a skill by $namepart, and returns all matches with their skill ID's.

  lookup spell
    Syntax: .lookup spell $namepart
    Looks up a spell by $namepart, and returns all matches with their spell ID's.

  lookup spell id
    Syntax: .lookup spell id #spellid
    Looks up a spell by #spellid, and returns the match with its spell name.

  lookup taxinode
    Syntax: .lookup taxinode $substring
    Search and output all taxinodes with provide $substring in name.

  lookup tele
    Syntax: .lookup tele $substring
    Search and output all .tele command locations with provide $substring in name.

  lookup title
    Syntax: .lookup title $$namepart
    Looks up a title by $namepart, and returns all matches with their title ID's and index's.

  lookup map
    Syntax: .lookup map $namepart
    Looks up a map by $namepart, and returns all matches with their map ID's.

  announce
    Syntax: .announce $MessageToBroadcast
    Send a global message to all players online in chat log.

  channel
    Syntax: channel $subcommand
    Type .channel to see a list of possible subcommands
    or .help channel $subcommand to see info on the subcommand.

  channel set
    Syntax:

  channel set ownership
    Syntax: .channel set ownership $channel [on/off]
    Grant ownership to the first person that joins the channel.

  gmannounce
    Syntax: .gmannounce $announcement
    Send an announcement to online Gamemasters.

  gmnameannounce
    Syntax: .gmnameannounce $announcement.
    Send an announcement to all online GM's, displaying the name of the sender.

  gmnotify
    Syntax: .gmnotify $notification
    Displays a notification on the screen of all online GM's.

  nameannounce
    Syntax: .nameannounce $announcement.
    Send an announcement to all online players, displaying the name of the sender.

  notify
    Syntax: .notify $MessageToBroadcast
    Send a global message to all players online in screen.

  whispers
    Syntax: .whispers on|off
    Enable/disable accepting whispers by GM from players. By default use trinityd.conf setting.

  group
    Syntax: .group $subcommand
    Type .group to see the list of possible subcommands or .help group $subcommand to see info on subcommands

  group leader
    Syntax: .group leader [$characterName]
    Sets the given character as his group's leader.

  group disband
    Syntax: .group disband [$characterName]
    Disbands the given character's group.

  group remove
    Syntax: .group remove [$characterName]
    Removes the given character from his group.

  group join
    Syntax: .group join $AnyCharacterNameFromGroup [$CharacterName] 
    Adds to group of player $AnyCharacterNameFromGroup player $CharacterName (or selected).

  group list
    Syntax: .group list [$CharacterName] 
    Lists all the members of the group/party the player is in.

  group summon
    Syntax: .group summon [$charactername]
    Teleport the given character and his group to you. Teleported only online characters but original selected group member can be offline.

  pet
    Syntax: .pet $subcommand
    Type .pet to see the list of possible subcommands or .help pet $subcommand to see info on subcommands

  pet create
    Syntax: .pet create
    Creates a pet of the selected creature.

  pet learn
    Syntax: .pet learn
    Learn #spellid to pet.

  pet unlearn
    Syntax: .pet unlean
    unLearn #spellid to pet.

  send
    Syntax: send $subcommand
    Type .send to see a list of possible subcommands
    or .help send $subcommand to see info on the subcommand.

  send items
    Syntax: .send items #playername "#subject" "#text" itemid1[:count1] itemid2[:count2] ... itemidN[:countN]
    Send a mail to a player. Subject and mail text must be in "". If for itemid not provided related count values then expected 1, if count > max items in stack then items will be send in required amount stacks. All stacks amount in mail limited to 12.

  send mail
    Syntax: .send mail #playername "#subject" "#text"
    Send a mail to a player. Subject and mail text must be in "".

  send message
    Syntax: .send message $playername $message
    Send screen message to player from ADMINISTRATOR.

  send money
    Syntax: .send money #playername "#subject" "#text" #money
    Send mail with money to a player. Subject and mail text must be in "".

  additem
    Syntax: .additem #itemid/[#itemname]/#shift-click-item-link #itemcount
    Adds the specified number of items of id #itemid (or exact (!) name $itemname in brackets, or link created by shift-click at item in inventory or recipe) to your or selected character inventory. If #itemcount is omitted, only one item will be added.

  additemset
    Syntax: .additemset #itemsetid
    Add items from itemset of id #itemsetid to your or selected character inventory. Will add by one example each item from itemset.

  appear
    Syntax: .appear [$charactername]
    Teleport to the given character. Either specify the character name or click on the character's portrait,e.g. when you are in a group. Character can be offline.

  aura
    Syntax: .aura #spellid
    Add the aura from spell #spellid to the selected Unit.

  bank
    Syntax: .bank
    Show your bank inventory.

  bindsight
    Syntax: .bindsight
    Binds vision to the selected unit indefinitely. Cannot be used while currently possessing a target.

  combatstop
    Syntax: .combatstop [$playername]
    Stop combat for selected character. If selected non-player then command applied to self. If $playername provided then attempt applied to online player $playername.

  cometome
    Syntax: .cometome
    Make selected creature come to your current location (new position not saved to DB).

  commands
    Syntax: .commands
    Display a list of available commands for your account level.

  cooldown
    Syntax: .cooldown [#spell_id]
    Remove all (if spell_id not provided) or #spel_id spell cooldown from selected character or their pet or you (if no selection).

  damage
    Syntax: .damage $damage_amount [$school [$spellid]]
    Apply $damage to target. If not $school and $spellid provided then this flat clean melee damage without any modifiers. If $school provided then damage modified by armor reduction (if school physical), and target absorbing modifiers and result applied as melee damage to target. If spell provided then damage modified and applied as spell damage. $spellid can be shift-link.

  dev
    Syntax: .dev [on/off]
    Enable or Disable in game Dev tag or show current state if on/off not provided.

  die
    Syntax: .die
    Kill the selected player. If no player is selected, it will kill you.

  dismount
    Syntax: .dismount
    Dismount you, if you are mounted.

  distance
    Syntax: .distance
    Display the distance from your character to the selected creature.

  flusharenapoints
    Syntax: .flusharenapoints
    Use it to distribute arena points based on arena team ratings, and start a new week.

  freeze
    Syntax: .freeze [#player] [#duration]
    Freezes #player for #duration (seconds)
    Freezes the selected player if no arguments are given.
    Default duration: GM.FreezeAuraDuration (worldserver.conf)

  gps
    Syntax: .gps [$name|$shift-link]
    Display the position information for a selected character or creature (also if player name $name provided then for named player, or if creature/gameobject shift-link provided then pointed creature/gameobject if it loaded). Position information includes X, Y, Z, and orientation, map Id and zone Id

  guid
    Syntax: .guid
    Display the GUID for the selected character.

  help
    Syntax: .help [$command]
    Display usage instructions for the given $command. If no $command provided show list available commands.

  hidearea
    Syntax: .hidearea #areaid
    Hide the area of #areaid to the selected character. If no character is selected, hide this area to you.

  itemmove
    Syntax: .itemmove #sourceslotid #destinationslotid
    Move an item from slots #sourceslotid to #destinationslotid in your inventory
    Not yet implemented

  kick
    Syntax: .kick [$charactername] [$reason]
    Kick the given character name from the world with or without reason. If no character name is provided then the selected player (except for yourself) will be kicked. If no reason is provided, default is "No Reason".

  linkgrave
    Syntax: .linkgrave #graveyard_id [alliance|horde]
    Link current zone to graveyard for any (or alliance/horde faction ghosts). This let character ghost from zone teleport to graveyard after die if graveyard is nearest from linked to zone and accept ghost of this faction. Add only single graveyard at another map and only if no graveyards linked (or planned linked at same map).

  listfreeze
    Syntax: .listfreeze
    Search and output all frozen players.

  maxskill
    Syntax: .maxskill
    Sets all skills of the targeted player to their maximum values for its current level.

  movegens
    Syntax: .movegens
    Show movement generators stack for selected creature or player.

  mute
    Syntax: .mute [$playerName] $timeInMinutes [$reason]
    Disible chat messaging for any character from account of character $playerName (or currently selected) at $timeInMinutes minutes. Player can be offline.

  neargrave
    Syntax: .neargrave [alliance|horde]
    Find nearest graveyard linked to zone (or only nearest from accepts alliance or horde faction ghosts).

  pinfo
    Syntax: .pinfo [$player_name/#GUID]
    Output account information and guild information for selected player or player find by $player_name or #GUID.

  playall
    Syntax: .playall #soundid
    Player a sound to whole server.

  possess
    Syntax: .possess
    Possesses indefinitely the selected creature.

  recall
    Syntax: .recall [$playername]
    Teleport $playername or selected player to the place where he has been before last use of a teleportation command. If no $playername is entered and no player is selected, it will teleport you.

  repairitems
    Syntax: .repairitems
    Repair all selected player's items.

  respawn
    Syntax: .respawn
    Respawn all nearest creatures and GO without waiting respawn time expiration.

  revive
    Syntax: .revive
    Revive the selected player. If no player is selected, it will revive you.

  saveall
    Syntax: .saveall
    Save all characters in game.

  save
    Syntax: .save
    Saves your character.

  setskill
    Syntax: .setskill #skill #level [#max]
    Set a skill of id #skill with a current skill value of #level and a maximum value of #max (or equal current maximum if not provide) for the selected character. If no character is selected, you learn the skill.

  showarea
    Syntax: .showarea #areaid
    Reveal the area of #areaid to the selected character. If no character is selected, reveal this area to you.

  summon
    Syntax: .summon [$charactername]
    Teleport the given character to you. Character can be offline.

  unaura
    Syntax: .unaura #spellid
    Remove aura due to spell #spellid from the selected Unit.

  unbindsight
    Syntax: .unbindsight
    Removes bound vision. Cannot be used while currently possessing a target.

  unfreeze
    Syntax: .unfreeze (#player)
    "Unfreezes" #player and enables his chat again. When using this without #name it will unfreeze your target.

  unmute
    Syntax: .unmute [$playerName]
    Restore chat messaging for any character from account of character $playerName (or selected). Character can be ofline.

  unpossess
    Syntax: .unpossess
    If you are possessed, unpossesses yourself; otherwise unpossesses current possessed target.

  unstuck
    Syntax: .unstuck $playername [inn/graveyard/startzone]
    Teleports specified player to specified location. Default location is player's current hearth location.

  wchange
    Syntax: .wchange #weathertype #status
    Set current weather to #weathertype with an intensity of #status.
    #weathertype can be 1 for rain, 2 for snow, and 3 for sand. #status can be 0 for disabled, and 1 for enabled.

  mmap
    Syntax: Syntax: .mmaps $subcommand Type .mmaps to see the list of possible subcommands or .help mmaps $subcommand to see info on subcommands

  mmap loadedtiles
    Syntax: .mmap loadedtiles to show which tiles are currently loaded

  mmap loc
    Syntax: .mmap loc to print on which tile one is

  mmap path
    Syntax: .mmap path to calculate and show a path to current select unit

  mmap stats
    Syntax: .mmap stats to show information about current state of mmaps

  mmap testarea
    Syntax: .mmap testarea to calculate paths for all nearby npcs to player

  morph
    Syntax: .morph #displayid
    Change your current model id to #displayid.

  demorph
    Syntax: .demorph
    Demorph the selected player.

  modify
    Syntax: .modify $subcommand
    Type .modify to see the list of possible subcommands or .help modify $subcommand to see info on subcommands

  modify arenapoints
    Syntax: .modify arenapoints #value
    Add $amount arena points to the selected player.

  modify bit
    Syntax: .modify bit #field #bit
    Toggle the #bit bit of the #field field for the selected player. If no player is selected, modify your character.

  modify drunk
    Syntax: .modify drunk #value
    Set drunk level to #value (0..100). Value 0 remove drunk state, 100 is max drunked state.

  modify energy
    Syntax: .modify energy #energy
    Modify the energy of the selected player. If no player is selected, modify your energy.

  modify faction
    Syntax: .modify faction #factionid #flagid #npcflagid #dynamicflagid
    Modify the faction and flags of the selected creature. Without arguments, display the faction and flags of the selected creature.

  modify gender
    Syntax: .modify gender male/female
    Change gender of selected player.

  modify honor
    Syntax: .modify honor $amount
    Add $amount honor points to the selected player.

  modify hp
    Syntax: .modify hp #newhp
    Modify the hp of the selected player. If no player is selected, modify your hp.

  modify mana
    Syntax: .modify mana #newmana
    Modify the mana of the selected player. If no player is selected, modify your mana.

  modify money
    Syntax: .modify money #money
    .money #money
    Add or remove money to the selected player. If no player is selected, modify your money.
    #gold can be negative to remove money.

  modify mount
    Syntax: .modify mount #id #speed
    Display selected player as mounted at #id creature and set speed to #speed value.

  modify phase
    Syntax: .modify phase #phasemask
    Selected character phasemask changed to #phasemask with related world vision update. Change active until in game phase changed, or GM-mode enable/disable, or re-login. Character pts pasemask update to same value.

  modify rage
    Syntax: .modify rage #newrage
    Modify the rage of the selected player. If no player is selected, modify your rage.

  modify reputation
    Syntax: .modify reputation #repId (#repvalue | $rankname [#delta])
    Sets the selected players reputation with faction #repId to #repvalue or to $reprank.
    If the reputation rank name is provided, the resulting reputation will be the lowest reputation for that rank plus the delta amount, if specified.
    You can use '.pinfo rep' to list all known reputation ids, or use '.lookup faction $name' to locate a specific faction id.

  modify runicpower
    Syntax: .modify runicpower #newrunicpower
    Modify the runic power of the selected player. If no player is selected, modify your runic power.

  modify scale
    .modify scale #scale
    Modify size of the selected player or creature to "normal scale"*rate. If no player or creature is selected, modify your size.
    #rate may range from 0.1 to 10.

  modify speed
    Syntax: .modify speed $speedtype #rate
    Modify the running speed of the selected player to "normal base run speed"= 1. If no player is selected, modify your speed.
    $speedtypes may be fly, all, walk, backwalk, or swim.
    #rate may range from 0.1 to 50.

  modify speed all
    Syntax: .modify aspeed #rate
    Modify all speeds -run,swim,run back,swim back- of the selected player to "normalbase speed for this move type"*rate. If no player is selected, modify your speed.
    #rate may range from 0.1 to 50.

  modify speed backwalk
    Syntax: .modify speed backwalk #rate
    Modify the speed of the selected player while running backwards to "normal walk back speed"*rate. If no player is selected, modify your speed.
    #rate may range from 0.1 to 50.

  modify speed fly
    .modify speed fly #rate
    Modify the flying speed of the selected player to "normal flying speed"*rate. If no player is selected, modify your speed.
    #rate may range from 0.1 to 50.

  modify speed walk
    Syntax: .modify speed bwalk #rate
    Modify the speed of the selected player while running to "normal walk speed"*rate. If no player is selected, modify your speed.
    #rate may range from 0.1 to 50.

  modify speed swim
    Syntax: .modify speed swim #rate
    Modify the swim speed of the selected player to "normal swim speed"*rate. If no player is selected, modify your speed.
    #rate may range from 0.1 to 50.

  modify spell
    TODO

  modify standstate
    Syntax: .modify standstate #emoteid
    Change the emote of your character while standing to #emoteid.

  modify talentpoints
    Syntax: .modify talentpoints #amount
    Set free talent points for selected character or character's pet. It will be reset to default expected at next levelup/login/quest reward.

  npc
    Syntax: .npc $subcommand
    Type .npc to see the list of possible subcommands or .help npc $subcommand to see info on subcommands

  npc add
    Syntax: .npc add #entry
    Spawn a creature using template #entry and save it to the database.
    If you want a temporary spawn that is not saved to the database, use .npc add temp instead.

  npc add formation
    Syntax: .npc add formation $leader
    Add selected creature to a leader's formation.

  npc add item
    Syntax: .npc add item #itemId <#maxcount><#incrtime><#extendedcost>r
    Add item #itemid to item list of selected vendor. Also optionally set max count item in vendor item list and time to item count restoring and items ExtendedCost.

  npc add move
    Syntax: .npc add move #creature_guid [#waittime]
    Add your current location as a waypoint for creature with guid #creature_guid. And optional add wait time.

  npc add temp
    Syntax: .npc add temp [loot/noloot] #entry
    Adds temporary NPC, not saved to database.
    Specify 'loot' to have the NPC's corpse stick around for some time after death, allowing it to be looted.
    Specify 'noloot' to have the corpse disappear immediately.

  npc delete
    Syntax: .npc delete [#guid]
    Delete creature with guid #guid (or the selected if no guid is provided)

  npc delete item
    Syntax: .npc delete item #itemId
    Remove item #itemid from item list of selected vendor.

  npc follow
    Syntax: .npc follow start
    Selected creature start follow you until death/fight/etc.

  npc follow stop
    Syntax: .npc follow stop
    Selected creature (non pet) stop follow you.

  npc set
    Syntax:

  npc set allowmove
    Syntax: .npc set allowmove
    Enable or disable movement creatures in world. Not implemented.

  npc set entry
    Syntax: .npc set entry $entry
    Switch selected creature with another entry from creature_template. - New creature.id value not saved to DB.

  npc set factionid
    Syntax: .npc set factionid #factionid
    Set the faction of the selected creature to #factionid.

  npc set flag
    Syntax: .npc set flag #npcflag
    Set the NPC flags of creature template of the selected creature and selected creature to #npcflag. NPC flags will applied to all creatures of selected creature template after server restart or grid unload/load.

  npc set level
    Syntax: .npc set level #level
    Change the level of the selected creature to #level.
    #level may range from 1 to (CONFIG_MAX_PLAYER_LEVEL) + 3.

  npc set link
    Syntax: .npc set link $creatureGUID
    Links respawn of selected creature to the condition that $creatureGUID defined is alive.

  npc set model
    Syntax: .npc set model #displayid
    Change the model id of the selected creature to #displayid.

  npc set movetype
    Syntax: .npc set movetype [#creature_guid] stay/random/way [NODEL]
    Set for creature pointed by #creature_guid (or selected if #creature_guid not provided) movement type and move it to respawn position (if creature alive). Any existing waypoints for creature will be removed from the database if you do not use NODEL. If the creature is dead then movement type will applied at creature respawn.
    Make sure you use NODEL, if you want to keep the waypoints.

  npc set phase
    Syntax: .npc set phase #phasemask
    Selected unit or pet phasemask changed to #phasemask with related world vision update for players. In creature case state saved to DB and persistent. In pet case change active until in game phase changed for owner, owner re-login, or GM-mode enable/disable..

  npc set spawndist
    Syntax: .npc set spawndist #dist
    Adjust spawndistance of selected creature to dist.

  npc set spawntime
    Syntax: .npc set spawntime #time 
    Adjust spawntime of selected creature to time.

  npc set data
    Syntax: .npc set data $field $data
    Sets data for the selected creature. Used for testing Scripting

  npc info
    Syntax: .npc info
    Display a list of details for the selected creature.
    The list includes:
    - GUID, Faction, NPC flags, Entry ID, Model ID,
    - Level,
    - Health (current/maximum),
    - Field flags, dynamic flags, faction template, 
    - Position information,
    - and the creature type, e.g. if the creature is a vendor.

  npc near
    Syntax:

  npc move
    Syntax: .npc move [#creature_guid]
    Move the targeted creature spawn point to your coordinates.

  npc playemote
    Syntax: .npc playemote #emoteid
    Make the selected creature emote with an emote of id #emoteid.

  npc say
    Syntax: .npc say $message
    Make selected creature say specified message.

  npc textemote
    Syntax: .npc textemote #emoteid
    Make the selected creature to do textemote with an emote of id #emoteid.

  npc whisper
    Syntax: .npc whisper #playerguid #text
    Make the selected npc whisper #text to  #playerguid.

  npc yell
    Syntax: .npc yell $message
    Make selected creature yell specified message.

  npc tame
    Syntax:

  quest
    Syntax: .quest $subcommand
    Type .quest to see the list of possible subcommands or .help quest $subcommand to see info on subcommands

  quest add
    Syntax: .quest add #quest_id
    Add to character quest log quest #quest_id. Quest started from item can't be added by this command but correct .additem call provided in command output.

  quest complete
    Syntax: .quest complete #questid
    Mark all quest objectives as completed for target character active quest. After this target character can go and get quest reward.

  quest remove
    Syntax: .quest remove #quest_id
    Set quest #quest_id state to not completed and not active (and remove from active quest list) for selected player.

  quest reward
    Syntax: .quest reward #questId
    Grants quest reward to selected player and removes quest from his log (quest must be in completed state).

  reload
    Syntax: .reload $subcommand
    Type .reload to see the list of possible subcommands or .help reload $subcommand to see info on subcommands

  reload access_requirement
    Syntax: .reload access_requirement
    Reload access_requirement table.

  reload achievement_criteria_data
    Syntax: .reload achievement_criteria_data
    Reload achievement_criteria_data table.

  reload achievement_reward
    Syntax: .reload achievement_reward
    Reload achievement_reward table.

  reload all
    Syntax: .reload all
    Reload all tables with reload support added and that can be _safe_ reloaded.

  reload all achievement
    Syntax: .reload all achievement
    Reload achievement_reward, achievement_criteria_data tables.

  reload all area
    Syntax: .reload all area
    Reload areatrigger_teleport, areatrigger_tavern, graveyard_zone tables.

  reload broadcast_text
    Syntax: .broadcast_text
    Reload broadcast_text table.

  reload all gossips
    Syntax: .reload all gossips
    Reload gossip_menu, gossip_menu_option, gossip_scripts, points_of_interest tables.

  reload all item
    Syntax: .reload all item
    Reload page_text, item_enchantment_table tables.

  reload all locales
    Syntax: .reload all locales
    Reload all `locales_*` tables with reload support added and that can be _safe_ reloaded.

  reload all loot
    Syntax: .reload all loot
    Reload all `*_loot_template` tables. This can be slow operation with lags for server run.

  reload all npc
    Syntax: .reload all npc
    Reload npc_option, npc_trainer, npc vendor, points of interest tables.

  reload all quest
    Syntax: .reload all quest
    Reload all quest related tables if reload support added for this table and this table can be _safe_ reloaded.

  reload all scripts
    Syntax: .reload all scripts
    Reload gameobject_scripts, event_scripts, quest_end_scripts, quest_start_scripts, spell_scripts, db_script_string, waypoint_scripts tables.

  reload all spell
    Syntax: .reload all spell
    Reload all `spell_*` tables with reload support added and that can be _safe_ reloaded.

  reload areatrigger_involvedrelation
    Syntax: .reload areatrigger_involvedrelation
    Reload areatrigger_involvedrelation table.

  reload areatrigger_tavern
    Syntax: .reload areatrigger_tavern
    Reload areatrigger_tavern table.

  reload areatrigger_teleport
    Syntax: .reload areatrigger_teleport
    Reload areatrigger_teleport table.

  reload auctions
    Syntax: .reload auctions
    Reload dynamic data tables from the database.

  reload autobroadcast
    Syntax: .reload autobroadcast
    Reload autobroadcast table.

  reload command
    Syntax: .reload command
    Reload command table.

  reload conditions
    Reload conditions table.

  reload config
    Syntax: .reload config
    Reload config settings (by default stored in trinityd.conf). Not all settings can be change at reload: some new setting values will be ignored until restart, some values will applied with delay or only to new objects/maps, some values will explicitly rejected to change at reload.

  reload battleground_template
    Syntax: .reload battleground_template
    Reload Battleground Templates.

  mutehistory
    Syntax:

  reload creature_linked_respawn
    Syntax: .reload creature_linked_respawn
    Reload creature_linked_respawn table.

  reload creature_loot_template
    Syntax: .reload creature_loot_template
    Reload creature_loot_template table.

  reload creature_onkill_reputation
    Syntax: .reload creature_onkill_reputation
    Reload creature_onkill_reputation table.

  reload creature_questender
    Syntax: .reload creature_questender
    Reload creature_questender table.

  reload creature_queststarter
    Syntax: .reload creature_queststarter
    Reload creature_queststarter table.

  reload creature_summon_groups
    Syntax: .reload creature_summon_groups
    Reload creature_summon_groups table.

  reload creature_template
    Syntax: .reload creature_template $entry
    Reload the specified creature's template.

  reload creature_text
    Syntax: .reload creature_text
    Reload creature_text Table.

  reload disables
    Syntax: .reload disables
    Reload disables table.

  reload disenchant_loot_template
    Syntax: .reload disenchant_loot_template
    Reload disenchant_loot_template table.

  reload event_scripts
    Syntax: .reload event_scripts
    Reload event_scripts table.

  reload fishing_loot_template
    Syntax: .reload fishing_loot_template
    Reload fishing_loot_template table.

  reload graveyard_zone
    Syntax: .reload graveyard_zone
    Reload graveyard_zone table.

  reload game_tele
    Syntax: .reload game_tele
    Reload game_tele table.

  reload gameobject_questender
    Syntax: .reload gameobject_questender\nReload gameobject_questender table.

  reload gameobject_loot_template
    Syntax: .reload gameobject_loot_template
    Reload gameobject_loot_template table.

  reload gameobject_queststarter
    Syntax: .reload gameobject_queststarter
    Reload gameobject_queststarter table.

  reload gm_tickets
    Syntax: .reload gm_tickets
    Reload gm_tickets table.

  reload gossip_menu
    Syntax: .reload gossip_menu
    Reload gossip_menu table.

  reload gossip_menu_option
    Syntax: .reload gossip_menu_option
    Reload gossip_menu_option table.

  reload item_enchantment_template
    Syntax: .reload item_enchantment_template
    Reload item_enchantment_template table.

  reload item_loot_template
    Syntax: .reload item_loot_template
    Reload item_loot_template table.

  reload item_set_names
    Syntax: .reload item_set_names
    Reload item_set_names table.

  reload lfg_dungeon_rewards
    Syntax: .reload lfg_dungeon_rewards
    Reload lfg_dungeon_rewards table.

  reload locales_achievement_reward
    Syntax:

  reload locales_creature
    Syntax: .reload locales_creature
    Reload locales_creature table.

  reload locales_creature_text
    Syntax: .reload locales_creature_text
    Reload locales_creature_text Table.

  reload locales_gameobject
    Syntax: .reload locales_gameobject
    Reload locales_gameobject table.

  reload locales_gossip_menu_option
    Syntax: .reload locales_gossip_menu_option
    Reload locales_gossip_menu_option table.

  reload locales_item
    Syntax: .reload locales_item
    Reload locales_item table.

  reload locales_item_set_name
    Syntax: .reload locales_item_set_name
    Reload locales_item_set_name table.

  reload locales_npc_text
    Syntax: .reload locales_npc_text
    Reload locales_npc_text table.

  reload locales_page_text
    Syntax: .reload locales_page_text
    Reload locales_page_text table.

  reload locales_points_of_interest
    Syntax: .reload locales_points_of_interest
    Reload locales_point_of_interest table.

  reload locales_quest
    Syntax: .reload locales_quest
    Reload locales_quest table.

  reload mail_level_reward
    Syntax: .reload mail_level_reward
    Reload mail_level_reward table.

  reload mail_loot_template
    Syntax: .reload quest_mail_loot_template
    Reload quest_mail_loot_template table.

  reload milling_loot_template
    Syntax: .reload milling_loot_template
    Reload milling_loot_template table.

  reload npc_spellclick_spells
    Syntax:

  reload npc_trainer
    Syntax: .reload npc_trainer
    Reload npc_trainer table.

  reload npc_vendor
    Syntax: .reload npc_vendor
    Reload npc_vendor table.

  reload page_text
    Syntax: .reload page_text
    Reload page_text table.

  reload pickpocketing_loot_template
    Syntax: .reload pickpocketing_loot_template
    Reload pickpocketing_loot_template table.

  reload points_of_interest
    Syntax: .reload points_of_interest
    Reload points_of_interest table.

  reload prospecting_loot_template
    Syntax: .reload prospecting_loot_template
    Reload prospecting_loot_template table.

  reload quest_poi
    Syntax: .reload quest_poi
    Reload quest_poi table.

  reload quest_template
    Syntax: .reload quest_template
    Reload quest_template table.

  reload rbac
    Syntax: .reload rbac
    Reload rbac system.

  reload reference_loot_template
    Syntax: .reload reference_loot_template
    Reload reference_loot_template table.

  reload reserved_name
    Syntax: .reload reserved_name
    Reload reserved_name table.

  reload reputation_reward_rate
    Syntax: .reload reputation_reward_rate
    Reload reputation_reward_rate table.

  reload reputation_spillover_template
    Syntax: .reload reputation_spillover_template
    Reload reputation_spillover_template table.

  reload skill_discovery_template
    Syntax: .reload skill_discovery_template
    Reload skill_discovery_template table.

  reload skill_extra_item_template
    Syntax: .reload skill_extra_item_template
    Reload skill_extra_item_template table.

  reload skill_fishing_base_level
    Syntax: .reload skill_fishing_base_level
    Reload skill_fishing_base_level table.

  reload skinning_loot_template
    Syntax: .reload skinning_loot_template
    Reload skinning_loot_template table.

  reload smart_scripts
    Syntax: .reload smart_scripts
    Reload smart_scripts table.

  reload spell_required
    Syntax: .reload spell_required
    Reload spell_required table.

  reload spell_area
    Syntax: .reload spell_area
    Reload spell_area table.

  reload spell_bonus_data
    Syntax: .reload spell_bonus_data
    Reload spell_bonus_data table.

  reload spell_group
    Syntax: .reload spell_group
    Reload spell_group table.

  reload spell_learn_spell
    Syntax: .reload spell_learn_spell
    Reload spell_learn_spell table.

  reload spell_loot_template
    Syntax: .reload spell_loot_template
    Reload spell_loot_template table.

  reload spell_linked_spell
    Usage: .reload spell_linked_spell
    Reloads the spell_linked_spell DB table.

  reload spell_pet_auras
    Syntax: .reload spell_pet_auras
    Reload spell_pet_auras table.

  character changeaccount
    Syntax: .character changeaccount [$player] $account
    Transfers ownership of named (or selected) character to another account

  reload spell_proc
    Syntax: .reload spell_proc
    Reload spell_proc table.

  reload spell_scripts
    Syntax: .reload spell_scripts
    Reload spell_scripts table.

  reload spell_target_position
    Syntax: .reload spell_target_position
    Reload spell_target_position table.

  reload spell_threats
    Syntax: .reload spell_threats
    Reload spell_threats table.

  reload spell_group_stack_rules
    Syntax: .reload spell_group
    Reload spell_group_stack_rules table.

  reload trinity_string
    Syntax: .reload trinity_string
    Reload trinity_string table.

  reload warden_action
    Syntax: .reload warden_action
    Reload warden_action.

  reload waypoint_scripts
    Syntax: .reload waypoint_scripts
    Reload waypoint_scripts table.

  reload waypoint_data
    Syntax: .reload waypoint_data will reload waypoint_data table.

  reload vehicle_accessory
    Syntax: .reload vehicle_accessory
    Reloads GUID-based vehicle accessory definitions from the database.

  reload vehicle_template_accessory
    Syntax: .reload vehicle_template_accessory
    Reloads entry-based vehicle accessory definitions from the database.

  reset
    Syntax: .reset $subcommand
    Type .reset to see the list of possible subcommands or .help reset $subcommand to see info on subcommands

  reset achievements
    Syntax: .reset achievements [$playername]
    Reset achievements data for selected or named (online or offline) character. Achievements for persistance progress data like completed quests/etc re-filled at reset. Achievements for events like kills/casts/etc will lost.

  reset honor
    Syntax: .reset honor [Playername]
    Reset all honor data for targeted character.

  reset level
    Syntax: .reset level [Playername]
    Reset level to 1 including reset stats and talents.  Equipped items with greater level requirement can be lost.

  reset spells
    Syntax: .reset spells [Playername]
    Removes all non-original spells from spellbook.
    . Playername can be name of offline character.

  reset stats
    Syntax: .reset stats [Playername]
    Resets(recalculate) all stats of the targeted player to their original VALUESat current level.

  reset talents
    Syntax: .reset talents [Playername]
    Removes all talents of the targeted player or pet or named player. Playername can be name of offline character. With player talents also will be reset talents for all character's pets if any.

  reset all
    Syntax: .reset all spells
    Syntax: .reset all talents
    Request reset spells or talents (including talents for all character's pets if any) at next login each existed character.

  server
    Syntax: .server $subcommand
    Type .server to see the list of possible subcommands or .help server $subcommand to see info on subcommands

  server corpses
    Syntax: .server corpses
    Triggering corpses expire check in world.

  server exit
    Syntax: .server exit
    Terminate trinity-core NOW. Exit code 0.

  server idlerestart
    Syntax: .server idlerestart #delay [#exit_code] [reason]
    Restart the server after #delay seconds if no active connections are present (no players). Use #exit_code or 2 as program exit code.

  server idlerestart cancel
    Syntax: .server idlerestart cancel
    Cancel the restart/shutdown timer if any.

  server idleshutdown
    Syntax: .server idleshutdown #delay [#exit_code] [reason]
    Shut the server down after #delay seconds if no active connections are present (no players). Use #exit_code or 0 as program exist code.

  server idleshutdown cancel
    Syntax: .server idleshutdown cancel
    Cancel the restart/shutdown timer if any.

  server info
    Syntax: .server info
    Display server version and the number of connected players.

  server plimit
    Syntax: .server plimit [#num|-1|-2|-3|reset|player|moderator|gamemaster|administrator]
    Without arg show current player amount and security level limitations for login to server, with arg set player linit ($num > 0) or securiti limitation ($num < 0 or security leme name. With `reset` sets player limit to the one in the config file

  server restart
    Syntax: .server restart [force] #delay [#exit_code] [reason]
    Restart the server after #delay seconds. Use #exit_code or 2 as program exit code. Specify 'force' to allow short-term shutdown despite other players being connected.

  server restart cancel
    Syntax: .server restart cancel
    Cancel the restart/shutdown timer if any.

  server set
    Syntax:

  server set closed
    Syntax: server set closed on/off
    Sets whether the world accepts new client connectsions.

  server set difftime
    Syntax:

  server set loglevel
    Syntax: .server set loglevel $facility $name $loglevel. $facility can take the values: appender (a) or logger (l). $loglevel can take the values: disabled (0), trace (1), debug (2), info (3), warn (4), error (5) or fatal (6)

  server set motd
    Syntax: .server set motd $MOTD
    Set server Message of the day.

  server shutdown
    Syntax: .server shutdown [force] #delay [#exit_code] [reason]
    Shut the server down after #delay seconds. Use #exit_code or 0 as program exit code. Specify 'force' to allow short-term shutdown despite other players being connected.

  server shutdown cancel
    Syntax: .server shutdown cancel
    Cancel the restart/shutdown timer if any.

  server motd
    Syntax: .server motd
    Show server Message of the day.

  tele
    Syntax: .tele #location
    Teleport player to a given location.

  tele add
    Syntax: .tele add $name
    Add current your position to .tele command target locations list with name $name.

  tele del
    Syntax: .tele del $name
    Remove location with name $name for .tele command locations list.

  tele name
    Syntax: .tele name [#playername] #location
    Teleport the given character to a given location. Character can be offline.
    To teleport to homebind, set #location to "$home" (without quotes).

  tele group
    Syntax: .tele group#location
    Teleport a selected player and his group members to a given location.

  ticket
    Syntax: .ticket $subcommand
    Type .ticket to see the list of possible subcommands or .help ticket $subcommand to see info on subcommands

  ticket assign
    Usage: .ticket assign $ticketid $gmname.
    Assigns the specified ticket to the specified Game Master.

  ticket close
    Usage: .ticket close $ticketid.
    Closes the specified ticket. Does not delete permanently.

  ticket closedlist
    Displays a list of closed GM tickets.

  ticket comment
    Usage: .ticket comment $ticketid $comment.
    Allows the adding or modifying of a comment to the specified ticket.

  ticket complete
    Syntax:

  ticket delete
    Usage: .ticket delete $ticketid.
    Deletes the specified ticket permanently. Ticket must be closed first.

  ticket escalate
    Syntax:

  ticket escalatedlist
    Syntax:

  ticket list
    Displays a list of open GM tickets.

  ticket onlinelist
    Displays a list of open GM tickets whose owner is online.

  ticket reset
    Syntax: .ticket reset
    Removes all closed tickets and resets the counter, if no pending open tickets are existing.

  ticket response
    Syntax:

  ticket response append
    Syntax:

  ticket response appendln
    Syntax:

  ticket togglesystem
    Syntax:

  ticket unassign
    Usage: .ticket unassign $ticketid.
    Unassigns the specified ticket from the current assigned Game Master.

  ticket viewid
    Usage: .ticket viewid $ticketid.
    Returns details about specified ticket. Ticket must be open and not deleted.

  ticket viewname
    Usage: .ticket viewname $creatorname. 
    Returns details about specified ticket. Ticket must be open and not deleted.

  titles
    Syntax:

  titles add
    Syntax: .titles add #title
    Add title #title (id or shift-link) to known titles list for selected player.

  titles current
    Syntax: .titles current #title
    Set title #title (id or shift-link) as current selected title for selected player. If title is not in known title list for player then it will be added to list.

  titles remove
    Syntax: .titles remove #title
    Remove title #title (id or shift-link) from known titles list for selected player.

  titles set
    Syntax:

  titles set mask
    Syntax: .titles set mask #mask
    Allows user to use all titles from #mask.
    #mask=0 disables the title-choose-field

  wp
    Syntax: wp $subcommand
    Type .wp to see a list of possible subcommands
    or .help wp $subcommand to see info on the subcommand.

  wp add
    Syntax: .wp add
    Add a waypoint for the selected creature at your current position.

  wp event
    Syntax: .wp event $subcommand
    Type .path event to see the list of possible subcommands or .help path event $subcommand to see info on subcommands.

  wp load
    Syntax: .wp load $pathid
    Load pathid number for selected creature. Creature must have no waypoint data.

  wp modify
    Syntax:

  wp unload
    Syntax: .wp unload
    Unload path for selected creature.

  wp reload
    Syntax: .wp reload $pathid
    Load path changes ingame - IMPORTANT: must be applied first for new paths before .wp load #pathid

  wp show
    Syntax: .wp show $option
    Options:
    on $pathid (or selected creature with loaded path) - Show path
    first $pathid (or selected creature with loaded path) - Show first waypoint in path
    last $pathid (or selected creature with loaded path) - Show last waypoint in path
    off - Hide all paths
    info $selected_waypoint - Show info for selected waypoint.

  mailbox
    Syntax: .mailbox
    Show your mailbox content.

  ahbot
    Syntax: ahbot $subcommand
    Type .ahbot to see a list of possible subcommands
    or .help ahbot $subcommand to see info on the subcommand.

  ahbot items
    Syntax: .ahbot items $GrayItems $WhiteItems $GreenItems $BlueItems $PurpleItems $OrangeItems $YellowItems
    Set amount of each items color be selled on auction.

  ahbot items gray
    Syntax: .ahbot items gray $GrayItems
    Set amount of Gray color items be selled on auction.

  ahbot items white
    Syntax: .ahbot items white $WhiteItems
    Set amount of White color items be selled on auction.

  ahbot items green
    Syntax: .ahbot items green $GreenItems
    Set amount of Green color items be selled on auction.

  ahbot items blue
    Syntax: .ahbot items blue $BlueItems
    Set amount of Blue color items be selled on auction.

  ahbot items purple
    Syntax: .ahbot items purple $PurpleItems
    Set amount of Purple color items be selled on auction.

  ahbot items orange
    Syntax: .ahbot items orange $OrangeItems
    Set amount of Orange color items be selled on auction.

  ahbot items yellow
    Syntax: .ahbot items yellow $YellowItems
    Set amount of Yellow color items be selled on auction.

  ahbot ratio
    Syntax: .ahbot ratio $allianceratio $horderatio $neutralratio
    Set ratio of items in 3 auctions house.

  ahbot ratio alliance
    Syntax: .ahbot ratio alliance $allianceratio
    Set ratio of items in alliance auction house.

  ahbot ratio horde
    Syntax: .ahbot ratio horde $horderatio
    Set ratio of items in horde auction house.

  ahbot ratio neutral
    Syntax: .ahbot ratio neutral $neutralratio
    Set ratio of items in $neutral auction house.

  ahbot rebuild
    Syntax: .ahbot rebuild [all]
    Expire all actual auction of ahbot except bided by player. Binded auctions included to expire if "all" option used. Ahbot re-fill auctions base at current settings then.

  ahbot reload
    Syntax: .ahbot reload
    Reload AHBot settings from configuration file.

  ahbot status
    Syntax: .ahbot status [all]
    Show current ahbot state data in short form, and with "all" with details.

  guild info
    Shows information about target's guild or a given guild identifier or name.

  instance setbossstate
    Syntax: .instance setbossstate $bossId $encounterState [$Name]
    Sets the EncounterState for the given boss id to a new value. EncounterStates range from 0 to 5.
    If no character name is provided, the current map will be used as target.

  instance getbossstate
    Syntax: .instance getbossstate $bossId [$Name]
    Gets the current EncounterState for the provided boss id.
    If no character name is provided, the current map will be used as target.

  pvpstats
    Shows number of battleground victories in the last 7 days

  modify xp
    Syntax: .modify xp #xp
    Gives experience points to the targeted player or self.

  debug loadcells
    Syntax: .debug loadcells [mapId]
    Loads all cells for debugging purposes

  debug boundary
    Syntax: .debug boundary [fill] [duration]
    Flood fills the targeted unit's movement boundary and marks the edge of said boundary with debug creatures.
    Specify 'fill' as first parameter to fill the entire area with debug creatures.

  npc evade
    Syntax: .npc evade [reason] [force]
    Makes the targeted NPC enter evade mode.
    Defaults to specifying EVADE_REASON_OTHER, override this by providing the reason string (ex.: .npc evade EVADE_REASON_BOUNDARY).
    Specify 'force' to clear any pre-existing evade state before evading - this may cause weirdness, use at your own risk.

  pet level
    Syntax: .pet level #dLevel
    Increases/decreases the pet's level by #dLevel. Pet's level cannot exceed the owner's level.

  server shutdown force
    Syntax: .server shutdown [force] #delay [#exit_code] [reason]
    Shut the server down after #delay seconds. Use #exit_code or 0 as program exit code. Specify 'force' to allow short-term shutdown despite other players being connected.

  server restart force
    Syntax: .server restart [force] #delay [#exit_code] [reason]
    Restart the server after #delay seconds. Use #exit_code or 2 as program exit code. Specify 'force' to allow short-term shutdown despite other players being connected.

  debug neargraveyard
    Syntax: .debug neargraveyard [linked]
    Find the nearest graveyard from dbc or db (if linked)

  go offset
    Syntax: .go offset [x[ y[ z[ o]]]]
    Teleports the player by given offset from his current coordinates. 

Configuring Database Credentials:
  To grant the minimal required read-only (SELECT) database permissions, modify
  as necessary and then run following command against your MySQL database:

  mysql -u root -p -e "
    CREATE USER 'tcadmin'@'localhost' IDENTIFIED BY 'tcadmin';
    GRANT SELECT ON world.command TO 'tcadmin'@'localhost';
    FLUSH PRIVILEGES;"

Configuring SOAP RPC API Credentials:
  From the worldsever console, execute the following commands:

  account create tcadmin tcadmin
  account set gmlevel tcadmin 3 -1

  See the following URL for additional instructions on creating a GM user
  suitable for use with the SOAP RPC API:
    https://trinitycore.atlassian.net/wiki/display/tc/Server+Setup

Environment Variables:
  TCDBHOST, TCDBPORT, TCDBUSER, TCDBPASS, TCDBNAME, TCSOAPHOST, TCSOAPPORT,
  TCSOAPUSER, TCSOAPPASS.

  These variables may either be overloaded by writing them as KEY=VALUE pairs
  in one of the configuration files listed below (the files are simply loaded
  by the bash source command), or by specifying their values on the command
  line (see "DB Arguments" and "SOAP Arguments" above).

Configuration Files:
  /etc/default/tcadmin
  ~/.tcadmin.cnf

For additional support and bug reports, please contact the author Nicola
Worthington at <nicolaw@tfb.net>. Also see https://nicolaw.uk or
https://github.com/neechbear.
```



