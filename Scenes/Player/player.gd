class_name Player
extends CharacterBody2D


@export var move_speed: float = 100.0
@export var acceleration: float = 10.0
@export var player_knockback_force: float = 150.0
@export var enemy_knockback_force: float = 120.0
@export var push_strength: float = 300.0

var is_attacking: bool = false
var can_interact: bool = false
var player_animation: String

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_collision_shape: CollisionShape2D = $InteractionZone/InteractionCollisionShape
@onready var hp_bar: AnimatedSprite2D = $CanvasLayer/HPBar
@onready var sword: Sprite2D = $Sword
@onready var sword_hurt_box: Area2D = $Sword/SwordHurtBox
@onready var attack_timer: Timer = $AttackTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_timer: Timer = $DeathTimer


func _ready() -> void:
	update_treasure_label()
	update_hp_bar()
	
	sword.visible = false
	sword_hurt_box.monitoring = false
	
	if SceneManager.player_spawn_position != Vector2.ZERO:
		position = SceneManager.player_spawn_position
	#Engine.max_fps = 30


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if SceneManager.player_hp <= 0:
		return
	
	if not is_attacking:
		move_player()
	push_blocks()
	
	update_treasure_label()
	
	if Input.is_action_just_pressed("interact") and attack_timer.time_left <= 0 and not can_interact:
		attack()
	
	move_and_slide()


func move_player() -> void:
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
	
	if velocity.x > 0:
		animated_sprite_2d.play("move_right")
		interaction_collision_shape.position = Vector2(5.0, 2.0)
	elif velocity.x < 0:
		animated_sprite_2d.play("move_left")
		interaction_collision_shape.position = Vector2(-5.0, 2.0)
	elif velocity.y > 0:
		animated_sprite_2d.play("move_down")
		interaction_collision_shape.position = Vector2(0, 8.0)
	elif velocity.y < 0:
		animated_sprite_2d.play("move_up")
		interaction_collision_shape.position = Vector2(0, -8.0)
	else:
		animated_sprite_2d.stop()


func update_treasure_label() -> void:
	var treasure_amount: int = SceneManager.open_chests.size()
	%TreasureLabel.text = str(treasure_amount)


func push_blocks() -> void:
	# Get the last collision
	# If there was a collision, get the colliding node
	# If colliding node was Block, push the block
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collider_node = collision.get_collider()
		if collider_node.is_in_group("pushable"):
			var collision_normal: Vector2 = collision.get_normal()
			collider_node.apply_central_force(-collision_normal * push_strength)


func die() -> void:
	animated_sprite_2d.play("die")
	if death_timer.is_stopped():
		death_timer.start()


func _on_death_timer_timeout() -> void:
	SceneManager.player_hp = 3
	get_tree().call_deferred("reload_current_scene")


func update_hp_bar() -> void:
	match SceneManager.player_hp:
		3:
			hp_bar.play("3_hp")
		2:
			hp_bar.play("2_hp")
		1:
			hp_bar.play("1_hp")
		0:
			hp_bar.play("0_hp")


func attack() -> void:
	attack_timer.start()
	sword.visible = true
	sword_hurt_box.monitoring = true
	is_attacking = true
	velocity = Vector2.ZERO
	
	$SwordAudioPlayer2D.play()
	
	player_animation = animated_sprite_2d.animation
	match player_animation:
		"move_down":
			animated_sprite_2d.play("attack_down")
			animation_player.play("attack_down")
		"move_up":
			animated_sprite_2d.play("attack_up")
			animation_player.play("attack_up")
		"move_left":
			animated_sprite_2d.play("attack_left")
			animation_player.play("attack_left")
		"move_right":
			animated_sprite_2d.play("attack_right")
			animation_player.play("attack_right")


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		can_interact = true
		body.can_interact = true


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		can_interact = false
		body.can_interact = false


func _on_hit_box_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.player_hp -= 1
	update_hp_bar()
	if SceneManager.player_hp <= 0:
		die()
	
	var enemy_direction = global_position.direction_to(body.global_position)
	velocity -= enemy_direction * player_knockback_force
	
	$HitAudioPlayer2D.play()
	
	var hit_flash_color: Color = Color(50, 50, 50)
	modulate = hit_flash_color
	await get_tree().create_timer(0.2).timeout
	var default_color: Color = Color(1, 1, 1)
	modulate = default_color


func _on_sword_hurt_box_body_entered(body: Node2D) -> void:
	var enemy_direction: Vector2 = global_position.direction_to(body.global_position)
	body.velocity += enemy_direction * enemy_knockback_force
	
	body.play_damage_sfx()
	
	body.hp -= 1
	if body.hp <= 0:
		body.queue_free()
	
	var hit_flash_color: Color = Color(15, 0, 0)
	body.modulate = hit_flash_color
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(body):
		var default_color: Color = Color(1, 1, 1)
		body.modulate = default_color


func _on_attack_timer_timeout() -> void:
	sword.visible = false
	sword_hurt_box.monitoring = false
	is_attacking = false
	animated_sprite_2d.play(player_animation)
