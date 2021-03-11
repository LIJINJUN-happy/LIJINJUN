// SER.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
#include <json/json.h>
#include <cstdio>          //c语言输入输出方式
#include <iostream>        //c++标准输入输出库
#include <string>          //string字符串
#include <cstring>         //字符串处理函数
#include <WinSock2.h>      //socket库
#include <vector>          //vector容器
#include <utility>         //pair容器模板类对象头文件
#include <thread>
#pragma comment(lib,"ws2_32.lib")
                           //静态加载库（此时还不可以用，需要初始化后才可以用）
using namespace std;

const int MaxConnect = 100;          //最大链接数量
const int MyPort = 6666;             //端口
const char* MyIp = "192.168.0.131";  //地址
vector<pair<SOCKET, string>> Arry;   //socket容器,子元素分别是socket对象以及socket对象的名字
vector<handle_t> ThreadHandleArry;

DWORD WINAPI GetTheMessage(LPVOID lpParameter);
void SendToAllOrAnyone(SOCKET, string, string, string);
BOOL ChangeName(SOCKET, string);

int main()
{
    //初始化
    WSADATA wsadata;
    int ifsuccess = WSAStartup(MAKEWORD(2, 2), &wsadata);
    if (ifsuccess < 0)
    {
        printf_s("初始化失败\n");
        return 0;
    }
    else
        cout << "初始化成功" << endl;

    //make socket obj
    SOCKET sockserver;
    sockserver = socket(AF_INET, SOCK_STREAM, IPPROTO::IPPROTO_TCP);
    if (sockserver == SOCKET_ERROR)
    {
        printf_s("socket object make not success!\n");
        WSACleanup();
        return 0;
    }
    else
        cout << "socket object make success!" << endl;

    //bind绑定
    SOCKADDR_IN sock_i;
    sock_i.sin_family = AF_INET;
    sock_i.sin_port = htons(MyPort);
    sock_i.sin_addr.S_un.S_addr = inet_addr(MyIp);
    int ifsuccess1 = bind(sockserver, (const sockaddr*)&sock_i, sizeof(sock_i));
    if (ifsuccess1 < 0)
    {
        printf_s("socket bind not success!\n");
        closesocket(sockserver);
        WSACleanup();
        return 0;
    }
    else
        cout << "bind success" << endl;


    //开始监听了
    int ifsuccess2 = listen(sockserver, MaxConnect);
    if (ifsuccess2 < 0)
    {
        printf_s("listen not success!\n");
        closesocket(sockserver);
        WSACleanup();
        return 0;
    }
    else
        cout << "listening .......(Watting Connect)" << endl;


    //accept函数
    SOCKADDR_IN sockclienadd;
    SOCKET scli;
    handle_t handle = NULL;
    int len = sizeof(sockclienadd);
    int max = 0;
    while (max <= MaxConnect)
    {
        if ((scli = accept(sockserver, (sockaddr*)&sockclienadd, &len)) != SOCKET_ERROR)
        {
            cout << "The Client "<< scli<<" has connected!\n";
            handle = CreateThread(NULL, 0, GetTheMessage, (LPVOID)scli, NULL, 0);
            //返回一个句柄
            if (handle != NULL)
            {
                Arry.push_back(make_pair(scli, ""));//先保存套接字
                max++;                              //链接数量加1
            }
            else
                continue;
        }
        else
        {
            closesocket(sockserver);
            WSACleanup();
            cout << "接受请求失败了！" << endl;
            return 0;
        }
    }


    WSACleanup();                                      //释放资源
    closesocket(sockserver);                           //关闭listen socket obj
    for (size_t i = 0; i < Arry.size(); i++)                    //遍历所有connect socket obj
        closesocket(Arry[i].first);
    for (size_t i = 0; i < ThreadHandleArry.size(); i++)  //遍历所有线程
        CloseHandle(ThreadHandleArry[i]);
    return 0;
}


DWORD WINAPI GetTheMessage(LPVOID lpParameter)
{
    SOCKET sock = SOCKET(lpParameter);
    while (true)
    {
        string str;                 //从收到的信息获取json格式,因为buff不方便做处理,char*转string不方便
        char  buff[1024];           //接受到的信息
        int ifsuccess;              //表示是否接受成功
        ifsuccess = recv(sock, buff, sizeof(buff), 0);
        if (ifsuccess < 0)
        {
            printf_s(" Threr Are Some Mistake With Getting The Message ");
            continue;
        }
        if (ifsuccess > -1)          //获取信息成功
        {
            str = buff;             //获取到信息
            if (str.size() >= 1)    //假如不为空
            {
                int type;
                bool ifsuccess1;
                Json::Reader reader;
                Json::Value value;
                ifsuccess1 = reader.parse(str, value);
                if (ifsuccess1 == true)
                {
                    type = value["Type"].asInt();
                    switch (type)
                    {
                    case 1:
                        SendToAllOrAnyone(sock, value["Message"].asString(), "All", "");
                        break; //{\"Type\": 1,\"Message\": \".......\"}                       Send All
                    case 2:
                        SendToAllOrAnyone(sock, value["Message"].asString(), "AnyOne", value["Name"].asString());
                        break; //{\"Type\": 2,\"Name\": \"name\",\"Message\": \".......\"}    Send AnyOne
                    case 3:
                        closesocket(sock);
                        return 0;
                        break; //{\"Type\": 3,\"Name\": \".......\"}                          Close
                    case 4:
                        break; //{\"Type\": 4}                                                Check EveryOne
                    case 5:
                        ChangeName(sock, value["NewName"].asString());
                        break; //{\"Type\": 5,\"NewName\": \".......\"}                       Change Name
                    default:
                        break;
                    }
                }
            }
        }
    }
    return 0;
}

void SendToAllOrAnyone(SOCKET sock, string message, string mode, string who)
{
    Json::Value value;
    Json::FastWriter write;
    if (mode == "All")
    {
        value["Type"] = Json::Value(1);
        value["Messae"] = Json::Value(message);
        string s = write.write(value);
        for (size_t i = 0; i < Arry.size(); i++)
        {
            if (Arry[i].first != sock)//假如不是本身
                send(Arry[i].first, s.c_str(), strlen(s.c_str()) + sizeof(char), 0);
            else
                continue;
        }
    }
    else
    {
        value["Type"] = Json::Value(2);
        value["Messae"] = Json::Value(message);
        string s = write.write(value);
        if (mode == "AnyOne" && who.size() > 0)
        {
            for (size_t i = 0; i < Arry.size(); i++)
            {
                if (Arry[i].second == who && Arry[i].first != sock)
                    send(Arry[i].first, s.c_str(), strlen(s.c_str()) + sizeof(char), 0);
                else
                    continue;
            }
        }
    }
    return;
}

BOOL ChangeName(SOCKET sock, string str)
{
    for (size_t i = 0; i < Arry.size(); i++)
    {
        if (Arry[i].first == sock)
        {
            if (Arry[i].second != str)
            {
                Arry[i].second = str;
                Json::Value value;
                Json::FastWriter write;
                value["Type"] = 5;
                value["NewName"] = "Save New Name!";
                string sendstr = write.write(value);
                cout << "sendstr: " << sendstr;
                if (send(sock, sendstr.c_str(), strlen(sendstr.c_str()), 0) >= 0)
                {
                    printf_s("修改名字成功");
                    return TRUE;
                }
                else
                    return false;
            }
            else
            {
                /*
                Json::Value value;
                Json::FastWriter write;
                value["Type"] = Json::Value(5);
                value["NewName"] = Json::Value("");
                */
                return FALSE;
            }
        }
        else
            continue;
    }
    /*
    Json::Value value;
    Json::FastWriter write;
    value["Type"] = Json::Value(5);
    value["NewName"] = Json::Value("");
    */
    return false;
}