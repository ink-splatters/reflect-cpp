project(reflect-cpp-json-tests)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "*.cpp")

add_executable(
    reflect-cpp-json-tests 
    ${SOURCES}
    "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/src/gtest_main.cc"
)

# SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DREFLECT_CPP_NO_C_ARRAYS_OR_INHERITANCE")

target_include_directories(reflect-cpp-json-tests SYSTEM PRIVATE "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include")

target_link_libraries(
    reflect-cpp-json-tests 
    PRIVATE 
    reflectcpp
    "${REFLECT_CPP_GTEST_LIB}"
)
