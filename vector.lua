--[[ -- if you want types (LuaU): remove the comments
export type Vector = {
	x: number,
	y: number,
	magnitude: () -> number,
	dot: (Vector) -> number,
	normalize: () -> Vector,
	orthogonal: (Vector) -> boolean,
	angle: (Vector) -> number,
	project: (Vector) -> (Vector, Vector),
  cross: (Vector) -> number,
}
]]

-- LuaU doesnt need this, but it isnt a standard math function
math.clamp = function(a, min, max)
	return math.max(min, math.min(a, max))
end

local Vector = {}

Vector.__index = {}

-- vector operations, add, sub, mult, div etc
local VectorMT = {
	__tostring = function(self) -- print X, Y instead of memory address/value of table
		return (self.x .. ' ' .. self.y)
	end,
	__mul = function(a, b)
		if (type(b) == 'number') then
			return Vector.new(a.x * b, a.y * b)
		elseif type(a) == 'number' then
			return Vector.new(b.x * a, b.y * a)
		elseif (type(b) == 'table') then
			local bx, by = b.x, b.y

			return Vector.new(a.x * bx, a.y * by)
		end
	end,
	__sub = function(a, b)
		if (type(b) == 'table') then
			local bx, by = b.x, b.y

			return Vector.new(a.x - bx, a.y - by)
		end
	end,
	__add = function(a, b)
		if (type(b) == 'table') then
			local bx, by = b.x, b.y

			return Vector.new(a.x + bx, a.y + by)
		end
	end,
	__div = function(a, b)
		if (type(b) == 'number') then
			return Vector.new(a.x / b, a.y / b)
		elseif type(a) == 'number' then
			return Vector.new(b.x / a, b.y / a)
		elseif (type(b) == 'table') then
			local bx, by = b.x, b.y

			return Vector.new(a.x / bx, a.y / by)
		end
	end,
	__mod = function(a, b)
		if (type(b) == 'table' and type(a) == 'table') then
			local bx, by = b.x, b.y

			return Vector.new(a.x % bx, a.y % bx)
		elseif (type(b) == 'number') then
			return Vector.new(a.x % b, a.y % b)
		elseif (type(a) == 'number' and type(b) == 'table') then
			return Vector.new(a % b.x, a % b.y)
		end
	end,
	__index = Vector
}

-- return the dot product v1 . v2
function Vector:dot(v2)
	local x1, y1 = self.x, self.y
	local x2, y2 = v2.x, v2.y

	return (x1 * x2) + (y1 * y2)
end

function Vector:perpendicular()
	return Vector.new(-self.y, self.x)
end

function Vector:magnitude()
	local x, y = self.x, self.y

	-- magnitude (sqrt(x^2 + y^2)) is also equivalent to sqrt(v:dot(v))
	-- because a dot product is (x1 * x2) + (y1 * y2) and since x1 and x2, y1 and y1 are equal, it is the same as
	-- (x1^2) + (y1^2)
	-- which is equivalent to magnitude formula, so we can just return the sqrt of the dot product and get magnitude
	return math.sqrt(self:dot(self))

	--return math.sqrt((x^2) + (y^2))
end

-- check if vector2 is orthogonal (perpendicular) to vector1
function Vector:orthogonal(v2)
	local d = self:dot(v2)

	if d == 0 then
		return true
	end

	return false
end

-- projects vector1 onto vector2
function Vector:project(v2)
	local d = self:dot(v2)
	local m = v2:dot(v2) -- since magnitude is sqrt(v:dot(v)), we can just not call mag and not sqrt to avoid a ^2

	local a = (d / m)
	local u2 = v2 * a -- proj comp
	local u1 = self - u2 -- orth comp

	-- projection component, orthogonal component
	return u2, u1
end

-- returns angle between vector1 and vector2
function Vector:angle(v2)
	local m = self:magnitude()
	local m2 = v2:magnitude()

	local d = self:dot(v2)

	local t = d / (m*m2)

	-- acos bounds [-1, 1]
	t = math.clamp(t, -1, 1)

	return math.acos(t)
end

-- ex: (1, 1) -> (0.707, 0.707)
-- since mag(1, 1) == 1.414,
-- 1 / 1.414 == 0.707
function Vector:normalize()
	local x, y = self.x, self.y
	local mag = self:magnitude()

	local nx, ny = x / mag, y / mag

	return Vector.new(nx, ny)
end

-- scalar cross
function Vector:cross(v2)
  local x, y = self.x, self.y
  local x2, y2 = v2.x, v2.y

  return x * y2 - y * x2
end

function Vector.new(x, y)
	local self = setmetatable({
		x = x,
		y = y,
	}, VectorMT)

	return self
end

return Vector
