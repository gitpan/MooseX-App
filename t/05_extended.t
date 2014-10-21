# -*- perl -*-

# t/01_basic.t - Basic tests

use Test::Most tests => 12+1;
use Test::NoWarnings;

use lib 't/testlib';

use Test03;

{
    explain('Test 1: Private option is not exposed');
    local @ARGV = qw(some --private 1);
    my $test01 = Test03->new_with_command;
    isa_ok($test01,'MooseX::App::Message::Envelope');
    is($test01->blocks->[0]->header,"Unknown option: private","Message ok");
    is($test01->blocks->[0]->type,"error",'Message is of type error');
}

{
    explain('Test 2: Options from role');
    local @ARGV = qw(some --another 10 --role 15);
    my $test02 = Test03->new_with_command;
    isa_ok($test02,'Test03::SomeCommand');
    is($test02->another_option,'10','Param is set');
    is($test02->roleattr,'15','Role param is set');
}

{
    explain('Test 3: Missing attribute value');
    local @ARGV = qw(some --another);
    my $test03 = Test03->new_with_command;
    isa_ok($test03,'MooseX::App::Message::Envelope');
    is($test03->blocks->[0]->header,"Option another requires an argument","Message ok");
    is($test03->blocks->[0]->type,"error",'Message is of type error');
}

{
    explain('Test 4: All options available & no description');
    local @ARGV = qw(some --help);
    my $test03 = Test03->new_with_command;
    isa_ok($test03,'MooseX::App::Message::Envelope');
    is($test03->blocks->[1]->header,'options:','No description');
    is($test03->blocks->[1]->body,"    --another          [Required; Not important]
    --global_option    Enable this to do fancy stuff [Flag]
    --help --usage -?  Prints this usage information. [Flag]
    --roleattr         [Role]
    --some_option      Very important option!","Message ok");
}
