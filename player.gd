extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var has_started = false
var alive = true;

var has_double_jump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func jump():
    velocity.y = JUMP_VELOCITY
    
    
func on_hit():
    alive = false

func _physics_process(delta):
    if !alive:
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
        velocity.x = SPEED
        has_started = true
        
    if is_on_floor():
        has_double_jump = true

    move_and_slide()
