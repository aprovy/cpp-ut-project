/******************************************************************************
 * ��Ȩ����(C)  Guodong Workshop. 2009-2019. All rights reserved.
 *-----------------------------------------------------------------------------
 * ģ �� �� : 
 * �ļ����� : UserHeader.h
 * �ļ���ʶ : {[N/A]}
 * �������� : ���õ�ͷ�ļ��͹���
 * ע������ : 
 * ����˵�� : 
 * 
 * ��ʷ��¼ : 
 *-----------------------------------------------------------------------------
 * ��    �� : 1.0
 * �� �� �� : 
 * ��    �� : chenguodong
 * ʱ    �� : 2009-6-2 21:50:43
 * �޸�˵�� : �����ļ�
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
     if (string::npos == pos) // �Ҳ�������npos�������ֵ 
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
        /*system("pause"); DevC++����仰��֤ͣ��*/\
        execute; \
    } \
}
#else
#define ASSERT_S(test, execute)        \
{ \
    if (!(test)) \
    { \
        cerr << "(" << GetFileName(__FILE__) <<", "<<__LINE__<<")" << " Assert: [TEST] " << #test << ". " << endl; /*lint !e1702*/\
        /*system("pause"); DevC++����仰��֤ͣ��*/\
        execute; \
    } \
}
#endif


#endif


