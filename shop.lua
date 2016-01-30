shop = {
  cheapitem = {
    color = {30, -30}
  },
  expensiveitem = {
    color = {60, -60}
  },
}

local tobedeleted = false

local cheapitempos, expensiveitempos

function shop.cheapitem.load(_, W, H)
  tobedeleted = false
  shop.cheapitem.price = math.floor(money * 0.8)
  cheapitempos = vec2:new{W/3, H/2}
end

function shop.expensiveitem.load(_, W, H)
  shop.expensiveitem.price = math.floor(money * 1.5 + math.random(10, 500))
  expensiveitempos = vec2:new{2*W/3, H/2}
end

function shop.cheapitem.oncollide()
  tobedeleted = true
end

function shop.expensiveitem.oncollide()
  return
end

function shop.cheapitem.getpos()
  return cheapitempos
end

function shop.expensiveitem.getpos()
  return expensiveitempos
end

function shop.cheapitem.update()
  if tobedeleted then 
    blinglevel = blinglevel * blingfactor
    money = money - shop.cheapitem.price
  end
  return tobedeleted
end

function shop.expensiveitem.update()
  return
end

return shop