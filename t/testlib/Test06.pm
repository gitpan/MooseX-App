package Test06;

use MooseX::App qw(Config Env);
app_fuzzy();

option 'some_option' => (
    is            => 'rw',
    isa           => 'Bool',
    documentation => q[Enable this to do fancy stuff],
);



1;