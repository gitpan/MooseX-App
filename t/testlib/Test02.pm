package Test02;

use Moose;
use MooseX::App qw(BashCompletion ConfigHome Color);

app_namespace "Test02::Command";

sub run {
    print "RAN";   
}

1;