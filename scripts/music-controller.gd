extends Node

var music = load("res://assets/sounds/puzzle-game-2.wav")
var volume = .5
var effectVolume = .5

func start_music():
	volume = .5
	$Music.stream = music
	$Music.play()

func _process(_delta):
	if linear2db(volume) == -20:
		$Music.volume_db = -100
	else:
		$Music.volume_db = clamp(linear2db(volume), -20, 0)
