extends StaticBody2D

@onready var obstacle = load("res://obstacle.tscn")
@onready var size = $CollisionShape2D.get_shape().size.x
@export var min_first_obstacle_coordinate: int = 0
@export var min_obstacle_distance = 150
@export var max_obstacle_distance = 350

signal PLAYER_IN_FLOOR
var has_entered = false
var colors = [Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 0.0)]

var heights := [-12, -40, -55]
var obstacles = []


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
	var obs: Area2D = obstacle.instantiate()
	obs.position = position
	print("adding obstacle at (%s, %s)", [obs.position.x, obs.position.y])
	obs.connect("body_entered", on_obstacle_hit)
	add_child(obs)
	obstacles.push_back(obs)
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_size() -> float:
	return size


func on_obstacle_hit(body):
	if body.has_method("on_hit"):
		body.on_hit()


func _on_player_detection_body_entered(body):
	if body is CharacterBody2D && !has_entered:
		print("player entered")
		print(body)
		has_entered = true
		emit_signal("PLAYER_IN_FLOOR", name)
