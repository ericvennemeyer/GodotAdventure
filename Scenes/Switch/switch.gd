extends StaticBody2D


signal switch_activated
signal switch_deactivated

var can_interact: bool = false
var is_activated: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		audio_stream_player_2d.play()
		if is_activated:
			deactivate_switch()
		else:
			activate_switch()


func activate_switch():
	animated_sprite_2d.play("activated")
	switch_activated.emit()
	is_activated = true


func deactivate_switch():
	animated_sprite_2d.play("deactivated")
	switch_deactivated.emit()
	is_activated = false
