local tcp_connection = require("net.tcp_connection")
local cloneable = require("utils.cloneable")

--- Defines a http request
-- @field method method this request uses
-- @field uri uri to request
-- @field host host to request from
-- @field headers list of key-value pairs representing th http headers see RFC 2616 for a description of valid HTTP/1.1 headers
-- @field body body of the request
local HttpRequest = {}

--- Creates a new instance of HttpRequest
-- @return new HttpRequest instance
function HttpRequest:new()
	local obj = {}

	setmetatable(HttpRequest, { __index = cloneable })
	HttpRequest.__index = HttpRequest
	setmetatable(obj, HttpRequest)

	obj._method = ""
	obj._uri = ""
	obj.host = ""
	obj.headers = {}
	obj.body = ""

	return obj
end

local function build_request_line(method, uri)
	return string.format("%s %s HTTP/1.1", method, uri)
end

local function build_headers(headers)
	local t = {}
	for key, value in pairs(headers) do
		if value then
			t[#t + 1] = string.format("%s: %s", key, value)
		else
			t[#t + 1] = key
		end
	end

	return table.concat(t, "\n")
end

function HttpRequest:to_string()
	return string.format(
		[[%s
Host:%s
%s

%s]],
		build_request_line(self.method, self.uri),
		self.host,
		build_headers(self.headers),
		self.body
	)
end

--- Sends the request to the server defined in the host field.
-- Host must be in the form of an ip and optionally a port separated by :
-- if the optional port is not in the host the default port for http 80 will be used to send the data
-- @param callback optional callback which gets called when there is response data
-- @return nil on error
function HttpRequest:send(callback)
	local ip, port = string.match(self.host, "(%d+%.%d+%.%d+%.%d+):?(%d*)")

	if not ip then
		--TODO: improve error handling
		return nil
	end

	if port then
		tcp_connection.send(ip, port, self:to_string(), callback)
	else
		tcp_connection.send(ip, 80, self:to_string(), callback)
	end
end

return HttpRequest
