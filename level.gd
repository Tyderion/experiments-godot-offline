extends Node2D

@onready var level_floor = load("res://floor.tscn")
@export var start_points = 0

var floors = []
var floor_count = 1
var current_speed = 1
var speed_factor = 0.2
static var restart = false
@onready var points = start_points
var game_active = false
var did_generate_powerup = false


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
	var factor = floor(points / 1000)
	current_speed = 1 + speed_factor * factor
	$Player.speed_factor = current_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("action_pause"):
		pause()
	pass


func pause():
	$Player.pause()
	game_active = false


func unpause():
	$Player.unpause()
	game_active = true


func _physics_process(delta):
	increment_points()


func add_floor(name: String):
	update_speed()
	if floors.size() >= 2:
		remove_child(floors.pop_front())
	var current_floor = get_node(name)
	floors.push_back(current_floor)
	floor_count += 1
	var next_floor: StaticBody2D = level_floor.instantiate()
	next_floor.name = "Floor%s" % floor_count
	next_floor.position = current_floor.position
	var size_offset = current_floor.get_size()
	next_floor.position.x += current_floor.get_size()
	next_floor.connect("PLAYER_IN_FLOOR", add_floor)
	next_floor.connect("POWERUP", add_powerup)
	next_floor.default_floor_min_distance *= current_speed
	next_floor.default_floor_max_distance *= current_speed
	next_floor.should_add_powerup = points > 100 and !did_generate_powerup
	did_generate_powerup = next_floor.should_add_powerup
	print("Speed factor: %s", current_speed)
	print("Min Floor Distance: %s", next_floor.default_floor_min_distance)
	next_floor.min_first_obstacle_coordinate = max(next_floor.default_floor_min_distance - current_floor.last_obstacle_offset(), 0)
	add_child(next_floor)


func _on_player_death():
	game_active = false
	$CanvasLayer/GameOverScreen/ResultLabel.text = "You reached %s Points" % points
	$CanvasLayer/GameOverScreen.visible = true


func increment_points():
	if game_active:
		points += 1
		$CanvasLayer/UserInterface/Label.text = "Points: %s" % points


func _on_button_pressed():
	start()


func add_powerup(powerup: String):
	$Player.add_powerup(powerup)
	pause()
	$CanvasLayer/PowerUpReceived.visible = true


func _on_continue_pressed():
	$CanvasLayer/PowerUpReceived.visible = false
	unpause()


func _on_restart_button_pressed():
	restart = true
	get_tree().reload_current_scene()
	pass  # Replace with function body.
