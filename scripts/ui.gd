extends Panel

func _ready():
	self.visible = false
	$VBoxContainer/Music/HSlider.value = MusicController.get("volume")
	$VBoxContainer/Effect/HSlider.value = MusicController.get("effectVolume")
	for node in get_tree().get_nodes_in_group("sound_effect"):
		node.volume_db = linear2db(MusicController.get("effectVolume"))

func _input(_ev):
	if Input.is_action_just_pressed("ui_settings"):
		self.visible = not self.visible
		get_tree().paused = not get_tree().paused


func _on_Button_pressed():
	self.visible = false
	get_tree().paused = false


func _on_HSlider_value_changed(value):
	MusicController.set("volume", value)
	
func _process(_delta):
	rect_rotation = get_parent().get_node("Camera2D").rotation_degrees


func _on_effect_volume_change(value):
	var volume = linear2db(value)
	MusicController.set("effectVolume", value)
	for node in get_tree().get_nodes_in_group("sound_effect"):
		node.volume_db = volume
