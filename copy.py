import json
overworld = open('MapEditing/Town1-backup.tmj')
gamemap = open('Source/maps/overworld.json')

info = json.load(overworld)
target = json.load(gamemap)

overworld.close()

target['data'] = info['layers'][0]['data']
target['width'] = info['width']

gamemapWrite = open('Source/maps/overworld.json', 'w')

json.dump(target, gamemapWrite)
