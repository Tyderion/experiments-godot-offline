extends StaticBody2D


@onready var obstacle = load("res://obstacle.tscn")

signal PLAYER_IN_FLOOR
var has_entered = false
var colors = [Color(1.0, 0.0, 0.0, 1.0),
          Color(0.0, 1.0, 0.0, 1.0),
          Color(0.0, 0.0, 1.0, 0.0)]
        
var heights := [-16, -40, -60]
var min_obstacle_distance = 150
var max_obstacle_distance = 300
var obstacles= []

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    generate_obstacles()
    #$CollisionShape2D.debug_color = colors[randi() % colors.size()]
    pass # Replace with function body.
func obstacle_distance():
    return randi_range(min_obstacle_distance, max_obstacle_distance)

func generate_obstacles():
    for i in range(10):
        var last_obs_xpos = obstacles[-1].position.x if obstacles.size() > 0 else min_obstacle_distance
        var obs: Area2D = obstacle.instantiate()
        obs.position.y = heights[randi_range(0, heights.size()-1)]
        obs.position.x = obstacle_distance() + last_obs_xpos
        if (get_size() < obs.position.x - 100):
            return 
        print("adding obstacle at (%s, %s)",  [obs.position.x, obs.position.y])
        obs.connect("body_entered", on_obstacle_hit)
        add_child(obs)
        obstacles.push_back(obs)
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_size() -> float:
   return $CollisionShape2D.get_shape().size.x

func on_obstacle_hit(body):
    if body.has_method("on_hit"):
        body.on_hit()


func _on_player_detection_body_entered(body):
    if body is CharacterBody2D && !has_entered:
        print("player entered")
        print(body)
        has_entered = true
        emit_signal("PLAYER_IN_FLOOR", name)
