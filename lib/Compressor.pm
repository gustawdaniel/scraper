use strict;
use warnings FATAL => 'all';
use DBI;
use Try::Tiny;
#use utf8;
use JSON;
#binmode STDOUT, ":utf8";

package Compressor;

sub new {
    my $dbh = DBI->connect(
        "dbi:SQLite:res/all.db", "", "",
        {
            RaiseError => 0,
            AutoCommit => 1,
            PrintError => 0
        }
    );
    my $sth = $dbh->prepare("SELECT id, val FROM dict") or die DBI->errstr;
    $sth->execute() or die DBI->errstr;
    my %dict;
    while( my( $item, $quantity ) = $sth->fetchrow_array() ) {
        $dict{ $item } = $quantity;
    }
#    $dbh->disconnect;
    return bless {
            "dict"=>\%dict,
            "l"=>"ջ",
            "r"=>"ձ",
            "dbh"=>$dbh
    }, shift;
}

sub addToDict {
    $_[0]->{dict}{$_[1]} = $_[2];
    $_[0]->{dbh}->prepare("INSERT INTO dict (id, val) VALUES (?,?)")->execute(($_[1],$_[2]));
}

sub removeFromDict { $_[0]->{"dbh"}->prepare("DELETE FROM dict WHERE id=?")->execute(($_[1])); }

sub path_to_int
{
    (my $nr) = ($_[1] =~ /dict\/(\d+).txt/);
    return $nr;
}

sub extract
{
    return $_[1];
}

sub compress
{

    my %h = % { $_[0]->{dict} };
    my $l = $_[0]->{l};
    my $r = $_[0]->{r};

    $_ = $_[1];

    foreach my $k (keys %h)
    {
        $_ = $_ =~ s/\Q$h{$k}/$l$k$r/r;
    }

    return $_;
}

sub count # file address, phrase to search, return number of occurences phrase in file
{
    open FILE, $_[1] or die "FILE $_[1] NOT FOUND - $!\n";
    $/=$_[2];

    my $res = chomp(@/=<FILE>)/$/=~y///c;

#    print "YES: ".$_[1]."\n" if $res;
#    print "NO:  ".$_[1]."\n" unless $res;

    return $res;
}

sub path_to_code
{
    return chr($_[0]->path_to_int($_[1]));
}

sub code_to_path
{
    return "dict/".ord("ഀ").".txt";
}

1;
