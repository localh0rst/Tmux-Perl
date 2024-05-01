use strict;
use Test::More 0.98;
use Tmux;

my $tmux = Tmux->new;

my $sessions = $tmux->sessions;

is( ref $sessions, 'Tmux::Sessions', 'sessions() returns a Tmux::Sessions object' );

my $rand = int rand 10000000;
my $sess = $sessions->create($rand);

is( ref $sess, 'Tmux::Sessions::Session', 'create() returns a Tmux::Sessions::Session object' );
is( $sess->session_name, $rand,           'session name is correct' );

my $list = $sessions->list;
is( ref $list,      'ARRAY',                   'list() returns an array reference' );
is( ref $list->[0], 'Tmux::Sessions::Session', 'list() returns a Tmux::Sessions::Session object' );

$sess = $sessions->get_by_name($rand);

is( ref $sess, 'Tmux::Sessions::Session',
  'get_by_name() returns a Tmux::Sessions::Session object' );
is( $sess->session_name, $rand, 'session name is correct' );

my $id = $sess->session_id;
$sess = $sessions->get_by_id($id);

is( ref $sess, 'Tmux::Sessions::Session', 'get_by_id() returns a Tmux::Sessions::Session object' );
is( $sess->session_name, $rand,           'session name is correct' );

is( $sessions->exists($rand), 1, 'session exists' );
is( $sessions->lock($rand),   1, 'session lock ok' );
is( $sessions->kill($rand),   1, 'session kill ok' );

is( $sessions->exists("Nothing-Here-I-Do-Not-Exist"), 0, 'session does not exist' );

done_testing;
