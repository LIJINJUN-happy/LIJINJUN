#include <cstdio>
#include <iostream>
#include <vector>
using namespace std;

void BubblingSort();  //冒泡排序

void InsertSort();    //插入排序

void PractiseSort();  //选择排序

void MergeSort();     //归并排序
vector<int> Split(int head, int tail, int*);//拆
vector<int> Merge(vector<int>, vector<int>); //合

void SoonSort();      //快速排序
void SplitMerge(int, int, int*);

void FindTheNumber1(int, int, int*); //二分查找算法非递归
void FindTheNumber2();               //二分查找算法递归

struct Node
{
    int value = 0;
    Node* next = nullptr;
};

void PrintOutList(Node* head);

void ReverseTheList(Node * head);            //翻转链表
void MiddleOfTheList(Node* head);            //链中节点
void JudgeTheList(Node  * head);             //判断环存在
void MergeTheList(Node* head1, Node* head2); //两个有序链表合并
void DeleteTheNode(Node* head,int N);        //删除倒数第N个节点

int main()
{
    cout << "//--------------------------------------------------------//排序算法" << endl << endl;
    BubblingSort();
    cout << endl << endl;
    InsertSort();
    cout << endl << endl;
    PractiseSort();
    cout << endl << endl;
    MergeSort();
    cout << endl << endl;
    SoonSort();
    cout << endl << endl;
    cout << endl << "//--------------------------------------------------------//链表数据结构" << endl << endl;
    vector<int> sz{11,23,111,23,334,22,1,2,45,578,4 };
    vector<int> merge1{ 1,101,200,303  };
    vector<int> merge2{ 100,300,302,400};
    Node *head = nullptr , *now = nullptr;
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
    now->next = head;
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
    JudgeTheList(head);        //判断环存在
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
    cout << "原链表为：";
    PrintOutList(head);
    for (int i = 0; i < N; i++)
    {
        p2 = p2->next;
    }
    
    while(p2 != nullptr)
    {
        p1 = p1->next;
        p2 = p2->next;
    }
    cout << "  " << "经过查找链表倒数第" << N << "个节点为" << p1->value;
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
    cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i] << "  ";
    }
    cout << "  " << "经过快速排序法排序后为： ";
    SplitMerge(0, len - 1, arr);
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
            now--;                  //now索引向前进一位
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


