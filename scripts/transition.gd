extends ColorRect

var endTween = false

func _ready():
	visible = true
	$Tween.interpolate_property(material, "shader_param/whitening", 0, -1, .75, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	get_tree().paused = false


func start_out_tween():
	endTween = true
	$Tween.interpolate_property(material, "shader_param/whitening", 1, 0, .75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_new_tween_complete():
	if endTween:
		assert(get_tree().change_scene(get_parent().get_parent().next_level) == OK)
	else:
		get_tree().paused = false
