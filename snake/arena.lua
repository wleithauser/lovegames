Arena = {}

-- Constructor for new arena object
function Arena:new(width, height)
    assert(width  % 20 == 0, "width must be divisibe by 20")
	assert(height % 20 == 0, "height must be divisibe by 20")
    local a = { width        = width,         -- Width in pixels
	            height       = height,        -- Height in pixels
                arenaColor   = {0, 0, 1},     -- Color of the field
                snakeColor   = {1, 1, 0},     -- Color of the snake
                appleColor   = {1, 0, 0},     -- Color of the apples
                dataWidth    = width  / 20,   -- Width in blocks
                dataHeight   = height / 20, } --Height in blocks
    -- Array to hold the level data
    a.data = {}
    for i = 1, a.dataWidth do
        a.data[i] = {}
        for j = 1, a.dataHeight do
            a.data[i][j] = 0
        end
    end
    -- Make this an object
    setmetatable(a, self)
    self.__index = self
    return a
end

-- Displays everything
function Arena:disp()
    self:dispBackground()
    self:dispData()
end

-- Displays the background
function Arena:dispBackground()
    love.graphics.setColor(self.arenaColor)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)
end

-- Displays the data in the data array. (Snake segments and apple.)
function Arena:dispData()
    for i = 1, self.dataWidth do
        for j = 1, self.dataHeight do
            if self.data[i][j] > 0 then
                love.graphics.setColor(self.snakeColor)
                love.graphics.rectangle("fill", (i - 1) * 20, (j - 1) * 20, 20, 20)
                love.graphics.setColor(self.arenaColor)
                love.graphics.rectangle("line", (i - 1) * 20, (j - 1) * 20, 20, 20)
            end
            if self.data[i][j] < 0 then
                love.graphics.setColor(self.appleColor)
                love.graphics.rectangle("fill", (i - 1) * 20, (j - 1) * 20, 20, 20)
            end
        end
    end
end

-- Updates a position (x, y) in the data array to be value
function Arena:writeData(x, y, value)
    -- Only need to check if the first dimension exists because lua will
    -- arbitrarily expand the second dimension
    if self.data[x] then self.data[x][y] = value end
end

-- Subtract 1 from each element in the data array greater than 0. This is to
-- make the segments of the snake go away once enough time has passed.
function Arena:updateData()
    for i = 1, self.dataWidth do
        for j = 1, self.dataHeight do
            if self.data[i][j] > 0 then self.data[i][j] = self.data[i][j] - 1 end
        end
    end
end

-- Title screen
function Arena:title()
    -- TODO (maybe): Write title screen
end

-- Displays a 'game over' message overlaid on the arena
function Arena:over()
    self:disp()
    x = (self.width  - 116) / 2
    y = (self.height - 22 ) / 2
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x - 2, y - 2, 118, 24)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x - 2, y - 2, 118, 24)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print("Game Over", x, y)
end

-- Returns the dimensions of the data array (in blocks)
function Arena:getDataSize()
    return self.dataWidth, self.dataHeight
end

-- Returns the value at a given position in the data array
function Arena:getDataAt(x, y)
    if self.data[x] then return self.data[x][y] end
end

-- Generates an apple on the screen
function Arena:generateApple()
    -- TODO: Make this more efficient. Should not be noticeable for a normal
    -- player, but as length approaches max it causes a noticeable slowdown.
    repeat
        x = math.random(1, self.dataWidth)
        y = math.random(1, self.dataHeight)
    until self.data[x][y] == 0
    self.data[x][y] = -1
end
