package Tmux::Panes;
use strict;
use warnings;
use feature qw/signatures/;
use Moo;
use Tmux::Helper::Default;
use Tmux::Panes::Pane;
extends 'Tmux::Command::Pane';

has attributes() => ( is => 'ro' );

sub list( $self, $session = undef, $window = undef, $filter = undef ) {
  my $panes =
    $self->cmd_list_panes( $session, $window, [qw/session_id window_id pane_id/], $filter );

  return (undef) unless $panes->[0];
  return ( [
    map {
      Tmux::Panes::Pane->new(
        __session_id => $_->{session_id},
        __window_id  => $_->{window_id},
        __pane_id    => $_->{pane_id}
      );
    } @$panes
  ] );
}

1;
