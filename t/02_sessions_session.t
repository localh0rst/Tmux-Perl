use strict;
use Test::More 0.98;
use Tmux::Sessions::Session;

# Test the Tmux::Sessions::Session object. With an empty session name.
my $session = Tmux::Sessions::Session->new("");

is( ref $session, 'Tmux::Sessions::Session', '$session is a valid Tmux::Sessions::Session object' );

my $res = $session->kill;
is( $res, 1, 'Session is killed' );

done_testing;
