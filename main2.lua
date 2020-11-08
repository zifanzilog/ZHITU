i=0
--厉害
while true do
i=i+1
    x, y = findColor({0, 0, 1079, 2247}, 
    "0|0|0xfbad05,-13|-24|0xfcfcfc,7|-24|0xffffff,-1|-34|0x000000,21|-15|0x000002,40|1|0xf9ac00,28|14|0xe5294a,-5|18|0xea0f13,0|47|0xffffff,-40|57|0xfdbc24,-58|15|0xffffff,-55|-14|0xffffff,48|50|0xffffff,-37|81|0xfdbc24,-49|75|0xfffeff",
    95, 0, 0, 0)
    if x > -1 then
		touchDown(1, x, y)
		mSleep(50)
		touchMove(1, x, y)
		mSleep(50)
		touchUp(1, x, y)  
    end
print("循环"..i)
mSleep(50)
end
