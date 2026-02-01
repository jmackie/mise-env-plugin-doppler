--!strict
local Types = require("@lib/types")

local plugin = PLUGIN :: Types.PluginType

--- Returns environment variables to set when this plugin is active
--- Documentation: https://mise.jdx.dev/dev-tools/backends/vfox.html
function plugin:MiseEnv(ctx: { env: { [string]: string } }): { [string]: string }
	-- Access current environment variables
	local _env = ctx.env

	-- Return map of environment variables to set
	local result: { [string]: string } = {}

	-- Example: Static environment variable
	result["MY_ENV_VAR"] = "my_value"

	-- Example: Dynamic environment variable based on existing env
	--[[
	if _env["HOME"] then
		result["MY_CONFIG_DIR"] = `{_env["HOME"]}/.config/my-tool`
	end
	--]]

	-- Example: Conditional environment variable
	--[[
	if not _env["MY_API_KEY"] then
		result["MY_API_KEY"] = "default_key"
	end
	--]]

	return result
end
