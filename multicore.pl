#await (
#    start { say "One!";   sleep 1; },
#    start { say "Two!";   sleep 1; },
#    start { say "Three!"; sleep 1; },
#);
#say now - INIT now;

# zef install HyperSeq
#
#use HyperSeq;

for (1..4).race( batch => 1 ) {
    say "Doing $_";
    sleep 1;
}
say "Code took {now - INIT now} seconds to run";
