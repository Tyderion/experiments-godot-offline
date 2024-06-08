extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var has_started = false

var has_double_jump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func jump():
    velocity.y = JUMP_VELOCITY

func _physics_process(delta):
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
    ## Get the input direction and handle the movement/deceleration.
    ## As good practice, you should replace UI actions with custom gameplay actions.
    #var direction = Input.get_axis("ui_left", "ui_right")
    #if direction:
        #velocity.x = direction * SPEED
    #else:
        #velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
