
package Module::ML::Functor;
use Moose;

has 'structure' => (
    is       => 'ro',
    isa      => 'Module::ML::Structure',
    required => 1,        
);

has 'parameter' => (
    is       => 'ro',
    isa      => 'Module::ML::Signature',
    required => 1,
);

sub create {
    my ($self, $name, $structure) = @_;
    
    my $new_pkg = Class::MOP::Package->initialize($name);
    
    $self->structure->export_to($name);
    $structure->export_to($name);                
    
}

no Moose; 1;

__END__

=pod

=cut