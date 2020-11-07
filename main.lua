i = 0
while true do
i=i+1
print("智图学院")
if i>500 then
i=-500
else
touchMove(1, 0, i)
end
mSleep(50)
end