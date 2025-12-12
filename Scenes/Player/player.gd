class_name Player
extends CharacterBody2D


@export var move_speed: float = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	position = SceneManager.player_spawn_position


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_vector * move_speed
	
	if velocity.x > 0:
		animated_sprite_2d.play("move_right")
	elif velocity.x < 0:
		animated_sprite_2d.play("move_left")
	elif velocity.y > 0:
		animated_sprite_2d.play("move_down")
	elif velocity.y < 0:
		animated_sprite_2d.play("move_up")
	else:
		animated_sprite_2d.stop()
	
	move_and_slide()
