# http-client.nvim

## Overview
The `http` module provides a simple interface for making HTTP requests in Lua, specifically for use with Neovim. It relies on Neovim's libuv bindings and is not intended for standalone Lua environments. It allows users to send GET, POST, PUT, DELETE, and other HTTP requests using a straightforward API. Currently, it only has basic and incomplete HTTP/1.1 support.

## Installation

### Lazy
```lua
require('lazy').setup({
  { 'sfenzke/http-client.nvim' }
})
```
## High-Level API Reference

### `http.get(host, uri, port, callback)`
Sends a **GET** request to the specified host and URI.

#### Parameters:
- `host` (string): The server host (e.g., `'localhost'`).
- `uri` (string): The endpoint to request (e.g., `'/path/to/resource'`).
- `port` (string, optional): The port number (default: `'80'`).
- `callback` (function): A function that receives an error (if any) and the response.

#### Example:
```lua
http.get('localhost', '/api/data', '80', function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.status_code)
  print(response.body)
end)
```

---

### `http.post(host, uri, port, body, is_json, callback)`
Sends a **POST** request to the specified host and URI.

#### Parameters:
- `host` (string): The server host.
- `uri` (string): The endpoint to request.
- `port` (string, optional): The port number (default: `'80'`).
- `body` (table|string, optional): The request payload.
- `is_json` (boolean, optional): If `true`, the request body is sent as JSON (default: `false`).
- `callback` (function): A function that receives an error (if any) and the response.

#### Example:
```lua
http.post('localhost', '/api/post', '80', { key = 'value' }, true, function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.status_code)
  print(response.body)
end)
```

---

### `http.put(host, uri, port, body, is_json, callback)`
Sends a **PUT** request to update data.

#### Parameters:
Same as `http.post`.

#### Example:
```lua
http.put('localhost', '/api/update', '80', { name = 'New Name' }, true, function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.status_code)
  print(response.body)
end)
```

---

### `http.delete(host, uri, port, body, is_json, callback)`
Sends a **DELETE** request.

#### Parameters:
Same as `http.post`, though `body` is optional.

#### Example:
```lua
http.delete('localhost', '/api/delete', '80', nil, false, function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.status_code)
end)
```

---

### `http.head(host, uri, port, callback)`
Sends a **HEAD** request to retrieve headers.

#### Example:
```lua
http.head('localhost', '/api/info', '80', function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.headers)
end)
```

---

### `http.options(host, uri, port, callback)`
Sends an **OPTIONS** request to determine supported HTTP methods.

#### Example:
```lua
http.options('localhost', '/api/info', '80', function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.headers)
end)
```

---

### `http.trace(host, uri, port, callback)`
Sends a **TRACE** request for debugging.

#### Example:
```lua
http.trace('localhost', '/api/trace', '80', function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.body)
end)
```

---

### `http.connect(host, uri, port, callback)`
Sends a **CONNECT** request.

#### Example:
```lua
http.connect('localhost', '/api/connect', '80', function(err, response)
  if err then
    print("Error:", err)
    return
  end
  print(response.body)
end)
```

## Low-Level API Reference

### `HttpRequest`
Represents an HTTP request.

#### Methods:
- `HttpRequest:new()`: Creates a new request instance.
- `HttpRequest:to_string()`: Converts the request to a string format.
- `HttpRequest:send(callback)`: Sends the request asynchronously.

### `HttpResponse`
Represents an HTTP response.

#### Methods:
- `HttpResponse:new()`: Creates a new response instance.
- `HttpResponse:parse(response)`: Parses a raw HTTP response string.
- `HttpResponse:to_string()`: Converts the response to a string format.

### `HttpRequestBuilder`
Used to construct HTTP requests in a structured manner.

#### Methods:
- `HttpRequestBuilder:new()`: Creates a new builder instance.
- `HttpRequestBuilder:method(method)`: Sets the HTTP method.
- `HttpRequestBuilder:uri(uri)`: Sets the request URI.
- `HttpRequestBuilder:host(host)`: Sets the request host.
- `HttpRequestBuilder:port(port)`: Sets the request port.
- `HttpRequestBuilder:add_header(key, value)`: Adds an HTTP header.
- `HttpRequestBuilder:body(body)`: Sets the request body.
- `HttpRequestBuilder:json_body(obj)`: Sets the request body as JSON.
- `HttpRequestBuilder:build()`: Constructs the final HTTP request.

The `HttpRequestBuilder` implements the Cloneable trait, allowing users to prepare a template request, clone it, finalize its configuration, and then build a new `HttpRequest` from it.

## Response Object
The callback function receives an **error** (if any) and a **response object**.

## License
This project is licensed under the MIT License.

## Contributing
Feel free to submit issues or contribute improvements!
