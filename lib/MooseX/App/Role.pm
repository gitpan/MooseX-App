# ============================================================================
package MooseX::App::Role;
# ============================================================================

use 5.010;
use utf8;
use strict;
use warnings;

use Moose::Role ();
use MooseX::App::Exporter qw(option);
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    also      => 'Moose::Role',
    with_meta => [ 'option' ],
);

sub init_meta {
    shift;
    my (%args) = @_;
    
    my $meta = Moose::Role->init_meta( %args );
    
    Moose::Util::MetaRole::apply_metaroles(
        for             => $meta,
        role_metaroles  => {
            applied_attribute   => ['MooseX::App::Meta::Role::Attribute::Option'],
        },
    );
    
    return $meta;
}

1;

__END__

=pod

=head1 NAME

MooseX::App::Role - Define attributes in a role

=head1 SYNOPSIS

 package MyApp::Role::SomeRole;
 
 use Moose::Role; # optional
 use MooseX::App::Role;
 
 option 'testattr' => (
    isa             => 'rw',
    cmd_tags        => [qw(Important! Nice))],
 );

=head1 DESCRIPTION

When loading this package in a role you can use the C<cmd_tags>
attribute to document an attribute and declare attributes with the
'option' keyword.

Alternatively you can also just use attribute traits:

 has 'testattr' => (
    isa             => 'rw',
    traits          => ['AppOption'],
    cmd_option      => 1,
    cmd_tags        => [qw(Important! Nice))],
 );

=cut