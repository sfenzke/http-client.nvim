--- **High-Lvel API** HTTP Client Module
-- Provides functions to make HTTP requests using various methods.
-- @module http

local HttpRequestBuilder = require("http.request.builder")
local HttpResponse = require("http.response")
local HttpMethods = require("http.http_methods")

local http = {}

--- Sends an HTTP request and processes the response.
-- @param request The HTTP request object.
-- @param callback Function to handle the response, receives (error, response).
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

--- Constructs and sends an HTTP request.
-- @param method HTTP method (e.g., GET, POST).
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param body The request body (optional).
-- @param is_json Whether the body should be sent as JSON (default: false).
-- @param callback Function to handle the response, receives (error, response).
local function make_request(method, host, uri, port, body, is_json, callback)
	port = port or 80 -- Default to port 80 if not provided

	local builder = HttpRequestBuilder:new()

	if not builder:method(method) then
		callback("Invalid HTTP method", nil)
		return
	end

	builder:uri(uri)
	builder:host(host)
	builder:port(port)

	if body then
		if is_json then
			builder:json_body(body)
		else
			builder:body(body)
		end
	end

	local request = builder:build()
	send_request(request, callback)
end

--- Sends a GET request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param callback Function to handle the response.
function http.get(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.GET, host, uri, port, nil, false, callback)
end

--- Sends a POST request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param body The request body.
-- @param is_json Whether the body should be sent as JSON (default: false).
-- @param callback Function to handle the response.
function http.post(host, uri, port, body, is_json, callback)
	port = port or 80
	is_json = is_json or false
	make_request(HttpMethods.POST, host, uri, port, body, is_json, callback)
end

--- Sends a PUT request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param body The request body.
-- @param is_json Whether the body should be sent as JSON (default: false).
-- @param callback Function to handle the response.
function http.put(host, uri, port, body, is_json, callback)
	port = port or 80
	is_json = is_json or false
	make_request(HttpMethods.PUT, host, uri, port, body, is_json, callback)
end

--- Sends a DELETE request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param body The request body (optional).
-- @param is_json Whether the body should be sent as JSON (default: false).
-- @param callback Function to handle the response.
function http.delete(host, uri, port, body, is_json, callback)
	port = port or 80
	is_json = is_json or false
	make_request(HttpMethods.DELETE, host, uri, port, body, is_json, callback)
end

--- Sends a HEAD request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param callback Function to handle the response.
function http.head(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.HEAD, host, uri, port, nil, false, callback)
end

--- Sends an OPTIONS request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param callback Function to handle the response.
function http.options(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.OPTIONS, host, uri, port, nil, false, callback)
end

--- Sends a TRACE request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param callback Function to handle the response.
function http.trace(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.TRACE, host, uri, port, nil, false, callback)
end

--- Sends a CONNECT request.
-- @param host The target host.
-- @param uri The request URI.
-- @param port The target port (defaults to 80).
-- @param callback Function to handle the response.
function http.connect(host, uri, port, callback)
	port = port or 80
	make_request(HttpMethods.CONNECT, host, uri, port, nil, false, callback)
end

return http
