extends CharacterBody2D
class_name Player

# Constants
@export var speed: float = 100.0
@export var gravity: int = 10
@export var jump_force: int = 300
@export var max_jump: int = 2
@export var attack_cooldown: float = 0.5

enum MovementState { IDLE, WALKING, JUMPING, FALLING, DEAD }
enum Direction { NONE, LEFT, RIGHT }

# State Variables
var current_movement_state: MovementState = MovementState.IDLE
var current_direction: Direction = Direction.NONE
var jump_count: int = 0
var attack_timer: float = 0.0
var is_attacking: bool = false
var is_dead: bool = false
var can_move: bool = true
var can_attack: bool = true

func _ready() -> void:
	initialize_player()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	update_attack_timer(delta)
	if can_move:
		handle_movement(delta)
		apply_gravity()
		move_and_slide()
		update_animation()
	check_health()

# Initialization
func initialize_player() -> void:
	$PlayerAnimation.play("Idle")
	$Sword/sword_AOE.disabled = true

# Core Updates
func check_health() -> void:
	if Player_data.hp <= 0 and not is_dead:
		die()

# Movement
func handle_movement(delta: float) -> void:
	if is_attacking:
		return

	var horizontal_input := get_horizontal_input()
	update_velocity(horizontal_input)
	handle_jumping()
	handle_attacking()

func get_horizontal_input() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func update_velocity(horizontal_input: float) -> void:
	velocity.x = horizontal_input * speed
	velocity.x = clamp(velocity.x, -speed, speed)

	if horizontal_input != 0:
		set_movement_state(MovementState.WALKING)
		set_direction(Direction.RIGHT if horizontal_input > 0 else Direction.LEFT)
		update_sword_position()
	elif is_on_floor():
		set_movement_state(MovementState.IDLE)

func update_sword_position() -> void:
	$Sword.position.x = 20 if current_direction == Direction.RIGHT else -20

# Jumping
func handle_jumping() -> void:
	if is_on_floor():
		reset_jump_count()

	if can_jump() and Input.is_action_just_pressed("ui_up"):
		perform_jump()

func can_jump() -> bool:
	return is_on_floor() or jump_count < max_jump

func perform_jump() -> void:
	jump_count += 1
	velocity.y = -jump_force
	set_movement_state(MovementState.JUMPING)

func reset_jump_count() -> void:
	jump_count = 0

# Gravity
func apply_gravity() -> void:
	if not is_on_floor():
		velocity.y += gravity
		set_movement_state(MovementState.FALLING)

# Attacking
func handle_attacking() -> void:
	if Input.is_action_just_pressed("attack") and attack_timer <= 0.0:
		start_attack()
	if is_attacking and Input.is_action_just_released("attack"):
		stop_attack()

func start_attack() -> void:
	is_attacking = true
	attack_timer = attack_cooldown
	$PlayerAnimation.play("Attack")
	$Sword/sword_AOE.disabled = false

func stop_attack() -> void:
	is_attacking = false
	$Sword/sword_AOE.disabled = true

func update_attack_timer(delta: float) -> void:
	if attack_timer > 0.0:
		attack_timer -= delta

# Death Handling
func die() -> void:
	is_dead = true
	can_attack = false
	can_move = false
	set_movement_state(MovementState.DEAD)
	$PlayerAnimation.play("Dead")
	velocity.x = 0
	apply_gravity()
	await $PlayerAnimation.animation_finished
	respawn_player()

func respawn_player() -> void:
	Player_data.hp = 4
	Player_data.coin = 0
	if get_tree():
		get_tree().reload_current_scene()

# Animation
func update_animation() -> void:
	if is_attacking:
		return  # Attack animation takes precedence

	$Sprite2D.flip_h = (current_direction == Direction.LEFT)

	match current_movement_state:
		MovementState.IDLE:
			play_animation("Idle")
		MovementState.WALKING:
			play_animation("Walk")
		MovementState.JUMPING:
			play_animation("Jump")
		MovementState.FALLING:
			play_animation("Fall")

func play_animation(animation_name: String) -> void:
	if $PlayerAnimation.current_animation != animation_name:
		$PlayerAnimation.play(animation_name)

# Helpers
func set_movement_state(state: MovementState) -> void:
	current_movement_state = state

func set_direction(direction: Direction) -> void:
	current_direction = direction
