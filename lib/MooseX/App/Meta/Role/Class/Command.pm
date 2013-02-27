# ============================================================================
package MooseX::App::Meta::Role::Class::Command;
# ============================================================================

use utf8;
use 5.010;

use namespace::autoclean;
use Moose::Role;

use Pod::Elemental;
use Pod::Elemental::Selectors qw();
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Transformer::Nester;

has 'command_short_description' => (
    is          => 'rw',
    isa         => 'Maybe[Str]',
    lazy_build  => 1,
);

has 'command_long_description' => (
    is          => 'rw',
    isa         => 'Maybe[Str]',
    lazy_build  => 1,
);

has 'command_usage' => (
    is          => 'rw',
    isa         => 'Maybe[Str]',
    lazy_build  => 1,
);

sub command_short_description_predicate {
    my ($self) = @_;  
    return $self->_command_description_predicate('command_short_description');
}

sub _build_command_short_description {
    my ($self) = @_;
    my %pod = $self->_build_command_pod();
    return $pod{'command_short_description'}
        if defined $pod{'command_short_description'};
    return;
}

sub command_long_description_predicate {
    my ($self) = @_;
    return $self->_command_description_predicate('command_long_description');
}

sub _build_command_long_description {
    my ($self) = @_;
    my %pod = $self->_build_command_pod();
    return $pod{'command_long_description'}
        if defined $pod{'command_long_description'};
    return;
}

sub command_usage_predicate {
    my ($self) = @_;
    return $self->_command_description_predicate('command_usage');
}

sub _build_command_usage {
    my ($self) = @_;
    my %pod = $self->_build_command_pod();
    return $pod{'command_usage'}
        if defined $pod{'command_usage'};
    return;
}

sub _command_description_predicate {
    my ($self,$field) = @_;
    
    my $attribute = $self->meta->find_attribute_by_name($field);
    
    unless ($attribute->has_value($self)) {
        $self->_build_command_pod($field);
    }
    
    my $value = $attribute->get_value($self); 
        
    return (defined $value && $value ? 1:0);
}


sub _build_command_pod {
    my ($self) = @_;
    
    my %pod_raw = MooseX::App::Utils::parse_pod($self->name);
    
    my %pod = (
        command_usage               => ($pod_raw{SYNOPSIS} || $pod_raw{USAGE}),
        command_long_description    => ($pod_raw{DESCRIPTION} || $pod_raw{OVERVIEW}),
        command_short_description   => ($pod_raw{NAME} || $pod_raw{ABSTRACT}),
    );
    
    while (my ($key,$value) = each %pod) {
        next
            unless defined $value;
            
        my $meta_attribute = $self->meta->find_attribute_by_name($key);
        next
            unless defined $meta_attribute;
        $meta_attribute->set_raw_value($self,$value);
    }
    
    return %pod;
}

#{
#    package Moose::Meta::Class::Custom::Trait::AppCommand;
#    sub register_implementation { return 'MooseX::App::Meta::Role::Class::Command' }
#}

1;

__END__

=pod

=encoding utf8

=head1 NAME

MooseX::App::Meta::Role::Class::Command - Meta class role for command classes

=head1 DESCRIPTION

This meta class role will automatically be applied to all command classes.
This documentation is only of interest if you intent to write plugins for 
MooseX-App.

=head1 ACCESSORS

=head2 command_short_description

Read/set the short command description. Will be extracted from the Pod NAME
section if not set. Alternative this will be taken from the DistZilla
ABSTRACT tag.

=head2 command_long_description

Read/set the long command description. Will be extracted from the Pod 
DESCRIPTION or OVERVIEW section if not set.

=head2 command_usage

Read/set the long command usage. Will be extracted from the Pod 
SYNOPSIS or USAGE section if not set. If these Pod sections are not defined
the usage will be autogenerated.

=head1 METHODS

=head2 _build_command_pod

Parses the Pod from the command class.

=cut