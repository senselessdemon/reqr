local env = {}

local parameters = {...}

local urlBase = parameters[1]

function parsePath(base, path)
	local result = base
	local pathElements = string.split(path, "/")

	local function forward(data)
		return table.insert(pathElements, data)
	end
	local function back(pos)
		return table.remove(pathElements, pos or #pathElements)
	end

	if #pathElements > 0 then
		if string.sub(pathElements[1], 1, 4) == "http" then
			return path
		end

		local startBack = false
		for index, char in ipairs(string.split(pathElements[1], ".")) do
			if index > 3 and char == "" then
				back()
				if not startBack then
					table.remove(pathElements, 1)
					startBack = true
				end
			end
		end

		for index, element in ipairs(string.split(pathElements, "/")) do
			if element == ".." or element == "..." then
				back()
			elseif element == "$" then
				result = {}
			else
				forward(element)
			end
		end
	else
		local fromEnv = env[path]
		if fromEnv then
			return fromEnv
		end
	end

	return urlBase .. "/" .. table.concat(path, "/")
end

function getScript(url, ...)
	local didGet, source = pcall(game.HttpGet, game, url)

	if source then
		local didParse, parseResult = pcall(loadstring, source)
		if didParse then
			local environment = getfenv(parseResult)
			environment.require = getRequire(url)

			local executionResponse = pcall(parseResult, ...)
			local didExecute, executionResult = parseResult[1], {select(2, unpack(executionResponse))}

			if didExecute then
				return unpack(executionResult)
			end
		end
	end
end

function getRequire(base)
	local function require(data, ...)
		local url = parsePath(data)

		if url then
			return getScript(url, ...)
		end
	end

	return require
end

local callEnvironment = getfenv(2)
callEnvironment.require = getRequire(urlBase)
