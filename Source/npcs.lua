import "npcs/signpost"
import "npcs/person"
import "npcs/door"

function loadNpc(info)
	local npcType = info[1]
	if npcType == "signpost" then
		table.insert(objs, Signpost(info[2], info[3], info[4]))
	elseif npcType == "person" then
		table.insert(objs, Person(info[2], info[3], info[4], info[5]))
	elseif npcType == "door" then
		table.insert(objs, Door(info[2], info[3], info[4], info[5]))
	end
end