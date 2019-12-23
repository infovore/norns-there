--
--
--  there (v0.1)
--  a min
--  @infovore
--
--
--  E2: pitch
--  E3: volume
--
--  K2:
--  K3:
--

engine.name = "TestSine"

vol = 0.0
hz = 440

function init()
  engine.hz(hz)
  engine.amp(vol)
end

function key(n,z)
end

function enc(n,d)
  if n == 2 then
    -- pitch
    hz_delt = d
    newhz = hz+hz_delt
    hz = math.max(math.min(newhz,15000),40)
    engine.hz(hz)
  elseif n == 3 then
    -- vol
    vol_delt = d/100.0
    newvol = vol + vol_delt
    vol = math.max(math.min(newvol,1),0)
    engine.amp(vol)
  end
end