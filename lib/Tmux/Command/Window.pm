package Tmux::Command::Window;
use strict;
use warnings;
use feature 'signatures';
use Moo;
use Data::Dumper;
use Carp qw/croak/;
use Tmux::Helper::Default;

extends 'Tmux::Command';

sub cmd_get_attribute_single( $self, $attribute, $session, $window ) {
  my $attr =
    $self->cmd_list_windows( $session, [$attribute],
    Tmux::Filter->new->equal( 'window_id', $window ) );
  return $attr->[0]->{$attribute};
}

sub cmd_list_windows( $self, $session = undef, $attributes = [], $filter = undef ) {
  my $cmd  = 'list-windows';
  my $args = [
    $session ? () : '-a',
    '-F',
    attr_builder($attributes),
    $filter  ? ( '-f', $filter )  : (),
    $session ? ( '-t', $session ) : (),
  ];

  return ( attr_parser( $self->do( $cmd, $args ) ) );
}

sub cmd_select_window( $self, $window_id, $params = {} ) {
  my $cmd  = 'select-window';
  my $args = [
    $window_id          ? ( '-t', $window_id ) : (),
    $params->{last}     ? '-l'                 : (),
    $params->{next}     ? '-n'                 : (),
    $params->{previous} ? '-p'                 : (),
  ];

  return ( $self->do_rc( $cmd, $args ) );
}

sub cmd_last_window( $self, $window_id = undef ) {
  return ( $self->cmd_select_window( $window_id, { last => 1 } ) );
}

sub cmd_next_window( $self, $window_id = undef ) {
  return ( $self->cmd_select_window( $window_id, { next => 1 } ) );
}

sub cmd_previous_window( $self, $window_id = undef ) {
  return ( $self->cmd_select_window( $window_id, { previous => 1 } ) );
}
1;

__DATA__

