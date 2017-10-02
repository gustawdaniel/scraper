// Wyszukiwanie najdłuższego podłańcucha
// Data: 10.07.2008
// (C)2012 mgr Jerzy Wałaszek
//-----------------------------

#include <iostream>
#include <string>
#include <cstdlib>
#include <time.h>

using namespace std;

int main()
{
  string s1,s2;
  int i,j,p1,p2,lm,lmax;

  srand((unsigned)time(NULL));

// generujemy łańcuchy s1 i s2

  s1 = ""; s2 = "";
  for(i = 0; i < 40; i++)
  {
    s1 += 65 + rand() % 2;
    s2 += 65 + rand() % 2;
  }

// wypisujemy łańcuchy s1 i s2

  cout << "s1 = " << s1 << endl
       << "s2 = " << s2 << endl;

// szukamy najdłuższego wspólnego podłańcucha

  s1 = "$" + s1 + "$"; // dodajemy wartowników do s1
  s2 = "#" + s2 + "#"; // dodajemy wartowników do s2

  lmax = 0;

  for(i = 1; i <= 40; i++)
    for(j = 1; j <= 40; j++)
      if(s1[i] == s2[j])
      {
        lm = 1;
        while(s1[i + lm] == s2[j + lm]) lm++;
        if(lm > lmax)
        {
          lmax  = lm; p1 = i - 1; p2 = j - 1;
        }
      }
  s1 = s1.substr(1,40); // usuwamy wartowników z s1
  s2 = s2.substr(1,40); // usuwamy wartowników z s2

// prezentujemy wyniki

  cout << endl;
  if(lmax == 0) cout << "BRAK\n";
  else
  {
    do
    {
      if(p1 > p2)
      {
        s2 = " " + s2; p2++;
      }
      else if(p2 > p1)
      {
        s1 = " " + s1; p1++;
      }
    } while(p1 != p2);
    cout << s1 << endl;
    for(i = 0; i < p1; i++) cout << " ";
    cout << s1.substr(p1,lmax) << " : " << lmax << endl
         << s2 << endl;
  }
  return 0;
} 
