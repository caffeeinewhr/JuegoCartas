extends Control

@onready var levels: Array[Level] = [$LevelsLayer/Level1, $LevelsLayer/Level2, $LevelsLayer/Level3, $LevelsLayer/Level4, $LevelsLayer/Level5]
@onready var completedLevels: Array[Level] = []
@export var lineWidth: int = 2
		
func _ready():
	AudioPlayer.play_music(preload("res://art/music/mapa.wav"))
	setupLevels()

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
		elif !lvl.isCompleted:
			lvl.button.disabled = true	
			lvl.isPlayable = false
		
		if i < (numLevels - 1):
			var line = Line2D.new()
			line.points = [lvl.position, levels[i + 1].position]
			line.width = lineWidth
			line.z_index = -1
			$LevelsLayer.add_child(line)
