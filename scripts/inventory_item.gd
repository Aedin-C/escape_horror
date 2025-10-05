extends Resource
## Resource that holds the information of an item.
##
## Items have an id, a name, a description, and a 2D texture.

class_name InvItem

@export var id: String
@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
