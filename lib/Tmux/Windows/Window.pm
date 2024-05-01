package Tmux::Windows::Window;
use strict;
use warnings;
use feature 'signatures';
use Moo;

use Tmux::Panes;
use Data::Dumper;
use Tmux::Command;
use Tmux::Helper::Default;

extends 'Tmux::Command::Window';

has '__session_id' => ( is => 'rw' );
has '__window_id'  => ( is => 'rw' );
has attributes()   => ( is => 'ro' );

foreach my $attr ( @{ attributes() } ) {
  around $attr => sub( $orig, $self ) {
    $self->cmd_get_attribute_single( $attr, $self->__session_id, $self->__window_id );
  };
}

sub panes( $self, $filter = undef ) {
  my $panes = Tmux::Panes->new->list( $self->__session_id, $self->__window_id, $filter );

  # Generate Objects before returning
  return ($panes);
}

#sub select_layout( $self, $layout = undef ) {
# my $ret = $self->cmd_select_layout($layout);
#return ($ret);
#}

sub select( $self, $params = {} ) {
  return ( $self->cmd_select_window( $self->__window_id, $params ) );
}

sub last($self)     { return ( $self->__window_id, $self->cmd_last_window ); }
sub next($self)     { return ( $self->__window_id, $self->cmd_next_window ); }
sub previous($self) { return ( $self->__window_id, $self->cmd_previous_window ); }

__PACKAGE__->meta->make_immutable;
1;
