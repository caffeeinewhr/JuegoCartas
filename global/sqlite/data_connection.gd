extends Node2D

var database: SQLite
var path = "C:/Users/Marco/Documents/GameDev/TFG/WebGato/db.sqlite3"

func _ready():
	database = SQLite.new()
	database.path = path
	database.open_db()

	var username = get_username_from_url()
	if username:
		print("Username:", username)
		#update_user_stats(username)

func get_username_from_url() -> String:
	var query_string = OS.get_cmdline_args()
	var url_params = ""
	for arg in query_string:
		if "?" in arg:
			url_params = arg.substr(arg.find("?") + 1)
			break
	
	if url_params == "":
		return ""
	
	var params = url_params.split("&")
	for param in params:
		var key_value = param.split("=")
		if key_value.size() == 2 and key_value[0] == "username":
			return key_value[1]
	
	return ""

#func update_user_stats(username: String):
	#var query = "SELECT * FROM userAuth_user WHERE username = '%s'" % username
	#var result = database.query(query)
	#
	#if result.size() > 0:
		#var user = result[0]
		#print(user)
		## Your logic to update the stats
