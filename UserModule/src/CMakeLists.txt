

SET(SRC_LIST
	HelloWorld.cpp       
	)

INCLUDE_DIRECTORIES(BEFORE 
  ${PROJECT_SOURCE_DIR}/include
  )  

ADD_LIBRARY(${MODULE_NAME} ${SRC_LIST})

