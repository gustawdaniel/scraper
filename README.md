To start downloading type:

    ./app.pl 0
    
Where 0 is number of chunk. It can have values in range 0..47

This process can download files.

W sqlite mamy .tables zamiast show tables oraz .schema dict zamiast desc dict.

Kompresja pierwszych 200 plików

    time for i in {1..200}; do echo $i; perl compress.pl raw/all/${i}.html > cmp/${i}.html; done
    
15 sec

    time for i in {1..200}; do echo $i; cp raw/all/${i}.html raw/all_200/${i}.html; done

Wyniki pracy nad kompresorem.

Wcześniej 30 sekund kompresowania 10k plików z 1.1 GB robi 49 MB

Teraz 13 sekund kompresowania 10k plików z 1.1 GB robi 86 MB 
Oraz 2 sekundy dokompresowania do 2.3 M

Kopiowanie między katalogami:

    find raw/all_0 -name '*.*' -exec mv {} raw/all \;
    
    
Sprawdzanie otwartych portów

    netstat -ntlp | grep LISTEN
    
albo
    
    nmap localhost