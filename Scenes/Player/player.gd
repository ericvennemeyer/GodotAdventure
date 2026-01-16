class_name Player
extends CharacterBody2D


@export var move_speed: float = 100.0
@export var push_strength: float = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_collision_shape: CollisionShape2D = $InteractionZone/InteractionCollisionShape


func _ready() -> void:
	update_treasure_label()
	
	if SceneManager.player_spawn_position != Vector2.ZERO:
		position = SceneManager.player_spawn_position
	#Engine.max_fps = 30


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	move_player()
	push_blocks()
	
	update_treasure_label()
	
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


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = true


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		body.can_interact = false
