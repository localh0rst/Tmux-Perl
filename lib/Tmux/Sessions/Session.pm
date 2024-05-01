package Tmux::Sessions::Session;
use strict;
use warnings;
use feature 'signatures';
use Moo;
use Tmux::Windows;
use Data::Dumper;
use Tmux::Helper::Default;

extends 'Tmux::Command::Session';

has '__session_id' => ( is => 'rw' );
has attributes()   => ( is => 'ro' );

foreach my $attr ( @{ attributes() } ) {
  around $attr => sub( $orig, $self ) {
    $self->cmd_get_attribute_single( $attr, $self->__session_id );
  };
}

sub windows( $self, $filter = undef ) {
  return ( Tmux::Windows->new->list( $self->__session_id, $filter ) );
}

sub rename( $self, $new ) {
  return ( $self->cmd_rename_session( $self->__session_id, $new ) );
}

sub kill($self) {
  return ( $self->cmd_kill_session( $self->__session_id ) );
}

sub attach( $self, $params = {} ) {
  return ( $self->cmd_attach_session( $self->__session_id, $params ) );
}

sub lock($self) {
  return ( $self->cmd_lock_session( $self->__session_id ) );
}

__PACKAGE__->meta->make_immutable;
1;
