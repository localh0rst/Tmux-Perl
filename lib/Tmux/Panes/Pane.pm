package Tmux::Panes::Pane;
use strict;
use warnings;
use feature 'signatures';
use Moo;
use Data::Dumper;
use Tmux::Helper::Default;
use Tmux::Command;

extends 'Tmux::Command::Pane';

has '__session_id' => ( is => 'rw' );
has '__window_id'  => ( is => 'rw' );
has '__pane_id'    => ( is => 'rw' );
has attributes()   => ( is => 'ro' );

foreach my $attr ( @{ attributes() } ) {
  around $attr => sub( $orig, $self ) {
    $self->cmd_get_attribute_single( $attr, $self->__session_id, $self->__window_id,
      $self->__pane_id );
  };
}

#sub clear_history( $self, $hyperlinks = undef ) {
#  my $ret = $self->cmd_clear_history( $self->pane_id, $hyperlinks );
#  return ($ret);
#}
#
#sub split( $self, $params = {} ) {
#  my $ret = $self->cmd_split_pane( $self->pane_id, $params );
#  return ($ret);
#}
#
#sub kill( $self, $params = {} ) {
#  my $ret = $self->cmd_kill_pane( $self->pane_id, $params );
#  return ($ret);
#}

__PACKAGE__->meta->make_immutable;
1;
