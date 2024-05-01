package Tmux::Command;
use strict;
use warnings;
use feature 'signatures';
use File::Which qw/which/;
use Symbol 'gensym';
use IPC::Open3;
use Data::Dumper;
use Moo;

# Delete the following line when you have a working implementation
use IO::Pty;
use IO::Handle;
use POSIX;

has 'basecmd'                               => ( is => 'rw', default => sub { which('tmux') } );
has [ 'in', 'out', 'err', 'cmd_pid', 'rc' ] => ( is => 'rw' );

# Command is the tmux-command (i.e. list-sessions) and not the executable
sub run( $self, $command, $args = [] ) {

  $self->cmd_pid( open3(
    my $in, my $out, my $err = gensym,
    $self->basecmd, $command, ref($args) eq 'ARRAY' ? @{$args} : $args
  ) );

  $self->in($in);
  $self->out($out);
  $self->err($err);

  #print Dumper $command, $args;
  return ($self);
}

sub get_lines($self) {
  my $o     = $self->out;
  my $lines = [];
  while ( my $line = <$o> ) {
    chomp($line);
    push( @{$lines}, $line );
  }

  return ($lines);
}

# TODO: This looks a bit like a hack. I need to find a better way to do this.
# btw, its stolen from: https://www.perlmonks.org/?node_id=392942
sub do_attach( $self, $command, $args = [] ) {
  warn('YOU SHOULD NOT USE THIS SHIT. ITS JUST A FUCKING POC!');
  my $cmd     = 'tmux attach -t WURST';
  my $pty     = IO::Pty->new;
  my $cmd_pid = fork;
  if ( !defined($cmd_pid) ) { die "error forking: $!"; }
  if ( $cmd_pid == 0 ) {
    POSIX::setsid();
    my $slave = $pty->slave;
    $slave->clone_winsize_from( \*STDIN );
    close($pty);

    STDOUT->fdopen( $slave, '>' ) || die $!;

    #STDIN->fdopen( $slave, '<' )    || die $!;
    STDERR->fdopen( \*STDOUT, '>' ) || die $!;
    close($slave);
    exec($cmd);
  }

  #$pty->make_slave_controlling_terminal();
  $pty->close_slave();

  #return $pty;
  while (<$pty>) { }
}

sub do( $self, $cmd, $args = [] ) {
  my $res = $self->run( $cmd, $args )->get_lines;
  my $e   = $self->err;

  $self->exit_cmd;
  return ($res);
}

sub do_rc( $self, $cmd, $args = [] ) {
  $self->run( $cmd, $args );
  my $e = $self->err;
  my $o = $self->out;

  $self->exit_cmd;

  return ( $self->rc == 0 ? 1 : 0 );
}

sub exit_cmd($self) {

  if ( $self->cmd_pid ) {
    close( $self->in );
    close( $self->out );
    close( $self->err );
    waitpid( $self->cmd_pid, 0 );
    $self->rc( $? >> 8 );
    return ( $self->rc );
  }
}

__PACKAGE__->meta->make_immutable;
1;
