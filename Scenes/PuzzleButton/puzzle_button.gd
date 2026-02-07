class_name PuzzleButton
extends Area2D


signal pressed
signal unpressed

@export var is_single_use: bool = false

var bodies_on_top: int = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			audio_stream_player_2d.pitch_scale = 1.0
			audio_stream_player_2d.play()
			pressed.emit()
			animated_sprite_2d.play("pressed")


func _on_body_exited(body: Node2D) -> void:
	if is_single_use:
		return
	
	bodies_on_top -= 1
	if bodies_on_top == 0:
		audio_stream_player_2d.pitch_scale = 0.8
		audio_stream_player_2d.play()
		unpressed.emit()
		animated_sprite_2d.play("unpressed")
