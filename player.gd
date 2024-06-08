extends CharacterBody2D

@export var invincible = false
@export var default_speed = 200
@export var speed_factor = 1

@onready var speed: float = default_speed

signal DEATH
const JUMP_VELOCITY = -400.0
var has_started = false
var alive = true
var has_double_jump = true
var paused = true
var can_double_jump = false

var powerups = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func jump():
	velocity.y = JUMP_VELOCITY


func pause():
	alive = false


func unpause():
	alive = true


func on_powerup_collect(powerup: String):
	powerups.push_back(powerup)


func on_hit():
	if invincible:
		return
	alive = false
	emit_signal("DEATH")
	pass


func start():
	paused = false


func _ready():
	pass


func add_powerup(powerup: String):
	powerups.push_back(powerup)
	can_double_jump = powerups.has("doublejump")


func _process(delta):
	if !alive or paused:
		return
	if Input.is_action_just_pressed("action_crouch"):
		$AnimationPlayer.play("duck_animation", -1, 2)
	if Input.is_action_just_released("action_crouch"):
		$AnimationPlayer.play("duck_animation", -1, -2, true)


func _physics_process(delta):
	#print("Current player speed:  %s", speed)
	if !alive or paused:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("action_jump"):
		if is_on_floor():
			jump()
		if can_double_jump and has_double_jump:
			jump()
			has_double_jump = false

	if is_on_floor():
		velocity.x = speed * speed_factor

	if is_on_floor():
		has_double_jump = true

	move_and_slide()
