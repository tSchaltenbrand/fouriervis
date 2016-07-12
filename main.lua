require "lume"

function love.load()
  HALFPCOUNT = 8
  STEPS = 256
  UPDATEPERFRAME = 2
  ITERATIONSKIP = 1 -- 2 to skip even k's; 1 otherwise

  --Information about function
  MAXHEIGHT = 1
  HALFP = 1/2 
  ANULL = -1
  function fA(k)
    return 0
  end
  function fB(k)
    return 1 / (k * math.pi)
  end

  iteration = 1
  xpos = 0
  yposlist = {}
  for i = 0, STEPS do
    table.insert(yposlist, ANULL/2)
  end
end

function love.update()
  require "lurker".update()
  for i = 1, UPDATEPERFRAME do
    yposlist[xpos+1] = yposlist[xpos+1] + f(xpos * HALFP * HALFPCOUNT / STEPS, iteration, HALFP, fA, fB)
    xpos = (xpos + 1) % STEPS
    if xpos == 0 then
      iteration = iteration + ITERATIONSKIP
    end
  end
end

function love.draw()
  love.graphics.print(tostring(xpos) .. " / " .. tostring(STEPS), 10, 10)
  love.graphics.print(tostring(iteration), 10, 30)

  love.graphics.line(0,love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight()/2)
  love.graphics.line(love.graphics.getWidth()/2, 0, love.graphics.getWidth()/2, love.graphics.getHeight())
  for i = 1, 63 do
    love.graphics.points(xpos * love.graphics.getWidth()/STEPS, love.graphics.getHeight() * i/64)
  end

  for i, value in ipairs(yposlist) do
    if yposlist[i+1] then
      drawLine(i-1, yposlist[i], i, yposlist[i+1])
    end
  end
end

function love.keypressed(key)
  if key == 'r' then
    love.load()
  end
end

function f(x, k, L, a, b)
  return a(k) * math.cos(k * math.pi * x / L) + b(k) * math.sin(k * math.pi * x / L)
end

function drawLine(x1,y1,x2,y2)
  love.graphics.line(
  x1 * love.graphics.getWidth()/STEPS, 
  love.graphics.getHeight() * (1/2 - y1/(3*MAXHEIGHT)), 
  x2 * love.graphics.getWidth()/STEPS, 
  love.graphics.getHeight() * (1/2 - y2/(3*MAXHEIGHT))
  )
end
