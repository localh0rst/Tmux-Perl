package Tmux;
use 5.36.0;
use strict;
use warnings;
use feature qw/signatures/;
use Moo;
use Tmux::Sessions;
use Tmux::Windows;
use Tmux::Panes;

our $VERSION = "0.5";

sub sessions($self) {
  return ( Tmux::Sessions->new );
}

sub windows($self) {
  return ( Tmux::Windows->new );
}

sub panes($self) {
  return ( Tmux::Panes->new );
}

1;
__END__

=encoding utf-8

=head1 NAME

Tmux - Perl library for interacting with tmux

=head1 SYNOPSIS

    use Tmux;

    my $tmux = Tmux->new;

    # Returns a Tmux::Sessions object
    my $sessions = $tmux->sessions;

    # Returns a Tmux::Windows object
    my $windows = $tmux->windows;

    # Returns a Tmux::Panes object
    my $panes = $tmux->panes;

=head1 METHODS

=head2 sessions

Returns a L<Tmux::Sessions> object.

    my $sessions = $tmux->sessions;

=head2 windows

Returns a L<Tmux::Windows> object.

    my $windows = $tmux->windows;

=head2 panes

Returns a L<Tmux::Panes> object.

    my $panes = $tmux->panes;

=head1 DESCRIPTION

Tmux is ...

=head1 LICENSE

Copyright (C) localh0rst.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

localh0rst E<lt>git@fail.ninjaE<gt>

=cut

