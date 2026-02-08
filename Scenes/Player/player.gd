class_name Player
extends CharacterBody2D


@export var move_speed: float = 100.0
@export var push_strength: float = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_collision_shape: CollisionShape2D = $InteractionZone/InteractionCollisionShape
@onready var hp_bar: AnimatedSprite2D = $CanvasLayer/HPBar
@onready var sword: Sprite2D = $Sword
@onready var sword_hurt_box: Area2D = $Sword/SwordHurtBox
@onready var attack_timer: Timer = $AttackTimer


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
	move_player()
	push_blocks()
	
	update_treasure_label()
	
	if Input.is_action_just_pressed("interact") and attack_timer.time_left <= 0:
		attack()
	
	move_and_slide()


func move_player() -> void:
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_vector * move_speed
	
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


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = true


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = false


func _on_hit_box_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.player_hp -= 1
	update_hp_bar()
	if SceneManager.player_hp <= 0:
		die()


func _on_sword_hurt_box_body_entered(body: Node2D) -> void:
	body.queue_free()


func _on_attack_timer_timeout() -> void:
	sword.visible = false
	sword_hurt_box.monitoring = false
