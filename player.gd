extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var has_started = false
var alive = true;
@onready var default_sprite_scale = $Sprite2D.scale.y
#@onready var default_collision_shape : RectangleShape2D = $CollisionShape2D.shape
#var ducked_collision_shape: RectangleShape2D
var has_double_jump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func jump():
    velocity.y = JUMP_VELOCITY

func toggle_pause():
    alive = !alive
    
func on_hit():
    alive = false

func _ready():
    pass
    
func _process(delta):
    if !alive:
        return
    if Input.is_action_just_pressed("action_crouch"):
        $AnimationPlayer.play("duck_animation")
        #$StandingCollision.disabled = true
        #$DuckedCollision.disabled = false
    if Input.is_action_just_released("action_crouch"):
        $AnimationPlayer.play_backwards("duck_animation")
        #$StandingCollision.disabled = false
        #$DuckedCollision.disabled = true

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
        #velocity.x = SPEED
        has_started = true
        
    if is_on_floor():
        has_double_jump = true

    move_and_slide()
