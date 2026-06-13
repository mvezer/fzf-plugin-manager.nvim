local M = {}

local get_all_plugins = function()
	local plugins = {}
	for _, plugin in ipairs(vim.api.nvim_list_runtime_paths()) do
		local plugin_name = vim.fn.fnamemodify(plugin, ":t")
		if plugin_name ~= "packer.nvim" then
			table.insert(plugins, plugin_name)
		end
	end
	return plugins
end

function M.update_all_plugins()
	vim.pack.update(get_all_plugins())
end

function M.show_plugins()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
		return
	end
	fzf.fzf_exec(get_all_plugins(), {
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

vim.api.nvim_create_user_command("UpdateAllPlugins", M.update_all_plugins, {})

return M
