extends StaticBody2D


signal switch_activated
signal switch_deactivated

var can_interact: bool = false
var is_activated: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		if is_activated:
			animated_sprite_2d.play("deactivated")
			switch_deactivated.emit()
			is_activated = false
		else:
			animated_sprite_2d.play("activated")
			switch_activated.emit()
			is_activated = true


func _on_switch_activated() -> void:
	print("switch activated")


func _on_switch_deactivated() -> void:
	print("switch deactivated")
