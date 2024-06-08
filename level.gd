extends Node2D

@onready var floor = load("res://floor.tscn")

var floors = []
var floor_count = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    $Floor1.connect("PLAYER_IN_FLOOR", add_floor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("action_pause"):
        $Player.toggle_pause()
    pass
    
    
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
    add_child(next_floor)
