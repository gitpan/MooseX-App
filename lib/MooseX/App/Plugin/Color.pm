# ============================================================================
package MooseX::App::Plugin::Color;
# ============================================================================

use 5.010;
use utf8;

use namespace::autoclean;
use Moose::Role;

sub plugin_metaroles {
    my ($self,$class) = @_;
    
    return {
        class   => ['MooseX::App::Plugin::Color::Meta::Class'],
    }
}

1;

__END__

=encoding utf8

=head1 NAME

MooseX::App::Plugin::Color - Colorful output for your MooseX::App applications

=head1 SYNOPSIS

 package MyApp;
 use MooseX::App qw(Color);

=head1 DESCRIPTION

This plugin enables colors for messages generated by MooseX-App.

=cut