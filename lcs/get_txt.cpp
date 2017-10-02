#include <iostream>
#include <string>
#include <cstdlib>
#include <time.h>
#include <sstream>
#include <fstream>

using namespace std;

int main()
{
    ifstream input("s1.txt");
    stringstream sstr;

    while(input >> sstr.rdbuf());

    cout << sstr.str() << endl;
    return 0;
}
