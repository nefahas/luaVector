# 2d vector library for lua and LuaU

usage:

	local vector = require('vector.lua')

	local v1 = vector.new(50, -25)

	local v2 = vector.new(25, 10)

	-- supports printing, and math operations directly onto vector

	print(v1) -> "50 -25"

	print(v1 - v2) -> "25 -35"

	print(v1 + v2) -> "75 -15"

functions and types:


	x: number,
 
	y: number, 
 
	magnitude: () -> number, -- magnitude of a vector
 
	dot: (Vector) -> number, -- dot product v1 . v2
 
	normalize: () -> Vector, -- normalizes a vector (eg: (1,1) -> (0.707, 0.707))
 
	orthogonal: (Vector) -> boolean, -- check if v2 is perpendicular to v1
 
	angle: (Vector) -> number, -- angle between v1 and v2
 
	project: (Vector) -> (Vector, Vector), -- projection component, orthogonal component
