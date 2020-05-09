W_WDH = 1280
W_HGT = 800

P_SPEED = 750
P_HGT = 60
P_WDH = 15

B_WDH_HGT = 13

function love.load()

	love.window.setMode(W_WDH, W_HGT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
	
	love.window.setTitle('Pong to Death')
	
	math.randomseed(os.time())
	
	p1Lives = 10
	p2Lives = 10
	
	p1WinCount = 0
	p2WinCount = 0
	
	p1Y = W_HGT/2 - 30
	p2Y = W_HGT/2 - 30
	
	p1X = 10
	p2X = W_WDH - 25

	ballreset()
	
	pause = false
	sysPause = true
end

function love.update(dt)

	if sysPause == false and pause == false
	then play(dt)
	end
	
end

function love.draw()

	--fontsize
	love.graphics.setFont(love.graphics.newFont(30))
	--paddle 1 & lives
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', p1X, p1Y, P_WDH, P_HGT)
	love.graphics.print(tostring(p1Lives), W_WDH/2 - 300, 30)
	love.graphics.print('Wins: ' .. tostring(p1WinCount), W_WDH/2 - 320, W_HGT-50)
	--paddle 2 & lives
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.rectangle('fill', p2X, p2Y, P_WDH, P_HGT)
	love.graphics.print(tostring(p2Lives), W_WDH/2 + 240, 30)
	love.graphics.print('Wins: ' .. tostring(p2WinCount), W_WDH/2 + 240, W_HGT-50)
	--reset color
	love.graphics.setColor(255, 255, 255, 255)
	--title
	love.graphics.printf('Pong to Death', 0, 10, W_WDH, 'center')
	--ball
	love.graphics.rectangle('fill', ballX, ballY, B_WDH_HGT, B_WDH_HGT)
	--FPS
	love.graphics.print('FPS:' .. tostring(love.timer.getFPS()), W_WDH/2-40, W_HGT-50)
	
end

function love.keypressed(key)

	if key == 'escape'
	then love.event.quit()
	
	elseif key == 'backspace'
	then gamereset()
	
	elseif key == 'space'
	then
		if pause == false
		then pause = true
		else pause = false
		end
	
	elseif key == 'return' or key == 'enter'
	then
		sysPause = false
	end
end

function bColl(pY)

	if ballY >= pY and ballY <= pY + P_HGT
	or ballY + B_WDH_HGT >= pY and ballY + B_WDH_HGT <= pY + P_HGT
	then ballDX = -ballDX * 1.05
	end
end

function ballreset()
	ballX = W_WDH/2
	ballY = W_HGT/2
	ballDY = math.random(-300, 300)
	ballDX = math.random(-450, 450)
end

function gamereset()
	p1Lives = 10
	p2Lives = 10
	ballreset()
	sysPause = true
end


function play(dt)

	--p1 movement
	if love.keyboard.isDown('w')
	then p1Y = math.max(0, p1Y - P_SPEED * dt)
	elseif love.keyboard.isDown('s')
	then p1Y = math.min(W_HGT - 60, p1Y + P_SPEED * dt)
	end
	
	--p2 movement
	if love.keyboard.isDown('up')
	then p2Y = math.max(0, p2Y - P_SPEED * dt)
	elseif love.keyboard.isDown('down')
	then p2Y = math.min(W_HGT - 60, p2Y + P_SPEED * dt)
	end
	
	--ball movement & wall collision
	ballX = ballX + ballDX * dt
	ballY = ballY + ballDY * dt
	
	if ballY <= 0 or ballY +13 >= W_HGT
	then ballDY = -ballDY * 1.05
	end
	
	--paddle collision & score check
	if ballX <= p1X + 15 and ballX >= p1X
	or ballX + 13 <= p1X + 15 and ballX + 13 >= p1X
	then bColl(p1Y)
	
	elseif ballX >= p2X and ballX <= p2X + 15
	or ballX + 13 >= p2X and ballX +13 <= p2X + 15
	then bColl(p2Y)
	
	elseif ballX <= 0
	then 
		p1Lives = p1Lives - 1
		ballreset()
		sysPause = true
	
	elseif ballX >= W_WDH
	then 
		p2Lives = p2Lives - 1
		ballreset()
		sysPause = true
	end
	
	--victory check
	if p1Lives == 0
	then 
		p2WinCount = p2WinCount + 1
		gamereset()
	elseif p2Lives == 0
	then
		p1WinCount = p1WinCount + 1
		gamereset()
	end

end
	