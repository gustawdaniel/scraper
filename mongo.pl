use strict;

# cpan App::cpanminus:
# cpanm MongoDB --force

use MongoDB;

my $client = MongoDB->connect();
my $users = $client->ns("tutorial.users");

$users->insert_one( {
    "name" => "Joe",
    "age" => 52,
    "likes" => [qw/skiing math ponies/]
});