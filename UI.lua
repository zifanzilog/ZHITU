

json = require('json')
print(342141241412)
function 页面点击函数(self)
    local 页面宽间距 = 20
    local 页面高间距 = 20
    local 屏幕宽,屏幕高 = UI.获取屏幕尺寸()
    local 页面ID = UI.获取ID(self)
    local JSON2 = UI.获取参数(self)
    local tab2 = json.decode(JSON2)
    local ID = tab2["Page_ID"]
    local i = 0
    while true do
        i=i+1
        local 页面 = UI.获取控件(ID+i)
        local JSON = UI.获取参数(页面)
        local tab = json.decode(JSON)
        local 滑动视图1 = UI.获取控件(tab["父控件"])
        if 页面ID==(ID+i) then
            print(页面ID)
            UI.设置按钮选择状态(页面,true)
            UI.设置字体(页面,20)
            UI.设置背景颜色(滑动视图1,0,0,0,1)
            UI.设置显示范围(滑动视图1,nil,nil,tab["宽"],tab["高"]) --显示
        else
            UI.设置按钮选择状态(页面,false)
            UI.设置字体(页面,17)
            UI.设置背景颜色(滑动视图1,0,0,255,1)
            UI.设置显示范围(滑动视图1,nil,nil,0,0)  --隐藏
        end
        local sizew,sizeh = UI.获取字体尺寸(页面)
        local 页面视图 = UI.获取父视图(页面)
        local 页面显示x,页面显示y,页面显示宽,页面显示高 = UI.获取显示范围(页面视图)
        UI.设置显示范围(页面,(页面显示宽-sizew)/2,(页面显示高-sizeh)/2,sizew,sizeh)  --居中
        if tab["数量"]==i then
          break
        end
    end
end
function 单选框点击函数(self)
    UI.设置按钮选择状态(self,UI.获取按钮选择状态(self))
end
function 创建UI(t)
    local Page_页面视图 = t["Page_页面视图"]
    local 滑动视图 = t["Page_滑动视图"]
    local 滑动x,滑动y,滑动宽,滑动高 = UI.获取显示范围(滑动视图)
    local ID = t["ID"]
    local Tab_JSON = t["Tab_JSON"]
    local Page_x = 0
    local Page_y = 0
    local Page_页面视图x = 0
    local Page_页面视图y = 0
    local Page_i = 0
    local Page_ID = ID
    local 单选视图宽 = 300
    local 单选视图高 = 100
    local 方向 = "垂直"
    for k,v in pairs(Tab_JSON["views"]) do
        if v["type"]=="Page" then
            local 页面宽间距 = 20
            local 页面高间距 = 20
            Page_i = Page_i + 1
            ID = ID + 1
            local 页面视图 = UI.创建("普通视图")
            UI.显示(滑动视图,页面视图)
            UI.设置背景颜色(页面视图,0,255,0,1)
            local 页面 = UI.创建("按钮")
            UI.设置ID(页面,ID)
            UI.显示(页面视图,页面)
            UI.设置按钮标题(页面,v["text"])
            UI.设置按钮标题颜色(页面,0,0,0,1)
            local sizew,sizeh = UI.获取字体尺寸(页面)
            UI.设置显示范围(页面视图,Page_x,(滑动高-(sizeh+页面高间距))/2,sizew+页面宽间距,sizeh+页面高间距)
            local 页面显示x,页面显示y,页面显示宽,页面显示高 = UI.获取显示范围(页面视图)
            UI.设置显示范围(页面,(页面显示宽-sizew)/2,(页面显示高-sizeh)/2,sizew,sizeh)  --居中
            UI.设置按钮已选择标题颜色(页面,0,0,255,1)
            UI.设置按钮点击事件(页面,"页面点击函数")

            Page_x = Page_x+页面显示宽



            local 页面视图1 = UI.创建("滑动视图")
            UI.显示(Page_页面视图,页面视图1)
            local 滑动x,滑动y,滑动宽,滑动高 = UI.获取显示范围(Page_页面视图)
            if( Page_i == 1 ) then  --默认
                UI.设置显示范围(页面视图1,0,0,滑动宽,滑动高)
                UI.设置按钮选择状态(页面,true)
            else
                UI.设置显示范围(页面视图1,0,0,0,0)
            end
            UI.设置背景颜色(页面视图1,0,0,0,1)
            local tab = {
                ["id"]=v["id"],
                ["text"]=v["text"],
                ["type"]=v["type"],
                ["Page_ID"]=Page_ID,  --第一个ID
                ["数量"]=#Tab_JSON["views"],--总数量
                ["父控件"]=UI.获取ID(页面视图1),--绑定其他视图
                ["宽"]=滑动宽,
                ["高"]=滑动高
            }
            local jsonTest = json.encode(tab)
            UI.设置参数(页面,jsonTest)

            创建UI({
                ["Tab_JSON"] = v,
                ["ID"] = ID,
                ["Page_页面视图"]=页面视图1,
            })
        elseif v["type"]=="RadioGroup" then
            local 单选视图 = UI.创建("普通视图")
            UI.显示(Page_页面视图,单选视图)
            UI.设置背景颜色(单选视图,255,0,0,1)
            UI.设置显示范围(单选视图,Page_页面视图x,Page_页面视图y,单选视图宽,单选视图高)
            local R_x = 0
            local R_Y = 0
            local 单选尺寸 = 0
            local 单选高度 = 0
            for R_k,R_v in pairs(v["list"]) do
                local 间距 = 5
                local 控件间距 = 10
                local 单选框 = UI.创建("按钮")
                UI.显示(单选视图,单选框)
                UI.设置显示范围(单选框,R_x,R_Y,30,30)
                UI.设置按钮点击事件(单选框,"单选框点击函数")
                UI.设置按钮图片(单选框,"luaSource/unchecked.png")
                UI.设置按钮已选择图片(单选框,"luaSource/checked.png")
                
                local 单选标题 = UI.创建("标签")
                UI.显示(单选视图,单选标题)
                UI.设置标签文本(单选标题,R_v)
                UI.设置标签文本颜色(单选标题,v["color"][1],v["color"][2],v["color"][3],1)
                local 单选x,单选y,单选w,单选h=UI.获取显示范围(单选框)
                local Le_w,Le_h = UI.获取字体尺寸(单选标题)
                UI.设置显示范围(单选标题,单选x+单选w+间距,R_Y,Le_w,单选h)
                单选尺寸 = 单选w + Le_w + 间距
                单选高度 = 单选h + 间距
                if v["orientation"] == "horizontal" then
                    R_x = R_x + 单选尺寸 + 控件间距
                    if R_x + 单选尺寸 > 单选视图宽 then
                        R_x = 0
                        R_Y = R_Y + 单选高度
                    end
                else
                    R_Y = R_Y + 单选高度
                    if R_Y + 单选h > 单选视图高 then
                        R_Y = 0
                        R_x = R_x + 单选尺寸 + 控件间距
                    end
                end
            end
            if 方向 == "垂直" then
              Page_页面视图y = Page_页面视图y + 单选视图高
            else
              Page_页面视图x = Page_页面视图x + 单选视图宽
            end
        end
    end
        UI.设置滑动范围(滑动视图,Page_x,Page_y)
        UI.设置滑动范围(Page_页面视图,Page_页面视图x,Page_页面视图y)
end
function UIshow(Tab_JSON)
    local ID = 28888
    if type(Tab_JSON)=="table" then
        local 全局视图=UI.获取父视图()
        local 屏幕宽,屏幕高 = UI.获取屏幕尺寸()

        local 滑动视图 = UI.创建("滑动视图")
        UI.显示(全局视图,滑动视图)
        UI.设置背景颜色(滑动视图,255,0,0,1)
        UI.设置显示范围(滑动视图,10,20,屏幕宽-20,50)
        local 滑动x,滑动y,滑动宽,滑动高 = UI.获取显示范围(滑动视图)
        local 页面视图 = UI.创建("滑动视图")
        UI.显示(全局视图,页面视图)
        UI.设置显示范围(页面视图,0,滑动y+滑动高,屏幕宽,500)
        UI.设置背景颜色(页面视图,0,255,0,1)

        创建UI({
            ["Tab_JSON"] = Tab_JSON,
            ["ID"] = ID,
            ["Page_滑动视图"]=滑动视图,
            ["Page_页面视图"]=页面视图,
        })

    end
end
