package Tmux::Windows;
use strict;
use warnings;
use feature qw/signatures/;
use Moo;
use Tmux::Helper::Default;
use Tmux::Windows::Window;
extends 'Tmux::Command::Window';

sub list( $self, $session = undef, $filter = undef ) {
  my $windows = $self->cmd_list_windows( $session, [qw/session_id window_id/], $filter );
  return (undef) unless $windows->[0];
  return ( [
    map {
      Tmux::Windows::Window->new(
        __session_id => $_->{session_id},
        __window_id  => $_->{window_id}
      );
    } @$windows
  ] );

}

1;
