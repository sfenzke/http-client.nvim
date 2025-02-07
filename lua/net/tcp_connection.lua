local tcp_connection = {}
--TODO: Callback for response data

-- doesnt suupport ipv6 right now
tcp_connection.send = function(host, port, data, callback)
	local tcp_handler = vim.uv.new_tcp()

	if not tcp_handler then
		return nil
	end

	local response = {}

	vim.uv.getaddrinfo(host, port, { protocol = "tcp", family = "inet" }, function(name_resolution_error, addresses)
		if name_resolution_error then
			return
		end

		-- TODO: implement multiple ip adresses
		tcp_handler:connect(addresses[1].addr, port, function(network_error)
			if network_error then
				-- TODO: improve error handling
				return
			end

			tcp_handler:write(data)
			tcp_handler:read_start(function(read_error, chunk)
				if read_error then
					callback(read_error, nil)
				elseif chunk then
					table.insert(response, chunk)
				else
					-- if we reached this point it means the reponse has been received in full
					tcp_handler:close()
					if callback then
						callback(nil, table.concat(response, ""))
					end
				end
			end)
		end)
	end)
end

return tcp_connection
