local tcp_connection = {}
--TODO: Callback for response data

tcp_connection.send = function(ip, port, data, callback)
	local tcp_handler = vim.uv.new_tcp()

	if not tcp_handler then
		return nil
	end

	tcp_handler:connect(ip, port, function(err)
		-- TODO: Error handling
		tcp_handler:write(data)
		tcp_handler:read_start(function(read_error, chunk)
			if read_error then
				--TODO: Error handling
			elseif chunk then
				if callback then
					callback(chunk)
				end
			else
				tcp_handler:close()
			end
		end)
	end)
end

return tcp_connection
