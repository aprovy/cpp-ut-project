#include <testngpp/testngpp.hpp>
#include <mockcpp/mockcpp.hpp>
#include <mem_checker/interface_4user.h>

#include <UserModule/ClassName.h>

USING_TESTNGPP_NS
USING_MOCKCPP_NS
USING_USERMODULE_NS

FIXTURE(TestClassName, fixture description)
{
	SETUP()
	{
	}
	
	TEARDOWN()
	{
	}
	
	TEST(test case description)
	{
	    INFO("Add test code here, please!");
	}
};
