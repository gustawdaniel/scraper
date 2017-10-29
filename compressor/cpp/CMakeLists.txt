cmake_minimum_required(VERSION 2.8.11)

project(scraper-compressor)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC             ON)

set(HEADERS
)

set(SOURCES
	"main.cpp"
)

find_package(Qt5Core)

add_executable("${PROJECT_NAME}"
	${HEADERS}
	${SOURCES}
)

target_link_libraries("${PROJECT_NAME}"
	"Qt5::Core"
)

