--
--
--  there (v0.4)
--  a min
--  @infovore
--
--
--  E2: pitch
--  E3: volume
--
--  K2: coarse control (hold)
--  K3: fine control (hold)
--
--  there's some crispy 
--  distortion at the 
--  highest volumes
--
-- also works with arc

engine.name = "TestSine"

local minhz = 40
local maxhz = 2000
local hz_scalar = 0.5
local hz_hand_height = 32

local a = arc.connect(1)

params:add_control("hz","pitch",controlspec.new(40,2000,'exp',0,440,'hz'))
params:add_control("amp","volume",controlspec.new(0,1.0,'lin',0,0,''))

params:set_action('hz', function(x) engine.hz(x); redraw() end)
params:set_action('amp', function(x) engine.amp(x); redraw() end)

function init()
  engine.hz(params:get('hz'))
  engine.amp(params:get('amp'))
  screen.aa(1)
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)
  draw_theremin()
  draw_amp_hand()
  draw_hz_hand()
  arc_redraw()
  screen.update()
end

function key(n,z)
  if n == 2 then
    if z == 1 then
      hz_scalar = 2
      hz_hand_height = 48
    else
      hz_scalar = 0.5
      hz_hand_height = 32
    end
  elseif n == 3 then
    -- up
    if z == 1 then
      hz_scalar = 0.25 
      hz_hand_height = 24
    else
      hz_scalar = 0.5
      hz_hand_height = 32
    end
  end
end

function enc(n,d)
  if n == 2 then
    -- pitch
    params:delta("hz", d * hz_scalar)
  elseif n == 3 then
    -- vol
    params:delta("amp", d)
  end
end

function a.delta(n,d)
  if n == 1 then
    -- pitch
    params:delta("hz", d * hz_scalar)
  elseif n == 2 then
    -- vol
    params:delta("amp", d)
  end
end

function hz_to_x_pos()
  -- take hz, spit out x pos for hand
  min_pos =10 
  max_pos = 42

  return util.explin(minhz,maxhz,min_pos,max_pos,params:get('hz'))
end

function amp_to_y_pos()
  -- take vol, spit out y pos for hand
  min_pos = 52
  max_pos = 22

  return util.linlin(0,1,min_pos,max_pos,params:get('amp'))
end

function arc_redraw()
  local full_circle = (2*math.pi)-0.01
  
  local arc_pos = math.floor(util.explin(minhz,maxhz,1,43,params:get('hz')))
  
  arc_pos = arc_pos - 21;
  if arc_pos < 0 then
    arc_pos = 64 + arc_pos
  end

  local amp_intensity =  math.floor(params:get('amp') * 15)
  
  a:all(0)
  a:led(1,arc_pos,10)
  a:segment(2,0,full_circle,amp_intensity)
  a:refresh()
end

function draw_theremin()
  screen.level(6)
  screen.move(50,10)
  screen.line(52,64)
  screen.line(48,64)
  screen.close()
  screen.fill()
  screen.stroke()
  screen.move(52,59)
  screen.line(118,64)
  screen.line(52,64)
  screen.close()
  screen.fill()
  screen.stroke()
  screen.fill()
  screen.stroke()
end

function draw_hz_hand()
  screen.level(12)
  screen.rect(hz_to_x_pos(),hz_hand_height,2, 7)
  screen.stroke()
  screen.move(32,15)
  screen.text_center(math.floor(params:get('hz')))
end

function draw_amp_hand()
  screen.level(12)
  screen.rect(82,amp_to_y_pos(),7,2)
  screen.stroke()
  screen.move(85,15)
  screen.text_center(string.format("%.2f", params:get('amp')))
end