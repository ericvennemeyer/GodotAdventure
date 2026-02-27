extends CharacterBody2D

@export var move_speed: float = 30.0
@export var acceleration: float = 5.0
@export var hp: int = 2

var target: Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if hp <= 0:
		return
	
	chase_target()
	animate_enemy()
	
	move_and_slide()


func chase_target() -> void:
	if target:
		var target_direction = position.direction_to(target.position)
		#velocity = target_direction * move_speed
		velocity = velocity.move_toward(target_direction * move_speed, acceleration)


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


func take_damage() -> void:
	hp -= 1
	if hp <= 0:
		die()
	
	var hit_flash_color: Color = Color(15, 0, 0)
	modulate = hit_flash_color
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(self):
		var default_color: Color = Color(1, 1, 1)
		modulate = default_color


func play_damage_sfx() -> void:
	$AudioStreamPlayer2D.play()


func die() -> void:
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _on_player_detect_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
