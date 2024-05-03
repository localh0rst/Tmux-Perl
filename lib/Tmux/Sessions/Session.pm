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

around BUILDARGS => sub( $orig, $class, @args ) {

  return { name => $args[0] }
    if @args == 1 && !ref $args[0];

  return $class->$orig(@args);
};

sub BUILD( $self, $args ) {

  # Assume that this session is already created since
  # $self->__session_id is set and should not be used
  # outside of Tmux::Sessions. If it is not set, try
  # to create a new session.
  return if ( $self->__session_id );

  if ( $self->cmd_find_session_by_name( $args->{name} ) ) {
    $self->__session_id( $self->cmd_find_session_by_name( $args->{name} ) );
  } else {
    $self->__session_id( $self->cmd_new_session( $args->{name}, $args->{params} ) );
  }

}

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
