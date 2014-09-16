module(..., package.seeall)


--***********************************************************************************************--
--***********************************************************************************************--

-- mainmenu

--***********************************************************************************************--
--***********************************************************************************************--
local movieclip = movieclip
-- Main function - MUST return a display.newGroup()
function new()

			local menuGroup = display.newGroup()
			
			local ui = ui --require("ui")
			local ghostTween
			local ofTween
			local playTween
			local isLevelSelection = false
			
			local tapSound = audio.loadSound( "sounds/tapsound.wav" )
	
			--tweens
			local nTween 
			local nTween2
			local nTween3
			local nTween4
			local btnTween
			local btn2Tween
			
			--botões
			local btn

	
	local drawScreen = function()

					--CANCELANDO TWEENS
					if nTween then transition.cancel( nTween ) end;
					if nTween2 then transition.cancel( nTween2 ) end;
					if nTween3 then transition.cancel( nTween3 ) end;
					if nTween4 then transition.cancel( nTween4 ) end;
					if btnTween then transition.cancel( btnTween ) end;
					if btn2Tween then transition.cancel( btn2Tween ) end;	
				
				
					--ADICIONANDO OBJETOS
					local backgroundImage = display.newImageRect( "images/fundoMenu.png", 480, 320 )
					backgroundImage.x = 240; backgroundImage.y = 150
					menuGroup:insert( backgroundImage )

					--NAVE SOMBRA
					local naveSombra = display.newImageRect( "images/navisombra.png", 13, 8 )
					naveSombra.x = 220; naveSombra.y = 160		
					menuGroup:insert( naveSombra )
					
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
					menuGroup:insert( naveSombra2 )				
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

					--NAVE GRANDE
					local navebtn = display.newImageRect( "images/navebtn.png", 241, 141 )
					navebtn.x = 250; navebtn.y = 150		
					menuGroup:insert( navebtn )		
					
					local function navebtnVertical()
						local animUp = function()
							btnTween = transition.to( navebtn, { time=1000, y=150, onComplete=navebtnVertical })
						end
						btnTween = transition.to( navebtn, { time=1000, y=160, onComplete=animUp })
					end
					navebtnVertical()						

					--BOTÃO PLAY
					local onLevel1Touch = function( event )
						if event.phase == "release" and btn.isActive then
							audio.play( tapSound )
							audio.dispose( backgroundSound ); backgroundSound = nil
							director:changeScene( "level1" )
						end
					end		
					
					btn = ui.newButton{
								defaultSrc = "images/btn.png",
								defaultX = 114,
								defaultY = 114,
								overSrc = "images/btn2.png",
								overX = 114,
								overY = 114,
								onEvent = onLevel1Touch,
								id = "onLevel1Touch",
								text = "",
								font = "Helvetica",
								textColor = { 255, 255, 255, 255 },
								size = 16,
								emboss = false
							}
					
					btn.x = 250; btn.y = 130; btn.width = 90; btn.height=70;
					menuGroup:insert( btn )
					
					local function btnVertical()
						local animUp = function()
							btn2Tween = transition.to( btn, { time=1000, y=130, onComplete=btnVertical })
						end
						btn2Tween = transition.to( btn, { time=1000, y=140, onComplete=animUp })
					end
					btnVertical()
					
					
					--SHEETDATAS PERSONAGEMS COM MOVIMENTOS
					local sheetData1 = {width=155,height=191,numFrames=6,sheetContentWidth = 931,sheetContentHeight=191}
					local sheet1 = graphics.newImageSheet("images/moveEsq.png",sheetData1)
					local sheetData2 = {width=155,height=191,numFrames=6,sheetContentWidth = 931,sheetContentHeight=191}
					local sheet2 = graphics.newImageSheet("images/moveDir.png",sheetData2)
					
					local sequenceData ={{name="personagem",sheet=sheet1,start=1,count=6,time =350,loopCount=0},
										 {name="personagem2",sheet=sheet2,start=1,count=6,time =350,loopCount=0}}
										
					--PERSONAGEM
					local personagem = display.newSprite(sheet1,sequenceData)
					personagem.x = 600
					personagem.y = 240
					personagem:scale(0.2,0.2)
					menuGroup:insert(personagem)
					personagem:play()  
					
					local function personAnimation()
						local animUp = function()
							personagem:setSequence( "personagem2") 
							personagem:play()  
							personagemTween = transition.to( personagem, { time=10000, x=600, onComplete=personAnimation })
						end
						personagem:setSequence( "personagem") 
						personagem:play()  
						personagemTween = transition.to( personagem, { time=10000, x=-100, onComplete=animUp })
					end
					personAnimation()

	end

	
	drawScreen()

	--LIMPANDO OS SONS
	local cleanSounds = function()
		audio.stop()
		
		if tapSound then
			audio.dispose( tapSound )
			tapSound = nil
		end
	end
	
	clean = function()
		
		--CANCELANDO TWEENS
		if nTween then transition.cancel( nTween ) end;
		if nTween2 then transition.cancel( nTween2 ) end;
		if nTween3 then transition.cancel( nTween3 ) end;
		if nTween4 then transition.cancel( nTween4 ) end;
		if btnTween then transition.cancel( btnTween ) end;
		if btn2Tween then transition.cancel( btn2Tween ) end;	
		if personagemTween then transition.cancel( personagemTween ) end;	
		
			
		cleanSounds()
	end

	return menuGroup
end
