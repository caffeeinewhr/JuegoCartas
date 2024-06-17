extends Control

@onready var levels: Array[Level] = [$LevelsLayer/Level1, $LevelsLayer/Level2, $LevelsLayer/Level3, $LevelsLayer/Level4, $LevelsLayer/Level5]
@onready var data_username = $UserStatsLayer/dataUsername
@onready var data_time_left = $UserStatsLayer/dataTimeLeft
@onready var data_kills = $UserStatsLayer/dataKills
@onready var data_deaths = $UserStatsLayer/dataDeaths

@export var lineWidth: int = 2

func _ready():
	AudioPlayer.play_music(preload("res://art/music/mapa.wav"))
	setup_data()
	setup_levels()
	
func setup_data():
	if GlobalData.username.is_empty():
		data_username.hide()
	else:
		data_username.label.text = "Username: " + GlobalData.username
		
	data_time_left.label.text = "Time left: " + str(int(GlobalData.time_left)) + " seconds"
	data_kills.label.text = "Kills: " + str(GlobalData.kills)
	data_deaths.label.text = "Deaths: " + str(GlobalData.deaths)
		
func setup_levels():
	var num_levels = levels.size()
	for i in range(num_levels):
		var lvl = levels[i]
		lvl.number = i + 1
		lvl.label.text = "Level " + str(i + 1)
		lvl.battle_scene = "res://scenes/battle/battle_" + str(i + 1) + ".tscn"
		
		if i == 0 or (i > 0 and levels[i - 1].number in GlobalData.completed_levels):
			lvl.is_playable = true
			lvl.button.disabled = false
		else:
			lvl.is_playable = false
			lvl.button.disabled = true
			
		if i < (num_levels - 1):
			var line = Line2D.new()
			line.points = [lvl.position, levels[i + 1].position]
			line.width = lineWidth
			line.z_index = -1
			$LevelsLayer.add_child(line)
