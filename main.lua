love.graphics.setDefaultFilter("nearest","nearest")


inimigo={}
inimigos_controller = {}
inimigos_controller.inimigos = {}

brutal = love.graphics.newImage("inimigo.png")
defensor = love.graphics.newImage("jogador.png")
tiro= love.audio.newSource("tiro.wav")
fundo= love.audio.newSource("fundo.mp3")
morte= love.audio.newSource("morte.wav")
gameover = love.audio.newSource("gameover.wav")
imagemfundo=love.graphics.newImage("space.jpg")

function love.load()
	game_over = false
	game_win =false
	love.audio.play(fundo)
	player = {}
	player.x = 0
	player.bullets = {}
	player.cooldown =20
	player.fire = function()
		if player.cooldown <=0 then
			love.audio.play(tiro)
			player.cooldown =20
			bullet = {}
			bullet.x = player.x + 4
			bullet.y = 106
			table.insert(player.bullets,bullet)
		end
	end
	
	for i=0,10 do 
	inimigos_controller:gerainimigo(i*15,0)
	inimigos_controller:gerainimigo(i*15,10)
	inimigos_controller:gerainimigo(i*15,20)
	inimigos_controller:gerainimigo(i*15,30)
	inimigos_controller:gerainimigo(i*15,50)
	end
	
end

function check(inimigos,tiros)
	for n,i in ipairs(inimigos) do
		for m,t in ipairs(tiros) do
			if t.y<=i.y+i.height and t.x>i.x and t.x<i.x+i.width then
				table.remove(inimigos,n)
				table.remove(tiros,m)
				love.audio.play(morte)				
			end
		end
	end
end

function inimigos_controller:gerainimigo(x,y)
	inimigo ={}
	inimigo.x=x
	inimigo.y=y
	inimigo.height=10
	inimigo.width=10
	inimigo.bullets = {}
	inimigo.cooldown =20
	table.insert(self.inimigos,inimigo)
end

function inimigo:fire()
	if player.cooldown <=0 then
			self.cooldown =20
			bullet = {}
			bullet.x = self.x + 7
			bullet.y = 106
			table.insert(self.bullets,bullet)
	end
end

function love.update(dt)

	player.cooldown = player.cooldown -1

	--Controles
	if love.keyboard.isDown("right") then
		player.x=player.x+1	
	elseif love.keyboard.isDown("left") then 
		player.x=player.x-1	
	end
	if love.keyboard.isDown("space") then
		
		player.fire()
	end
	
	  --Inimigos
      for _,i in pairs(inimigos_controller.inimigos) do
      if i.y >= love.graphics.getHeight()/4 then
      	game_over=true
      end
    	i.y= i.y+0.01
    
    end
  
	
	--Tiro player
	for i,b in ipairs(player.bullets) do
		if b.y < -10 then 
			table.remove(player.bullets, i)
		end
    	b.y=b.y-0.2
    end
    
	check(inimigos_controller.inimigos,player.bullets)  
	if #inimigos_controller.inimigos  == 0 then
		game_win =true
	end
end

function love.draw()
	love.graphics.scale(5)
	love.graphics.draw(imagemfundo)
	
	if game_over then
		love.graphics.print("GAME OVER !")
		return
	elseif game_win then
		love.graphics.print("VOCÊ VENCEU!")
		return
	end
	-- Player
	love.graphics.setColor(255,255,255)
    love.graphics.draw(defensor,player.x,106)
    
    
    -- Inimigos
    for _,i in pairs(inimigos_controller.inimigos) do
    	love.graphics.draw(brutal,i.x,i.y,0)    	
    end
    
    --Tiro     
    love.graphics.setColor(255,255,255)
    for _,v in pairs(player.bullets) do
    	love.graphics.rectangle("fill",v.x,v.y,2,2)
    end
    
end
