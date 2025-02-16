_G.love = require("love")
selectedHero = nil

-- Table to track where heroes are placed in combat
allyHeroes = {}
activeCombatHeroes = {}

function love.load()
    love.window.setTitle("AFK Arena-like Game")
    love.window.setMode(800, 600)  -- Window size (width, height)

    userHeroList = getUserHeroList() -- Store heroes globally

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

    hero.x = startX + (i - 1) * spacing
    hero.y = startY
    hero.width = avatarSize
    hero.height = avatarSize


    -- Load the hero image
    local heroAvatar = love.graphics.newImage("assets/heroes/" .. hero.name .. ".png")
    if selectedHero == hero then
        love.graphics.setColor(1, 0, 0)  -- Red color for the rectangle
        love.graphics.setLineWidth(3)    -- Set line width for the rectangle
        love.graphics.rectangle("line", startX + (i - 1) * spacing - 5, startY - 5, avatarSize + 10, avatarSize + 10)  -- Rectangle around the avatar
    end

    local isInCombat = false
    for _, combatHero in ipairs(activeCombatHeroes) do
        if combatHero == hero then
            isInCombat = true
            break
        end
    end
    
    -- Draw the hero avatar at the correct position
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(heroAvatar, startX + (i - 1) * spacing, startY, 0, avatarSize / heroAvatar:getWidth(), avatarSize / heroAvatar:getHeight())

    if isInCombat then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)  -- Grey with some transparency
        love.graphics.rectangle("fill", startX + (i - 1) * spacing, startY, avatarSize, avatarSize)
    else
        love.graphics.setColor(1, 1, 1) -- Set color to white if not in combat
    end
end

-- x = 20 y = 450 is where we start drawing hero avatar objects
function drawHeroSection(heroSectionBackground)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(heroSectionBackground, heroSection.x, heroSection.y, 0,
        heroSection.width / heroSectionBackground:getWidth(), -- Scale width
        heroSection.height / heroSectionBackground:getHeight() -- Scale height
    )
end


function love.mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        -- Check if click is on a hero avatar        
        for i, hero in ipairs(userHeroList) do
            if x >= hero.x and x <= hero.x + hero.width and
               y >= hero.y and y <= hero.y + hero.height then
                selectedHero = hero -- Set selected hero

                --Debug
                -- print("Selected Hero: " .. selectedHero.name)
                -- print(selectedHero.isInCombat)
                -- End Debug
                if selectedHero.isInCombat then
                    print("Hero " .. selectedHero.name .. " is already in combat")
                    selectedHero = nil
                    break
                else
                    print("Selected Hero: " .. hero.name)
                    break
                end
        end
    end

    if selectedHero then
        -- Check if click is on an Ally position
        for i, position in ipairs(allyPositions) do
            -- Check if the click is within the circle
            if (x - position.x)^2 + (y - position.y)^2 <= 30^2 then
                if allyHeroes[i] then

                    --Debug
                    print("Allied hero at position " .. i .. ": " .. allyHeroes[i].name)
                    print("Removing " .. allyHeroes[i].name .. " from position " .. i)
                    --End Debug

                    local oldHero = allyHeroes[i]
                    allyHeroes[i] = nil  -- Remove the hero by setting to nil instead of using table.remove
                    
                    if not allyHeroes[i] then
                        print("Removed " .. oldHero.name .. " from position " .. i)
                    else
                        print("There is still a hero at position " .. i)
                    end
                
                    -- Remove old hero from activeCombatHeroes
                    if oldHero then
                    print("Removing " .. oldHero.name .. " from combat.")
                    for i, hero in ipairs(activeCombatHeroes) do
                        if hero.name == oldHero.name then
                            hero.isInCombat = false
                            table.remove(activeCombatHeroes, i)
                            print("Removed " .. oldHero.name .. " from combat.")
                            break
                        end
                    end
                end
            end

                    selectedHero.x = position.x
                    selectedHero.y = position.y
                    print("Selected Hero: " .. selectedHero.name)
                    table.insert(activeCombatHeroes, selectedHero)
                    selectedHero.isInCombat = true

                    print("Placed " .. selectedHero.name .. " at Ally position")
                    print("Hero " .. selectedHero.name .. " is now in combat")

                    --Debug
                    print("Active Combat Heroes: ")
                    for k = 1, #activeCombatHeroes do
                        local hero = activeCombatHeroes[k]
                        print("Hero " .. k .. ":")
                        print("  Name: " .. hero.name)
                        print("  In Combat: " .. tostring(hero.isInCombat))
                    end
                    -- End Debug


                    allyHeroes[i] = {
                        name = selectedHero.name,
                        avatar = love.graphics.newImage("assets/heroes/" .. selectedHero.name .. ".png"),
                    }

                    selectedHero = nil
                break
            end
        end
    end
        -- Check if click is on an Enemy position (circle bounds)
        for i, position in ipairs(enemyPositions) do
            -- Check if the click is within the circle
            if (x - position.x)^2 + (y - position.y)^2 <= 30^2 then
                if selectedHero then
                    print("Please select an Ally position!")
                end
                break
            end
        end
    end
end


function drawHeroList(heroList)
    for i, hero in ipairs(heroList) do
        drawHeroAvatar(hero, i)
    end
end

-- in perfect world we would have a database of heroes and their stats for each user
function getUserHeroList()
    userHeroList = {
        {name = "Shemira", level = 240, ascension = 0, signatureItem = 0, furniture = 0, isInCombat = false},
        {name = "Lucius", level = 240, ascension = 0, signatureItem = 0, furniture = 0, isInCombat = false},
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
    allyPositions = {
        {x = 40, y = 120},
        {x = 40, y = 210},
        {x = 40, y = 300},
        {x = 160, y = 160},
        {x = 160, y = 250},
    }

    for i, position in ipairs(allyPositions) do
        -- Check if a hero is placed at this position
        local heroAtPosition = allyHeroes[i]
        
        if heroAtPosition then
            love.graphics.setColor(1, 1, 1)
            -- If there is a hero at this position, draw the hero's avatar
            love.graphics.draw(heroAtPosition.avatar, position.x - heroAtPosition.avatar:getWidth() / 2, position.y - heroAtPosition.avatar:getHeight() / 2)
        else
            -- If no hero is placed, draw a green circle to show it's an available position
            love.graphics.setColor(0, 1, 0, 0.5)
            love.graphics.circle("fill", position.x, position.y, 30)
        end
    end
end

    local drawEnemyPositions = function ()
        enemyPositions = {
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
    drawHeroList(userHeroList)
end