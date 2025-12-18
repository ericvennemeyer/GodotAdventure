class_name PuzzleButton
extends Area2D


signal pressed
signal unpressed

var bodies_on_top: int = 0


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			pressed.emit()
			animated_sprite_2d.play("pressed")


func _on_body_exited(body: Node2D) -> void:
	bodies_on_top -= 1
	if bodies_on_top == 0:
		unpressed.emit()
		animated_sprite_2d.play("unpressed")
