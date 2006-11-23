#!/usr/bin/perl

use strict;
use warnings;
use Test::More no_plan => 1;

BEGIN {
    use_ok('Module::ML::Signature');
    use_ok('Module::ML::Structure');
    use_ok('Module::ML::Functor');    
}

=pod

NOTE:
This test currently calls all functions as 
class methods, this is so we can get the proper
amount of polymorphism. I have to fix this.

=cut

{
    package Foo;
    use strict;
    use warnings;
    
    sub foo { 'Foo::foo' }    
    sub bar { 'Foo::bar' }
    sub baz { 'Foo::baz' }    
}

{
    package Foo::Bar;
    use strict;
    use warnings;
    
    sub foo { 'Foo::Bar::foo' }    
    sub bar { 'Foo::Bar::bar' } 
}

{
    package My::Functor;
    use strict;
    use warnings;
        
    sub woot {
        "My::Functor::woot => " . $_[0]->foo() . " => " . $_[0]->bar();
    }
}

## signature

my $foo_sig = Module::ML::Signature->new(
    name        => 'Foo.Sig',
    definitions => [ '&foo', '&bar' ]
);
isa_ok($foo_sig, 'Module::ML::Signature');

## structures

my $foo_struct = Module::ML::Structure->new(
    signature => $foo_sig,
    package   => 'Foo',
);
isa_ok($foo_struct, 'Module::ML::Structure');

my $foo_bar_struct = Module::ML::Structure->new(
    signature => $foo_sig,
    package   => 'Foo::Bar',
);
isa_ok($foo_bar_struct, 'Module::ML::Structure');

## functor

my $my_functor = Module::ML::Functor->new(
    structure => Module::ML::Structure->new(
        package   => 'My::Functor',
        signature => Module::ML::Signature->new(
            name        => 'Foo::Functor.Sig',
            definitions => [ '&woot' ]
        )
    ),
    parameter => $foo_sig,
);
isa_ok($my_functor, 'Module::ML::Functor');

$my_functor->create('My::Functor::Foo' => $foo_struct);

can_ok('My::Functor::Foo', 'woot');
can_ok('My::Functor::Foo', 'foo');
can_ok('My::Functor::Foo', 'bar');

is(My::Functor::Foo->woot(), 'My::Functor::woot => Foo::foo => Foo::bar', '... got the right values');

$my_functor->create('My::Functor::Foo::Bar' => $foo_bar_struct);

can_ok('My::Functor::Foo::Bar', 'woot');
can_ok('My::Functor::Foo::Bar', 'foo');
can_ok('My::Functor::Foo::Bar', 'bar');

is(My::Functor::Foo::Bar->woot(), 'My::Functor::woot => Foo::Bar::foo => Foo::Bar::bar', '... got the right values');



