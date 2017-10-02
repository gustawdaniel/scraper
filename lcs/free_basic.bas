' Wyszukiwanie najdłuższego podłańcucha
' Data: 10.07.2008
' (C)2012 mgr Jerzy Wałaszek
'-----------------------------

Dim As String s1,s2
Dim As Integer i,j,p1,p2,lm,lmax

Randomize

' generujemy łańcuchy s1 i s2

s1 = "": s2 = ""
For i = 1 To 40
  s1 += Chr(65 + Cint(Rnd))
  s2 += Chr(65 + Cint(Rnd))
Next

' wypisujemy łańcuchy s1 i s2

Print "s1 = ";s1
Print "s2 = ";s2

' szukamy najdłuższego wspólnego podłańcucha

s1 = "$" + s1 + "$" ' dodajemy wartowników do s1
s2 = "#" + s2 + "#" ' dodajemy wartowników do s2

lmax = 0

For i = 2 To 41
  For j = 2 To 41
    If Mid(s1,i,1) = Mid(s2,j,1) Then
      lm = 1
      While Mid(s1,i + lm,1) = Mid(s2,j + lm,1): lm += 1: Wend
      If lm > lmax Then
        lmax  = lm
        p1 = i - 1
        p2 = j - 1
      End If
    End If
  Next
Next
s1 = Mid(s1,2,40) ' usuwamy wartowników z s1
s2 = Mid(s2,2,40) ' usuwamy wartowników z s2

' prezentujemy wyniki

Print
If lmax = 0 Then
  Print "BRAK"
Else
  Do
    If p1 > p2 Then
      s2 = " " + s2: p2 += 1
    Elseif p2 > p1 Then
      s1 = " " + s1: p1 += 1
    End If
  Loop Until p1 = p2
  Print s1
  For i = 1 To p1 - 1: Print " ";: Next
  Print Mid(s1,p1,lmax);" : ";lmax
  Print s2
End If
End
