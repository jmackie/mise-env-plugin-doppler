--!strict
local Types = require("@lib/types")

local plugin = PLUGIN :: Types.PluginType

--- Returns PATH entries to prepend when this plugin is active
--- Documentation: https://mise.jdx.dev/dev-tools/backends/vfox.html
function plugin:MisePath(ctx: { env: { [string]: string } }): { string }
	-- Access current environment variables
	local _env = ctx.env

	-- Return list of paths to prepend to PATH
	local paths: { string } = {}

	-- Example: Add a computed path
	--[[
	if _env["HOME"] then
		table.insert(paths, `{_env["HOME"]}/.local/bin`)
	end
	--]]

	-- Example: Add a static path
	-- table.insert(paths, "/opt/my-tool/bin")

	return paths
end
