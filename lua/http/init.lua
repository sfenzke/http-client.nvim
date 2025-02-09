local HttpRequestBuilder = require("http.request.builder")
local HttpResponse = require("http.response")
local HttpMethods = require("http.http_methods")

local http = {}

-- Helper function to send the request and handle the response
local function send_request(request, callback)
	request:send(function(error, response_raw)
		if error then
			callback(error, nil)
		end

		local response = HttpResponse:new()
		response:parse(response_raw)
		callback(error, response)
	end)
end

-- Generic function to handle requests
local function make_request(method, host, uri, port, body, is_json, callback)
	port = port or 80 -- Default to port 80 if not provided

	-- Use the HttpRequestBuilder to build the request
	local builder = HttpRequestBuilder:new()

	-- Set the method
	if not builder:method(method) then
		callback("Invalid HTTP method", nil)
		return
	end

	-- Set the URI, host, and port
	builder:uri(uri)
	builder:host(host)
	builder:port(port)

	-- Set the body based on the is_json flag
	if body then
		if is_json then
			builder:json_body(body)
		else
			builder:body(body)
		end
	end

	-- Build the request and send it
	local request = builder:build()
	send_request(request, callback)
end

-- GET request
function http.get(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.GET, host, uri, port, nil, false, callback)
end

-- POST request
function http.post(host, uri, port, body, is_json, callback)
	port = port or 80
	is_json = is_json or false
	make_request(HttpMethods.POST, host, uri, port, body, is_json, callback)
end

-- PUT request
function http.put(host, uri, port, body, is_json, callback)
	port = port or 80
	is_json = is_json or false
	make_request(HttpMethods.PUT, host, uri, port, body, is_json, callback)
end

-- DELETE request
function http.delete(host, uri, port, body, is_json, callback)
	port = port or 80
	is_json = is_json or false
	make_request(HttpMethods.DELETE, host, uri, port, body, is_json, callback)
end

-- HEAD request
function http.head(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.HEAD, host, uri, port, nil, false, callback)
end

-- OPTIONS request
function http.options(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.OPTIONS, host, uri, port, nil, false, callback)
end

-- TRACE request
function http.trace(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.TRACE, host, uri, port, nil, false, callback)
end

-- CONNECT request
function http.connect(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.CONNECT, host, uri, port, nil, false, callback)
end

return http
