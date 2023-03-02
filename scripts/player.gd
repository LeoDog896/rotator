extends KinematicBody2D

export var speed      : float = 300 # X speed
export var gravity    : float = 490 # opposite Y speed
export var jump       : float = 235 # Y jump power
export var next_level : String = "res://scenes/levels/level1/index.tscn"

var gravity_direction := Vector2.DOWN
var velocity := Vector2.ZERO
var rotating := false

var can_play_land := true

onready var spawn_position := position
onready var map := get_parent().get_node("TileMap")

func get_input():
	if Input.get_action_strength("ui_left"):
		if gravity_direction.y == 1:
			velocity.x = -speed
		else:
			velocity.x = speed
	elif Input.get_action_strength("ui_right"):
		if gravity_direction.y == 1:
			velocity.x = speed
		else:
			velocity.x = -speed
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("ui_up") and is_on_ground():
		velocity = gravity_direction * -jump
		$Jump.play()
		can_play_land = true
	elif is_on_floor():
		velocity.y = gravity_direction.y * 2
	
	#handle switching
	if Input.is_action_just_pressed("rotate"):
		if !rotating:
			can_play_land = true
			gravity_direction = gravity_direction.rotated(PI)
			rotating = true	
			#camera functions
			var tween := $PlayerBody/Tween
			tween.interpolate_property($Camera2D, "rotation_degrees", $Camera2D.rotation_degrees, $Camera2D.rotation_degrees + 180, 0.3)
			tween.start()
			
			var arrowTween := $Arrow/Tween
			arrowTween.interpolate_property($Arrow, "rotation_degrees", $Arrow.rotation_degrees, $Arrow.rotation_degrees + 180, 0.5)
			arrowTween.start()
	

func _physics_process(delta):
	get_input()
	if not is_on_ground():
		velocity += gravity_direction * delta * gravity
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, gravity_direction, false, 4, 0.785398, false)
	
	if is_on_ground() and can_play_land:
		$Land.play()
		can_play_land = false
	
	var cell: Vector2 = map.world_to_map(position)
	var tile_id: int = map.get_cellv(cell)
	if tile_id == 4:
		$Death.play()
		$PlayerBody/Tween.stop_all()
		$Arrow/Tween.stop_all()
		rotating = false
		position = spawn_position
		$Camera2D.rotation_degrees = 0
		$Arrow.rotation_degrees = 90
		gravity_direction = Vector2.DOWN
		velocity = Vector2.ZERO

func _process(_delta):
	var cell: Vector2 = map.world_to_map(position)
	var tile_id: int = map.get_cellv(cell)
	if tile_id == 1:
		get_tree().paused = true
		$Camera2D/ColorRect.start_out_tween()

func is_on_ground():
	return (is_on_floor() and gravity_direction.y != 1) or (is_on_ceiling())

func _on_Tween_tween_completed(_object, _key):
	rotating = false
