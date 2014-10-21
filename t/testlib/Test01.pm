package Test01;

use Moose;
use MooseX::App qw(Config Env);

app_strict 1;

app_description "Huissasa";

option 'global' => (
    isa             => 'Int',
    is              => 'rw',
    required        => 1,
    documentation   => q[test],
    cmd_tags        => ['Important!'],
);

has 'private' => (
    isa             => 'Int',
    is              => 'rw',
);



1;