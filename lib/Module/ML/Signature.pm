
package Module::ML::Signature;
use Moose;

use Module::ML::Types;

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

no Moose; 1;

__END__

=pod

=cut