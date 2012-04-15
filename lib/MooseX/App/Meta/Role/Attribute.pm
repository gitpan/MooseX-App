# ============================================================================
package MooseX::App::Meta::Role::Attribute;
# ============================================================================

use utf8;
use 5.010;

use namespace::autoclean;
use Moose::Role;

has 'cmd_tags' => (
    is          => 'rw',
    isa         => 'ArrayRef[Str]',
    predicate   => 'has_cmd_tags',
);

{
    package Moose::Meta::Attribute::Custom::Trait::App::Tags;
    sub register_implementation { 'MooseX::App::Meta::Role::Attribute' }
}

1;