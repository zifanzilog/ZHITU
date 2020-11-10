i=0
--厉害
function slide_d(t,w)
  local w = w or 5 --[[速率默认5像素,整数型]]
  -- local id = createHUD()     --[[创建一个HUD]]
  local t = t or {0,0,0,0}
  local x=t[3]-t[1]+1
  local y=t[4]-t[2]+1
  if x==0 then x=1
  elseif y==0 then y=1 end  --[[x,y除数不等于0]]
  local k=y/x           --[[y=kx+b  b=0 ]]
  local i,j = 0,0
  local Lx,Ly=t[1],t[2]
  if math.abs(x) > math.abs(y) then
    j = x
    if x < 0 then
      w = 0 - w
    end
  else
    j = y
    if y < 0 then
      w = 0 - w
    end
  end
  if i < j and w < 0 then   --倒序遍历
      i,j = j,i
  elseif i > j and w > 0 then --正序遍历
      i,j = j,i
  end
   touchDown(1, Lx,Ly)  --[[触摸按下]]
  -- showHUD(id,"",12,"0xffff0000","0xffffff00",0,Lx,Ly,20,20)
  mSleep(50)
  for p=i,j,w do
    if math.abs(x) > math.abs(y) then
      x1, y1 = p,math.floor(p*k)
    else
      x1, y1 = math.floor(p/k),p
    end
    touchMove(1, x1+Lx, y1+Ly)  --[[移动]]
    -- showHUD(id,"",12,"0xffff0000","0xffffff00",0,x1+Lx, y1+Ly,20,20)
    -- ptable({x1+Lx,y1+Ly})
    -- mSleep(20)
  end
  mSleep(50)
  touchUp(1, x1+Lx, y1+Ly)  --[[松开]]
  -- hideHUD(id)     --隐藏HUD
end


function tap(x, y)
  touchDown(1, x, y)
  mSleep(50)
  touchMove(1, x, y)
  mSleep(50)
  touchUp(1, x, y)  
end
while true do
i=i+1
-- slide_d({492,1407,563,603},5)
touchDown(1, 492,1407)
mSleep(50)
touchMove(1,563,603)
mSleep(50)
touchUp(1, 563,603)  
mSleep(1000)
x, y = findColor({0, 0, 1079, 2247}, 
"1002|1186|0xece8e8,994|1172|0xebe7e7,1021|1166|0xeeeae9,1032|1181|0xeceae8,976|1192|0xebe8e8,1001|1202|0xe8e7e7,990|1357|0xe6e6e6,1019|1363|0xe6e6e6,1003|1402|0xe6e6e6,974|1401|0xe6e6e6,1009|1560|0xe6e6e6,1013|1582|0xe6e6e6,1025|1578|0xe5e5e5,981|1581|0xe5e4e5,962|1590|0xe6e6e6",
95, 0, 0, 0)
if x > -1 then
  tap(x, y)
end
print("循环"..i)
mSleep(2000)
end
