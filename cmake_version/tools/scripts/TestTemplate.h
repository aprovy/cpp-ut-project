#include <testngpp/testngpp.hpp>
#include <mockcpp/mockcpp.hpp>
#include <mem_checker/interface_4user.h>

#include <BtsLoader/HelloWorld.h>

USING_TESTNGPP_NS
USING_MOCKCPP_NS
USING_BTSLOADER_NS

FIXTURE(HelloWorld, base test)
{
	SETUP()
	{
	}
	
	TEARDOWN()
	{
	}
	
	TEST(1 + 2 => 3)
	{
	    ASSERT_EQ(3, add(1, 2));
	}
};
