--
-- Baseline Experiment - Player moving at 'maxSpeed' pixels-per-second to right w/ 'maxObjs' objects in world at time.
--

local physics = require "physics"
physics.start()
physics.setGravity(0,0)

-- A group to contain all display objects in 'world'
--
local world = display.newGroup()

-- Object to track with 'camera' code
local player = display.newImageRect( world, "smiley.png", 40, 40  )
player.x = display.contentCenterX
player.y = display.contentCenterY
player.lx = player.x
player.ly = player.y
physics.addBody( player )

-- Player Mover - Translate manually over time (not a good mix with physics, but OK for experiment)
--
local getTimer = system.getTimer
local lastTime = getTimer()
local maxSpeed = _G.maxSpeed
function player.enterFrame( self )
	local curTime = getTimer()
	local dt = curTime - lastTime
	lastTime = curTime
	local dx = (dt/1000) * maxSpeed
	self:translate(dx,0)
end
Runtime:addEventListener( "enterFrame", player )


-- Basic camera code.  Keeps player in center of screen; moves world 'around' player
--
function world.enterFrame( self )
	local dx = player.x - player.lx
	local dy = player.y - player.ly
	self:translate(-dx,-dy)
	player.lx = player.x	
	player.ly = player.y
end
Runtime:addEventListener( "enterFrame", world )

-- Generate objects to show 'hiccup' more clearly
local mRand 	= math.random
local period 	= 100  -- create and delete up to 10 objects per second
local maxCount 	= _G.maxObjs
local objs 		= {}   -- table to hold 'object' references

timer.performWithDelay( period, 
	function()

		if( #objs < maxCount ) then
			local obj = display.newCircle( world, player.x + 600, player.y + mRand( -200, 200), mRand( 10, 15 ) )
			obj:setFillColor(mRand(),mRand(),mRand())
			obj:toBack()
			objs[#objs+1] = obj
		else
			local obj = objs[1]
			objs[#objs+1] = obj
			table.remove(objs, 1 )
			obj.x = player.x + 600
			obj.y = player.y + mRand( -200, 200)
		end
	end, -1)