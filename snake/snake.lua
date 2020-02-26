Snake = {}

-- Constructor for new snake object
function Snake:new(interval)
    local interval = interval or 0.1
    local s = { length    = 3,        -- Length of the snake
                direction = "right",  -- Direction of the snake
                interval  = interval, -- Time in seconds before updating position
                wait      = interval, -- Amount of time waited to update position
                lock      = false,    -- Locks the snake from moving if it's
                                      -- already moved in one update.
                growWait = 0,         -- Wait for the snake to expand in size
                x = 0,  y = 1 }       -- Coordinates (in blocks) of the snake
    -- Make it an object
    setmetatable(s, self)
    self.__index = self
    return s
end

-- Automatically moves the snake once a sufficient amount of time has passed
function Snake:updatePosition(dt)
    if self.wait > self.interval then
        self.wait = 0
        if self.direction == "right" then
            self.x = self.x + 1
        elseif self.direction == "down" then
            self.y = self.y + 1
        elseif self.direction == "left" then
            self.x = self.x - 1
        elseif self.direction == "up" then
            self.y = self.y - 1
        end
        self.lock = false
        return self.x, self.y, self.length
    else
        self.wait = self.wait + dt
    end
end

-- Update the direction of the snake (if it isn't locked)
function Snake:changeDirection(direction)
    if not self.lock then 
        self.direction = direction
        self.lock = true
    end
end

-- Returns the direction of the snake
function Snake:getDirection()
    return self.direction
end

-- Returns the coordinates of the snake
function Snake:getPosition()
    return self.x, self.y
end

-- Grow the snake after eating an apple
function Snake:grow(amount)
    local amount = amount or 2
    self.length = self.length + 1
    self.growWait = amount
end

-- Returns true if the snake is in the process of growing
function Snake:isGrowing()
    if self.growWait > 0 then
        self.growWait = self.growWait - 1
        if self.growWait > 0 then self.length = self.length + 1 end
        return true
    else
        return false
    end
end
