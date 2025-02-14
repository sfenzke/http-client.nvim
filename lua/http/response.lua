--- **Low-Level API** HTTP Response Module
-- Provides functionality to parse and represent HTTP responses.
-- @classmod http.HttpResponse

local HttpResponse = {}

--- Creates a new HttpResponse object.
-- @return HttpResponse A new instance of HttpResponse.
function HttpResponse:new()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	--- The HTTP protocol version (e.g., HTTP/1.1).
	-- @field string protocol
	obj.protocol = ""

	--- The HTTP status code (e.g., 200, 404).
	-- @field string status_code
	obj.status_code = ""

	--- The HTTP status message (e.g., OK, Not Found).
	-- @field string status_message
	obj.status_message = ""

	--- The response headers as a table.
	-- @field table headers
	obj.headers = {}

	--- The response body.
	-- @field string body
	obj.body = ""

	return obj
end

--- Parses the response line (e.g., HTTP/1.1 200 OK).
-- @param response_line string The response line string.
-- @return string protocol, string status_code, string status_message
local function parse_response_line(response_line)
	local protocol, status_code, status_message = response_line:match("([%w/]+) (%d%d%d) (.+)")
	return protocol, status_code, status_message
end

--- Parses the response headers.
-- @param header_string string The raw header string.
-- @return table A table containing the parsed headers.
local function parse_headers(header_string)
	local headers = {}
	for line in header_string:gmatch("([^\r\n]+)") do
		local key, value = line:match("([%w-%s]+):%s*(.+)")
		if key then
			headers[key:lower()] = value
		end
	end
	return headers
end

--- Parses the response body based on headers.
-- @param response string The full raw response string.
-- @param headers table The parsed headers table.
-- @return string The extracted response body.
local function parse_body(response, headers)
	local body_start = response:find("\r\n\r\n") + 4
	local body = response:sub(body_start)

	local content_length = tonumber(headers["content-length"])
	if content_length then
		body = body:sub(1, content_length)
	end

	return body
end

--- Parses a raw HTTP response string into an HttpResponse object.
-- @param response string The raw HTTP response string.
function HttpResponse:parse(response)
	local response_line_end = response:find("\r\n")
	local response_line = response:sub(1, response_line_end - 1)
	local headers_and_body = response:sub(response_line_end + 2)

	self.protocol, self.status_code, self.status_message = parse_response_line(response_line)
	local headers = parse_headers(headers_and_body)
	self.body = parse_body(headers_and_body, headers)
	self.headers = headers
end

--- Converts the HttpResponse object into a string representation.
-- @return string A string representation of the HTTP response.
function HttpResponse:to_string()
	local header_str = ""
	for key, value in pairs(self.headers) do
		header_str = header_str .. key .. ": " .. value .. "\r\n"
	end
	return string.format(
		"%s %s %s\r\n%s\r\n\r\n%s",
		self.protocol,
		self.status_code,
		self.status_message,
		header_str,
		self.body
	)
end

return HttpResponse
