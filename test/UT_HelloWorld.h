#include <testngpp/testngpp.hpp>
#include <mockcpp/mokc.h>
#include <mem_checker/interface_4user.h>

#include <module_name/HelloWorld.h>

FIXTURE(HelloWorld, base test)
{
	TEST(1 + 2 => 3)
	{
	    ASSERT_EQ(3, add(1, 2));
	}
	
	TEST(mem leak test)
	{
	    char *p = new char[13];
		delete [] p;
	}
	
	TEST(mockcpp test)
	{
        STOP_MEM_CHECKER(); // TODO: maybe mockcpp leaked one object

	    MOCKER(add)
		  .stubs()
		  .will(returnValue(200));
		ASSERT_EQ(200, add(1, 2));

        GlobalMockObject::verify();
        GlobalMockObject::reset();
	}
};