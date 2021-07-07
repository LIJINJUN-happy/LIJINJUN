--加载LuaTools工具库
local LuaTools = require("LuaTools")
if not LuaTools then
  assert(LuaTools,"LuaTools.lua库在 Class.lua 文件中加载失败！")
end

--基类的Meta表,每当有新的类都是以这个Meta表作为元表
local MetaTable = { 
  ["Private"] = {["Save"]={},["Temp"]={}},--私有区域（存放相关的成员变量）
  ["Protected"] = {},                     --保护区域（存放操作私有成员变量的操作函数）
  ["Public"] = {},                        --公有区域（存放执行函数）
}

----------------------------------------------------------------------Lua类库----------------------------------------------------------------------
--所有类的基类
local Class = {}
assert(setmetatable(Class,MetaTable),"Class.lua 设置基类元表的时候发生了预料之外的错误！")

--创建类模版
function Class:Create()
  --排好元表索引顺序以及各区域的元表关系
  local metaTable = getmetatable(self)                                       --获取Class元表
  local New_Class , New_MetaTable = {} , LuaTools.DeepCopy(metaTable) or {}  --新类以及新类的元表(与MetaTable一样) 
  setmetatable(New_Class,New_MetaTable)                                      --设置New_MetaTable为新类的元表
  New_MetaTable.__index = New_MetaTable.Public                               --公有区域为新类元表的__index
  setmetatable(New_MetaTable.Public,New_MetaTable.Public)                    --设自己为自己的元表
  New_MetaTable.Public.__index = New_MetaTable.Protected                     --到protected区域结束,私有不可访问

  --编写类方法
  --注册保存成员变量(索引字段,默认值)
  function New_MetaTable.Protected:RegisterSave(index_Name,default_value)
    if not (type(index_Name) == "string") then
      assert(false,"RegisterSave :参数一必须是字符类型，其代表成员变量名")
    end
    if not default_value then
      assert(false,"RegisterSave :参数二必须不为空，其代表成员变量值")
    end
    if not New_MetaTable.Private.Save[index_Name] then
      New_MetaTable.Private.Save[index_Name] = default_value
      New_MetaTable.Protected["Get" .. index_Name] = function(self)
        if New_MetaTable.Private.Save[index_Name] then
          return New_MetaTable.Private.Save[index_Name]
        end
      end
      New_MetaTable.Protected["Set" .. index_Name] = function(self,value)
        local ttype = type(New_MetaTable.Private.Save[index_Name])
        if ttype == type(value) then
          New_MetaTable.Private.Save[index_Name] = value
        else
          assert(nil,"Set" .. index_Name .. " 字段设置的值与原先的值类型不一致" ) 
        end
      end
    else
      assert(false,index_Name .. "  字段已被注册，不可重复注册同一字段")
    end
  end

  --注册临时成员变量(索引字段，默认值)
  function New_MetaTable.Protected:RegisterTemp(index_Name,default_value)
    if not (type(index_Name) == "string") then
      assert(false,"RegisterSave :参数一必须是字符类型，其代表成员变量名")
    end
    if not default_value then
      assert(false,"RegisterSave :参数二必须不为空，其代表成员变量值")
    end
    if not New_MetaTable.Private.Temp[index_Name] then
      New_MetaTable.Private.Temp[index_Name] = default_value
      New_MetaTable.Protected["Get" .. index_Name] = function(self)
        if New_MetaTable.Private.Temp[index_Name] then
          return New_MetaTable.Private.Temp[index_Name]
        end
      end
      New_MetaTable.Protected["Set" .. index_Name] = function(self,value)
        local ttype = type(New_MetaTable.Private.Temp[index_Name])
        if ttype == type(value) then
          New_MetaTable.Private.Temp[index_Name] = value
        else
          assert(nil,"Set" .. index_Name .. " 字段设置的值与原先的值类型不一致" )
        end
      end
    else
      assert(false,index_Name .. "  字段已被注册，不可重复注册同一字段")
    end
  end

  --生成类对象的成员函数(所有生成的成员变量以及成员函数需要一样)
  function New_MetaTable.Protected:New()
  end

  return New_Class
end


----------------------------------------------------------------------Lua类库----------------------------------------------------------------------
return Class