package Tmux::Command::Session;
use strict;
use warnings;
use feature 'signatures';
use Moo;
use Data::Dumper;
use Carp qw/croak/;
use Tmux::Helper::Default;
use Tmux::Filter;
extends 'Tmux::Command';

sub cmd_get_attribute_single( $self, $attribute, $session ) {
  my $attr =
    $self->cmd_list_sessions( [$attribute], Tmux::Filter->new->equal( 'session_id', $session ) );
  return $attr->[0]->{$attribute};
}

sub cmd_list_sessions( $self, $attributes = [], $filter = undef ) {

  my $cmd  = 'list-sessions';
  my $args = [
    '-F', attr_builder($attributes),
    $filter ? ( '-f', $filter ) : ()

  ];

  return ( attr_parser( $self->do( $cmd, $args ) ) );
}

sub cmd_new_session( $self, $name = undef, $params = {} ) {
  my $cmd  = 'new-session';
  my $args = [
    '-d',    #We require detached sessions
    '-P',    #We require print info
    '-F', attr_builder( [qw/session_id/] ),
    $name                 ? ( '-s', $name )                              : (),
    $params->{win_name}   ? ( '-n', $params->{win_name} )                : (),
    $params->{path}       ? ( '-c', $params->{path} )                    : (),
    $params->{group}      ? ( '-t', $params->{group} )                   : (),
    $params->{width}      ? ( '-x', $params->{width} )                   : (),
    $params->{height}     ? ( '-y', $params->{height} )                  : (),
    $params->{flags}->[0] ? ( '-f', join( ',', @{ $params->{flags} } ) ) : (),
    $params->{command}    ? $params->{command} : (),
  ];

  my $id = attr_parser( $self->do( $cmd, $args ) );

  return ( $id->[0] ? $id->[0]->{session_id} : undef );
}

sub cmd_kill_session( $self, $session ) {
  my $cmd  = 'kill-session';
  my $args = [ '-t', $session ];

  return $self->do_rc( $cmd, $args );
}

sub cmd_has_session( $self, $session ) {
  my $cmd  = 'has-session';
  my $args = [ '-t', $session ];

  return $self->do_rc( $cmd, $args );
}

sub cmd_rename_session( $self, $session, $new ) {
  my $cmd  = 'rename-session';
  my $args = [ '-t', $session, $new ];

  return $self->do_rc( $cmd, $args );
}

sub cmd_lock_session( $self, $session ) {
  my $cmd  = 'lock-session';
  my $args = [ '-t', $session ];

  return $self->do_rc( $cmd, $args );
}

1;

