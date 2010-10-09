#include <testngpp/testngpp.hpp>
#include <mockcpp/mokc.h>
#include <mem_checker/interface_4user.h>

#include <UserModule/HelloWorld.h>

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

    // @test(id = parent1)
    TEST(±ª“¿¿µ1)
    {

    }
    
    // @test(id = parent2-test)
    TEST(±ª“¿¿µ2)
    {

    }

    // @test(depends=parent1)
    TEST(“¿¿µ1)
    {

    }

    // @test(depends=parent2-test)
    TEST(“¿¿µ2)
    {
    }
};
