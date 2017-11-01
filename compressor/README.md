# Podprojekt scraper/compressor

Słóży do kompresji danych na podstawie słownika zawierającego często powtarzające się podciągi z kompresowanych plików. Zawiera cztery skrypty napisane głównie w języku `python`.


## Słownik

Do tworzenia nowego słonika wykorzystujemy skrypt `dict.py`. Modyfikacja parametrów nowego słownika wymaga edycji kodu źródłowego skryptu i zmiany zmiennych umieszczonych na początku skryptu.

Słownik zapisywany jest do katalogu (domyślnie `dict`). Każdy z plików odpowiada jednemu wpisowi w słowniku, z wyjątkiem pliku `-1` który zawiera informacje o tym, jak z nazwy pliku utworzyć tag którym zastępowana jest treść przy podmianie.

## Kompresja

Do kompresji słóży skrypt `compress.py` przyjmuje on trzy parametry. Pierwszy to ścieżka do katalogu ze słownikiem, drugi to ścieżka do katalogu z plikami do kompresji, a trzeci do ścieżka do pustego katalogu w którym będą zapisywane pliki po kompresji.

## Dekompresja

Do dekompresji słóży skrypt `decompress.py` przyjmuje on trzy parametry. Pierwszy to ścieżka do katalogu ze słownikiem, drugi to ścieżka do katalogu z plikami skompresowanymi, a trzeci do ścieżka do pustego katalogu w którym będą zapisywane pliki po dekompresji.

## Lista plików

#### Wykonywalne:
* `dict.py` - Skrypt tworzący nowy słownik.
* `compress.py` - Skrypt kompresujący dane.
* `decompress.py` - Skrypt dekompresujący dane.
* `test.bash` - Skrypt testujący wydajność i poprawność działania.

#### Biblioteki:
* `lib/compress.py` - Funkcje pomocnicze, słóżące do kompresji i dekompresji danych.
* `lib/dict.py` - Funkcje pomocnicze, słóżące do obsługi słownika.
* `lib/lcs.py` - Funkcje pomocnicze, słóżące do znajdowania najdłuższego wspólnego podciągu.
* `lib/samples.py` - Funkcje pomocnicze, słóżące do pobierania próbek plików przy tworzeniu słownika.

#### Inne :
* `cpp` - Katalog z kodem zdeprecjonowanego kompresora napisanego w C++.
