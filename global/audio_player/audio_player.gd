extends AudioStreamPlayer

var isMusicEnabled: bool = true
var isVolumeUp: bool = true

@onready var audio: AudioStreamPlayer = $"."
@onready var music: AudioStreamPlayer = $music_player

func change_volume(volume: float):
	music.volume_db = volume
	
func play_music(userStream: AudioStream, volume = 0.0):	
	if isMusicEnabled:
		music.stream = userStream
		music.volume_db = volume
		music.play()
	
func stop_music():
	music.stop()
	
func _on_music_player_finished():
	music.play()

func change_mute():
	if isVolumeUp:
		music.volume_db = -100
	else:
		music.volume_db = 0.0
		
	isVolumeUp = not isVolumeUp
		
func change_play():
	if isMusicEnabled:
		music.stop()
	else:
		music.play()
		
	isMusicEnabled = not isMusicEnabled
