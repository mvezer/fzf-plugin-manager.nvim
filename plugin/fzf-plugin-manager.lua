local M = {}

local function get_all_plugin_names()
	local plugins_names = {}
	local all_plugin_specs = vim.pack.get()
	for _, plugin_spec in ipairs(all_plugin_specs) do
		if plugin_spec.active then
			table.insert(plugins_names, plugin_spec.spec.name)
		end
	end
	return plugins_names
end

local function on_pack_changed(pack_changed_event)
	local name, kind = pack_changed_event.data.spec.name, pack_changed_event.data.kind
	if kind == "remove" then
		vim.notify("Plugin " .. name .. " was removed", vim.log.levels.INFO)
	elseif kind == "install" then
		vim.notify("Plugin " .. name .. " was installed", vim.log.levels.INFO)
	elseif kind == "update" then
		vim.notify("Plugin " .. name .. " was updated", vim.log.levels.INFO)
	end
end

function M.update_all_plugins()
	vim.pack.update(get_all_plugin_names())
end

function M.show_plugins()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
		return
	end
	fzf.fzf_exec(get_all_plugin_names(), {
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

vim.api.nvim_create_autocmd("PackChanged", { callback = on_pack_changed })

return M
