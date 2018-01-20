local dump = require "dump"

local functools = {}

local table = table

functools.partial = function( func, ... )
	if type(func) ~= 'function' then
		error("partial() argment must be function",0)
	end
	
	local args = {...}
	print (#args)
	if #args == 0 then
		return func
	end

	return function(...)
		table.foreachi({...},
			function(_,v) 
				table.insert(args, v) 
			end)

		return func(unpack(args))
	end
end


functools.reduce = function( func, sequence, initial--[[=nil]] )
	if type(func) ~= 'function' then
		error("reduce() 1 argment must be function",0)
	end

	if type(sequence) ~= 'table' then
		error("reduce() 2 argment must be table",0)
	end

	local start,first = 1, initial
	if not initial then
		first = sequence[1]
		start = 2
	end

	if not first then
		error("TypeError: reduce() of empty sequence with no initial value",0)
	end

	local r = first
	for i=start,#sequence do
		r = func(r, sequence[i])
	end
	
	return r
end


functools.map = function( func, sequence, ...)
	local args, r = {sequence, ...}, {}

	for i=1,#sequence do
		local tmp = {}
		for _,arg in ipairs(args) do
			table.insert(tmp,arg[i])
		end

		local v = func(unpack(tmp))
		table.insert(r,v)
	end

	return r
end

functools.handler = function(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

return functools
