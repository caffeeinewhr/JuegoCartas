extends Control

@onready var levels: Array[Level] = [$LevelsLayer/Level1, $LevelsLayer/Level2, $LevelsLayer/Level3, $LevelsLayer/Level4, $LevelsLayer/Level5]
@onready var data_username = $UserStatsLayer/dataUsername
@onready var data_time_left = $UserStatsLayer/dataTimeLeft
@onready var data_kills = $UserStatsLayer/dataKills
@onready var data_deaths = $UserStatsLayer/dataDeaths

@export var lineWidth: int = 2

func _ready():
	AudioPlayer.play_music(preload("res://art/music/mapa.wav"))
	setupData()
	setupLevels()
	
func _process(delta):
	print("Total playtime: ", str(GlobalData.playtime), " seconds")
	
func setupData():
	data_username.label.text = "Username: " + GlobalData.username
	data_time_left.label.text = "Time left: " + str(GlobalData.time_left)
	data_kills.label.text = "Kills: " + str(GlobalData.kills)
	data_deaths.label.text = "Deaths: " + str(GlobalData.deaths)
		
func setupLevels():
	var numLevels = levels.size()
	for i in range(numLevels):
		var lvl = levels[i]
		lvl.number = i + 1
		lvl.label.text = "Level " + str(i + 1)
		#lvl.battleScene = load("res://scenes/battle/level_" + str(i + 1) + ".tscn")
		if i == 0:
			lvl.isFirstLevel = true
			lvl.isPlayable = true
		elif lvl.number in GlobalData.completed_levels and i < numLevels:
			var next_lvl = levels[i + 1]
			lvl.isCompleted = true
			lvl.isPlayable = true
			next_lvl.isPlayable = true
		else:
			lvl.button.disabled = true
			lvl.isPlayable = false
			
		if i < (numLevels - 1):
			var line = Line2D.new()
			line.points = [lvl.position, levels[i + 1].position]
			line.width = lineWidth
			line.z_index = -1
			$LevelsLayer.add_child(line)
