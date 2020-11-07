i = 0
--厉害
touchDown(1, 100, 100)
while true do
i=i+1
print("智图学院222")
if i>500 then
i=-500
else
touchMove(1, 100, 100+i)
end
mSleep(50)
end
touchUp(1, 150, 150)  