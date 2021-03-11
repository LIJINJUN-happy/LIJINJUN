// CLI.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
#include <cstdio>
#include <iostream>
#include <json/json.h>
#include <string>
#include <cstring>
#include <thread>
#include <WinSock2.h>
#pragma comment(lib,"ws2_32.lib")

using namespace std;

const int MyPort = 6666;
const char* MyIp = "192.168.0.131";
pair<SOCKET, string> Obj;
HANDLE hanpid = nullptr;
string MynName;

DWORD WINAPI GetTheMessage(LPVOID); //用来Get message 的线程函数

int main()
{
	WSADATA wsadata;
	WSAStartup(MAKEWORD(2, 2), &wsadata);

	SOCKET sock = socket(AF_INET, SOCK_STREAM, IPPROTO::IPPROTO_TCP);

	
	SOCKADDR_IN s_i;
	s_i.sin_addr.S_un.S_addr = inet_addr(MyIp);
	s_i.sin_family = AF_INET;
	s_i.sin_port = htons(MyPort);
	if (connect(sock, (const sockaddr*)&s_i, sizeof(s_i)) >= 0)
	{
		printf_s("Connect Success\n");
		cout << "please Type Your Id:" << endl;
		string mn = "";
		cin >> mn;
		MynName = mn;
		Json::FastWriter w;
		Json::Value v;
		v["Type"] = 5;
		v["NewName"] = MynName;
		string what_want_to_send = w.write(v);
		cout << "what_want_to_send is :" << what_want_to_send << endl;
		send(sock, what_want_to_send.c_str(), strlen(what_want_to_send.c_str())+sizeof(char),0);
		hanpid = CreateThread(NULL, 0, GetTheMessage, (LPVOID)sock, NULL, NULL);
		if (hanpid != nullptr)
		{
			int num = 0;
			string str;
			while (true)
			{
				num = 0;
				str.clear();
				printf_s("请选择要进行的操作:\n");
				cin >> num;
				Json::FastWriter write;
				Json::Value value;
				switch (num)
				{
				case 1:
					cout << "please type waht you want to send：";
					cin >> str;
					break; //{\"Type\": 1,\"Message\": \".......\"}                       Send All
				case 2:
					
					break; //{\"Type\": 2,\"Name\": \"name\",\"Message\": \".......\"}    Send AnyOne
				case 3:
					
					return 0;
					break; //{\"Type\": 3,\"Name\": \".......\"}                          Close
				case 4:
					break; //{\"Type\": 4}                                                Check EveryOne
				case 5:
					
					break; //{\"Type\": 5,\"NewName\": \".......\"}                       Change Name
				default:
					break;
				}
			}
		}
		else
		{
			printf_s("There are some mistake with creating the thread!\n");
			WSACleanup();
			closesocket(sock);
			return 0;
		}
	}
	else
	{
		printf_s("Connect Not Success\n");
		WSACleanup();
		return 0;
	}


	return 0;
}

DWORD WINAPI GetTheMessage(LPVOID sock)
{
	char buff[1024] = {0};
	string str;
	while (true)
	{
		recv((SOCKET)sock, buff, sizeof(buff), 0);
		str = buff;
		cout << "str:" <<str;
		Json::Reader re;
		Json::Value  va;
		bool ifs = re.parse(str,va);
		if (ifs == true)
		{
			cout << "Json 信息接收成功！" << endl;
		}
		else
		{
			cout << "Json 信息接收不成功！" << endl;
		}
		int num = 5;
		num = va["Type"].asInt();
		cout << "num is :" << num << endl;
		switch (num)
		{
		case 1: 
			break;
		case 2: 
			break;
		case 3: 
			break;
		case 4: 
			break;
		case 5:
			cout << va["NewName"].asString() << endl;
			break;
		default:
			break;
		}
	}
	return 0;
}