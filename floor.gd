extends StaticBody2D

signal PLAYER_IN_FLOOR
var has_entered = false
var colors = [Color(1.0, 0.0, 0.0, 1.0),
          Color(0.0, 1.0, 0.0, 1.0),
          Color(0.0, 0.0, 1.0, 0.0)]

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    $CollisionShape2D.debug_color = colors[randi() % colors.size()]
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_size() -> float:
   return $CollisionShape2D.get_shape().size.x

func _on_area_2d_body_entered(body):
    if body is CharacterBody2D && !has_entered:
        print("player entered")
        print(body)
        has_entered = true
        emit_signal("PLAYER_IN_FLOOR", name)
