extends HTTPRequest

const BASE_URL := "http://127.0.0.1:8000/api/"

var validating_username: String
var request_queue = []
var is_requesting = false

# Status variables
var is_validated = false
var is_updated = false

signal user_validation_completed(success: bool)
signal user_update_completed(success: bool)
signal user_stats_retrieved(success: bool, stats: Dictionary)

func _ready():
	connect("request_completed", Callable(self, "_on_request_completed"))

# Common method for making HTTP requests
func make_request(endpoint: String, method: int, data: Dictionary):
	var request = {
		"endpoint": endpoint,
		"method": method,
		"data": data
	}
	request_queue.append(request)
	process_next_request()

func process_next_request():
	if not is_requesting and request_queue.size() > 0:
		is_requesting = true
		var request = request_queue.pop_front()
		var url = BASE_URL + request.endpoint
		var request_data = JSON.stringify(request.data).to_utf8_buffer()
		var headers = ["Content-Type: application/json"]
		print("Sending request to URL: ", url)
		print("Request data: ", request_data.get_string_from_utf8())
		request_raw(url, headers, request.method, request_data)

# Validate User
func validate_user(username: String, password: String):
	print("Request validate")
	validating_username = username
	var json_data = {
		"username": username,
		"password": password
	}
	make_request("user_exists/", HTTPClient.METHOD_GET, json_data)

# Update User Stats
func update_user_stats():
	print("Request update")
	var json_data = {
		"username": GlobalData.username,
		"stats": {
			"playtime": GlobalData.playtime,
			"levels_completed": GlobalData.completed_levels.size(),
			"kills": GlobalData.kills,
			"deaths": GlobalData.deaths
		}
	}
	make_request("update_user_stats/", HTTPClient.METHOD_POST, json_data)

# Retrieve User Stats
func get_user_stats(username: String):
	print("Request get user stats")
	var json_data = {
		"username": username
	}
	make_request("get_user_stats/", HTTPClient.METHOD_GET, json_data)

func _on_request_completed(result, response_code, _headers, body):
	is_requesting = false
	var body_str = body.get_string_from_utf8()
	print("Response body: ", body_str)  # Print the response body for debugging
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body_str)
		if parse_result == OK:
			var response_dict = json.get_data()
			if "exists" in response_dict:
				is_validated = response_dict["exists"]
				if is_validated:
					GlobalData.username = validating_username
					print("User exists. GlobalData.username updated to: ", GlobalData.username)
					update_user_stats()
				else:
					print("User does not exist.")
				emit_signal("user_validation_completed", is_validated)
			elif "updated" in response_dict:
				is_updated = response_dict["updated"]
				print("User stats updated:", is_updated)
				emit_signal("user_update_completed", is_updated)
			elif "success" in response_dict and response_dict["success"]:
				if "stats" in response_dict:
					var stats = response_dict["stats"]
					print("User stats retrieved: ", stats)
					emit_signal("user_stats_retrieved", true, stats)
			else:
				print("Request failed with response code: ", response_code)
				emit_signal("user_stats_retrieved", false, {})
		else:
			print("Failed to parse JSON response: ", json.error_string)
	else:
		print("Request failed with response code: ", response_code)
	process_next_request()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		update_user_stats()
