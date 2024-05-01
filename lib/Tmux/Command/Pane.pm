package Tmux::Command::Pane;
use strict;
use warnings;
use feature 'signatures';
use Moo;
use Data::Dumper;
use Carp qw/croak/;
use Tmux::Helper::Default;

extends 'Tmux::Command';

sub cmd_get_attribute_single( $self, $attribute, $session, $window, $pane ) {
  my $filter = Tmux::Filter->new->equal( 'window_id', $window );
  $filter = Tmux::Filter->new->and( $filter, Tmux::Filter->new->equal( 'pane_id', $pane ) );

  my $attr =
    $self->cmd_list_panes( $session, $window, [$attribute],
    Tmux::Filter->new->equal( 'pane_id', $pane ) );
  return $attr->[0]->{$attribute};
}

sub cmd_list_panes( $self, $session = undef, $window = undef, $attributes = [], $filter = undef ) {

  if ($window) {
    my $win_filter = Tmux::Filter->new->equal( 'window_id', $window );
    $filter = $filter ? Tmux::Filter->new->and( $win_filter, $filter ) : $win_filter;
  }

  my $cmd  = 'list-panes';
  my $args = [
    !$session && !$window ? -a : (),
    '-F',
    attr_builder($attributes),
    $filter ? ( '-f', $filter ) : (),
    $session ? ( '-s', '-t', $session ) : (),
  ];

  return ( attr_parser( $self->do( $cmd, $args ) ) );
}

1;
