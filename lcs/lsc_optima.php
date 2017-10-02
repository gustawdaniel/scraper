<?php

$s1 = $s2 = "";
$L = [];
$p1 = $p2 = 0;

$l1 = 4000;

for($i = 0; $i < $l1; $i ++){
    $s1 .= rand() % 2 ? "A" : "B";
    $s2 .= rand() % 2 ? "A" : "B";
}

echo "s1 = " . $s1 . "\n";
echo "s2 = " . $s2 . "\n";

for($i = 0; $i <= $l1; $i++) $L[$i][0] = $L[0][$i] = 0;

$lmax = 0;

for($i = 0; $i < $l1; $i++) {
    for ($j = 0; $j < $l1; $j++) {
        if ($s1[$i] != $s2[$j]) $L[1][$j + 1] = 0;
        else {
            $L[1][$j + 1] = 1 + $L[0][$j];
            if ($L[1][$j + 1] > $lmax) {
                $lmax = $L[1][$j + 1];
                $p1 = $i - $lmax + 1;
                $p2 = $j - $lmax + 1;
            }
        }
    }
    for ($j = 0; $j < $l1; $j++) {
        $L[0][$j] = $L[1][$j];
    }
}

if($lmax == 0) echo "BRAK\n";
else
{
    do
    {
        if($p1 > $p2)
        {
            $s2 = " " . $s2; $p2++;
        }
        else if($p2 > $p1)
        {
            $s1 = " " . $s1; $p1++;
        }
    } while($p1 != $p2);
    echo $s1 . "\n";
    for($i = 0; $i < $p1; $i++) echo " ";
    echo substr($s1, $p1,$lmax) ." : " . $lmax . "\n"
    . $s2 . "\n";
}