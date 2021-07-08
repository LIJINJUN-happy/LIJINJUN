--加载LuaTools工具库
local LuaTools = require("LuaTools")
if not LuaTools then
  assert(LuaTools,"LuaTools.lua库在 Class.lua 文件中加载失败！")
end

--基类的Meta表,每当有新的类都是以这个Meta表作为元表(字段前加_可以避免字段名冲突)
local MetaTable = { 
  ["_Private"] = {         --私有区域（存放相关的成员变量,Save:保存在数据库的信息,Temp:临时信息）
    ["_Save"] = {},        --保存成员变量
    ["_Temp"] = {},        --临时成员变量
    ["_Assignment"] = {},  --赋值顺序（顺序即是调用 RegisterSave 函数的顺序）
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
      New_MetaTable["_Private"]["_Assignment"][index_Name] = total                  --代表这个字段是第 total 个注册的字段
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
      New_MetaTable["_Private"]["_Assignment"][index_Name] = total                  --代表这个字段是第 total 个注册的字段
    else                                                                            --字段存在不可重复注册（因为字段是唯一变量）
      assert(false,index_Name .. "  字段已被注册，不可重复注册同一字段")
    end
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
    --私有区域中的也需要保留（但其存放的均是默认初始化的值）可通过Get和Set函数来更换新的值

    --处理传回来的参数 ... 但lua5.2开始没有pack函数了，所以可以直接放在table里面处理
    local temp_tab = {...}                                                     --把参数都放在表里
    if #temp_tab > 0 then                                                      --创建类对象时候有显式赋值（非默认参数）
    end

    --Save 的 Set And Get 函数方式
    local fun_save = function(index_Name)
      --对象方法：获取私有变量值
      new_metaTable._Public["Get" .. index_Name] = function(self)                   --Get方法
        if new_metaTable["_Private"]["_Save"][index_Name] then                      --返回前判断存不存在该字段
          return new_metaTable["_Private"]["_Save"][index_Name]                     --存在便返回值
        else
          assert(nil,"不存在" .. index_Name .. " 该字段名")
        end
      end
      --对象方法：设置私有变量值
      new_metaTable._Public["Set" .. index_Name] = function(self,value)             --Set方法
        local ttype = type(new_metaTable["_Private"]["_Save"][index_Name])          --替换前判断类型是否一致
        if ttype == type(value) then
          new_metaTable["_Private"]["_Save"][index_Name] = value
        else
          assert(nil,"Set" .. index_Name .. " 字段设置的值与原先的值类型不一致" ) 
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
          assert(nil,"Set" .. index_Name .. " 字段设置的值与原先的值类型不一致" ) 
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
    local base_type = new_metaTable._Protected.ClassName or ""
    LuaTools.Clean(new_metaTable._Protected)        --清除表中所有的字段
    new_metaTable._Protected.Type = "object"        --标识为对象类型
    new_metaTable._Protected.ClassName = base_type  --对象所基于类的类名
    new_metaTable._Protected.CreateTime = os.time() --创建时间

    return new_class
  end
  
  --设置类信息，在_Protected字段里面
  if type(ClassName) ~= "string" then
    assert(nil,"Create 函数的参数必须为字符串，此参数是所创建类的类名") 
    return
  end
  New_MetaTable._Protected.Type = "class"         --标识为类类型
  New_MetaTable._Protected.ClassName = ClassName  --设置类名
  New_MetaTable._Protected.CreateTime = os.time() --创建时间

  return New_Class
end


----------------------------------------------------------------------Lua类库----------------------------------------------------------------------
return Class