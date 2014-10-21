# ============================================================================
package MooseX::App::Plugin::Env::Meta::Class;
# ============================================================================

use 5.010;
use utf8;

use namespace::autoclean;
use Moose::Role;

around 'command_proto' => sub {
    my ($orig,$self,$command_meta,$processed_argv) = @_;
    
    my ($result,$errors) = $self->$orig($command_meta,$processed_argv);
    
    foreach my $attribute ($self->command_usage_attributes_list($command_meta)) {
        next
            unless $attribute->can('has_cmd_env')
            && $attribute->has_cmd_env;
       
        my $cmd_env = $attribute->cmd_env;
       
        if (exists $ENV{$cmd_env}
            && ! defined $result->{$attribute->name}) {
            $result->{$attribute->name} = $ENV{$cmd_env};
            my $error = $self->command_check_attribute($attribute,$ENV{$cmd_env});
            push(@{$errors},$error)
                if $error;
        }
    }
    
    return ($result,$errors);
};

1;