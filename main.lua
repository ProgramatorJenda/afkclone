_G.love = require("love")
function love.load()
    love.window.setTitle("AFK Arena-like Game")
    love.window.setMode(800, 600)  -- Window size (width, height)

    -- Define sections
    screenWidth, screenHeight = love.graphics.getDimensions()
    arena = { x = 0, y = 0, width = screenWidth, height = screenHeight * 0.7 }
    heroSection = { x = 0, y = screenHeight * 0.7, width = screenWidth, height = screenHeight * 0.3 }
    background = setArenaBackground()
    heroSectionBackground = love.graphics.newImage("assets/heroSection.png")
end

function setArenaBackground()
    arenaBackground = love.graphics.newImage("assets/celestial_background.jpg")
    return arenaBackground

end

function drawHeroAvatar(hero, i)
    local avatarSize = 50 -- Define a fixed size for the avatars
    local startX = 20 -- Initial X position
    local startY = 450 -- Fixed Y position for all avatars
    local spacing = 60 -- Space between each avatar

    -- Load the hero image
    local heroAvatar = love.graphics.newImage("assets/heroes/" .. hero.name .. ".png")

    -- Draw the hero avatar at the correct position
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(heroAvatar, startX + (i - 1) * spacing, startY, 0, avatarSize / heroAvatar:getWidth(), avatarSize / heroAvatar:getHeight())
end

-- x = 20 y = 450 is where we start drawing hero avatar objects
function drawHeroSection(heroSectionBackground)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(heroSectionBackground, heroSection.x, heroSection.y, 0,
        heroSection.width / heroSectionBackground:getWidth(), -- Scale width
        heroSection.height / heroSectionBackground:getHeight() -- Scale height
    )
end

function drawHeroList(heroList)
    for i, hero in ipairs(heroList) do
        drawHeroAvatar(hero, i)
    end
end

-- in perfect world we would have a database of heroes and their stats for each user
function getUserHeroList()
    userHeroList = {
        {name = "Shemira", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        {name = "Lucius", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Rowan", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Eironn", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Ferael", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Tasi", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Lyca", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Nara", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Gwyneth", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Belinda", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Roselina", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Rosaline", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Fawkes", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Nemora", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Estrilda", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Thoran", level = 240, ascension = 0, signatureItem = 0, furniture = 0},
        -- {name = "Hendrik", level = 240, ascension = 0, signatureItem = 0, furniture = 0}
    }
    return userHeroList
end

function drawArena(background)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background, arena.x, arena.y, 0, 
        arena.width / background:getWidth(), -- Scale width
        arena.height / background:getHeight() -- Scale height
)
  
-- x = 70 y = 160
    local drawAllyPositions = function ()
        local allyPositions = {
            {x = 40, y = 120},
            {x = 40, y = 210},
            {x = 40, y = 300},
            {x = 160, y = 160},
            {x = 160, y = 250},
        }
        for i, position in ipairs(allyPositions) do
            love.graphics.setColor(0, 1, 0)
            love.graphics.circle("fill", position.x, position.y, 30)
        end
        
    end

    local drawEnemyPositions = function ()
        local enemyPositions = {
            {x = 750, y = 120},
            {x = 750, y = 210},
            {x = 750, y = 300},
            {x = 610, y = 160},
            {x = 610, y = 250},
        }
        for i, position in ipairs(enemyPositions) do
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", position.x, position.y, 30)
        end
    end

    drawAllyPositions()
    drawEnemyPositions()
end


function love.draw()
    drawArena(background)
    drawHeroSection(heroSectionBackground)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.print("Mouse Position: X = " .. mouseX .. ", Y = " .. mouseY, 10, 10)
    drawHeroList(getUserHeroList())
end