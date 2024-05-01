package Tmux::Filter;
use strict;
use warnings;
use feature 'signatures';
use Moo;
use Carp                  qw/croak/;
use Tmux::Helper::Default qw/mask_attr is_masked/;
use Data::Dumper;

has 'current' => ( is => 'rw' );

sub regex( $self, $attribute, $value = [], $flags = [], $exact = 0 ) {
  my $prefix = '#{m/r' . join( '', @{$flags}, ':' );
  my $suffix = '}';
  my $str    = join(
    '',
    $prefix, ref($value) eq 'ARRAY' ? join( '|', @{$value} ) : $value,
    ',',
    $self->mask_attr($attribute),
    $suffix

  );

  return ($str);
}

sub equal( $self, $lhs, $rhs ) {
  return ( join( '', '#{==:', is_masked($lhs) ? $lhs : mask_attr($lhs), ',', $rhs, '}' ) );
}

sub or( $self, $lhs, $rhs ) {
  return ( join( '', '#{||:', $lhs, ',', $rhs, '}' ) );
}

sub and( $self, $lhs, $rhs ) {
  return ( join( '', '#{&&:', $lhs, ',', $rhs, '}' ) );
}

__PACKAGE__->meta->make_immutable;
1;
