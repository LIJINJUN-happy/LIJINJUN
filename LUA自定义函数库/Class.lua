--加载LuaTools工具库
local LuaTools = require("LuaTools")
if not LuaTools then
    assert(LuaTools,"LuaTools.lua库在 Class.lua 文件中加载失败！")
end

--基类的Meta表,每当有新的类都是以这个Meta表作为元表(字段前加_可以避免字段名冲突)
local MetaTable = { 
    ["_Private"] = {           --私有区域（存放相关的成员变量,Save:保存在数据库的信息,Temp:临时信息）
        ["_Save"] = {},        --保存成员变量
        ["_Temp"] = {},        --临时成员变量
        ["_Assignment"] = {},  --New函数赋值参数的顺序（顺序即是调用 RegisterSave 函数的顺序）
    },
    ["_Protected"] = {},     --保护区域 (一些信息)
    ["_Public"] = {},        --公有区域（存放执行函数 以及 存放操作私有成员变量的操作函数Set Get RegisterSave）
}

----------------------------------------------------------------------Lua类库----------------------------------------------------------------------
--所有类的基类
local Class = {}
assert(setmetatable(Class,MetaTable),"Class.lua 设置基类元表的时候发生了预料之外的错误！")

--创建类模版
function Class:Create(ClassName)
    --排好元表索引顺序以及各区域的元表关系
    local metaTable = getmetatable(self)                                       --获取Class元表
    local New_Class , New_MetaTable = {} , LuaTools.DeepCopy(metaTable) or {}  --新类以及新类的元表(与MetaTable一样) 
    setmetatable(New_Class,New_MetaTable)                                      --设置New_MetaTable为新类的元表
    New_MetaTable.__index = New_MetaTable["_Public"]                           --公有区域为新类元表的__index
    setmetatable(New_MetaTable["_Public"],New_MetaTable["_Public"])            --设自己为自己的元表
    New_MetaTable["_Public"].__index = New_MetaTable["_Protected"]             --到protected区域结束,私有不可访问

    --编写类方法
    --类方法：注册保存成员变量(索引字段,默认值)
    function New_MetaTable._Public:RegisterSave(index_Name,default_value)
        if not (type(index_Name) == "string" and #index_Name >= 1) then
            assert(false,"RegisterSave :参数一必须是字符类型，其代表成员变量名，且长度必定要大于零")
        end
        if not default_value then
            assert(false,"RegisterSave :参数二必须不为空，其代表成员变量值")
        end

        if not New_MetaTable["_Private"]["_Save"][index_Name] then                      --判断字段存不存在（不存在才可以注册）
            New_MetaTable["_Private"]["_Save"][index_Name] = default_value
            --设置Assignment字段，给每个新增的字段排序好（方便赋值的时候与参数对应）
            local total_save = LuaTools.Size(New_MetaTable["_Private"]["_Save"]) or 0
            local total_temp = LuaTools.Size(New_MetaTable["_Private"]["_Temp"]) or 0
            local total = (total_save + total_temp) or 1
            New_MetaTable["_Private"]["_Assignment"][index_Name] = total                --代表这个字段是第 total 个注册的字段
        else                                                                            --字段存在不可重复注册（因为字段是唯一变量）
            assert(false,index_Name .. "  字段已被注册，不可重复注册同一字段")
        end
    end

    --类方法：注册临时成员变量(索引字段，默认值)
    function New_MetaTable._Public:RegisterTemp(index_Name,default_value)
        if not (type(index_Name) == "string" and #index_Name >= 1) then
            assert(false,"RegisterSave :参数一必须是字符类型，其代表成员变量名，且长度必定要大于零")
        end
        if not default_value then
            assert(false,"RegisterSave :参数二必须不为空，其代表成员变量值")
        end

        if not New_MetaTable["_Private"]["_Temp"][index_Name] then                      --判断字段存不存在（不存在才可以注册）
            New_MetaTable["_Private"]["_Temp"][index_Name] = default_value
            --设置Assignment字段，给每个新增的字段排序好（方便赋值的时候与参数对应）
            local total_save = LuaTools.Size(New_MetaTable["_Private"]["_Save"]) or 0
            local total_temp = LuaTools.Size(New_MetaTable["_Private"]["_Temp"]) or 0
            local total = (total_save + total_temp) or 1
            New_MetaTable["_Private"]["_Assignment"][index_Name] = total                --代表这个字段是第 total 个注册的字段
        else                                                                            --字段存在不可重复注册（因为字段是唯一变量）
            assert(false,index_Name .. "  字段已被注册，不可重复注册同一字段")
        end
    end

    --类方法：继承类模板（也就是派生出新的类模板，以至于新的类模板是一个独立的新表，与基类模板相互不影响但是可在已有内容上拓展延伸，各自有独立的空间）
    function New_MetaTable._Public:Child(NewClassName)
        local new_class , new_metaTable = {} , LuaTools.DeepCopy(New_MetaTable)    --新类以及新类的元表(与New_MetaTable一样) 
        setmetatable(new_class,new_metaTable)                                      --设置new_metaTable为新类的元表
        new_metaTable.__index = new_metaTable["_Public"]                           --公有区域为新类元表的__index
        setmetatable(new_metaTable["_Public"],new_metaTable["_Public"])            --设自己为自己的元表
        new_metaTable["_Public"].__index = new_metaTable["_Protected"]             --到protected区域结束,私有不可访问

        --此时此刻，经过DeepCopy函数的深复制，新的派生类模板已经和原基类模板的字段内容一致，且各自拥有各自的空间
        --设置新派生类信息，在_Protected字段里面
        if type(NewClassName) ~= "string" then
            assert(nil,"Child 函数的参数必须为字符串，此参数是所继承派生类的新类名") 
            return
        end
        --此时需要判断新的派生类名和基类名是否一致，派生类的类名不可以是父类的类名
        if new_metaTable._Protected._BaseClassName == NewClassName then
            assert(nil,"Child 函数的参数必须与原父类的类名不一致方可") 
            return
        end
        --由于是派生类模板，所以：
        --类型不变（_Type）
        --所属的基类的类名不变（_BaseClassName）
        new_metaTable._Protected._ClassName = NewClassName --设置派生的新类名
        new_metaTable._Protected._CreateTime = os.time()   --创建类模板的时间
        return new_class
    end

    --类方法：生成类对象的成员函数(所有生成的成员变量以及成员函数这时候是一样的)
    function New_MetaTable._Public:New(...)
        --仿造类中的形式排序好元表索引的对象
        local new_class , new_metaTable = {} , LuaTools.DeepCopy(New_MetaTable)    --新类以及新类的元表(与New_MetaTable一样) 
        setmetatable(new_class,new_metaTable)                                      --设置New_MetaTable为新类的元表
        new_metaTable.__index = new_metaTable["_Public"]                           --公有区域为新类元表的__index
        setmetatable(new_metaTable["_Public"],new_metaTable["_Public"])            --设自己为自己的元表
        new_metaTable["_Public"].__index = new_metaTable["_Protected"]             --到protected区域结束,私有不可访问

        --此时new_metaTable已经是独立的表 且其结构与类中的元表一致（此时只要删除类方法保留下成员变量以及成员函数即可）
        new_metaTable._Public.RegisterTemp = nil                                --把临时变量注册函数设为空(因为New出来的是一个类的对象)
        new_metaTable._Public.RegisterSave = nil                                --把保存变量注册函数设为空(因为New出来的是一个类的对象)
        new_metaTable._Public.New = nil                                         --把New函数设为空(因为New函数是类用来创建类对象的)
        new_metaTable._Public.Child = nil                                       --把Child函数设空(因为Child函数是类用来派生新类模板的,类对象不可用)
        --私有区域中的也需要保留（但其存放的均是默认初始化的值）可通过Get和Set函数来更换新的值

        --处理传回来的参数 ... 但lua5.2开始没有pack函数了，所以可以直接放在table里面处理
        local temp_tab = {...}                                                                                   --把参数都放在表里
        local len = #temp_tab                                                                                    --参数数量
        if len > 0 then                                                                                          --创建类对象时候有显式赋值（非默认参数）
            local len_Save,len_Temp = LuaTools.Size(new_metaTable._Private._Save or {}),LuaTools.Size(new_metaTable._Private._Temp or {})
            if len == (len_Save + len_Temp) then                                                                       --参数数量和类注册变量的数量一致
                for index_Name , value in pairs(new_metaTable._Private._Assignment or {}) do                           --遍历所有的成员变量
                    local Val = new_metaTable._Private._Save[index_Name] or new_metaTable._Private._Temp[index_Name]   --得出索引对应的成员变量值（不是在_Save就是在_Temp中）
                    if type(Val) == type(temp_tab[value]) then                                                         --假如成员变量值类型和所赋值的类型相同则进行替换
                        if new_metaTable._Private._Save[index_Name] then                   --假若该字段存在于_Save中
                            new_metaTable._Private._Save[index_Name] = temp_tab[value]
                        else                                                               --假若该字段存在于_Temp中
                            new_metaTable._Private._Temp[index_Name] = temp_tab[value]
                        end
                    else                                                                                               --否则直接报错
                        assert(nil,string.format("New函数: 参数%s的值与类注册所对应字段'%s'的值不一致,此处的数据类型应是一个'%s'型数据,但实际传入数据的类型为'%s'型",tostring(value),index_Name,type(Val),type(temp_tab[value])))
                        return
                    end
                end
            else
                assert(nil,"New函数: 非默认参数生成对象的时候,必须保证参数的数量等于该对象所属类注册的成员变量的数量 ")
                return
            end
        end

        --Save 的 Set And Get 函数方式
        local fun_save = function(index_Name)
            --对象方法：获取私有变量值
            new_metaTable._Public["Get" .. index_Name] = function(self)                       --Get方法
                if new_metaTable["_Private"]["_Save"][index_Name] then                        --返回前判断存不存在该字段
                    return new_metaTable["_Private"]["_Save"][index_Name]                     --存在便返回值
                else
                    assert(nil,"不存在" .. index_Name .. " 该字段名")
                end
            end
            --对象方法：设置私有变量值
            new_metaTable._Public["Set" .. index_Name] = function(self,value)                 --Set方法
                local ttype = type(new_metaTable["_Private"]["_Save"][index_Name])            --替换前判断类型是否一致
                if ttype == type(value) then
                    new_metaTable["_Private"]["_Save"][index_Name] = value
                else
                    assert(nil,string.format("Set%s()函数参数值与原先的值类型不一致,理应传入的值类型为‘%s’型,但实际传入数据的类型为‘%s’型",index_Name,ttype,type(value)) ) 
                end
            end
        end

        --Temp 的 Set And Get 函数方式
        local fun_temp = function(index_Name)
            --对象方法：获取私有变量值
            new_metaTable._Public["Get" .. index_Name] = function(self)                   --Get方法
                if new_metaTable["_Private"]["_Temp"][index_Name] then                      --返回前判断存不存在该字段
                    return new_metaTable["_Private"]["_Temp"][index_Name]                     --存在便返回值
                else
                    assert(nil,"不存在" .. index_Name .. " 该字段名")
                end
            end
            --对象方法：设置私有变量值
            new_metaTable._Public["Set" .. index_Name] = function(self,value)             --Set方法
                local ttype = type(new_metaTable["_Private"]["_Temp"][index_Name])          --替换前判断类型是否一致
                if ttype == type(value) then
                    new_metaTable["_Private"]["_Temp"][index_Name] = value
                else
                    assert(nil,string.format("Set%s()函数参数值与原先的值类型不一致,理应传入的值类型为‘%s’型,但实际传入数据的类型为‘%s’型",index_Name,ttype,type(value)) ) 
                end
            end
        end

        --_Save字段表内的成员变量,令它们有Get and Set function
        for i,_ in pairs(new_metaTable._Private._Save) do
            fun_save(i)
        end
        --_Temp字段表内的成员变量,令它们有Get and Set function
        for i,_ in pairs(new_metaTable._Private._Temp) do
            fun_temp(i)
        end
    
        --设置对象的信息，在_Protected字段里面
        local class_type,base_type = new_metaTable._Protected._ClassName or "",new_metaTable._Protected._BaseClassName or ""
        LuaTools.Clean(new_metaTable._Protected)            --清除表中所有的字段
        new_metaTable._Protected._Type = "object"           --标识为对象类型
        new_metaTable._Protected._ClassName = class_type    --对象类名(可以知道不同对象是不是同类的)
        new_metaTable._Protected._BaseClassName = base_type --基类的类名（所属父类模板的类名）
        new_metaTable._Protected._CreateTime = os.time()    --创建对象的时间

        return new_class
    end
  
    --设置类信息，在_Protected字段里面
    if type(ClassName) ~= "string" then
        assert(nil,"Create 函数的参数必须为字符串，此参数是所创建类的类名") 
        return
    end
    New_MetaTable._Protected._Type = "class"            --标识为类类型
    New_MetaTable._Protected._ClassName = ClassName     --设置类名
    New_MetaTable._Protected._BaseClassName = ClassName --设置基类名（基类名和类名在创建的时候一致 -> 此条件可以判断此类是一个派生类还是一个父类）
    New_MetaTable._Protected._CreateTime = os.time()    --创建类模板的时间

    return New_Class
end


----------------------------------------------------------------------Lua类库----------------------------------------------------------------------
return Class