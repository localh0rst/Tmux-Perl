[![Actions Status](https://github.com/localh0rst/Tmux-Perl/actions/workflows/test.yml/badge.svg)](https://github.com/localh0rst/Tmux-Perl/actions)
# NAME

Tmux - Perl library for interacting with tmux

# SYNOPSIS

    use Tmux;

    my $tmux = Tmux->new;

    # Returns a Tmux::Sessions object
    my $sessions = $tmux->sessions;

    # Returns a Tmux::Windows object
    my $windows = $tmux->windows;

    # Returns a Tmux::Panes object
    my $panes = $tmux->panes;

# METHODS

## sessions

Returns a [Tmux::Sessions](https://metacpan.org/pod/Tmux%3A%3ASessions) object.

    my $sessions = $tmux->sessions;

## windows

Returns a [Tmux::Windows](https://metacpan.org/pod/Tmux%3A%3AWindows) object.

    my $windows = $tmux->windows;

## panes

Returns a [Tmux::Panes](https://metacpan.org/pod/Tmux%3A%3APanes) object.

    my $panes = $tmux->panes;

# DESCRIPTION

Tmux is ...

# LICENSE

Copyright (C) localh0rst.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

localh0rst <git@fail.ninja>
