/* vim:<% eval: printf("ts=%s:sw=%s:sts=%s:tw=%s:set %s", &ts, &sw, &sts, &tw, &expandtab ? "et" : "noet") %>: */
/* 
 * <%filename%> -
 *
 * Written By: <%author%> <<%email%>>
 * Last Change: .
 *
 */


#include <iostream>
#include <string>
#include <boost/format.hpp>



namespace tyru {
namespace test {

template <typename T1, typename T2>
void
is(const T1& got, const T2& expected)
{
    if (got == expected) {
        std::cout << "ok";
    }
    else {
        std::cout << boost::format("got %1%, expected %2%") % got % expected;
    }
    std::cout << std::endl;
}

} // namespace test
} // namespace tyru



int
main(int, char**)
{
}
