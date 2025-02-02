local HttpRequestBuilder = {}

local cloneable = require("utils.cloneable")
local HttpMethods = require("http.http_methods")
local HttpRequest = require("http.request.request")

function HttpRequestBuilder:new()
	local o = {}

	setmetatable(HttpRequestBuilder, { __index = cloneable })
	HttpRequestBuilder.__index = HttpRequestBuilder
	setmetatable(o, HttpRequestBuilder)

	o.http_request = HttpRequest:new()

	return o
end

-- return self on success or nil on failure
function HttpRequestBuilder:method(method)
	if HttpMethods[method] then
		self.http_request.method = HttpMethods[method]
		return self
	else
		return nil
	end
end

function HttpRequestBuilder:uri(uri)
	self.http_request.uri = uri
	return self
end

function HttpRequestBuilder:host(host)
	self.http_request.host = host
	return self
end

function HttpRequestBuilder:port(port)
	self.http_request.port = port
	return self
end

function HttpRequestBuilder:add_header(key, value)
	self.http_request.headers[key] = value

	return self
end

function HttpRequestBuilder:body(body)
	self.http_request.body = body
	self:add_header("Content-Length", string.len(body))

	return self
end

--- Takes an object, json encodes it and sets it as the body of the request.
--- Also adds the HTTP headder "Content-Type": "application/json"
function HttpRequestBuilder:json_body(obj)
	self:add_header("Content-Type", "application/json")

	self:body(vim.json.encode(obj))

	return self
end

function HttpRequestBuilder:build()
	return self.http_request
end

return HttpRequestBuilder
