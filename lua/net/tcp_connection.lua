local tcp_connection = {}

tcp_connection.send = function(host, port, data, callback)
	local response = {}

	-- Resolve hostname to an IP address
	vim.uv.getaddrinfo(host, tostring(port), { protocol = "tcp", family = "inet" },
		function(name_resolution_error, addresses)
			if name_resolution_error then
				if callback then callback("DNS resolution error: " .. name_resolution_error, nil) end
				return
			end

			if not addresses or #addresses == 0 then
				if callback then callback("No addresses found for host", nil) end
				return
			end

			-- Function to attempt connection to each address sequentially
			local function try_connect(index)
				if index > #addresses then
					if callback then callback("Failed to connect to any resolved address", nil) end
					return
				end

				local addr = addresses[index].addr

				-- Create a new TCP handle for each attempt
				local tcp_handler = vim.uv.new_tcp()
				if not tcp_handler then
					if callback then callback("Failed to create TCP handle", nil) end
					return
				end

				-- Attempt connection
				tcp_handler:connect(addr, port, function(network_error)
					if network_error then
						-- Close the failed handler before retrying
						tcp_handler:close()
						try_connect(index + 1) -- Try the next address
						return
					end

					-- Successfully connected, send data
					tcp_handler:write(data, function(write_error)
						if write_error then
							tcp_handler:close()
							if callback then
								callback("Failed to send data: " .. write_error,
									nil)
							end
							return
						end

						-- Start reading response
						tcp_handler:read_start(function(read_error, chunk)
							if read_error then
								tcp_handler:close()
								if callback then
									callback("Read error: " .. read_error,
										nil)
								end
								return
							elseif chunk then
								table.insert(response, chunk)
							else
								-- Reading finished, call the callback
								tcp_handler:close()
								if callback then callback(nil, table.concat(response, "")) end
							end
						end)
					end)
				end)
			end

			-- Start trying connections
			try_connect(1)
		end)
end

return tcp_connection
