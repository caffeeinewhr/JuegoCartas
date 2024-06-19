extends HTTPRequest

const BASE_URL := "https://webgato.onrender.com/api/"

var validating_username: String
var request_queue = []
var is_requesting = false
var is_validated = false
var is_updated = false

signal user_validation_completed(success: bool)
signal user_update_completed(success: bool)
signal user_stats_retrieved(success: bool, stats: Dictionary)

func _ready():
	connect("request_completed", Callable(self, "_on_request_completed"))

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

func validate_user(username: String, password: String):
	print("Request validate")
	validating_username = username
	var json_data = {
		"username": username,
		"password": password
	}
	# Changed METHOD_GET to METHOD_POST to allow body in the request
	make_request("user_exists/", HTTPClient.METHOD_POST, json_data)

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

func get_user_stats(username: String):
	print("Request get user stats")
	var json_data = {
		"username": username
	}
	# Changed METHOD_GET to METHOD_POST to allow body in the request
	make_request("get_user_stats/", HTTPClient.METHOD_POST, json_data)

func _on_request_completed(result, response_code, _headers, body):
	is_requesting = false
	var body_str = body.get_string_from_utf8()
	print("Response body: ", body_str)
	
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
				else:
					print("User does not exist.")
				emit_signal("user_validation_completed", is_validated)
			elif "updated" in response_dict:
				is_updated = response_dict["updated"]
				print("User stats updated:", is_updated)
				emit_signal("user_update_completed", is_updated)
			elif "retrieved" in response_dict and response_dict["retrieved"]:
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
