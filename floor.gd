extends StaticBody2D

@onready var obstacle_blueprints = [load("res://obstacle.tscn"), load("res://slit_obstacle.tscn")]
@onready var doublejump = load("res://powerup_doublejump.tscn")

@onready var size = $CollisionShape2D.get_shape().size.x
@export var min_first_obstacle_coordinate: int = 0
@export var default_floor_min_distance = 150
@export var default_floor_max_distance = 350
@onready var min_obstacle_distance: int = default_floor_min_distance
@onready var max_obstacle_distance: int = default_floor_max_distance

signal PLAYER_IN_FLOOR
signal POWERUP
var has_entered = false
var colors = [Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 0.0)]

var heights := [-12, -40]
var obstacles = []
var should_add_powerup = false
var active_powerUp = null


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_obstacles()
	#$Sprite2D/PlayerDetection/CollisionShape2D.debug_color = colors[randi() % colors.size()]


func obstacle_distance():
	return randi_range(min_obstacle_distance, max_obstacle_distance)


func generate_obstacles():
	var next_position = Vector2(randi_range(min_first_obstacle_coordinate, max_obstacle_distance - min_first_obstacle_coordinate), heights[randi_range(0, heights.size() - 1)])
	while add_obstacle_at(next_position):
		var last_obs_xpos = obstacles[-1].position.x
		next_position = Vector2(obstacle_distance() + last_obs_xpos, heights[randi_range(0, heights.size() - 1)])
	pass


func last_obstacle_offset() -> int:
	return get_size() - obstacles[-1].position.x


func add_obstacle_at(position: Vector2) -> bool:
	if get_size() < position.x:
		return false
	if !should_add_powerup:
		var obs: Area2D = obstacle_blueprints[randi() % obstacle_blueprints.size()].instantiate()
		obs.position = position
		#print("adding obstacle at (%s, %s)", [obs.position.x, obs.position.y])
		obs.connect("body_entered", on_obstacle_hit)
		add_child(obs)
		obstacles.push_back(obs)
	else:
		var powerup: Area2D = doublejump.instantiate()
		powerup.position = position
		#print("adding obstacle at (%s, %s)", [obs.position.x, obs.position.y])
		powerup.connect("body_entered", on_doublejump_collect)
		add_child(powerup)
		should_add_powerup = false
		obstacles.push_back(powerup)
		active_powerUp = powerup
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_size() -> float:
	return size


func on_obstacle_hit(body):
	if body.has_method("on_hit"):
		body.on_hit()


func on_doublejump_collect(body):
	emit_signal("POWERUP", "doublejump")
	remove_child(active_powerUp)


func _on_player_detection_body_entered(body):
	if body is CharacterBody2D && !has_entered:
		print("player entered")
		print(body)
		has_entered = true
		emit_signal("PLAYER_IN_FLOOR", name)
