extends AudioStreamPlayer

var cheer = preload("res://assets/music/Crowd Applause.wav")
var boo = preload("res://assets/music/Crowd Concerned.wav")
var bad = preload("res://assets/music/sound_2.mp3")
var good = preload("res://assets/music/sound_3.mp3")
var select = preload("res://assets/music/sound_1.mp3")

var sounds = {
	"cheer": cheer,
	"boo": boo,
	"bad": bad,
	"good": good,
	"select": select
}

func play_fx(str):
	stream = sounds[str]
	play()
