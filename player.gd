extends CharacterBody2D

@export var speed: float = 100.0
@export var invincible = false

signal DEATH
const JUMP_VELOCITY = -400.0 
var has_started = false
var alive = true;
var has_double_jump = true
var paused = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func jump():
    velocity.y = JUMP_VELOCITY

func toggle_pause():
    alive = !alive
    
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
    
func _process(delta):
    if !alive or paused:
        return
    if Input.is_action_just_pressed("action_crouch"):
        $AnimationPlayer.play("duck_animation", -1, 2)
    if Input.is_action_just_released("action_crouch"):
        $AnimationPlayer.play("duck_animation", -1, -2, true)

func _physics_process(delta):
    if !alive or paused:
        return
    # Add the gravity.
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle jump.
    if Input.is_action_just_pressed("action_jump"):
        if is_on_floor():
            jump()
        if has_double_jump:
            jump()
            has_double_jump = false
    
    if is_on_floor() && !has_started:
        velocity.x = speed
        print("velocity: %s", velocity.x)
        has_started = true
        
    if is_on_floor():
        has_double_jump = true

    move_and_slide()
