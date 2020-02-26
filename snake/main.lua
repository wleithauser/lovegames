require("arena")
require("snake")

-- Runs at the beginning of the game to initialize variables and objects
function love.load()
    width     = 600                      -- Width of the window in pixels
    height    = 600                      -- Height of the window in pixels
    game      = Arena:new(width, height) -- Game "arena" object
    snake     = Snake:new()              -- Snake object
    gameState = "main"                   -- Keeps track of game state
    seed      = nil or os.time()         -- Set random number generator seed
    math.randomseed(seed)
    game:generateApple()
end

-- Runs every tick to update anything that needs updated
function love.update(dt)
    if     gameState == "title" then
    elseif gameState == "main"  then
        local x, y, length = snake:updatePosition(dt)
        if x then
            xmax, ymax = game:getDataSize()
            if not snake:isGrowing() then game:updateData() end
            -- Check if the game is over
            checkGameOver(x, y, xmax, ymax)
            -- Check if the snake ate an apple
            if game:getDataAt(x, y) == -1 then
                snake:grow()
                game:generateApple()
            end
            game:writeData(x, y, length)
        end
    elseif gameState == "over"  then
    end
end

-- Runs every tick to draw the entire screen
function love.draw()
    if     gameState == "title" then
        game:title()
    elseif gameState == "main"  then
        game:disp()
    elseif gameState == "over"  then
        game:over()
    end
end

-- Runs every time a key is pressed, determines what should be done
function love.keypressed(key)
    if     key == "right" and snake:getDirection() ~= "left" then
        snake:changeDirection("right")
    elseif key == "down"  and snake:getDirection() ~= "up"  then
        snake:changeDirection("down")
    elseif key == "left"  and snake:getDirection() ~= "right"  then
        snake:changeDirection("left")
    elseif key == "up"    and snake:getDirection() ~= "down"    then
        snake:changeDirection("up")
    end
end

-- Changes game state to "over" once the player loses
function checkGameOver(x, y, xmax, ymax)
    if (x < 1 or x > xmax or y < 1 or y > ymax) or game:getDataAt(x, y) > 0 then
        gameState = "over"
    end
end
