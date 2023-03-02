extends ColorRect

func _ready():
	$ShadingAnimation.interpolate_property(material, "shader_param/fading", 1, 0, .75, Tween.TRANS_LINEAR, Tween.EASE_IN)
