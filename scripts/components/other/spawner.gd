@tool
extends Node2D

var _default_shape: RectangleShape2D = RectangleShape2D.new()

## Add description here
@export var spawn_scene: PackedScene

## Add description here
@export var spawn_area: Shape2D = _default_shape

## Add description here
@export_range(0.0, 10.0, 0.1, "or_greater") var life_time: float = 3.0

## Add description here
@export_range(0.0, 10.0, 0.1, "or_greater") var spawn_period: float = 0.0

const _DEBUG_COLOR = Color(1.0, 0.3, 0.7, 0.2)
const _DEFAULT_SHAPE_SIZE = Vector2(200, 200)


# Called when the node enters the scene tree for the first time.
func _ready():
	_default_shape.set_size(_DEFAULT_SHAPE_SIZE)

	if Engine.is_editor_hint():
		return
	
	if spawn_period != 0.0:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = spawn_period
		timer.timeout.connect(spawn)
		timer.start()


func _draw():
	if spawn_area != null:
		if Engine.is_editor_hint() or get_tree().is_debugging_collisions_hint():
			spawn_area.draw(get_canvas_item(), _DEBUG_COLOR)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint() or get_tree().is_debugging_collisions_hint():
		queue_redraw()


func _get_random_point_in_area() -> Vector2:
	var spawn_rect = spawn_area.get_rect()
	var x = randf_range(spawn_rect.position.x, spawn_rect.position.x + spawn_rect.size.x)
	var y = randf_range(spawn_rect.position.y, spawn_rect.position.y + spawn_rect.size.y)
	return Vector2(x, y)


func spawn(direction = Global.Direction.LEFT):
	var node = spawn_scene.instantiate()
	if life_time != 0.0:
		var timer = get_tree().create_timer(life_time)
		timer.timeout.connect(node.queue_free)
	if spawn_area != null:
		node.position = _get_random_point_in_area()
	if node is PhysicsBody2D and direction == Global.Direction.RIGHT:
		node.linear_velocity = node.linear_velocity.reflect(Vector2.UP)
	call_deferred("add_child", node)
	return node
