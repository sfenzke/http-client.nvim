--- **Low-Level API** Builder for a HTTP-Request object.
-- @classmod request.builder.HttpRequestBuilder
local HttpRequestBuilder = {}

local cloneable = require("utils.cloneable")
local HttpMethods = require("http.http_methods")
local HttpRequest = require("http.request.request")

--- Creates a new instance of HttpRequestBuilder.
-- @return HttpRequestBuilder A new HttpRequestBuilder instance.
function HttpRequestBuilder:new()
	local o = {}

	setmetatable(HttpRequestBuilder, { __index = cloneable })
	HttpRequestBuilder.__index = HttpRequestBuilder
	setmetatable(o, HttpRequestBuilder)

	o.http_request = HttpRequest:new()

	return o
end

--- Sets the HTTP method.
-- @param method string The HTTP method (e.g., "GET", "POST").
-- @return HttpRequestBuilder|nil The builder instance on success, or nil on failure.
function HttpRequestBuilder:method(method)
	if HttpMethods[method] then
		self.http_request.method = HttpMethods[method]
		return self
	else
		return nil
	end
end

--- Sets the request URI.
-- @param uri string The request URI.
-- @return HttpRequestBuilder The builder instance.
function HttpRequestBuilder:uri(uri)
	self.http_request.uri = uri
	return self
end

--- Sets the request host.
-- @param host string The request host.
-- @return HttpRequestBuilder The builder instance.
function HttpRequestBuilder:host(host)
	self.http_request.host = host
	return self
end

--- Sets the request port.
-- @param port string The request port.
-- @return HttpRequestBuilder The builder instance.
function HttpRequestBuilder:port(port)
	self.http_request.port = port
	return self
end

--- Adds a header to the request.
-- @param key string The header name.
-- @param value string The header value.
-- @return HttpRequestBuilder The builder instance.
function HttpRequestBuilder:add_header(key, value)
	self.http_request.headers[key] = value
	return self
end

--- Sets the request body.
-- @param body string The request body.
-- @return HttpRequestBuilder The builder instance.
function HttpRequestBuilder:body(body)
	self.http_request.body = body
	self:add_header("Content-Length", string.len(body))
	return self
end

--- Encodes an object as JSON and sets it as the request body.
-- Also adds the HTTP header "Content-Type": "application/json".
-- @param obj table The object to encode.
-- @return HttpRequestBuilder The builder instance.
function HttpRequestBuilder:json_body(obj)
	self:add_header("Content-Type", "application/json")
	self:body(vim.json.encode(obj))
	return self
end

--- Builds and returns the HTTP request.
-- @return HttpRequest The built HTTP request.
function HttpRequestBuilder:build()
	return self.http_request
end

return HttpRequestBuilder
