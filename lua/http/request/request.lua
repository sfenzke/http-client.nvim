--- **Low-Level API** Defines an HTTP request.
-- @classmod http.request.HttpRequest
-- @field method string Method this request uses (e.g., "GET", "POST").
-- @field uri string URI to request.
-- @field host string Host to request from.
-- @field port string Port number (default "80").
-- @field headers table<string, string> List of key-value pairs representing the HTTP headers. See RFC 2616 for a description of valid HTTP/1.1 headers.
-- @field body string Body of the request.
local HttpRequest = {}

local tcp_connection = require("net.tcp_connection")
local cloneable = require("utils.cloneable")

--- Creates a new instance of HttpRequest.
-- @return HttpRequest A new HttpRequest instance.
function HttpRequest:new()
	local obj = {}

	setmetatable(HttpRequest, { __index = cloneable })
	HttpRequest.__index = HttpRequest
	setmetatable(obj, HttpRequest)

	obj.method = ""
	obj.uri = ""
	obj.host = ""
	obj.port = "80"
	obj.headers = {}
	obj.body = ""

	return obj
end

--- Builds the request line.
-- @param method string The HTTP method.
-- @param uri string The request URI.
-- @return string The formatted request line.
local function build_request_line(method, uri)
	return string.format("%s %s HTTP/1.1", method, uri)
end

--- Builds the HTTP headers.
-- @param headers table<string, string> The headers to format.
-- @return string The formatted headers as a string.
local function build_headers(headers)
	local t = {}
	for key, value in pairs(headers) do
		if value then
			t[#t + 1] = string.format("%s: %s", key, value)
		else
			t[#t + 1] = key
		end
	end

	return table.concat(t, "\r\n")
end

--- Converts the HttpRequest to a string representation.
-- @return string The full HTTP request as a string.
function HttpRequest:to_string()
	return string.format(
		"%s\r\nHost: %s\r\n%s\r\n\r\n%s",
		build_request_line(self.method, self.uri),
		self.host,
		build_headers(self.headers),
		self.body
	)
end

--- Sends the HTTP request.
-- @param callback function A function to handle the response. It receives (err: string|nil, response: string|nil).
-- @return nil
function HttpRequest:send(callback)
	if not self.host then
		callback("host may not be empty", nil)
		return nil
	end

	tcp_connection.send(self.host, self.port, self:to_string(), callback)
end

return HttpRequest
