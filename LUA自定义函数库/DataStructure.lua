--Create The Queue（列隊）
function CreatQueue(tab)
    if not tab or type(tab) ~= "table" or #tab <= 0 then
        return                          --判断是否无参或者空表
    end
    local num = 1
    local return_tab = {}
    for _,v in ipairs(tab) do         --逐個賦值
        return_tab[num] = v
        num = num + 1
    end
    return_tab.StructureType = "Queue"--得出結構類型（列隊）
    return_tab.front = function() 
        return return_tab[1] 
    end                               --取队首元素
    return_tab.back = function() 
        return return_tab[#return_tab] 
    end                               --取队尾元素
    return_tab.push = function(x) 
        return_tab[#return_tab + 1] = x 
    end                               --将元素x入队
    return_tab.pop = function() 
        table.remove(return_tab,1) 
    end                               --将队首元素出队
    return_tab.size = function() 
        return #return_tab 
    end                               --返回队列的长度
    return_tab.empty = function() 
        if #return_tab == 0 then
            return true
        else
            return false
        end
    end                               --判断队列是否为空，若为空则返回true，否则返回false
    return return_tab
end


--Create The Stack（棧）
function CreatStack(tab)
    if not tab or type(tab) ~= "table" or #tab <= 0 then
        return                          --判断是否无参或者空表
    end
    local num = 1
    local return_tab = {}
    for _,v in ipairs(tab) do         --逐個賦值
        return_tab[num] = v
        num = num + 1
    end
    return_tab.StructureType = "Stack"--得出結構類型（棧）
    return_tab.empty = function()     --堆栈为空则返回真
        if #return_tab == 0 then
            return true
        end
        return false
    end
    return_tab.pop = function()       --移除栈顶元素
        table.remove(return_tab,1)
    end
    return_tab.push = function()      --在栈顶增加元素
        table.insert(return_tab,1)
    end
    return_tab.size = function()      --返回栈中元素数目
        return #return_tab
    end
    return_tab.top = function()       --返回栈顶元素
        return return_tab[1]
    end
    return return_tab
end


--Create The List Structure(鏈表)
function CreatList(tab)
    if not tab or type(tab) ~= "table" or #tab <= 0 then --判断是否无参或者空表
        return
    end
    local return_tab = {}                                --返回值（成型的鏈表）
    local tab_index = 1                                  --當前索引
    local function fun(r_t,t_i)                          --尾調函數
        if not (r_t and t_i and tab[t_i]) then             --判斷索引的值爲否空
            return
        end
        --開始創建鏈表節點
        r_t.StructureType = "List"                         --得出結構類型（鏈表）
        r_t.Head = return_tab                              --每個節點的Head字段都是只想頭部（避免遍歷鏈表的時候丟失了頭部節點）
        r_t.Val = tab[t_i]                                 --賦值
        --判斷下個節點是否有值
        if tab[t_i + 1] then
            r_t.Next = {}                                  --存在下個節點
        else
            r_t.Next = nil                                 --不存在下個節點
        end
        fun(r_t.Next,t_i + 1)                              --尾調給下個節點賦值
    end
    fun(return_tab,tab_index)
    return return_tab
end


--Create The ForwardList Structure(双向链表)
function CreatForwardList(tab)
    if not tab or type(tab) ~= "table" or #tab <= 0 then --判断是否无参或者空表
        return
    end
    local return_tab = {}                                --返回值（成型的双向鏈表）
    local tab_index = 1                                  --當前索引
    local function fun(r_t,t_i)                          --尾調函數
        if not (r_t and t_i and tab[t_i]) then             --判斷索引的值爲否空
            return
        end
        --開始創建鏈表節點
        r_t.StructureType = "ForwardList"                  --得出結構類型（双向鏈表）
        r_t.Head = return_tab                              --每個節點的Head字段都是只想頭部（避免遍歷鏈表的時候丟失了頭部節點）
        r_t.Val = tab[t_i]                                 --賦值
        --判斷下個節點是否有值
        if tab[t_i + 1] then
            r_t.Next = {}                                    --存在下個節點
            r_t.Next.Previous = r_t                          --下个节点的previous指向当前的节点
        else
            r_t.Next = nil                                   --不存在下個節點
        end
        fun(r_t.Next,t_i + 1)                                --尾調給下個節點賦值
    end
    fun(return_tab,tab_index)
    return return_tab
end


--判断是不是链表或者栈或者是列队或者是双向链表其中之一
function StructType(tab)
    if not (tab and type(tab) == "table") then --是否有参且为表类型
        return
    end
    local res = tab.StructureType
    if not res then                            --判断是否有此字段
        return
    end
    if res ~= "List" and res ~= "Queue" and res ~= "Stack" and res ~= "ForwardList" then
        return
    end
    return res
end
