#!/usr/bin/perl

use strict;
use warnings;
use Test::More no_plan => 1;

BEGIN {
    use_ok('Module::ML::Signature');
    use_ok('Module::ML::Structure');
    use_ok('Module::ML::Functor'); 
    use_ok('Module::ML::Types');            
}