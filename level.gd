extends Node2D

@onready var floor = load("res://floor.tscn")

var floors = []
var floor_count = 1
var current_speed = 1
var speed_factor = 0.1
static var restart = false
var points = 0
var game_active = false


# Called when the node enters the scene tree for the first time.
func _ready():
    $Floor1.connect("PLAYER_IN_FLOOR", add_floor)
    if restart:
        start()
    else:
        $CanvasLayer/StartScreen.visible = true


func start():
    $CanvasLayer/StartScreen.visible = false
    $CanvasLayer/UserInterface.visible = true
    $Player.start()
    game_active = true
    #$Timer.start()


func update_speed():
    var factor = log(points) / log(2)
    current_speed = 1 + speed_factor * factor
    $Player.speed *= current_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("action_pause"):
        $Player.toggle_pause()
        game_active = false
    pass


func _physics_process(delta):
    increment_points()


func add_floor(name: String):
    if floors.size() >= 2:
        remove_child(floors.pop_front())
    var current_floor = get_node(name)
    floors.push_back(current_floor)
    floor_count += 1
    var next_floor: StaticBody2D = floor.instantiate()
    next_floor.name = "Floor%s" % floor_count
    next_floor.position = current_floor.position
    var size_offset = current_floor.get_size()
    next_floor.position.x += current_floor.get_size()
    next_floor.connect("PLAYER_IN_FLOOR", add_floor)
    next_floor.min_obstacle_distance *= current_speed
    next_floor.max_obstacle_distance *= current_speed
    next_floor.min_first_obstacle_coordinate = max(next_floor.min_obstacle_distance - current_floor.last_obstacle_offset(), 0)
    add_child(next_floor)


func _on_player_death():
    game_active = false
    $CanvasLayer/GameOverScreen/ResultLabel.text = "You reached %s Points" % points
    $CanvasLayer/GameOverScreen.visible = true


func increment_points():
    if game_active:
        points += 1
        $CanvasLayer/UserInterface/Label.text = "Points: %s" % points
        update_speed()


func _on_button_pressed():
    start()


func _on_restart_button_pressed():
    restart = true
    get_tree().reload_current_scene()
    pass  # Replace with function body.
