// Wyszukiwanie najdłuższego podłańcucha
// Data: 10.07.2008
// (C)2012 mgr Jerzy Wałaszek
//-----------------------------

program prg;

var
  s1,s2 : ansistring;
  i,j,p1,p2,lm,lmax : integer;

begin
  randomize;

// generujemy łańcuchy s1 i s2

  s1 := ''; s2 := '';
  for i := 1 to 40 do
  begin
    s1 := s1 + char(65 + random(2));
    s2 := s2 + char(65 + random(2));
  end;

// wypisujemy łańcuchy s1 i s2

  writeln('s1 = ',s1);
  writeln('s2 = ',s2);

// szukamy najdłuższego wspólnego podłańcucha

  s1 := '$' + s1 + '$'; // dodajemy wartowników do s1
  s2 := '#' + s2 + '#'; // dodajemy wartowników do s2

  lmax := 0;

  for i := 2 to 41 do
    for j := 2 to 41 do
      if s1[i] = s2[j] then
      begin
        lm := 1;
        while s1[i + lm] = s2[j + lm] do inc(lm);
        if lm > lmax then
        begin
          lmax  := lm; p1 := i - 1; p2 := j - 1;
        end;
      end;
  s1 := copy(s1,2,40); // usuwamy wartowników z s1
  s2 := copy(s2,2,40); // usuwamy wartowników z s2

// prezentujemy wyniki

  writeln;
  if lmax = 0 then writeln('BRAK')
  else
  begin
    repeat
      if p1 > p2 then
      begin
        s2 := ' ' + s2; inc(p2);
      end
      else if p2 > p1 then
      begin
        s1 := ' ' + s1; inc(p1);
      end;
    until p1 = p2;
    writeln(s1);
    for i := 1 to p1 - 1 do write(' ');
    writeln(copy(s1,p1,lmax),' : ',lmax);
    writeln(s2);
  end;
end. 