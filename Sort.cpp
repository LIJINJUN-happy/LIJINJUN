#include <cstdio>
#include <iostream>
#include <vector>
using namespace std;

void BubblingSort();  //冒泡排序

void InsertSort();    //插入排序

void PractiseSort();  //选择排序

void MergeSort();     //归并排序
vector<int> Split(int head, int tail,int *);//拆
vector<int> Merge(vector<int>,vector<int>); //合

int main()
{
    BubblingSort();
    cout << endl << endl;
    InsertSort();
    cout << endl << endl;
    PractiseSort();
    cout << endl << endl;
    MergeSort();
    cout << endl << endl;
}

void BubblingSort()
{
    int arr[11]{11,23,111,23,334,22,1,2,45,578,4};
    int len = 11;
    cout << "原数组为：";
    for (int i = 0; i < 11; i++)
    {
        cout << arr[i]<<"  ";
    }
    cout << "  " << "经过冒泡排序法排序后为： ";
    for (int i = 0; i < len - 1; i++)
    {
        for (int j = 0;j< len - 1 - i; j++)
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
    for (int i=1;i<len;i++)
    {
        int temp = arr[i];
        for (int j=i-1;j>=0;j--)
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
    for (int i=0;i<len-1;i++)
    {
        int temp = arr[len-1];//记录下最后一个
        int index = len - 1;  //当前索引
        for (int j = i; j < len-1; j++)
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
    int middle = 0+(len - 1) / 2;
    vector<int> back = Merge(Split(0,middle-1,arr), Split(middle,len-1,arr));
    for (int i = 0; i < len; i++)
    {
        cout << back[i] << "  ";
    }
}

vector<int> Split(int head, int tail,int * arr)
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
        back = Merge(Split(head, middle - 1,arr), Split(middle, tail, arr));
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