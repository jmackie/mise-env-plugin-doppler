local cmd = require("cmd")
local strings = require("strings")

local function shell_quote(value)
    if value == nil then
        return "''"
    end
    local escaped = tostring(value):gsub("'", "'\"'\"'")
    return "'" .. escaped .. "'"
end

local function strip_quotes(value)
    if value == nil then
        return ""
    end
    local len = #value
    if len >= 2 then
        local first = value:sub(1, 1)
        local last = value:sub(len, len)
        if (first == '"' and last == '"') or (first == "'" and last == "'") then
            return value:sub(2, len - 1)
        end
    end
    return value
end

local function parse_env_output(output)
    local env_vars = {}
    for line in output:gmatch("[^\r\n]+") do
        local trimmed = strings.trim_space(line)
        -- Assumes doppler --format env outputs plain KEY=VALUE lines without export or comments.
        if trimmed ~= "" then
            local eq = trimmed:find("=", 1, true)
            if eq then
                local key = strings.trim_space(trimmed:sub(1, eq - 1))
                local value = strings.trim_space(trimmed:sub(eq + 1))
                value = strip_quotes(value)
                if key ~= "" then
                    table.insert(env_vars, { key = key, value = value })
                end
            end
        end
    end
    return env_vars
end

--- Returns environment variables to set when this plugin is active
--- Documentation: https://mise.jdx.dev/env-plugin-development.html#miseenv-hook
--- @param ctx MiseEnvCtx Context (options = plugin configuration from mise.toml)
--- @return MiseEnvResult
function PLUGIN:MiseEnv(ctx)
    local options = ctx.options or {}
    local project = options.project or error("doppler plugin requires 'project' in mise.toml")
    local config = options.config or error("doppler plugin requires 'config' in mise.toml")
    local bin = options.bin or "doppler"
    local cacheable = options.cacheable
    if cacheable == nil then
        cacheable = true
    end

    local command = table.concat({
        shell_quote(bin),
        "secrets",
        "download",
        "--project",
        shell_quote(project),
        "--config",
        shell_quote(config),
        "--no-file",
        "--format",
        "env",
    }, " ")

    local output = cmd.exec(command)
    local env_vars = parse_env_output(output)

    return {
        cacheable = cacheable,
        env = env_vars,
    }
end
