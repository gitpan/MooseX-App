# ============================================================================
package MooseX::App::Plugin::Typo::Meta::Class;
# ============================================================================

use 5.010;
use utf8;

use namespace::autoclean;
use Moose::Role;

use MooseX::App::Plugin::Version::Command;

around 'command_matching' => sub {
    my $orig = shift;
    my $self = shift;
    my $command = shift;
    
    my @candidates = $self->$orig($command);
    
    if (scalar @candidates) {
        return @candidates;   
    } else {
        my $commands = $self->app_commands;
        my $length = length($command);
        foreach (@{$commands}) {
            
        }
    }
};

1;