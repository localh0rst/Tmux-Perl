package Tmux::Sessions;
use strict;
use warnings;
use feature qw/signatures/;
use Moo;
use Tmux::Helper::Default;
use Tmux::Sessions::Session;
use Data::Dumper;
extends 'Tmux::Command::Session';

has attributes() => ( is => 'ro' );

sub list( $self, $filter = undef ) {
  my $sessions = $self->cmd_list_sessions( [qw/session_id/], $filter );
  return (undef) unless $sessions->[0];
  return ( [
    map { Tmux::Sessions::Session->new( __session_id => $_->{session_id} ); } @$sessions ] );

}

sub get_by_name( $self, $name ) {
  my $sessions =
    $self->cmd_list_sessions( [qw/session_id/], Tmux::Filter->new->equal( 'session_name', $name ) );
  return (undef) unless $sessions->[0];
  return Tmux::Sessions::Session->new( __session_id => $sessions->[0]->{session_id} );
}

sub get_by_id( $self, $id ) {

  #print Dumper "IDDDD: $id";
  my $sessions =
    $self->cmd_list_sessions( [qw/session_id/], Tmux::Filter->new->equal( 'session_id', $id ) );
  return (undef) unless $sessions->[0];
  return Tmux::Sessions::Session->new( __session_id => $sessions->[0]->{session_id} );
}

sub create( $self, $name = undef, $params = {} ) {
  my $id = $self->cmd_new_session( $name, $params );

  if ( defined $id ) {
    return Tmux::Sessions::Session->new( __session_id => $id );
  }
  return (undef);
}

sub kill( $self, $session ) {
  return $self->cmd_kill_session($session);
}

sub exists( $self, $session ) {
  return $self->cmd_has_session($session);
}

sub rename( $self, $session, $new ) {
  return $self->cmd_rename_session( $session, $new );
}

sub lock( $self, $session ) {
  return $self->cmd_lock_session($session);
}

1;
