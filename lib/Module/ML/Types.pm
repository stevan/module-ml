
package Module::ML::Types;
use Moose::Util::TypeConstraints;

use Set::Object;
use Class::MOP::Package;

subtype 'Class::MOP::Package'
    => as 'Object'
    => where { $_->isa('Class::MOP::Package') };

coerce 'Class::MOP::Package'
    => from 'Str'
        => via { Class::MOP::Package->initialize($_) };

subtype 'Set::Object'
    => as 'Object'
    => where { $_->isa('Set::Object') };

coerce 'Set::Object'
    => from 'ArrayRef'
        => via { Set::Object->new(@{$_}) };
        
1;

__END__

=pod

=cut