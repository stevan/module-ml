
package Module::ML::Signature;
use Moose;
use Moose::Util::TypeConstraints;
    
use Set::Object;

subtype 'Set::Object'
    => as 'Object'
    => where { $_->isa('Set::Object') };

coerce 'Set::Object'
    => from 'ArrayRef'
        => via { Set::Object->new(@{$_}) };

has 'name' => (
    is  => 'ro',
    isa => 'Str',
);

has 'definitions' => (
    is       => 'ro',
    isa      => 'Set::Object',
    coerce   => 1,
    required => 1,
);

no Moose; no Moose::Util::TypeConstraints; 1;

__END__

=pod

=cut