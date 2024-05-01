requires 'perl', '5.36.0';
requires 'File::Which';
requires 'IO::Handle';
requires 'IO::Pty';
requires 'IPC::Open3';
requires 'Moo';
requires 'Moose';
requires 'POSIX';
requires 'Symbol';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

