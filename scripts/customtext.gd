extends Position2D

func _on_Timer_timeout():
	var tween = $Tween
	tween.interpolate_property($Label, "self_modulate", Color(255,255,255,0),Color(255,255,255,100),1)
	tween.start()
