--- **Low-Level API** HTTP Methods Module
-- Provides a table of standard HTTP methods.
-- @module http_methods

local HttpMethods = {
	--- HTTP OPTIONS method.
	-- Used to describe communication options for the target resource.
	-- @field OPTIONS
	OPTIONS = "OPTIONS",

	--- HTTP GET method.
	-- Used to request a representation of the specified resource.
	-- @field GET
	GET = "GET",

	--- HTTP HEAD method.
	-- Similar to GET but only retrieves headers.
	-- @field HEAD
	HEAD = "HEAD",

	--- HTTP POST method.
	-- Used to submit data to be processed to a specified resource.
	-- @field POST
	POST = "POST",

	--- HTTP PUT method.
	-- Used to update or create a resource.
	-- @field PUT
	PUT = "PUT",

	--- HTTP DELETE method.
	-- Used to delete the specified resource.
	-- @field DELETE
	DELETE = "DELETE",

	--- HTTP TRACE method.
	-- Used to perform a message loop-back test.
	-- @field TRACE
	TRACE = "TRACE",

	--- HTTP CONNECT method.
	-- Used to establish a tunnel to the server.
	-- @field CONNECT
	CONNECT = "CONNECT",
}

return HttpMethods
