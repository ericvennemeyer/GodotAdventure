extends CharacterBody2D

@export var move_speed: float = 30.0

var target: Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	chase_target()
	animate_enemy()
	
	move_and_slide()


func chase_target() -> void:
	if target:
		var target_direction = position.direction_to(target.position)
		velocity = target_direction * move_speed


func animate_enemy() -> void:
	var normal_velocity: Vector2 = velocity.normalized()
	if normal_velocity.x > 0.707:
		# Moving Right
		animated_sprite_2d.play("move_right")
	elif normal_velocity.x < -0.707:
		# Moving Left
		animated_sprite_2d.play("move_left")
	elif normal_velocity.y > 0.707:
		# Moving Down
		animated_sprite_2d.play("move_down")
	elif normal_velocity.y < -0.707:
		# Moving Up
		animated_sprite_2d.play("move_up")


func _on_player_detect_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
