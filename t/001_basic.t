#!/usr/bin/perl

use strict;
use warnings;
use Test::More no_plan => 1;

BEGIN {
    use_ok('Module::ML::Signature');
    use_ok('Module::ML::Structure');
}

{
    package Foo;
    use strict;
    use warnings;
    
    sub foo { 'Foo::foo' }    
    sub bar { 'Foo::bar' }
    sub baz { 'Foo::baz' }    
}

my $foo_sig = Module::ML::Signature->new(
    name        => 'Foo.Sig',
    definitions => [ '&foo', '&bar' ]
);
isa_ok($foo_sig, 'Module::ML::Signature');

my $foo_struct = Module::ML::Structure->new(
    signature => $foo_sig,
    package   => 'Foo',
);
isa_ok($foo_struct, 'Module::ML::Structure');

isa_ok($foo_struct->package, 'Class::MOP::Package');
is($foo_struct->package->name, 'Foo', '... got the right package name');

isa_ok($foo_struct->signature, 'Module::ML::Signature');
is($foo_struct->signature, $foo_sig, '... got the right signature');

{
    package Bar;
    use strict;
    use warnings;    
    Foo->import;
}

can_ok('Bar', 'foo');
can_ok('Bar', 'bar');

ok(!Bar->can('baz'), '... but Bar can not &baz');

{
    package Baz;
    use strict;
    use warnings;    
    Foo->import('&foo');
}

can_ok('Baz', 'foo');

ok(!Baz->can('bar'), '... but Baz can not &bar');
ok(!Baz->can('baz'), '... but Baz can not &baz');

