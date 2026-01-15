extends TileMapLayer


func _ready() -> void:
	enable_secret_wall()


func disable_secret_wall():
	visible = false
	collision_enabled = false


func enable_secret_wall():
	visible = true
	collision_enabled = true
