#include <testngpp/testngpp.hpp>
#include <mockcpp/mokc.h>
#include <mem_checker/interface_4user.h>
#include <mockcpp/mockcpp.hpp>

#include <UserModule/HelloWorld.h>

struct Interface 
{
    virtual int func() = 0;
    virtual ~Interface(){}
};

FIXTURE(HelloWorld, base test)
{
    MockObject<Interface> mocker;

	TEST(1 + 2 => 3)
	{
	    ASSERT_EQ(3, add(1, 2));
	}
	
	TEST(mem leak test)
	{
	    char *p = new char[13];
		delete [] p;
	}
	
	TEST(mockcpp global mocker test)
	{
	    MOCKER(add)
		  .stubs()
		  .will(returnValue(200));
		ASSERT_EQ(200, add(1, 2));

        GlobalMockObject::verify();
        //GlobalMockObject::reset();
	}

    TEST(mockcpp mock object test)
    {        
        MOCK_METHOD(mocker, func)
            .expects(once())
            .will(returnValue(3));
        ASSERT_EQ(3, mocker->func());
        mocker.verify();
        //mocker.reset();
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

FIXTURE(HelloWorld2, ≤π≥‰)
{
    TEST(≤π≥‰≤‚ ‘1)
    {
    }
    TEST(≤π≥‰≤‚ ‘2)
    {
    }

};