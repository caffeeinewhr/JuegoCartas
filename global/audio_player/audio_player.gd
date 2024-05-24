extends AudioStreamPlayer

var isMusicEnabled: bool = true
var isVolumeUp: bool = true

@onready var audio: AudioStreamPlayer = $"."
@onready var music: AudioStreamPlayer = $music_player

func change_volume(volume: float):
	set_volume_db(volume)
	
func play_music(userStream: AudioStream, volume = 0.0):	
	if isMusicEnabled:
		music.set_stream(userStream)
		music.set_volume_db(volume)
		music.play()
	
func stop_music():
	music.stop()
	
func _on_music_player_finished():
	music.play()

func change_mute():
	if isVolumeUp:
		music.set_volume_db(-80.0)
	else:
		music.set_volume_db(0.0)
	isVolumeUp = not isVolumeUp

func change_play():
	if isMusicEnabled:
		music.stop()
	else:
		music.play()
		
	isMusicEnabled = not isMusicEnabled
