extends CharacterBody2D
class_name Player

@export var max_speed: float = 350.0
@export var acceleration: float = 3000
@export var friction: float = 2000

var direction: Vector2 = Vector2.ZERO

@export var jump_height: float = 100
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.3

@export var wall_jump_pushback: float = 400



@onready var jump_timer = $JumpTimer
var can_jump: bool = true
var can_double_jump = true
var can_wall_jump = true

@onready var jump_velocity: float = (-2 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = (2 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity: float = (2 * jump_height) / (jump_time_to_descent * jump_time_to_descent)


var can_wall_slide: bool = true
var is_wall_sliding: bool = false
@onready var wall_slide_gravity: float = fall_gravity / 30


func _ready():
	GameManager.player = self

func _physics_process(delta):
	
	floor_check()
	if can_wall_slide:
		is_wall_sliding = check_wall_slide()
	apply_gravity(delta)
	handle_jump()
	handle_double_jump()
	handle_wall_jump()
	
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0:
		apply_acceleration(direction, delta)

	apply_friction(delta)

	print(velocity.y)

	move_and_slide()

func apply_acceleration(direction, delta):
	velocity.x += direction.x * acceleration * delta
	
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -max_speed:
		velocity.x = -max_speed
	

func apply_friction(delta):
	if velocity.x > 20:
		velocity.x -= friction * delta
	elif velocity.x < -20:
		velocity.x += friction * delta
	else:
		velocity.x = 0

func floor_check():
	if is_on_floor():
		can_jump = true
		can_double_jump = true
	elif can_jump == true and jump_timer.is_stopped():
		jump_timer.start()
		
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += get_gravity() * delta

func handle_jump():
	if Input.is_action_just_pressed("jump") and can_jump:
		jump()
	# Cut Off Jump When Releasing Button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
		
func handle_double_jump():
	if not can_jump:
		if Input.is_action_just_pressed("jump") and can_double_jump:
			jump()
			can_double_jump = false
		# Cut Off Jump When Releasing Button
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
			
func handle_wall_jump():
	if can_wall_jump and Input.is_action_just_pressed("jump"):
		if is_on_wall() and Input.is_action_pressed("left"):
			jump()
			velocity.x = wall_jump_pushback
		if is_on_wall() and Input.is_action_pressed("right"):
			jump()
			velocity.x = -wall_jump_pushback
			
func check_wall_slide() -> bool:
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			return true

	return false

func get_gravity() -> float:
	if is_wall_sliding and velocity.y > 0:
		return wall_slide_gravity
	elif velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity

func jump():
	velocity.y = jump_velocity
	
func die():
	GameManager.respawn_player()

func _on_timer_timeout():
	can_jump = false
