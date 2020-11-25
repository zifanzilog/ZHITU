-- 函数库
ZHITU_TABLE_rect = {0, 0, 0, 0} -- 脚本范围
ZHITU_TABLE_color = {0, 0, 0xffffff} -- 脚本颜色
ZHITU_TABLE_findColor = {-1, -1, 0xffffff} -- 实际颜色 x:-1,y:-1
ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x00, 0x48, 0xf4, 0x48, 0xf4, 0x00, 0x00} -- 鼠标指令 x:-3000 y:-3000 
ZHITU_TABLE_X = 0 -- 当前坐标
ZHITU_TABLE_Y = 0
ZHITU_TABLE_IP = "192.168.3.3"
ZHITU_TABLE_POST = 60000
local function initShuBiaoZL(i)
    local i1, i2
    if i < 0 then -- 负数i
        local info = string.format("%04x", i)
        i2 = tonumber("0x" .. string.sub(info, 5, 6)) -- 颠倒 转 数值
        i1 = tonumber("0x" .. string.sub(info, 7, 8))
    else
        local info = string.format("%04x", i)
        i2 = tonumber("0x" .. string.sub(info, 1, 2))
        i1 = tonumber("0x" .. string.sub(info, 3, 4))
    end
    return i1, i2 -- 16进制数值
    
end

local function ZHITU_Strtable(str) -- 字符串颜色切割一维表 v=字符串类型
    local co = {}
    if type(str) == 'string' then
        for w in string.gmatch(str, '[^,]+') do
            for w in string.gmatch(w, '[^|]+') do
                table.insert(co, tonumber(w))
            end
        end
    end
    return co
end
local function ZHITU_inittable(t) -- 重新创建表
    local tab = {}
    for k, v in pairs(t) do -- 重新创建
        tab[k] = v
    end
    return tab
end
local function ZHITU_initRGB(ARGB) -- 0xff000000
    local RGB
    -- 把四字节颜色先处理成双字节
    if ARGB > 0x100000000 / 2 then
        ARGB = ARGB - 0x100000000 -- 0x80000000*2
    elseif ARGB >= 0x01000000 and ARGB < 0x100000000 / 2 then
        ARGB = ARGB - 0x01000000
    end
    -- 根据双字节颜色值0xaarrggbb处理成0xrrggbb 不带透明度
    if ARGB < 0 then -- 负数值的颜色
        RGB = ARGB + 0x01000000
        ARGB = ARGB
    else -- 正常颜色值+双字节0x8000000以下的颜色值
        RGB = ARGB
        ARGB = ARGB - 0x01000000
    end
    local r = math.floor(RGB / 0x010000) -- 脚本颜色RGB
    local g = math.floor(RGB % 0x010000 / 0x000100)
    local b = math.floor(RGB % 0x000100)
    return ARGB, (65536 * r) + (256 * g) + (b), r, g, b
end
function ZHITU_string_contains(str, item) -- Lua字符串查找（包含特殊字符）
    local t = {}
    local l = {}
    local index = 0
    for i = 1, string.len(str) do
        table.insert(t, string.byte(string.sub(str, i, i)))
    end

    for i = 1, string.len(item) do
        table.insert(l, string.byte(string.sub(item, i, i)))
    end
    if #l > #t then
        return false
    end

    for k, v1 in pairs(t) do
        index = index + 1
        if v1 == l[1] then
            local iscontens = true
            for i = 1, #l do
                if t[index + i - 1] ~= l[i] then
                    iscontens = false
                end
            end
            if iscontens then
                return iscontens
            end
        end
    end
    return false
end
function findColor(rect, color, degree, hdir, vdir, priority) -- 找色
    local rect = rect or {0, 0, 0, 0}
    local color = color or '0|0|0xffffff'
    local degree = degree or 95
    local hdir = hdir or 0
    local vdir = vdir or 0
    local priority = priority or 0
    ZHITU_TABLE_rect = ZHITU_inittable(rect)
    if type(color) == 'string' then
        ZHITU_TABLE_color = ZHITU_Strtable(color)
    end

    --    RenYu:setdegree(degree)
    --    RenYu:sethdir(hdir)
    --    RenYu:setvdir(vdir)
    --    RenYu:setpriority(priority)

    ZHITU_TABLE_findColor = {-1, -1, 0xffffff} -- x,y  初始化  返回实际颜色
    ZHITU_getfindColor(#ZHITU_TABLE_rect, "ZHITU_TABLE_rect", #ZHITU_TABLE_color, "ZHITU_TABLE_color",
        "ZHITU_TABLE_findColor")
    local t = {}
    if #ZHITUTABLE_findColor > 2 then
        t = ZHITU_inittable(ZHITUTABLE_findColor)
    end
    return t[1], t[2], t
end
function mSleep(i)
    ZHITU_mSleep(i)
end
function touchDown(i, x, y)
    for i = 1, 5 do -- 发送垃圾数据 激活蓝牙休眠
        ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
        ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL",ZHITU_TABLE_POST,ZHITU_TABLE_IP)
    end
    ZHITU_TABLE_X, ZHITU_TABLE_Y = 0, 0 -- 实际位置保存
    -- 初始化 鼠标指令 x:-3000 y:-3000 
    ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x00, 0x48, 0xf4, 0x48, 0xf4, 0x00, 0x00}
    ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL", ZHITU_TABLE_POST,ZHITU_TABLE_IP)
    -- 移动指定位置
    local x1, x2 = initShuBiaoZL(x)
    local y1, y2 = initShuBiaoZL(y)
    ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x00, x1, x2, y1, y2, 0x00, 0x00}
    ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL", ZHITU_TABLE_POST,ZHITU_TABLE_IP)
    -- 点击
    ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
    ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL", ZHITU_TABLE_POST,ZHITU_TABLE_IP)
    ZHITU_TABLE_X, ZHITU_TABLE_Y = ZHITU_TABLE_X + x, ZHITU_TABLE_Y + y -- 实际位置保存
   
end
function touchMove(i, x, y, q)
    local x3 = x - ZHITU_TABLE_X -- 移动距离
    
    local y3 = y - ZHITU_TABLE_Y
    local Q, QQ = 1, 1 -- 循环次数, 余数
    local q = q or 50
    if (math.abs(x3) > math.abs(y3)) then
        Q, QQ = math.modf(math.abs(x3 / q)) -- Q整数,QQ余数 q移动像素值
    else
        Q, QQ = math.modf(math.abs(y3 / q))
    end
    local x_1 = math.floor(x3 / Q + 0.5) -- 这个走的次数多
    local y_1 = math.floor(y3 / Q + 0.5)
    local x1, x2 = initShuBiaoZL(x_1) -- 整数
    local y1, y2 = initShuBiaoZL(y_1)
    for i = 1, Q do
        ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x01, x1, x2, y1, y2, 0x00, 0x00}
        ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL", ZHITU_TABLE_POST,ZHITU_TABLE_IP)
        ZHITU_TABLE_X, ZHITU_TABLE_Y = ZHITU_TABLE_X + x_1, ZHITU_TABLE_Y + y_1 -- 实际位置保存
       
    end
    local x_2 = math.floor(x_1 * QQ + 0.5) -- 这个只走一次
    local y_2 = math.floor(y_1 * QQ + 0.5)
    local x1, x2 = initShuBiaoZL(x_2) -- 余数
    local y1, y2 = initShuBiaoZL(y_2)
    ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x01, x1, x2, y1, y2, 0x00, 0x00}
    ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL", ZHITU_TABLE_POST,ZHITU_TABLE_IP)
    ZHITU_TABLE_X, ZHITU_TABLE_Y = ZHITU_TABLE_X + x_2, ZHITU_TABLE_Y + y_2 -- 实际位置保存
   
end
function touchUp(i, x, y) -- 松开
    ZHITU_TABLE_ShuBiaoZL = {0x0B, 0x00, 0xA1, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
    ZHITU_Socket_ShuBiaoZL(#ZHITU_TABLE_ShuBiaoZL, "ZHITU_TABLE_ShuBiaoZL", ZHITU_TABLE_POST,ZHITU_TABLE_IP)
end

while true do
    mSleep(2000)
    touchDown(1, 500, 500)
    touchMove(i, 800, 800, 20)
    touchUp(i, 800, 800)
end

