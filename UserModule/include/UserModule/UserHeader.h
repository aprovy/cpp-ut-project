/******************************************************************************
 * 版权所有(C)  Guodong Workshop. 2009-2019. All rights reserved.
 *-----------------------------------------------------------------------------
 * 模 块 名 : 
 * 文件名称 : UserHeader.h
 * 文件标识 : {[N/A]}
 * 功能描述 : 常用的头文件和工具
 * 注意事项 : 
 * 其它说明 : 
 * 
 * 历史记录 : 
 *-----------------------------------------------------------------------------
 * 版    本 : 1.0
 * 问 题 单 : 
 * 作    者 : chenguodong
 * 时    间 : 2009-6-2 21:50:43
 * 修改说明 : 创建文件
 * 
 *-----------------------------------------------------------------------------
 */
#ifndef _USER_HEADER_H_
#define _USER_HEADER_H_
 
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>
#include <set>
#include <list>
#include <map>
#include <functional>
#include <iterator>

using namespace std;

//lint -esym(534, *insert)

#ifdef _lint
#define _MSC_VER     1300
#endif

//#ifdef _MSC_VER
//#pragma warning(disable:4786) // STL
//#endif

#ifdef _MSC_VER
typedef unsigned __int64 _ULL;
#else
typedef unsigned long long _ULL;
#endif
typedef unsigned long _UL;
typedef unsigned int _UI;
typedef unsigned short _US;
typedef unsigned char _UC;

//#ifndef min
//#define min(a,b)  ((a < b) ? a : b)
//#endif

inline const char *GetFileName(const char *file)
{
     string strFile(file);
     size_t pos = min(strFile.rfind('\\'), strFile.rfind('/')); //lint !e666 Warning 666: Expression with side effects passed to repeated parameter 1 in macro 'min'
     if (string::npos == pos) // 找不到返回npos，即最大值 
     {
         cerr << "can not find file name.\n"; //lint !e1702 !e534
         return file;
     }
     return file + pos + 1;
}

//lint -emacro(1702, ASSERT_S)
//lint -emacro(534, ASSERT_S)
#if _MSC_VER > 1200
#define ASSERT_S(test, execute, ...)        \
{ \
    if (!(test)) \
    { \
        cerr << "(" << GetFileName(__FILE__) <<", "<<__LINE__<<")" << " Assert: [TEST] " << #test << ". " __VA_ARGS__ << endl; /*lint !e1702*/ \
        /*system("pause"); DevC++加这句话保证停下*/\
        execute; \
    } \
}
#else
#define ASSERT_S(test, execute)        \
{ \
    if (!(test)) \
    { \
        cerr << "(" << GetFileName(__FILE__) <<", "<<__LINE__<<")" << " Assert: [TEST] " << #test << ". " << endl; /*lint !e1702*/\
        /*system("pause"); DevC++加这句话保证停下*/\
        execute; \
    } \
}
#endif


#endif


