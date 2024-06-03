extends Node2D

func _ready() -> void:
	godotLog("READY JE JE JE")
	fetch_user_data()
	await get_tree().create_timer(1.0).timeout
	if GlobalData.user_id != -1:
		print("User ID:", GlobalData.user_id)
		godotLog("User ID:" + str(GlobalData.user_id))

func fetch_user_data() -> void:
	godotLog("Fetch user data")
	var api_url = "http://127.0.0.1:8000/api/user/"
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._on_request_completed)

	var response = http_request.request(api_url)
	if response != OK:
		print("Error fetching user data: ", response)
		godotLog("Error fetching user data: " + response)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	godotLog("Request completed")
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result.error == OK:
			var user_data = parse_result.result
			GlobalData.user_id = user_data["id"]
			GlobalData.username = user_data["username"]
			print("User ID fetched: ", GlobalData.user_id)
			godotLog("User ID fetched: " + str(GlobalData.user_id))
		else:
			print("Error parsing JSON: ", parse_result.error_string)
			godotLog("Error parsing JSON: " + parse_result.error_string)
	else:
		print("Error fetching data: ", response_code)
		godotLog("Error fetching data: " + str(response_code))
	godotLog("End")
	
func godotLog(message: String):
	var js_code = "console.log('" + message + "')"
	JavaScriptBridge.eval(js_code, 0)
