# ============================================================================
package MooseX::App::Meta::Role::Attribute::Option;
# ============================================================================

use utf8;
use 5.010;

use namespace::autoclean;
use Moose::Role;

use Moose::Util::TypeConstraints;

subtype 'MooseX::App::Types::CmdAliases' => as 'ArrayRef';

coerce 'MooseX::App::Types::CmdAliases'
    => from 'Str'
        => via { [$_] };

no Moose::Util::TypeConstraints;


has 'cmd_option' => (
    is          => 'rw',
    isa         => 'Bool',
    default     => 0,
);

has 'cmd_tags' => (
    is          => 'rw',
    isa         => 'ArrayRef[Str]',
    predicate   => 'has_cmd_tags',
);

has 'cmd_flag' => (
    is          => 'rw',
    isa         => 'Str',
    predicate   => 'has_cmd_flag',
);

has 'cmd_aliases' => (
    is          => 'rw',
    isa         => 'MooseX::App::Types::CmdAliases',
    predicate   => 'has_cmd_aliases',
    coerce      => 1,
);

has 'cmd_proto' => (
    is          => 'rw',
    isa         => 'Bool',
    default     => 0,
);

sub cmd_is_bool {
    my ($self) = @_; 
   
    if ($self->has_type_constraint
        && $self->type_constraint->is_a_type_of('Bool')) {
        
        # Bool and defaults to true 
        if ($self->has_default 
            && ! $self->is_default_a_coderef
            && $self->default == 1) {
            return 0;
        ## Bool and is required
        #} elsif (! $self->has_default
        #    && $self->is_required) {
        #    return 0; 
        }
        
        # Ordinary bool
        return 1;
    }
    
    return undef
}

sub cmd_usage {
    my ($self) = @_;
    
    my $name = join(' ', map { (length($_) == 1) ? "-$_":"--$_" } $self->cmd_name_possible); ;
    my @tags = $self->cmd_tags_list();
    my $description = ($self->has_documentation) ? $self->documentation : '';
    
    if (scalar @tags) {
        $description .= ' '
            if $description;
        $description .= '['.join('; ',@tags).']';
    }
    
    return ($name,$description);
}

sub cmd_name_primary {
    my ($self) = @_;
    
    if ($self->has_cmd_flag) {
        return $self->cmd_flag;
    } else {
        return $self->name;
    }
}

sub cmd_name_possible {
    my ($self) = @_;
    
    my @names = ($self->cmd_name_primary);
    
    if ($self->has_cmd_aliases) {
        push(@names, @{$self->cmd_aliases});
    }
    
    my $bool = $self->cmd_is_bool();
    
    return @names;
}

sub cmd_tags_list {
    my ($self) = @_;
    
    my @tags;
    
    if ($self->is_required
        && ! $self->is_lazy_build
        && ! $self->has_default) {
        push(@tags,'Required')
    }
    
    if ($self->has_default && ! $self->is_default_a_coderef) {
        if ($self->has_type_constraint
            && $self->type_constraint->is_a_type_of('Bool')) {
#            if ($attribute->default) {
#                push(@tags,'Default:Enabled');
#            } else {
#                push(@tags,'Default:Disabled');
#            }
        } else {
            push(@tags,'Default:"'.$self->default.'"');
        }
    }
    
    if ($self->has_type_constraint) {
        my $type_constraint = $self->type_constraint;
        if ($type_constraint->is_subtype_of('ArrayRef')) {
            push(@tags,'Multiple');
        } elsif ($type_constraint->is_a_type_of('HashRef')) {
            push(@tags,'Key-Value');
        }
        unless ($self->should_coerce) {
            if ($type_constraint->is_a_type_of('Int')) {
                push(@tags,'Integer');
            } elsif ($type_constraint->is_a_type_of('Num')) {
                push(@tags ,'Number');
            } elsif ($type_constraint->is_a_type_of('Bool')) {
                push(@tags ,'Flag');
            }
        }
    }
    
    if ($self->can('cmd_tags')
        && $self->can('cmd_tags')
        && $self->has_cmd_tags) {
        push(@tags,@{$self->cmd_tags});
    }
    
    return @tags;
}

{
    package Moose::Meta::Attribute::Custom::Trait::AppOption;
    
    use strict;
    use warnings;
    
    sub register_implementation { return 'MooseX::App::Meta::Role::Attribute::Option' }
}

1;

=pod

=encoding utf8

=head1 NAME

MooseX::App::Meta::Role::Attribute::Option - Meta attribute role for options

=head1 DESCRIPTION

This meta attribute role will automatically be applied to all attributes
that should be used as options. This documentation is only of interest if you 
intent to write plugins for MooseX-App.

=head1 ACCESSORS

=head2 cmd_flag

Use this name instead of the attribute name as the option name

=head2 cmd_option

Boolean flag to mark if this attribute should be used as an option

=head2 cmd_aliases

Arrayref of alternative option names

=head2 cmd_proto

Boolean flag to mark this attribute as proto option. Proto attributes will be 
parsed before all other options (eg. a config-file option that sets
other attribues)

=head2 cmd_tags

Extra option tags displayed in the usage information (in brackets)

=head1 METHODS

=head2 cmd_name_possible

 my @names = $attribute->cmd_name_possible();

Returns a list of all possible option names.

=head2 cmd_name_primary

 my $name = $attribute->cmd_name_primary();

Returns the primary option name

=head2 cmd_usage

 my ($name,$description) = $attribute->command_usage_attribute_detail();

Returns a name and description for a given meta attribute class.

=head2 cmd_tags_list

 my @tags = $attribute->cmd_tags_list();

Returns a list of tags for a given meta attribute class.

=head2 cmd_is_bool

 my $bool = $attribute->cmd_is_bool();

Returns true, false or undef depending on the type constraint and default
of the attribute:

=over

=item * undef: Does not have a boolean type constraint

=item * true: Has a boolean type constraint

=item * false: Has a boolean type constraint, and a true default value

=back

=cut

