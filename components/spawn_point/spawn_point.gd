## A marker that identifies a valid spawn location within a room.
##
## Place these as children of a room scene to mark where entities can spawn.
## Set [member spawn_type] in the inspector to control what can spawn here.
## The room manager queries these by type to find valid positions.
class_name SpawnPointComponent
extends Marker2D

enum SpawnType {
	PLAYER,
	ENEMY,
	POI
}

## What type of entity can spawn at this location.
@export var spawn_type: SpawnType = SpawnType.ENEMY


## Returns the spawn type of this point.
func get_spawn_type() -> SpawnType:
	return spawn_type
