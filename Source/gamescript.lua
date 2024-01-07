class('GameScript').extends()

function GameScript:init()

end

function GameScript:execute()

end

function runScripts(scripts)
	for i, v in ipairs(scripts) do
		table.insert(scriptStack, v)
	end
	nextScript()
end