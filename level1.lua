module(..., package.seeall)

-- Main function - MUST return a display.newGroup()
function new()

	local gameGroup = display.newGroup()
	--gameGroup.x = -480

	--local aux
	local movimentIsActive = true
	local direcaoBall = -1
	local shotTime = 2000
	local naveSimples
	local naveIsVisible = 0	
	
	--tweens
	local tweenTimer,tweenTimer2,tweenShotFire,nTween
	local nTween2,nTween3,nTween4,tweenTimer,tweenDannyMov
	local tweenNaveSimplesH,tweenNaveSimplesV
	
	-- EXTERNAL MODULES / LIBRARIES
	local movieclip = movieclip --require( "movieclip" )
	local physics = require "physics"
	local ui = ui --require("ui")	
	
	
	-- AUDIO
	local backSound = audio.loadSound( "sounds/POL-snowy-hill-short.wav")
	local tapSound = audio.loadSound( "sounds/tapsound.wav" )
	
	-- OBJECTS
	local backgroundImage1	
	local dannyObject
	local timerShotObject
	local blueFireObject
	
	local timeEnemy = 100
	
	--SHEETDATAS PERSONAGEMS COM MOVIMENTOS
	local sheetData1 = {width=155,height=191,numFrames=6,sheetContentWidth = 931,sheetContentHeight=191}
	local sheet1 = graphics.newImageSheet("images/moveEsq.png",sheetData1)
	local sheetData2 = {width=155,height=191,numFrames=6,sheetContentWidth = 931,sheetContentHeight=191}
	local sheet2 = graphics.newImageSheet("images/moveDir.png",sheetData2)
	
	local sequenceData ={{name="danny",sheet=sheet1,start=1,count=6,time =150,loopCount=0},
						 {name="danny2",sheet=sheet2,start=1,count=6,time =150,loopCount=0}}	
	
	
	
	local drawBackground = function()
		-- Background gets drawn in this order: backdrop, clouds, trees, red glow
		
		-- BACKDROP
		backgroundImage1 = display.newImageRect( "images/fundoMenuLevel.png", 480, 320 )
		backgroundImage1:setReferencePoint( display.CenterLeftReferencePoint )
		backgroundImage1.x = 0; backgroundImage1.y = 160
		gameGroup:insert( backgroundImage1 )

	end	
	
	--#CREATEBLUEFIRE
	local createBlueFire = function()
		if blueFireObject then
			blueFireObject.x = dannyObject.x + (10*direcaoBall);
			blueFireObject.y = dannyObject.y - 10;
		else
			blueFireObject = display.newImageRect( "images/blueFire.png", 20, 20 )
			blueFireObject.x = dannyObject.x + (10*direcaoBall);
			blueFireObject.y = dannyObject.y - 10;
			blueFireObject.radius = 12
			physics.addBody( blueFireObject, "static", { density=1.0, bounce=0.4, friction=0.15, radius=dannyObject.radius } )
		end
		-- Insert objects into main group
		gameGroup:insert( blueFireObject )
		tweenShotFire = transition.to( blueFireObject, { time=500, y=-50} )				
		
	end
	--#CREATEBLUEFIRE
	
	--#CREATEFIRE
	local createFire = function()
		audio.play( tapSound )
		createBlueFire()
	end
	--CREATEFIRE	
	
	--CRIAR NAVES SOMBRAS
	local createShadow = function()
					local naveSombra = display.newImageRect( "images/navisombra.png", 13, 8 )
					naveSombra.x = 220; naveSombra.y = 160		
					gameGroup:insert( naveSombra )
					
					local function naveAnimationVertical()
						local animUp = function()
							nTween = transition.to( naveSombra, { time=1000, y=160, onComplete=naveAnimationVertical })
						end
						nTween = transition.to( naveSombra, { time=1000, y=170, onComplete=animUp })
					end
					naveAnimationVertical()		
					
					local function naveAnimationHorizontal()
						local animUp = function()
							nTween2 = transition.to( naveSombra, { time=10000, x=600, onComplete=naveAnimationHorizontal })
						end
						nTween2 = transition.to( naveSombra, { time=10000, x=-100, onComplete=animUp })
					end
					naveAnimationHorizontal()				

					--NAVE SOMBRA 2
					local naveSombra2 = display.newImageRect( "images/navisombra.png", 13, 8 )
					naveSombra2.x = 440; naveSombra2.y = 100		
					gameGroup:insert( naveSombra2 )				
					local function naveAnimationVertical2()
						local animUp = function()
							nTween3 = transition.to( naveSombra2, { time=1000, y=100, onComplete=naveAnimationVertical2 })
						end
						nTween3 = transition.to( naveSombra2, { time=1000, y=110, onComplete=animUp })
					end
					naveAnimationVertical2()			
					
					local function naveAnimationHorizontal2()
						local animUp = function()
							nTween4 = transition.to( naveSombra2, { time=10000, x=-100, onComplete=naveAnimationHorizontal2 })
						end
							nTween4 = transition.to( naveSombra2, { time=10000, x=600, onComplete=animUp })
					end
					naveAnimationHorizontal2()									
	end

	--#CREATEDANNY
	local createDanny = function()
		
		local onDannyCollision = function( self, event )
			if event.phase == "began" then
				--audio.play( impactSound )
				
				if dannyObject.isHit == false then
				
					if dotTimer then timer.cancel( dotTimer ); end
					ghostObject.isHit = true
					
					if event.other.myName == "wood" or event.other.myName == "stone" or event.other.myName == "tomb" or event.other.myName == "monster" then
						callNewRound( true, "yes" )
					else
						callNewRound( true, "no" )
					end
				
				elseif dannyObject.isHit then
					return true
				end
			end
		end
		
		dannyObject = display.newSprite(sheet1,sequenceData)
		dannyObject.x = 400
		dannyObject.y = 250
		dannyObject:scale(0.2,0.2)
		--dannyObject:play()  		
		
		--dannyObject.x = 150; dannyObject.y = 195
		--dannyObject.isVisible = false
		
		dannyObject.isReady = false	--> Not "flingable" until touched.
		dannyObject.inAir = false
		dannyObject.isHit = false
		dannyObject.isBullet = true
		dannyObject.trailNum = 0
		dannyObject.radius = 12
		physics.addBody( dannyObject, "static", { density=1.0, bounce=0.4, friction=0.15, radius=dannyObject.radius } )
		dannyObject.rotation = 0
		
		-- Set up collisions
		dannyObject.collision = onDannyCollision
		dannyObject:addEventListener( "collision", dannyObject )

		-- Insert objects into main group
		gameGroup:insert( dannyObject )
		
	end
--CREATEDANNY	

--createTimerShot
local createTimerShot = function()
	
	timerShotObjectFundo = display.newImageRect( "images/BarraTiroFundo2.png", 100, 15 );
	timerShotObjectFundo:setReferencePoint(display.BottomLeftReferencePoint)
	timerShotObjectFundo.x = 350;
	timerShotObjectFundo.y = 295;	

	timerShotObject = display.newImageRect( "images/BarraTiro.png",0, 15 );
	
	timerShotObject:setReferencePoint(display.BottomLeftReferencePoint)

	timerShotObject.x = 350;
	timerShotObject.y = 295;
	--physics.addBody( timerShotObject, "static", { density=1.0, bounce=0.4, friction=0.15} )	
	
	local function reduzTimer()
		createFire();
		local reduzTimer2 = function()
			createFire()
			timerShotObject.width = 0;
			tweenTimer = transition.to( timerShotObject, { time=shotTime, width = 100, onComplete=reduzTimer } )				
		end
		
		timerShotObject.width = 0;
		tweenTimer = transition.to( timerShotObject, { time=shotTime, width = 100, onComplete=reduzTimer2 } )				
	end
	reduzTimer()
	
end;
--fim createTimerShot


--#PAROUANDAR
local parouAndar = function()
	movimentIsActive = true
	dannyObject:pause()
end;
--PAROUANDAR


--#TOUCH
	local onScreenTouch = function( event )
		if movimentIsActive then
			
			--if event.phase == "began" and ghostObject.inAir == false and event.xStart > 115 and event.xStart < 180 and event.yStart > 160 and event.yStart < 230 and screenPosition == "left" then
			if event.phase == "began" then
				movimentIsActive = false	
				if event.xStart > dannyObject.x then
					direcaoBall = 1
					dannyObject:setSequence( "danny2") 
					dannyObject:play()
				else
					direcaoBall = -1
					dannyObject:setSequence( "danny") 
					dannyObject:play()
				end
				
				tweenDannyMov = transition.to( dannyObject, { time=300, x=event.xStart-(10*direcaoBall), onComplete=parouAndar } )				

				
			end
		end
	end

--TOUCH	
	
	local createEnemy = function()

		timeEnemy = timeEnemy + 1;
		
		if timeEnemy > 150 and naveIsVisible == 0 then
			naveIsVisible = 1;
			timeEnemy = 0;			
			if naveSimples == nil then
				naveSimples = display.newImageRect( "images/navebtn.png", 40, 30 )
				naveSimples.x = 600; naveSimples.y = 60
				naveSimples.yInicial = 60;
			end 
			if tweenNaveSimplesH then transition.cancel( tweenNaveSimplesH ) end;
			if tweenNaveSimplesV then transition.cancel( tweenNaveSimplesV ) end;

			--local ZeraNaveSimples = function()
			local function ZeraNaveSimples()
				naveIsVisible = 0;
				naveSimples.x = 600
				naveSimples.yInicial = math.random(60,160);
			end
			
			tweenNaveSimplesH = transition.to(naveSimples,{ time=10000, x=-100,onComplete=ZeraNaveSimples})
			

			local function naveSimplesVUp()
				local naveSimplesVDown = function()
					tweenNaveSimplesV = transition.to(naveSimples,{ time=1000, y=naveSimples.yInicial,onComplete=naveSimplesVUp})
				end
					tweenNaveSimplesV = transition.to(naveSimples,{ time=1000, y=naveSimples.yInicial + 20,onComplete=naveSimplesVDown})
			end
			
			naveSimplesVUp();
		end
		
	end
	
	
	--#STARTNEWROUND
	local startNewRound = function()
			audio.setVolume( 0.8, { channel=1 } )
			audio.play( backSound ,{channel=1,loops=-1})
			local activateRound = function()
				canSwipe = true
				waitingForNewRound = false
						
				if restartTimer then
					timer.cancel( restartTimer )
				end
				
				
			end
			
			
--[[			
			-- reset camera
			if gameGroup.x < 0 then
				transition.to( gameGroup, { time=1000, x=0, transition=easing.inOutExpo, onComplete=activateRound } )
			else
				gameGroup.x = 0
				activateRound()
			end
]]			
			
	end
	--STARTNEWROUND
	
	--#GAMELOOP
	local gameLoop = function()
		 --blueFireObject.x = dannyObject.x + (10*direcaoBall)
		 
	end
	--GAMELOOP
	
	
	--#GAMEINIT()
	local gameInit = function()
		
		-- PHYSICS
		physics.start( true )
		physics.setDrawMode( "normal" )	-- set to "debug" or "hybrid" to see collision boundaries
		physics.setGravity( 0, 11 )	--> 0, 9.8 = Earth-like gravity
		
		-- DRAW GAME OBJECTS
		drawBackground()
		createShadow()
		createDanny()
		createTimerShot()
		Runtime:addEventListener( "enterFrame", createEnemy)
		
		
		-- CREATE LEVEL
		--createLevel()
		
		-- DRAW HEADS-UP DISPLAY (score, lives, etc)
		--drawHUD()

		
		-- START EVENT LISTENERS
		Runtime:addEventListener( "touch", onScreenTouch )
		Runtime:addEventListener( "enterFrame", gameLoop )
		--Runtime:addEventListener( "system", onSystem )
		
		local startTimer = timer.performWithDelay( 500, function() startNewRound(); end, 1 )
		--local shotTimer = timer.performWithDelay( shotTime, createFire, -1 )
		--local shotTimer = timer.performWithDelay( shotTime, createFire, -1 )
		
		
	end
	
	gameInit()




	--LIMPANDO OS SONS
	local cleanSounds = function()
		audio.stop()
		
		if tapSound then
			--audio.dispose( tapSound )
			--tapSound = nil
		end
	end
	
	clean = function()
	
		--CANCELANDO TWEENS
		if tweenTimer then transition.cancel( tweenTimer ) end;
		if tweenTimer2 then transition.cancel( tweenTimer2 ) end;
		if tweenShotFire then transition.cancel( tweenShotFire ) end;
		if nTween then transition.cancel( nTween ) end;
		if nTween2 then transition.cancel( nTween2 ) end;
		if nTween3 then transition.cancel( nTween3 ) end;	
		if nTween4 then transition.cancel( nTween4 ) end;	
		if tweenTimer then transition.cancel( tweenTimer ) end;	
		if tweenDannyMov then transition.cancel( tweenDannyMov ) end;	
		if tweenNaveSimplesH then transition.cancel( tweenNaveSimplesH ) end;	
		if tweenNaveSimplesV then transition.cancel( tweenNaveSimplesV ) end;	
			
		cleanSounds()
	end



	
	-- MUST return a display.newGroup()
	return gameGroup
end
