extends Node2D

var database: SQLite
var path = "C:/Users/Marco/Documents/GameDev/TFG/WebGato-main/WebGato-main/db.sqlite3"
var api_url = "http://127.0.0.1:8000/api/user/"

func _ready() -> void:
	database = SQLite.new()
	database.path = path
	database.open_db()

	fetch_user_data(api_url)
	await get_tree().create_timer(1.0).timeout
	if GlobalData.user_id != -1:
		print("User ID:", GlobalData.user_id)
		update_user_stats()

func fetch_user_data(api_url: String) -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._on_request_completed)

	var response = http_request.request(api_url)
	if response != OK:
		print("Error fetching user data: ", response)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result.error == OK:
			var user_data = parse_result.result
			GlobalData.user_id = user_data["id"]
			GlobalData.username = user_data["username"]
			print("User ID fetched: ", GlobalData.user_id)
		else:
			print("Error parsing JSON: ", parse_result.error_string)
	else:
		print("Error fetching data: ", response_code)

func update_user_stats() -> void:
	var query_string = "UPDATE stats_userstats SET playtime = ?, levels_completed = ?, kills = ?, deaths = ? WHERE user_id = ?"
	var params = [GlobalData.playtime, GlobalData.completed_levels.size(), GlobalData.kills, GlobalData.deaths, GlobalData.user_id]
	var query_result = database.query_with_args(query_string, params)
	if query_result != OK:
		print("Error updating user stats:", query_result)
	else:
		print("User stats updated for user ID:", GlobalData.user_id)
