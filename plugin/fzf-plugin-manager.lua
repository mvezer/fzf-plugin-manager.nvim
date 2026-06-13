local M = {}

function M.show_plugins()
	local plugin_info = vim.pack.get()
	local plugin_names = {}
	for _, plugin in ipairs(plugin_info) do
		table.insert(plugin_names, plugin.spec.name)
	end
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
		return
	end
	fzf.fzf_exec(plugin_names, {
		prompt = "Plugins (<enter>: open plugin url, <ctrl-u>: update, <ctrl-d>: delete): ",
		actions = {
			["default"] = function(selected_plugin)
				local plugin_specs = vim.pack.get(selected_plugin)
				if #plugin_specs == 0 then
					return
				end
				local url = plugin_specs[1].spec.src
				if url ~= nil then
					M.open_url(url)
				end
			end,
			["ctrl-u"] = function(selected_plugin)
				vim.pack.update(selected_plugin)
			end,
			["ctrl-d"] = function(selected_plugin)
				vim.pack.del(selected_plugin)
			end,
		},
	})
end

function M.open_url(url)
	if vim.fn.has("mac") == 1 then
		vim.fn.system({ "open", url })
	elseif vim.fn.has("unix") == 1 then
		vim.fn.system({ "xdg-open", url })
	elseif vim.fn.has("win32") == 1 then
		vim.fn.system({ "cmd.exe", "/c", "start", url })
	else
		vim.notify("Unsupported operating system", vim.log.levels.ERROR)
		return
	end
end

vim.api.nvim_create_user_command("Plugins", M.show_plugins, {})

return M
