--------------------------------------------------面向對象封裝----------------------------------------------------------------------------------------

--所有类的基类
Class = {
	ClassName = "BaseClass",  --类名称
	private = {},             --私有区域（私有成员，键值对）
	protected = {},           --保护区域（Registration注册字段函数）
	public = {},              --公有区域（Get 和 Set 函数）
}


--创建类
function Class:Inherit(ClassName)
	--先深复制一个返回对象
	local temp_tab = Patch_DeepCopy(self)
	--设置公有类区域（设为元表，用来访问私有区域）
    temp_tab = setmetatable(temp_tab,temp_tab.public)
    --设置保护区域为共有区域的私有区域（此区域放置一些基类必备的函数，如注册函数）
    setmetatable(temp_tab.public,temp_tab.protected)

    --设置元方法，在表中索引不了对应方法就在__index中查找
    temp_tab.public.__index = temp_tab.public
    temp_tab.protected.__index = temp_tab.protected

    --注册字段表示私有部分的内置类型成员，且在公有处增加Set和Get的成员函数
    temp_tab.protected["Registration"] = function(KEY,VAL)
	    if not (KEY and type(KEY) == "string" and VAL and ClassName) then
	        return                         --先记录下在私有区域的的键值对成员(键值对均不可为空)
	    end
	    if type(VAL) == "table" then       --假如这个值为表类型
		    local tab = Patch_DeepCopy(VAL)--要重新深复制一个新表来保存,避免VAL被操作后导致类对象数据被修改
		    temp_tab.private[KEY] = tab
	    else
		    temp_tab.private[KEY] = VAL
	    end

	--在私有区域记录完后,要在共有区域创建get和set函数,因为私有区域不可以直接读取,要通过共有区域的方法获取
	    temp_tab.public["Get"..KEY] = function()
	        return temp_tab.private[KEY]
	    end
	    temp_tab.public["Set"..KEY] = function(temp_val)
	        temp_tab.private[KEY] = temp_val
	        if temp_tab.private[KEY] then
	        	return true
	        end
	        return
	    end
	--成功返回true
	    return true
    end

    --设置类名称 
    temp_tab.ClassName = ClassName
    --继承父类的函数（用于子类去派生子类）
    temp_tab["Inherit"] = Class["Inherit"]
    return temp_tab
end


--創建類的实例對象(参数是类)
function New(class)
	if type(class) ~= "table" then
		return false
	end
	--返回一个类
	local tab = Class:Inherit(class.ClassName or "")       --该对象的类为class的类名
	if not (tab and type(tab) == "table" and tab.private and tab.protected and tab.public) then
		return                                             --假如没有各种区域则直接返回
	end
    --成员函数已经成员变量的拷贝
    for index,Type in pairs(class) do                       --遍历所有的数据
    	if type(Type) == "table" then                       --加入遍历到了私有公有保护区域
    		if index == "private" then                      --假如是私有区域
    			for KEY,VAL in pairs(Type) do               --遍历该私有区域的所有成员遍历的键值对（复制）
    				if type(VAL) == "table" then            --是个表类型（需要深复制）
    					tab.private[KEY] = Patch_DeepCopy(VAL)
    				elseif type(VAL) ~= "table" and type(VAL) ~= "function" then
    					tab.private[KEY] = VAL              --非表非函数则直接赋值
    				end
    			end
    		elseif index == "public" then                   --假如是公有区域
    			for i,v in pairs(Type) do                   --遍历所有的公有数据
    				local head = string.sub(i,1,3)          --获取前缀（为了查看是不是Get或者Set前缀）
    				if type(v) == "function" and (head == "Get" or head == "Set") then
    					tab.public[i] = v                   --记录下公有区域的get and set function
    				end
    			end
    		elseif index == "protected" then                --假如是保護区域
    			for i,v in pairs(Type) do                   --遍历所有的公有数据
    				if type(v) == "function" then
    					tab.protected[i] = v                --记录下保護区域的function
    				end
    			end
    		end
    	elseif type(Type) == "function" then                --成员函数直接复制
    		tab[index] = Type
    	end
    end
    --类变对象（除去不该存在的函数）
	if tab.protected["Registration"] or tab["Inherit"] then --因为对象没有继承和注册对象的能力
	    tab.protected["Registration"] = nil                 --所以要去掉这两个函数（留下get and set 函数）
	    tab["Inherit"] = nil
    end
    return tab
end


--用於判断是类还是对象还是既不是类也不是对象（返回nil则啥也不是,否则返回字符串标识类或者字段）
function ClassOrObj(tab)
	if not type(tab) == "table" or not tab.ClassName or not tab.private or not tab.public or not tab.protected then
		return                                   --假如不是表类型且没有ClassName字段或者缺少任意区域字段的都不是类也不是对象
	end
	local num = tab["Inherit"]                   --派生函数
	local mun = tab.protected["Registration"]    --注册字段的函数
	if num and type(num) == "function" and mun and type(mun) == "function" then
		return "CLASS"                           --假如获取到了这两个函数的话就是一个类
	end
	return "OBJECT"                              --否则是一个对象
end


--------------------------------------------------自定義工具庫函數--------------------------------------------------------------------------------------

--删除表中全部指定的元素--仅仅用于数组
--tab为待处理数组，parameter为数组或者字符串或者数字
function Patch_Remove(tab,parameter)
	if not tab or type(tab) ~= "table" then     --检测第一个参数
		assert(nil,"第一个参数的类型需要为table")
		return 
	end
	if not parameter or #tab == 0 then          --检测第二个参数
		return tab
	end
	--判断parameter类型
	if type(parameter) == "table" then          --类型为表(数组)
		local temp_tab = {}
		for _,v in ipairs(parameter) do
			temp_tab[ v ] = v                   --无论是字符或者数字都作为键值对保存
		end
		for index = #tab,1,-1 do                --遍历所有的数据
			local temp_val = tab[ index ]       --获取每个元素（局部变量）
			if temp_tab[ temp_val ] then        --假如在临时键值对表中索引到相关值
				table.remove(tab,index)         --在tab中删除掉相关的值
			end
		end 
	elseif type(parameter) == "string" or type(parameter) == "number" then
		for index = #tab,1,-1 do
			if tab[ index ] == parameter then
				table.remove(tab,index)
			end
		end
	end
	--table.sort(tab)
	return tab
end


--去重函数(适用于数字数组和字符串数组以及字符串)
function Patch_Unique(list)
	if type(list) == "table" and #list > 1 then
		table.sort(list)            --先排序
		local temp_tab = {}
		for index = #list,1,-1 do   --遍历所有的数据
			local temp_val = list[ index ]
			if not temp_tab[ temp_val ] then
				temp_tab[ temp_val ] = temp_val
			end
		end  
		list = {}                    --置空list表
		for _,v in pairs(temp_tab) do--遍历所有键值对(因为键值对为唯一值,可以达到去重目的)
			table.insert(list,v)     --放入list中
		end
	elseif type(list) == "string" and string.len(list) >= 1 then
		local temp_tab = {}
		for i=1,string.len(list) do
			local temp_val = string.sub(list,i,i)
			if temp_val then
				table.insert(temp_tab,temp_val)
			end
		end
		list = Patch_Unique(temp_tab)
	else
		return
	end
	table.sort(list)
	return list
end


--键值对表和数组表的互转（不可以是不同值类型的）
--若tab为数组，且其子元素均有哈希键值对的时候，取inde为索引构建键值对
function Patch_Conversion(tab,index)
	if type(tab) ~= "table" then          --假如不是表类型直接返回
		return 
	end
	local num = 0                         --创建一个局部变量来记录数据大小
	local mun = 0                         --创建一个局部变量来记录数据同类型大小
	local Type
	for _,v in pairs(tab) do
		if num == 0 then                  --刚开始用遍历到的数据类型作为参考
			Type = type(v)                --记录下数据类型
		end
		num = num + 1                     --用pairs遍历，有遍历到就 +1
		if type(v) == Type then
			mun = mun + 1
		end
	end
	if num <= 0 or num ~= mun then        --空表或者不是单一类型表则直接返回
		--assert(nil,"类型不一样")
		return
	end
	--到了这里知道了不为空,且所有值类型相同，再进一步判断是属于数组还是键值对表
	local list = {}
	--#tab 有可能为零或者小于tab实际长度是因为可能以字符串为索引或者以不连续数字为索引
	if #tab ~= num then                   --假设为哈希表--》需要转化为纯数组
		for _,v in pairs(tab) do
			table.insert(list,v)
		end
	elseif #tab >= 1 and #tab == num then --假设为纯数组--》需要转化为哈希表
		if Type ~= "table" then           --假如tab子元素为字符串或者数字时候
			for _,v in ipairs(tab) do     --以本身作为索引键，且以本身作为值对
			    list[ v ] = v
		    end
		elseif Type == "table" then
			if not index then
				assert(index,"当子元素为表类型时候,Patch_Conversion函数需要两个参数,参数2不可为空")
				return                    --tab子元素为表则index必须为索引（不可空）
			end
			for _,v in ipairs(tab) do
				local temp_val = v[index] --子元素索引对应的字段
				if not temp_val then      --假如在元素中找不到相关的索引，这时候直接返回
					return
				else
					if list[temp_val] then--假在list中索引到了该字段证明在tab的子元素中的index索引对应值不唯一
						return
					else
						list[temp_val] = v
					end
				end
			end
		end
	end
	return list
end


--真实随机函数（非伪随机）
function Patch_Random(head,tail)
	local temp_val = tostring(os.time()):reverse():sub(1,6)
    math.randomseed(temp_val)
    if head and tail and type(head) == "number" and type(tail) == "number" then
    	return math.random(head,tail)
    elseif head and not tail and type(head) == "number" then
    	return math.random(head)
    elseif not head and not tail then
    	return math.random()
    elseif head and not tail and type(head) == "table" and #head >= 1 then
    	local num = math.random(1,#head)
    	return head[num]
    end
    return
end


--某天（无参默认为今日）零点
function Patch_TodayZeroClock(num)
	local t = os.date("*t",num or os.time())
    return os.time({year=t.year, month=t.month, day=t.day, hour=0, min=0, sec=0})
end


--获取是周几（因为wday的周日为1）
function Patch_GetWeekDay(num)
	if type(num) ~= "number" then
		return 
	end
	local temp_tab = {7,1,2,3,4,5,6}
	local temp_val = os.date("*t",num).wday or 8
	return temp_tab[ temp_val ]
end


--判断该时间num是不是在str所描述的时间之内
function Patch_WhitnTime(num,str)
	if not num or type(str) ~= "string" or not type(num) == "number" then
		return
	end
	local ost = os.time()
	local t = os.date("*t",ost)
	local NumTime = os.date("*t",num)
    --判读是不是在str时间之内
    if str == "week" then                                            --是否为本周内
    	if t.year == NumTime.year and t.month == NumTime.month then
    		local wday = Patch_GetWeekDay(ost)                       --获取是周几
    		local dayzero = Patch_TodayZeroClock(ost)                --获取今日零点
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


--表元素反轉
function Patch_TableReverse(tab)
	if type(tab) ~= "table" then
		return
	end
	if #tab <= 1 then         --長度小於等於1直接返回
		return tab
	end
	local num = 1             --頭部
	local mun = #tab          --尾部
	while mun > num do        --双指针移动
		local head = tab[num] --前指针所指元素
		local tail = tab[mun] --后指针所指元素
		tab[num] = tail
		tab[mun] = head
		num = num + 1
		mun = mun - 1
	end
	return tab
end


--字符串分割->返回一个列表
--str是个字符串，t也是字符类型
function Patch_Split(str,t)
	if type(str) ~= "string" or type(t) ~= "string" then return end
	if str == t then return {} end                      --假如str就是分隔符则返回空表因为无分隔
	if not string.find(str,t) then return {str} end     --没有找到分隔符直接返回一个元素的表
	local temp_tab , num , temp_val = {},string.len(str)--分别代表返回列表，索引，累积字符串
	for i = 1 , num do                                  --逐个遍历
		local v = string.sub(str,i,i)                   --获取当前索引对应的字符串中的元素
		if v ~= t then                                  --假如不是分隔符
			if temp_val then                            --判断是不是新的开始
				temp_val = temp_val..v                  --不是则叠加
			else
				temp_val = v                            --是的话就赋值作为开头
			end
		end
		if v == t or i == num then                      --假如是到了分隔符的地方或者是最后末尾处
			table.insert(temp_tab,temp_val or "")       --放入返回列表中
			temp_val = nil                              --置空（重新开始记录新的临时字符串）
			if v == t and i == num then                 --假如最后一个是分隔符则要在最后加多个空字符串
				table.insert(temp_tab,temp_val or "")   --放入返回列表中
			end
		end
	end
	return temp_tab
end


--数组表中所有指定元素替换
function Patch_Replace(tab,head,tail)
	if not tab or not head or not tail or type(tab) ~= "table" or #tab == 0 then
		return
	end
	local num , mun = 0 , 0
	local Type
	for _,v in pairs(tab) do
		if num == 0 then                  --刚开始用遍历到的数据类型作为参考
			Type = type(v)                --记录下数据类型
		end
		num = num + 1                     --用pairs遍历，有遍历到就 +1
		if type(v) == Type then
			mun = mun + 1
		end
	end
	if num <= 0 or num ~= mun then        --空表或者不是单一类型表则直接返回
		--assert(nil,"类型不一样")
		return
	end
    --至此已经判断完类型以及数据大小的准确性
    --开始进行替换
    for i,v in ipairs(tab) do             --遍历所有的数据
    	if v == head then                 --找到要替换的目标子元素
    		tab[i] = tail                 --后者提的换掉前者
    	end
    end
    return tab                            --返回列表
end


--读取ini文件，返回一个键值对表
function Patch_ReadINI(path)
	local IO = io.open(path,"r")
    --print(IO)
    local T = {}
    local list = IO:read("*l")                                 --先读取第一行
    local Index                                                --表示当前段的索引标识
    while list do                                              --假如读取成功
        if string.match(list,"%[%a+%]") then                   --判断结构是不是[xxx]这样的
            Index = string.match(list,"%w+")                   --是的话记录下标识
            T[Index] = {}                                      --创建表
        elseif string.match(list,".+=.+") then                 --判断是不是xxx = xxx这样的键值
            local KEY,VAL = string.match(list,"(.+)=(.+)")     --是的话吧这些数据传进去刚刚创建的表中
            T[Index][KEY] = VAL                                --以xxx==xxx的=号前的符号作为前缀，=后面的最为后缀
        end
        list = IO:read("*l")                                   --读取下一行（直到获取不了）
    end
    --[[for i,v in pairs(T) do                                 --打印一下数据
        print(i,"={")                                          --索引前缀
        for ii,vv in pairs(v) do                               --元素
            print(ii,"=",vv)
        end
        print("}\n")
    end--]]
    return T
end


--深复制(因为lua的表拷贝均为浅复制,非深复制）
--也就是说拷贝后的地址均是一样的,这样会影响前者的数据,深复制是为了让他们有独立的地址,保证数据间互不干扰)
function Patch_DeepCopy(tab)
	local temp_tab = {}                    --创建一个表作为返回表（新表和参数表地址不一样，故为深复制）
	local function fun(head,tail,len)      --递归函数（逐层复制）
		len = len + 1                      --每次调用+1次
		if len > 10 then                   --大于十次不允许知己断点
			assert(nil,"深度大于10层")
		end
		for i,v in pairs(head) do          --遍历所有的数据
			if type(v) == "table" then     --假如子元素是个表类型
				tail[i] = {}               --以该子元素的索引作为新表索引进行表类型子元素的深复制
 				fun(v,head[i],len)
			else
				tail[i] = v                --非表类型直接复制（非表类型可以直接拷贝）
			end
		end
	end
	fun(tab,temp_tab,0)
	return temp_tab
end


--延遲函數(利用ping的性質作為延遲)
function Patch_Sleep(n)
    if n > 0 then
    	os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL") 
    end
end


--表真实长度（不区分数组和键值对表）
function Patch_Size(tab)
	if not tab or type(tab) ~= "table" then
		return
	end
	local num = 0
	for _ , _ in pairs(tab) do
		num = num + 1
	end
	return num
end


--判断是数组还是纯键值对或者是既不是纯数组也不是纯键值对
function Patch_ArrayOrMap(tab)
	local mun = Patch_Size(tab)
	local num = #tab
	--if array
	if num >= 1 and num == mun then
		return "Array"        --假如表长度不为0且长度为所有子元素数量,即为纯数组
	end
	--if array and Map
	if num >= 1 and num ~= mun then
		return "ArrayAndMap"  --假如长度不为零且表长度与所有子元素数量不符,即又不是纯数组也不是纯键值对表
	end
	--if Map
	if num == 0 and mun >= 1 then
		return "Map"          --假如表格长度为零,但是遍历的时候子元素不为0,则全部都是键值对（纯键值对表）
	end
	--if nil table
	if num == 0 and mun == 0 then
		return                --假如是个空表，返回空
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------