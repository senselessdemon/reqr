local DESCEND_STR = "/"
local BEGIN_STR = "."
local ASCEND_STR = ".."
local URL_STR = "http"

-- helper function to make an http request
-- easy to run in a protected call (pcall)
function httpGet(...)
	return game:HttpGet(...)
end

-- helper function to check start of a string
-- don't know why roblox's doesn't have this already
function startsWith(str, start)
	return str:sub(1, #start) == start
end

-- determines whether a path is a url
function isUrl(path)
	return startsWith(path, URL_STR)
end

-- gets a script's buffer from its url
-- makes a http GET request
function getScript(url)
	local didGet, src = pcall(httpGet, url)

	if didGet then
		local didParse, parseRes = pcall(loadstring, src)
	
		if didParse then
			return res
		end
	end
end

-- loads a script's buffer
-- injects variables into environment
function loadScript(buffer, env, ...)
	local fenv = getfenv(buffer)
	
	injectEnv(fenv, env)
	return buffer(...)
end

-- creates an envonment
-- just basic import stuff
function createEnv(base)
	return {
		import = function(...)
			return import(base, ...)
		end,
		__import = true,
	}
end

-- injects an environment
function injectEnv(env, data)
	for name, var in pairs(data) do
		env[name] = var
	end
end

-- path parsing function
-- handles finding the url for the script
-- handles operators to ascend and descend
function parse(start, path)
	local parts = path:split(DESCEND_STR)
	local pos = start
	local isFirst = true

	local function descend(child)
		table.insert(parts)
	end

	local function ascend()
		table.remove(parts, #parts)
	end

	for _, part in ipairs(parts) do
		if isFirst then
			isFirst = false
			if part == BEGIN_STR or part == ASCEND_STR then
				pos = start
			end
		end

		if part == ASCEND_STR then
			ascend()
		else
			descend(part)
		end
	end

	return table.concat(parts, DESCEND_STR)
end

-- called upon importing a path
-- determines what to do with it
function handle(start, path)
	return isUrl(path) and path or parse(start, path)
end

-- main importing function
-- called by proxy function
function import(start, path, ...)
	local url = handle(start, path)
	
	if url then
		local buffer = getScript(url)
	
		if buffer then
			local env = createEnv(start)
			return loadScript(buffer, env, ...)
		end
	end
end

-- installation function
-- injects import function to script's code
function install(start)
	local fenv = getfenv(3)
	local env = createEnv(start)

	injectEnv(fenv, env)
end

return install(...)
