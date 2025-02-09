local HttpResponse = {}

-- Function to create a new HttpResponse object
function HttpResponse:new()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	-- Initialize fields for the response
	obj.protocol = ""
	obj.status_code = ""
	obj.status_message = ""
	obj.headers = {}
	obj.body = ""

	return obj
end

-- Function to parse the response line (e.g., HTTP/1.1 200 OK)
local function parse_response_line(response_line)
	local protocol, status_code, status_message = response_line:match("([%w/]+) (%d%d%d) (.+)")
	return protocol, status_code, status_message
end

-- Function to parse headers (assumes headers are separated by \r\n)
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

-- Function to parse the body based on the content length (or the rest of the response)
local function parse_body(response, headers)
	local body_start = response:find("\r\n\r\n") + 4
	local body = response:sub(body_start)

	-- If there is a 'Content-Length' header, we trim the body to that length
	local content_length = tonumber(headers["content-length"])
	if content_length then
		body = body:sub(1, content_length)
	end

	return body
end

-- Main function to parse the raw HTTP response
function HttpResponse:parse(response)
	-- Split the response into headers and body
	local response_line_end = response:find("\r\n")
	local response_line = response:sub(1, response_line_end - 1)
	local headers_and_body = response:sub(response_line_end + 2)

	-- Parse the response line
	self.protocol, self.status_code, self.status_message = parse_response_line(response_line)

	-- Parse the headers
	local headers = parse_headers(headers_and_body)

	-- Parse the body
	self.body = parse_body(headers_and_body, headers)

	-- Store the parsed headers
	self.headers = headers
end

-- Convert the HttpResponse object into a string representation (useful for debugging)
function HttpResponse:to_string()
	local header_str = ""
	for key, value in pairs(self.headers) do
		header_str = header_str .. key .. ": " .. value .. "\r\n"
	end
	return string.format("%s %s %s\r\n%s\r\n\r\n%s",
		self.protocol,
		self.status_code,
		self.status_message,
		header_str,
		self.body)
end

return HttpResponse
