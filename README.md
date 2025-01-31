# http-client.nvim
This is a basic http-client library for Neovim. It uses the internal bindings to libuv for network communication.
There is only basic and incomplete HTTP/1.1 support at the moment.

## Cloneable trait
This library implements a cloneable trait so that objects which inherits them are able to be deep copied. Every field of the inheriting object must be either cloenable by itself, a string or a primitive. Since strings areimmutable in LUA by design we don't need to copy them.
Example:
```lua
local Cloneable = require("utils.cloneable")

local Example = {}

function Example:new()
    local obj = {}

    setmetatable(Example, Cloneable, { __index = Cloneable })
    Example.__index = Example
    setmetatable(obj, Example)

    example_primitive = true
    example_string = "example"
    obj.example_table = {}
    setmetatable(obj.example_table, { __index = Cloneable })
end
```

The example above would be cloneable since itself inherits the Cloneable trait and all it's field are primitives, string or cloneable by themself.

## Creating a new http request

A HTTP-Request can be constructed usig the http.request.builder module.
It implents the builder pattern so th contruction methods can be chained.

The Builder implements the Cloneable trait which makes it possible to prepare a template request, clone it finish it's configuration and the build a new HttpRequest out of it.

### Builder Methods
- method
    Sets the HTTP Method. Can be on of the value provided in the *http.http_methods* module.

- uri
Sets th uri to request from the server.

- host
Sets the host to send the request to. **must** be provided in IP at the moment since there is no DNS-resolution implemented yet.
A port can be added optionally separated from the ip by a ":"
Example: `127.0.0.1:8080`

- add_header
Adds a new header to the table of headers. Refer to RFC 2616 for valid headers.
    - arguments:
        - key: the key of the header.
        - value: value of the header.

- body
Sets the body of the request. Also sets the Cotent-Size header to the size of the body.

- body_json
Accepts a table, encodes it into json and sets it as the body of the request. Also sets the Cotent-Size header to the size of the body and the Content-Type header to application/json.

- build
Returns the HttpRequest instance which got configured by the builder.

### HttpRequest methods
- send
Sends the request to the host configured.
 - arguments: 
    - callback: *optional* a function which gets called whenever there is response data fort this request available. It gets passed one argument which contains either a chunk of the the response or nil if the response reached EOF

## Response Parsing
**Not yet implemented**
