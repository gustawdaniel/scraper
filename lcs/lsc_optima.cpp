// Wyszukiwanie najdłuższego podłańcucha
// Data: 16.07.2008
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
  int i,j,p1,p2,lmax,L[2][4001];

  srand((unsigned)time(NULL));

// generujemy łańcuchy s1 i s2

  s1 = ""; s2 = "";
  for(i = 0; i < 4000; i++)
  {
    s1 += 65 + rand() % 2;
    s2 += 65 + rand() % 2;
  }

// wypisujemy łańcuchy s1 i s2

  cout << "s1 = " << s1 << endl
       << "s2 = " << s2 << endl;

// szukamy najdłuższego wspólnego podłańcucha

  for(i = 0; i <= 4000; i++) L[0][0] = L[1][0] = L[0][i] = 0;

  lmax = 0;

  for(i = 0; i < 4000; i++) {
    for(j = 0; j < 4000; j++) {
      if(s1[i] != s2[j]) L[1][j+1] = 0;
      else
      {
        L[1][j+1] = 1 + L[0][j];
        if(L[1][j+1] > lmax)
        {
          lmax = L[1][j+1];
          p1   = i - lmax + 1;
          p2   = j - lmax + 1;
        }
      }
    }
    for(j = 0; j < 4000; j++) {
      L[0][j] = L[1][j];
    }
  }
      
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
