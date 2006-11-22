
package Module::ML::Structure;
use Moose;
use Moose::Util::TypeConstraints;

use Class::MOP::Package;

subtype 'Class::MOP::Package'
    => as 'Object'
    => where { $_->isa('Class::MOP::Package') };

coerce 'Class::MOP::Package'
    => from 'Str'
        => via { Class::MOP::Package->initialize($_) };

has 'signature' => (
    is       => 'ro',
    isa      => 'Module::ML::Signature',
    required => 1,
);

has 'package' => (
    is       => 'ro',
    isa      => 'Class::MOP::Package',
    coerce   => 1,        
    required => 1,        
);

sub BUILD {
    my $self = shift;
    
    # first make sure we export the right stuff
    foreach my $symbol ($self->signature->definitions->elements) {
        $self->package->has_package_symbol($symbol)
            || confess $self->package->name . 
                       " does not match signature (" . 
                       $self->signature->name .
                       "), missing '$symbol'";
    }        
    
    
    $self->package->add_package_symbol('&import' => sub {
        shift;
        $self->export_to(scalar caller, @_);
    })
}

sub export_to {
    my $self = shift;
    my $pkg  = shift;
    my @exports = @_ ? @_ : $self->signature->definitions->elements;
    my $meta_pkg = Class::MOP::Package->initialize($pkg);
    foreach my $symbol (@exports) {
        $meta_pkg->add_package_symbol(
            $symbol,
            $self->package->get_package_symbol($symbol)
        );
    }        
}

no Moose; no Moose::Util::TypeConstraints; 1;

__END__

=pod

=cut