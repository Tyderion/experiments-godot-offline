extends StaticBody2D

signal PLAYER_IN_FLOOR
var has_entered = false
var colors = [Color(1.0, 0.0, 0.0, 1.0),
          Color(0.0, 1.0, 0.0, 1.0),
          Color(0.0, 0.0, 1.0, 0.0)]
var min_obstacle_distance = 100

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    #$CollisionShape2D.debug_color = colors[randi() % colors.size()]
    pass # Replace with function body.

func generate_obstacles():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_size() -> float:
   return $CollisionShape2D.get_shape().size.x

func _on_low_bar_body_entered(body):
    if body.has_method("on_hit"):
        body.on_hit()
    pass # Replace with function body.


func _on_player_detection_body_entered(body):
    if body is CharacterBody2D && !has_entered:
        print("player entered")
        print(body)
        has_entered = true
        emit_signal("PLAYER_IN_FLOOR", name)
