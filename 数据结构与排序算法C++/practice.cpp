#include <cstdio>
#include <iostream>
#include <vector>
#include <stdlib.h>
#include <map>
#include <string>
#include <thread>
#include <Windows.h>

using namespace std;

void BubblingSort();  //冒泡排序

void InsertSort();    //插入排序

void PractiseSort();  //选择排序

void MergeSort();     //归并排序
vector<int> Split(int head, int tail, int*);//拆
vector<int> Merge(vector<int>, vector<int>); //合

void SoonSort();      //快速排序
void SplitMerge(int, int, int*);
void SplitMerge_Version_Two(int, int, int*);

int Step(int n);      //递归例子（走楼梯）

void FindTheNumber1(int);                   //0至100中，二分查找算法非递归
void FindTheNumber2(int,int,int);           //0至100中，二分查找算法递归
void FindTheNumber3(int, int, int*,int);    //二分查找算法递归（有序数组中第一个某个数值）
void FindTheNumber4(int, int, int*, int);   //二分查找算法递归（有序数组中最后一个某个数值）

struct Node
{
    int value = 0;
    Node* next = nullptr;
};


void PrintOutList(Node* head);
void ReverseTheList(Node * head);            //翻转链表
void JudgeTheList(Node  * head);             //判断环存在
void MiddleOfTheList(Node* head);            //链表中间节点
void MergeTheList(Node* head1, Node* head2); //两个有序链表合并
void DeleteTheNode(Node* head,int N);        //删除倒数第N个节点

//顺序栈
struct Stack
{
    int size1 = -1;               //number 数组的长度位置
    int size2 = -1;               //ctrl 数组的长度位置
    int number[100] = {0};        //放数字
    char ctrl[100] = {0};         //放计算字符的
    void Pop(string);             //弹出（参数是指从哪个数组中弹出）
    void Press(string, string);   //压入（参数是指压入哪个数组，且压入啥）
    void accumulate(string);      //计算
};

//队列
struct Deque
{
    int allticket = 50;//一共有的票数
    int size = 0;
    Node * head = nullptr;
    Node * tail = nullptr;
    void BeginSell()   //开始售票了
    {
        while (true)
        {
            //cout << "总票数为：" <<this->allticket <<endl;
            if (this->allticket >= 1)           //还有票
            {
                if (head != nullptr)            //有人排队
                {
                    Sleep(3000);               //买票的时候需要3秒时间处理一下
                    if (head != tail)           //判断剩下止不止一个节点了
                    {
                        Leave();                //删除头节点
                    }
                    else                        //只有一个的话
                    {
                        Leave();
                        //delete head;
                        head = nullptr;
                        tail = nullptr;
                    }
                    cout << "票数还剩余 :" << this->allticket << endl;
                }
                else                            //冇人排队
                {
                    ;
                }
            }
            else                                //没票啦
            {
                cout << "票已售罄了，拉闸！";
                return;
            }
       }
    }
    void Come()                  //来了
    {
        if (tail != head)        //不止一人在排队
        {
            tail->next = new Node();
            tail = tail->next;
            tail->value = 1;
        }
        else                     //一个或者没有人
        {
            if (tail != nullptr && head != nullptr)    //一个人
            {
                tail->next = new Node();
                tail = tail->next;
                tail->value = 1;
            }
            else                 //无人
            {
                head = new Node();
                head->value = 1;
                tail = head;
            }
        }
        this->size += 1;

        cout << "来排队了，数了一下，队伍长度为：" << this->size<<endl;
    }
    void Leave()                //离开了
    {
        Node* will_delete = head;
        head = head->next;
        this->size -= 1;
        this->allticket -= 1;
        cout << "好开心，买到票了，溜了溜了, 数了一下，队伍长度为： " << this->size << endl;
    }
};
void run(Deque * d)
{
    d->BeginSell();
}

int main()
{
    cout << "//--------------------------------------------------------//排序算法" << endl << endl;
    //BubblingSort();
    cout << endl << endl;
    //InsertSort();
    cout << endl << endl;
    //PractiseSort();
    cout << endl << endl;
    //MergeSort();
    cout << endl << endl;
    //SoonSort();
    cout << endl << endl;
    cout << "//--------------------------------------------------------//链表数据结构" << endl << endl;
    vector<int> sz{11,23,111,23,334,22,1,2,45,578,4 };
    vector<int> merge1{ 1,101,200,303  };
    vector<int> merge2{ 100,300,302,400};
    Node* head = nullptr , * now = nullptr;
    Node* head1 = nullptr, * now1 = nullptr;
    Node* head2 = nullptr, * now2 = nullptr;
    int N = 7;
    for (int i = 0; i < sz.size(); i++)
    {
        if (!now)
        {
            now = new Node();
            now->value = sz[i];
            head = now;             //记录下链表头
        }
        else
        {
            Node * now_temp = new Node();
            now_temp->value = sz[i];
            now->next = now_temp;
            now = now->next;
        }
    }
    for (int i = 0; i < merge1.size(); i++)
    {
        if (!now1)
        {
            now1 = new Node();
            now1->value = merge1[i];
            head1 = now1;             //记录下链表头
        }
        else
        {
            Node* now_temp = new Node();
            now_temp->value = merge1[i];
            now1->next = now_temp;
            now1 = now1->next;
        }
    }
    for (int i = 0; i < merge2.size(); i++)
    {
        if (!now2)
        {
            now2 = new Node();
            now2->value = merge2[i];
            head2 = now2;             //记录下链表头
        }
        else
        {
            Node* now_temp = new Node();
            now_temp->value = merge2[i];
            now2->next = now_temp;
            now2 = now2->next;
        }
    }
    //ReverseTheList(head);      //翻转链表
    //MiddleOfTheList(head);     //链表中间节点
    //DeleteTheNode(head,N);     //删除倒数第N个节点
    //MergeTheList(head1,head2); //合并有序链表
    //JudgeTheList(head);        //判断环存在

    //栈的运用（简单计算器）
    //Stack stack;
    //stack.accumulate("100+2*300=");

    //队列
    /*
    Deque *deque = new Deque();
    thread thread(run,deque);
    thread.detach();
    while (true)
    {
        if (deque->allticket == 0)
            break;
        char c = getchar();
        int num = atoi(&c);
        cout << num<<"个人来排队了" << endl;
        for (int i = 0; i < num; i++)
        {
            deque->Come();
        }
    }*/

    //递归算法（走楼梯，走1步或者走两步，N层阶梯）
    //int step_way_num = Step(30);
    //cout << "结果递归算法，走楼梯的方式数为："<<step_way_num;

    int sssz[14] = { 1,2,3,11,19,22,23,33,33,111,212,212,578,40000 };
    //FindTheNumber1(33);
    //FindTheNumber2(0,100,33);
    //FindTheNumber3(0, 13,sssz ,212);
    //FindTheNumber4(0, 13,sssz ,212);
    return 0;
}

void PrintOutList(Node* head)
{
    while (true)
    {
        if (head != nullptr)
        {
            cout << head->value << "  ";
            head = head->next;
        }
        else
        {
            break;
        }
    }
}

void ReverseTheList(Node* head)
{
    Node* p1 = nullptr;
    Node* p2 = head;
    Node* p3 = head->next;
    cout << "原链表为：";
    PrintOutList(head);
    while (true)
    {
        p2->next = p1;
        p1 = p2;
        p2 = p3;
        p3 = p3->next;
        if (p3 == nullptr)
        {
            p2->next = p1;
            break;
        }
    }
    cout << "  " << "经过链表反转操作之后为： ";
    PrintOutList(p2);

    cout << endl;
    return;
}

void MiddleOfTheList(Node* head)
{
    
    Node* p1 = head; //走一步
    Node* p2 = head; //走两步
    cout << "原链表为：";
    PrintOutList(head);
    while (p2->next->next != nullptr && p2->next != nullptr)
    {
        p1 = p1->next;
        p2 = p2->next->next;
        
    }
    if(p2->next == nullptr)
        cout << "  " << "经过查找链表中间节点为： " << p1->value;
    else 
        if(p2->next->next == nullptr)
        cout << "  " << "经过查找链表中间节点为： " << p1->value << "  " << p1->next->value;
}

void JudgeTheList(Node* head)
{
    Node* p1 = head;
    Node* p2 = head;
    printf("起点为：%d\n", head->value);
    while (p2 != nullptr && p2->next != nullptr)
    {
        p2 = p2->next->next;
        p1 = p1->next;
        printf("p1,p2的位置为：%d  %d\n", p1->value, p2->value);
        if (p1 == p2)
        {
            printf("经过判断后，链表中存在环,且相遇点的值为%d",p1->value);
            return;
        }
    }
    printf("经过判断后，链表中不存在环");
    return;
}

void DeleteTheNode(Node* head, int N)
{
    Node* p1 = head;
    Node* p2 = head;
    Node* p3 = head;
    Node* p4 = head;
    cout << "原链表为：";
    PrintOutList(head);
    for (int i = 0; i < N; i++)
    {
        p2 = p2->next;
    }
    for (int i = 0; i < N; i++)
    {
        p4 = p4->next;
    }
    
    while(p2 != nullptr)
    {
        p1 = p1->next;
        p2 = p2->next;
    }
    cout << "  " << "经过查找链表倒数第" << N << "个节点为" << p1->value<<"\n";

    while (p4->next != nullptr)
    {
        p3 = p3->next;
        p4 = p4->next;
    }
    p3->next = p3->next->next;
    cout << "删除后为：";
    PrintOutList(head);
}

void MergeTheList(Node* head1, Node* head2)
{
    cout << "两个链表分别为:  " << "{1,101,200,303} 以及 {100,300,302,400} ";
    //从小到大所以头节点为最小
    Node* Head = nullptr, * now=nullptr;
    //直到任意一链表到了末尾为止
    while (head1 != nullptr && head2 != nullptr)
    {

        if (head1->value >= head2->value)
        {
            if (now == nullptr)  //第一个节点
            {
                now = head2;     //作为开头
                Head = now;      //记录下最后用来遍历
                head2 = head2->next;
                continue;
            }
            now->next = head2;
            head2 = head2->next;
        }
        else
        {

            if (now == nullptr)  //第一个节点
            {
                now = head1;     //作为开头
                Head = now;      //记录下最后用来遍历
                head1 = head1->next;
                continue;
            }
            now->next = head1;
            head1 = head1->next;
        }
        now = now->next;
    }
    if (head1 == nullptr)
    {
        now->next = head2;
    }
    else
    {
        now->next = head1;
    }
    cout << "合并后：";
    PrintOutList(Head);
}

void BubblingSort()
{
    int arr[11]{ 11,23,111,23,334,22,1,2,45,578,4 };
    int len = 11;
    cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
    cout << "  " << "经过冒泡排序法排序后为： ";
    for (int i = 0; i < len - 1; i++)
    {
        for (int j = 0; j < len - 1 - i; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
            else
                continue;
        }
    }
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
}

void InsertSort()
{
    int arr[11]{ 11,23,111,23,334,22,1,2,45,578,4 };
    int len = 11;
    cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
    cout << "  " << "经过插入排序法排序后为： ";
    for (int i = 1; i < len; i++)
    {
        int temp = arr[i];
        for (int j = i - 1; j >= 0; j--)
        {
            if (arr[j] > temp)
            {
                arr[j + 1] = arr[j];
                arr[j] = temp;
            }
            else
            {
                //arr[j] = temp;
                break;
            }
        }
    }
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
}

void PractiseSort()
{
    int arr[11]{ 11,23,111,23,334,22,1,2,45,578,4 };
    int len = 11;
    cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
    cout << "  " << "经过选择排序法排序后为： ";
    for (int i = 0; i < len - 1; i++)
    {
        int temp = arr[len - 1];//记录下最后一个
        int index = len - 1;  //当前索引
        for (int j = i; j < len - 1; j++)
        {
            if (arr[j] < temp)
            {
                temp = arr[j];
                index = j;
            }
            else
                continue;
        }
        arr[index] = arr[i];
        arr[i] = temp;
    }
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
}

void MergeSort()
{
    int arr[11]{ 11,23,111,23,334,22,1,2,45,578,4 };
    int len = 11;
    cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
    cout << "  " << "经过归并排序法排序后为： ";
    int middle = 0 + (len - 1) / 2;
    vector<int> back = Merge(Split(0, middle - 1, arr), Split(middle, len - 1, arr));
    for (int i = 0; i < len; i++)
    {
        cout << back[i] << "  ";
    }
}

vector<int> Split(int head, int tail, int* arr)
{
    vector<int> back{};
    if (tail - head <= 1)//剩两个或者1个的时候
    {
        if (tail == head)//剩一个
        {
            //back.push_back();
            back.push_back(arr[head]);
        }
        else//剩两个
        {
            if (arr[head] > arr[tail])
            {
                back.push_back(arr[tail]);
                back.push_back(arr[head]);
            }
            else
            {
                back.push_back(arr[head]);
                back.push_back(arr[tail]);
            }
        }
        return back;
    }
    else
    {
        int middle = (head + tail) / 2;
        back = Merge(Split(head, middle - 1, arr), Split(middle, tail, arr));
    }
    return back;
}

vector<int> Merge(vector<int> h, vector<int> t)
{
    vector<int> back{};
    int i = 0;
    int j = 0;
    while (true)
    {
        if (i != h.size() && j != t.size())
        {
            if (h[i] > t[j])
            {
                back.push_back(t[j]);
                j++;
            }
            else
            {
                back.push_back(h[i]);
                i++;
            }
        }
        else
        {
            if (i == h.size())
            {
                for (int jj = j; jj < t.size(); jj++)
                    back.push_back(t[jj]);
            }
            else
            {
                for (int ii = i; ii < h.size(); ii++)
                    back.push_back(h[ii]);
            }
            break;
        }
    }
    return back;
}

void SoonSort()
{
    int arr[11]{ 11,23,111,23,334,22,1,2,45,578,4 };
    int len = 11;
//cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
    SplitMerge(0, len - 1, arr);
    cout << "  " << "经过快速排序法排序后为： ";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
}

void SplitMerge(int head, int tail, int* arr)
{
    if (head == tail || head - tail == -1)
    {
        if (arr[head] > arr[tail])
        {
            int temp = arr[head];
            arr[head] = arr[tail];
            arr[tail] = temp;
        }
        return;
    }
    int now = tail;//每次以结尾元素为分界点
    for (int i = head; i < now;)//从头开始索引遍历
    {
        if (arr[i] > arr[now])//比它大就放在后面，否则保持在前面（比它小）
        {
            //cout << "arr[i]= " << arr[i];
            int temp = arr[i];//记录下该值（后面的都往后移动）
            for (int j = i; j < tail; j++)
                arr[j] = arr[j + 1];//逐个往前迁移
            arr[tail] = temp;        //最后把该记录下的值移动到now的地方
            now--;                   //now索引向前进一位
        }
        else
        {
            i++;
        }
    }
    SplitMerge(head, now - 1, arr);
    SplitMerge(now , tail, arr);
    return;
}
void SplitMerge_Version_Two(int head, int tail, int* arr)
{
    if(head >= tail)               //假如是只有一个数了，直接返回（多于2个才需要进行操作）
    {
        return;
    }
    //到了这一步已经确认至少两个了有数
    int i = head;
    int j = tail;
    int who_move = 2;          //偶数是j动，奇数是i动
    int point_value = arr[head];
    while (i < j)
    {
        if (who_move % 2 == 0) //偶数
        {
            if (arr[j] < point_value)  //小于分界值
            {
                arr[i] = arr[j];       //与arr[i]对换
                who_move++;
                arr[j] = point_value;
                i += 1;
            }
            else
                j-=1;
        }
        else
        {
            if (arr[i] > point_value)  //大于分界值
            {
                arr[j] = arr[i];       //与arr[i]对换
                who_move++;
                arr[i] = point_value;
                j -= 1;
            }
            else
                i+=1;
        }
        cout << "\n";
        for (int i = 0; i < 11; i++)
        {
            cout << arr[i] << "  ";
        }
    }
    cout << "\n-----------------------------------------------";
    SplitMerge_Version_Two(head, i, arr);
    SplitMerge_Version_Two(i+1 , tail, arr);
}


void Stack::Pop(string str)
{
    if (str == "number")
    {
        if (this->size1 >= 0)
        {
            this->number[this->size1] = 0;
            this->size1 -= 1;
        }
    }
    if (str == "ctrl")
    {
        if (this->size2 >= 0)
        {
            this->ctrl[this->size2] = '\0';
            this->size2 -= 1;
        }
    }
}

void Stack::Press(string str1, string str2)
{
    if (str1 == "number")
    {
        int num = atoi(str2.c_str()); //转为数值类型
        this->size1 += 1;
        this->number[this->size1] = num;
        cout << "Press  " << num<<"   ";
    }
    if (str1 == "ctrl")
    {
        this->size2 += 1;
        this->ctrl[this->size2] = str2[0];
        cout << "Press  " << str2[0] << "   ";
    }
}

void Stack::accumulate(string str)
{
    std::map<char, int> Tab{ {'=',1}, {'+',2}, { '-',2 }, { '*',3 }, { '/',3 } };
    string temp = "";
    bool now_deal_with = false;
    for (int i = 0; i < str.size(); i++)
    {
        cout <<"str[i]:"<< str[i]<<"\n";
        //遇到数字
        if (str[i] != '+' && str[i] != '-' && str[i] != '*' && str[i] != '/' && str[i] != '=')
        {
            temp += str[i];                        //逐渐叠加除了加减乘除外的字符
            cout << "str[i]: " << str[i] << "  是个数字放链接在temp中,temp:" << temp<<"\n";
            continue;
        }
        else                                       //遇到加减乘除等运算符
        {
            if (now_deal_with)                     //先处理
            {
                int num_inside = this->number[this->size1];
                char ch = this->ctrl[this->size2];
                this->Pop("ctrl");
                this->Pop("number");
                cout << "由于有优先处理的情况，所以需要优先处理一下最顶层的运算符以及最新的temp,num_inside 以及 ch 为：" << num_inside << "   " << ch << "\n";
                if (ch == '*')
                {
                    int result = num_inside * atoi(temp.c_str());
                    temp = to_string(result);
                }
                else
                {
                    if (ch == '/')
                    {
                        int result = num_inside / atoi(temp.c_str());
                        temp = to_string(result);
                    }
                }
                now_deal_with = false;
            }

            this->Press("number",temp);            //先把数字放进去数组中
            cout << "遇到了运算符组成的数字放进number里" << temp << "\n";
            if(this->size2 == -1)
            {
                cout << "crtl中没存在任何一个字符\n";
                string sss{ str[i] };
                this->Press("ctrl", sss);  //再把运算符放进去另一个数组中去，没有运算符在此数组中，最起码放一个进去
            }
            else
            {
                if (this->size2 >= 0)              //里面至少有一个运算符了已经（进行对比,只有新来的优先级大才可以进行运算，否者继续加入数组中）
                {
                    if (str[i] == '=')
                    {
                        cout << "遇到了等于号了，直接退出并结算\n";
                        break;                     //假如运算符数组里的数量大于一个的话，碰到=要直接退出，因为证明这时候的运算符属于同一优先级Level的
                    }
                    else
                    {
                        cout << "遇到非等于号了\n";
                        int c1 = Tab.at(this->ctrl[this->size2]);     //数组中最顶层的运算符
                        int c2 = Tab.at(str[i]);                      //未假如数组总的运算符
                        cout << "c1 c2 优先级分别是" << c1 << "   " << c2 << " 对应符号为" << this->ctrl[this->size2] << "  " << str[i]<<endl;
                        //假如容器内的运算符优先级大于这次待处理的运算符话
                        if(c1>c2)
                        {
                            cout << "c1>c2" << "\n";
                        }
                        else
                        {   //假如容器内的运算符优先级小于这次待处理的运算符话，计算外层的
                            if(c1<c2)
                            {
                                cout << "c1<c2" << "\n";
                                string sss{ str[i] };
                                this->Press("ctrl", sss);
                                now_deal_with = true;                    //下次碰到运算符就先算旧的那个

                            }
                            //假如容器内的运算符优先级等于这次待处理的运算符话直接放进去，同级不计算
                            else
                            {
                                cout << "c1 = c2" << "\n";
                                string sss{ str[i] };
                                this->Press("ctrl", sss);
                            }
                        }
                    }
                }
                else
                {
                    printf("有出错了哟!");
                    _ASSERT(false);
                }
            }
            temp.clear();                          //恢复
        }
    }
    //到了这一步都是统一level的运算符
    int back = 0;
    for (int iii = 0,jjj = 0  ; iii <= this->size1;iii+=2,++jjj)
    {
        if (this->ctrl[jjj] == '+')
        {
            back += (this->number[iii] + this->number[iii + 1]);
        }
        if (this->ctrl[jjj] == '-')
        {
            back += (this->number[iii] - this->number[iii + 1]);
        }
        if (this->ctrl[jjj] == '*')
        {
            back += (this->number[iii] * this->number[iii + 1]);
        }
        if (this->ctrl[jjj] == '/')
        {
            back += (this->number[iii] / this->number[iii + 1]);
        }
    }
    cout << "结果为： " << back;
}

//递归算法（走楼梯，走1步或者走两步，N层阶梯）
int Step(int n)
{
    if (n <= 2)
    {
        if (n == 1 || n == 2)
        {
            return n;
        }
        if (n <= 0)
        {
            return 0;
        }
    }
    return Step(n - 1) + Step(n - 2);
}

void FindTheNumber1(int num)                               //二分查找算法非递归
{
    int head = 0; int tail = 100; int middle = (head + tail) / 2;
    while (middle != num )
    {
        middle = (head + tail) / 2;
        printf("当前head=%d tail=%d 其中位数为%d\n",head,tail, middle);
        if (middle < num)
        {
            head = middle;
        }
        else
        {
            tail = middle;
        }
    }
    cout << "最后的结果为："<<middle<<endl;
}

void FindTheNumber2(int head, int tail, int num)           //二分查找算法递归
{
    int middle = (head + tail) / 2;
    printf("当前head=%d tail=%d 其中位数为%d\n", head, tail, middle);
    if (middle == num)
    {
        printf("最后结果为：%d\n",middle);
        return;
    }
    else
    {
        if (middle < num)
        {
            FindTheNumber2(middle,tail,num);
        }
        else
        {
            FindTheNumber2(head,middle,num);
        }
    }
}

void FindTheNumber3(int head, int tail, int* arr, int num)  //二分查找算法递归（有序数组中第一个某个数值）
{
    int middle = (head + tail) / 2;
    printf("当前头索引为head=%d 尾部索引为tail=%d 其中间索引为%d，arr【索引】值为%d\n", 
        head, tail, middle, arr[middle]);
    if (arr[middle] == num)
    {
        if (middle != 0 && arr[middle-1] == num)
        {
            FindTheNumber3(middle-1, middle - 1, arr, num);
        }
        else
        {
            printf("首位第一个指定结果为：arr[ %d ] = %d\n", middle, arr[middle]);
            return;
        }
    }
    else
    {
        if (arr[middle] < num)
        {
            FindTheNumber3(middle, tail, arr,num);
        }
        else
        {
            FindTheNumber3(head, middle, arr, num);
        }
    }
}

void FindTheNumber4(int head, int tail, int* arr, int num)  //二分查找算法递归（有序数组中最后一个某个数值）
{
    int middle = (head + tail) / 2;
    printf("当前头索引为head=%d 尾部索引为tail=%d 其中间索引为%d，arr【索引】值为%d\n", 
        head, tail, middle, arr[middle]);
    if (arr[middle] == num)
    {
        if (middle != 11 && arr[middle+1] == num)
        {
            FindTheNumber4(middle + 1, middle + 1, arr, num);
        }
        else
        {
            printf("最后一个指定值结果为：arr[ %d ] = %d\n", middle, arr[middle]);
            return;
        }
    }
    else
    {
        if (arr[middle] < num)
        {
            FindTheNumber4(middle, tail, arr, num);
        }
        else
        {
            FindTheNumber4(head, middle, arr, num);
        }
    }
}