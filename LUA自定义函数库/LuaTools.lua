--库名为：LuaTools
local LuaTools = {}
----------------------------------------------------------------------Lua工具库函数----------------------------------------------------------------------


--深复制(因为lua的表拷贝均为浅复制,非深复制）
--也就是说拷贝后的地址均是一样的,这样会影响前者的数据,深复制是为了让他们有独立的地址,保证数据间互不干扰)
LuaTools.DeepCopy = function(Tab)
    if type(Tab) ~= "table" then
        assert(nil,"深复制函数参数必须是一个表结构数据类型")
        return
    end
	local temp_tab = {}                  --创建一个表作为返回表（新表和参数表地址不一样，故为深复制）
	local function fun(head,tail,len)    --递归函数（逐层复制）
		len = len + 1                    --每次调用+1次
		if len > 10 then                 --大于十次不允许，断点
			assert(nil,"深度大于10层")
		end
		for i,v in pairs(head) do        --遍历所有的数据
			if type(v) == "table" then   --假如子元素是个表类型
				tail[i] = {}             --以该子元素的索引作为新表索引进行表类型子元素的深复制
 				fun(v,tail[i],len)
			else
				tail[i] = v              --非表类型直接复制（非表类型可以直接拷贝）
			end
		end
	end
	fun(Tab,temp_tab,0)
	return temp_tab
end


--类型函数 除了内置类型之外 还有额外增加了自己定义的类或对象类型,注意!!! 对象 和 类模板 类型不属于 table类型
LuaTools.Type = function(value)
    local ret = type(value)                                        --value类型
    if ret == "table" then                                         --是表类型
        local temp_tab = getmetatable(value)
        if temp_tab then                                           --是否存在元表
            if temp_tab._Protected and temp_tab._Protected._Type and temp_tab._Protected._ClassName and temp_tab._Protected._CreateTime then
                if temp_tab._Protected._Type == "object" then 
                    return "object",temp_tab._Protected._ClassName --返回对象类型
                end
                if temp_tab._Protected._Type == "class" then 
                    return "class"                                 --返回类类型
                end 
            else
                return ret                                         --不存在_Protected _Type等字段均是单纯的table类型
            end 
        else                                                       --不存在元表直接返回是单纯的的表类型
            return ret
        end
    else                                                           --非表类型直接返回
        return ret
    end
end


--真实长度（适用于表和字符串）
LuaTools.Size = function(Tab_Or_Str)
    if not Tab_Or_Str or (type(Tab_Or_Str) ~= "string" and type(Tab_Or_Str) ~= "table")  then
        assert(nil,"参数必须是一个表或字符串类型的数据")
    end
    local lenth = 0
    if type(Tab_Or_Str) == "table" then
        for _,_ in pairs(Tab_Or_Str) do
            lenth = lenth + 1
        end
    elseif type(Tab_Or_Str) == "string" then
        lenth = string.len(Tab_Or_Str)
    end
    return lenth
end


--是否为纯数组
LuaTools.IsArray = function(Tab)
    if not Tab or type(Tab) ~= "table"then
        assert(nil,"参数必须是一个表类型的数据")
    end
    if #Tab == LuaTools.Size(Tab) then
        return true
    end
    return false
end


--是否为纯哈希
LuaTools.IsHash = function(Tab)
    if not Tab or type(Tab) ~= "table"then
        assert(nil,"参数必须是一个表类型的数据")
    end
    if #Tab ~= LuaTools.Size(Tab) and #Tab == 0 then
        return true
    end
    return false
end


--清空表（返回参数表的引用,而不会创建新的表）
LuaTools.Clean = function(Tab)
    if not Tab or type(Tab) ~= "table"then
        assert(nil,"参数必须是一个表类型的数据")
    end
    local function clean1(arg)    --清除数组
        for index = #arg,1,-1 do
            table.remove(arg,index)
        end
        return arg
    end
    local function clean2(arg)    --清除哈希
        for index,_ in pairs(arg) do
            arg[index] = nil
        end
        return arg
    end
    if LuaTools.IsArray(Tab) then --为纯数组
        clean1(Tab)
    else                          --不一致为哈希表或者混杂表
        clean2(Tab)
    end
    return Tab
end


--去重函数（适用于纯数组<且返回此表引用对象而不是新表>以及字符串）
LuaTools.Unique = function(Tab_Or_Str)
    if (type(Tab_Or_Str) ~= "string" and type(Tab_Or_Str) ~= "table") then
        assert(nil,"参数必须是一个表或字符串类型的数据")
    end
    if (type(Tab_Or_Str) == "table") and (LuaTools.IsArray(Tab_Or_Str) == false) then
        assert(nil,"参数必须是一个纯数组类型的数据")
    end
    --字符串去重
    if Tab_Or_Str and type(Tab_Or_Str) == "string" then
        if #Tab_Or_Str == 0 then return Tab_Or_Str end
        local str = ""
        for i = 1,#Tab_Or_Str,1 do
            local temp_str = string.sub(Tab_Or_Str,i,i)  --逐个单字符
            if not string.find(str,temp_str) then        --判断找不到
                str = str .. temp_str
            end
        end
        Tab_Or_Str = str
        return Tab_Or_Str
    end
    --纯数组表去重
    local temp_Tab = {}                             --充当计算器表
    for _,value in ipairs(Tab_Or_Str) do
        if not temp_Tab[value] then
            temp_Tab[value] = 1                     --没有就创建且对应数量为1
        else
            temp_Tab[value] = temp_Tab[value] + 1   --否则数量加一
        end
    end
    for i = #Tab_Or_Str,1,-1 do --从后面开始删除，前面开始可能会因为补位的原因删除不干净
        local index = Tab_Or_Str[i]                 --对应的值
        if temp_Tab[index] >= 2 then                --对应值大于2
            temp_Tab[index] = temp_Tab[index] - 1   --数量减去1
            table.remove(Tab_Or_Str,i)              --移除此数
        elseif temp_Tab[index] == 1 then
        ---------donothing------------
        end
    end
    return Tab_Or_Str
end


--去除指定元素（适用于表和字符串）
LuaTools.Remove = function(Tab_Or_Str,Tab_Or_Val)
    if type(Tab_Or_Str) ~= "table" and type(Tab_Or_Str) ~= "string" then            --数据类型不对
        assert(nil,"参数必须是一个表或字符串类型的数据")
        return
    end
    if Tab_Or_Val == nil or (type(Tab_Or_Val) == "string" and Tab_Or_Val == "") then--第二个参数不存在，或者是一个空字符串
        return Tab_Or_Str
    end
    if type(Tab_Or_Str) == "string" and (type(Tab_Or_Val) ~= "string" and type(Tab_Or_Val) ~= "table") then
        assert(nil,"第一个参数为字符串时,第二个参数必须也为字符串或者字符串数组,此处错误：参数二既不是表也不是字符串类型")
        return 
    end
    --Tab_Or_Str 为表类型
    if type(Tab_Or_Str) == "table" then               --首参是表类型
        if type(Tab_Or_Val) == "table" then           --尾参为表类型
            for _,v in pairs(Tab_Or_Val) do
                for index,value in pairs(Tab_Or_Str) do
                    if value == v then
                        Tab_Or_Str[index] = nil
                    end
                end
            end 
        else
            for index,value in pairs(Tab_Or_Str) do         --尾参为非表类型（如字符串，数值，布尔等....）
                if value == Tab_Or_Val then
                    Tab_Or_Str[index] = nil                 --直接设为垓值
                end
            end
        end
        return Tab_Or_Str
    end
    --Tab_Or_Str 为字符串类型
    if type(Tab_Or_Str) == "string" then                 --首参是字符串类型
        if type(Tab_Or_Val) == "table" then              --尾参是表类型
            for _,value in pairs(Tab_Or_Val) do          --遍历所有表中的元素数据
                if type(value) == "string" then          --判断元素是不是字符类型
                    Tab_Or_Str = string.gsub(Tab_Or_Str,value,"")
                else
                    assert(nil,"第一个参数为字符串时,第二个参数必须也为字符串或者字符串数组,此处错误：参数二不是纯字符串数组类型")
                end
            end
        elseif type(Tab_Or_Val) == "string" then         --尾参是字符串类型
            Tab_Or_Str = string.gsub(Tab_Or_Str,Tab_Or_Val,"")
        end
    end
    return Tab_Or_Str
end


--数组表内元素是否为统一类型 注意！！！(即使是object类型，但是其所属类不一致也不属于同一类型)
LuaTools.IsSameTypeArray = function(Tab)
    if LuaTools.IsArray(Tab) then                      --判断是不是数组
        local first_one = Tab[1]                       --头元素
        local first_one_type = LuaTools.Type(first_one)--头元素类型
        for _,value in ipairs(Tab) do
            if first_one_type ~= LuaTools.Type(value) then
                return false                                 --其中有遇到不一致的就直接返回false
            else                                             --进一步判断对象类型是不是属于同一个类
                if first_one_type == "object" then           --假如是对象类型
                    local temp_tab = getmetatable(first_one) --得出元表
                    if temp_tab._Protected._ClassName ~= (getmetatable(value)._Protected._ClassName) then
                        return false
                    end
                end
            end
        end
        return true
    end
    return false
end


--延迟函数（利用os库中的execute函数调用系统函数,类似C语言的system函数）
LuaTools.Sleep = function(n)
    if n > 0 then
    	os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL") 
    end
end


--读取ini文件，返回一个键值对表
LuaTools.ReadINI = function(path)
	local IO = io.open(path,"r")
    local T = {}
    local list = IO:read("*l")                             --先读取第一行
    local Index                                            --表示当前段的索引标识
    while list do                                          --假如读取成功
        if string.match(list,"%[%a+%]") then               --判断结构是不是[xxx]这样的
            Index = string.match(list,"%w+")               --是的话记录下标识
            T[Index] = {}                                  --创建表
        elseif string.match(list,".+=.+") then             --判断是不是xxx = xxx这样的键值
            local KEY,VAL = string.match(list,"(.+)=(.+)") --是的话吧这些数据传进去刚刚创建的表中
            T[Index][KEY] = VAL                            --以xxx==xxx的=号前的符号作为前缀，=后面的最为后缀
        end
        list = IO:read("*l")                               --读取下一行（直到获取不了）
    end
    return T
end


--数组表元素反轉（利用双指针往中间靠拢移动替换）
LuaTools.Reverse = function(Tab)
	if LuaTools.IsArray(Tab) ~= true then
    assert(nil,"翻转函数必须是一个数组表结构")
		return
	end
	if #Tab <= 1 then       --長度小於等於1直接返回
		return Tab
	end
	local num = 1           --頭部
	local mun = #Tab        --尾部
	while mun > num do      --双指针移动
		local head = Tab[num] --前指针所指元素
		local tail = Tab[mun] --后指针所指元素
		Tab[num] = tail
		Tab[mun] = head
		num = num + 1
		mun = mun - 1
	end
	return Tab
end


--获取是周几（因为wday的周日为1）
LuaTools.GetWeekDay = function(num)
	if type(num) ~= "number" then
		return 
	end
	local temp_tab = {7,1,2,3,4,5,6}
	local temp_val = os.date("*t",num).wday or 8
	return temp_tab[ temp_val ]
end


--某天（无参默认为今日）零点
LuaTools.TodayZeroClock = function(num)
	local t = os.date("*t",num or os.time())
    return os.time({year=t.year, month=t.month, day=t.day, hour=0, min=0, sec=0})
end


--真实随机函数（非伪随机）
LuaTools.Random = function(Tab_Or_Num,Num_Or_Nil)
	local temp_val = tostring(os.time()):reverse():sub(1,6)
    math.randomseed(temp_val)
    if Tab_Or_Num and Num_Or_Nil and type(Tab_Or_Num) == "number" and type(Num_Or_Nil) == "number" then
    	return math.random(Tab_Or_Num,Num_Or_Nil)
    elseif Tab_Or_Num and not Num_Or_Nil and type(Tab_Or_Num) == "number" then
    	return math.random(Tab_Or_Num)
    elseif not Tab_Or_Num and not Num_Or_Nil then
    	return math.random()
    elseif Tab_Or_Num and not Num_Or_Nil and type(Tab_Or_Num) == "table" and #Tab_Or_Num >= 1 and LuaTools.IsArray(Tab_Or_Num) then
    	local num = math.random(1,#Tab_Or_Num)
    	return Tab_Or_Num[num]
    end
    return
end


--判断该时间num是不是在str所描述的时间之内
LuaTools.WhitnTime = function(num,str)
	if not num or type(str) ~= "string" or not type(num) == "number" then
		return
	end
	local ost = os.time()
	local t = os.date("*t",ost)
	local NumTime = os.date("*t",num)
    --判读是不是在str时间之内
    if str == "week" then                                            --是否为本周内
    	if t.year == NumTime.year and t.month == NumTime.month then
    		local wday = LuaTools.GetWeekDay(ost)                    --获取是周几
    		local dayzero = LuaTools.TodayZeroClock(ost)             --获取今日零点
    		local weekzero = dayzero - ((wday -1) * 24 * 60 * 60)    --本周一零点
    		local weekzero_end = weekzero + ( 7 * 24 * 60 * 60 ) - 1 --周末零点
    		if num >= weekzero and num <= weekzero_end then
    			return true
    		else
    			return false
    		end
    	else
    		return false
    	end
    elseif str == "year" then                                        --是否为今年内
    	if t.year == NumTime.year then
    		return true
    	else
    		return false
    	end
    elseif str == "month" then                                       --是否为本月内
    	if t.year == NumTime.year and t.month == NumTime.month then
    		return true
    	else
    		return false
    	end		
    elseif str == "day" then                                         --是否为今日内
    	if t.year == NumTime.year and t.month == NumTime.month and t.day == NumTime.day then
        return true
    	else
    		return false
    	end
    elseif str == "hour" then                                        --是否为这个小时之内
    	if t.year == NumTime.year and t.month == NumTime.month and t.day == NumTime.day and t.hour == NumTime.hour then
    		return true
    	else
    		return false
    	end
    elseif str == "min" then                                         --是否为这分钟之内
    	if t.year == NumTime.year and t.month == NumTime.month and t.day == NumTime.day and t.hour == NumTime.hour and t.min == NumTime.min then
    		return true
    	else
    		return false
    	end		
    end
end


--分割函数，分割字符串中每个字符，或者以参数二中的字符为参照分割参数一的字符串
LuaTools.Split = function(str,n)
    if str and n and (type(str) ~= "string" or type(n) ~= "string") then
        assert(type(str) ~= "string" and type(n) ~= "string","当存在参数一和参数二的时候,两参数均需要指定为字符串类型")
        return false
    end
    if str and type(str) ~= "string" then
        assert(nil,"参数一需要指定为字符串类型")
        return false
    end
    if str and n and (n == "" or str == "") then        --两者有其一为空字符串直接返回表
        return {str}
    end
    local Tab = {}
    if str and n then                                   --到了此处两者均不为空
        local index                                     --下标
        ocal temp_str                                   --下标前分割的临时字符
        repeat 
            index = string.find(str,n)                  --用find函数查找
            if index then                               --找到的话
                if index == 1 and index ~= #str then    --判断index值是不是在第一个首字符索引
                --------------doNothing---------------  --第一个就是分隔符所以不需要任何操作直接忽视,从下一个字符作为字符串首
                elseif index == 1 and index == #str then--剩下一个字符的字符串而且是分割服n便直接退出
                    str = ""                            --相当于str是个空字符串因为除了分隔符没有其他的字符了
                    break
                else                                    --不是第一个字符（但有可能是最后一个）
                    temp_str = string.sub(str,1,index-1)--记录下临时字符（不包括分隔符，所以减一）
                    table.insert(Tab,temp_str)          --把分割出来的字符放入表中
                    if index == #str then               --假如找到的索引是最后一个字符
                        str = ""                        --相当于str是个空字符串因为分隔符后没有其他的字符了
                        break                           --直接退出不需要继续在查找了
                    end
                end
                str = string.sub(str,index+1,#str)      --不是最后一个或是第一个字符的话,用索引下标后的字符串覆盖旧的字符串
            end
        until index == nil
        if str ~= "" then                               --假如是个非空表证明是因为在循环中找不到分隔符了,但是在退出循环前分隔符后的字符串没有被处理
            table.insert(Tab,str)
        end
    elseif str and (n == nil) then
        for index = 1 ,#str ,1 do
            local temp_str = string.sub(str,index,index)
            table.insert(Tab,temp_str)
        end
    end
    return Tab
end


--得出数组中最大值
LuaTools.Max = function(Tab)
    local result
    if LuaTools.IsArray(Tab) == true then 
        if LuaTools.IsSameTypeArray(Tab) then
            if Tab[1] == "number" or Tab[1] == "string" then
                local temp_tab = LuaTools.DeepCopy(Tab) or {}
                table.sort(temp_tab)
                if temp_tab[1] then          --存在数据
                    result = temp_tab[#Tab]  --取最后一个
                end
            else
                assert(nil,"表中的所有元素类型要指定为 number类型 或者 string类型！")
            end
        else
            assert(nil,"表中的所有元素需要一致！")
        end
    else
        assert(nil,"参数需要指定为纯数组类型！")
    end
    return result
end


--得出数组中最小值
LuaTools.Min = function(Tab)
    local result
    if LuaTools.IsArray(Tab) == true then 
        if LuaTools.IsSameTypeArray(Tab) then
            if Tab[1] == "number" or Tab[1] == "string" then
                local temp_tab = LuaTools.DeepCopy(Tab) or {}
                table.sort(temp_tab)
                if temp_tab[1] then          --存在数据
                    result = temp_tab[1]     --取第一个
                end
            else
                assert(nil,"表中的所有元素类型要指定为 number类型 或者 string类型！")
            end
        else
            assert(nil,"表中的所有元素需要一致！")
        end
    else
        assert(nil,"参数需要指定为纯数组类型！")
    end
    return result
end


----------------------------------------------------------------------Lua工具库函数----------------------------------------------------------------------
return LuaTools