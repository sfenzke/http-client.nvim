HttpRequestBuilder = {}

HttpRequestBuilder._http_methods = {
	OPTIONS = "OPTIONS",
	GET = "GET",
	HEAD = "HEAD",
	POST = "POST",
	PUT = "PUT",
	DELETE = "DELETE",
	TRACE = "TRACE",
	CONNECT = "CONNECT",
}

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

function HttpRequestBuilder:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self._method = ""
	self._uri = ""
	self._host = ""
	self._headers = {}
	self._body = ""

	return o
end

-- return self on success or nil on failure
function HttpRequestBuilder:method(method)
	if self._http_methods[method] then
		self._method = self._http_methods[method]
		return self
	else
		return nil
	end
end

function HttpRequestBuilder:uri(uri)
	self._uri = uri
	return self
end

function HttpRequestBuilder:host(host)
	self._host = host
	return self
end

function HttpRequestBuilder:add_header(
	--[[required]]
	key,
	--[[optional]]
	value
)
	if key then
		self._headers[key] = value
	else
		self._headers[key] = nil
	end

	return self
end

function HttpRequestBuilder:body(body)
	self._body = body
end

function HttpRequestBuilder:json_body(obj)
	self._body = vim.json.encode(obj)
end

function HttpRequestBuilder:build()
	return string.format(
		[[%s
Host:%s
%s

%s]],
		build_request_line(self._method, self._uri),
		self._host,
		build_headers(self._headers),
		self._body
	)
end
