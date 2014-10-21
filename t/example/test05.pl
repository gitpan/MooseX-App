#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use FindBin qw();
use lib $FindBin::Bin.'/../testlib';

use Test05;
Test05->new_with_options->run;