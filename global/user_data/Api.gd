extends Node2D

var url = "http://127.0.0.1:8000/api/"
@onready var http_request = $HTTPRequest

func _ready():
	http_request.request_completed.connect(_on_request_completed)
	send_request()

func send_request():
	var url_actual = url + "user/"
	var headers = ["Content-Type: application/json"]
  
	var result = http_request.request(url_actual, headers, HTTPClient.METHOD_GET)
	if result == HTTPRequest.RESULT_SUCCESS:
		_on_request_completed(result, http_request.get_status_code(), http_request.get_response_headers(), http_request.get_response_body())
	else:
		print("Request failed:", result)
	
func send_data(data):
	var url_actual = url + "updateStats/"
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	http_request.request(url_actual, headers, HTTPClient.METHOD_POST)
	
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:  # Check for successful response (200 OK)
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json["username"])  # Access username from response if successful
	else:
		print("Error:", response_code)  # Handle non-200 response codes
