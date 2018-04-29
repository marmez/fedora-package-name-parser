package FedoraPackage::NameParser;

use strict;
use warnings;
use diagnostics;

sub new {
  # This is more readable than:
  # return bless {}, shift;
  my ($class, $object) = (shift, {});
  return bless $object, $class;
}

sub parse {
  my ($self, $string) = @_;
  my (
    # Package name
    $name,
    # Package architecture
    $arch,
    # Package number
    $num,
    # Package version number
    $ver,
    # Package milestone number
    $milst,
    # Package distribution tag
    $dist,
    # Package repository tag
    $repo
  );
  my ($first_part, $second_part) = split / /, $string;
  my ($third_part, $fourth_part) = split /-/, $second_part;
  $first_part =~ /^(.+)\.(x86_64|i686|noarch)$/;
  ($name, $arch) = ($1, $2);
  if ($third_part =~ /:/) {
    ($num, $ver) = split q{:}, $third_part;
  }
  else {
    $ver = $third_part;
  }
  if ($fourth_part =~ /\.(fc\d+)\.?/) {
    $dist = $1;
    ($milst, $repo) = split /\.$dist\.?/, $fourth_part;
  }
  else {
    $milst = $fourth_part;
  }
  $self->{name} = $name // return 0;
  $self->{arch} = $arch // return 0;
  $self->{num} = $num // q{};
  $self->{ver} = $ver // return 0;
  $self->{milst} = $milst // return 0;
  $self->{dist} = $dist // q{};
  $self->{repo} = $repo // q{};
  $self->{rest} = q{};
  my $fullname_length = length $self->fullname;
  $self->{rest} = substr $string, $fullname_length
    if length $string > $fullname_length;
  return 1;
}

sub get {
  my ($self, @keys) = @_;
  return map {
    $self->{$_};
  } @keys
    if wantarray;
  return $self->{shift @keys};
}

sub fullname {
  my $self = shift;
  my $fullname = $self->{name} . q{.} . $self->{arch} . q{ };
  $fullname .= $self->{num} . q{:}
    if $self->{num};
  $fullname .= $self->{ver} . q{-} . $self->{milst};
  $fullname .= q{.} . $self->{dist}
    if $self->{dist};
  $fullname .= q{.} . $self->{repo}
    if $self->{repo};
  return $fullname;
}

1;

=pod

=encoding utf8

=head1 NAME

C<FedoraPackage::NameParser> - Parse a Fedora RPM package name to its components.

=head1 SYNOPSIS

  use FedoraPackage::NameParser;

  my $fpnp = FedoraPackage::NameParser->new;

  # Parse a string containing single package name
  $fpnp->parse($package_name)
    or die 'Could not parse package name';

  # Parse a string containing more package names
  while ($string) {
    $fpnp->parse($string)
      or die 'Could not parse string for package name';
    $string = $fpnp->get('rest');
  }

  # Get the package name components
  # Package name
  $fpnp->get('name');
  # Package architecture
  $fpnp->get('arch');
  # Package number (optional)
  $fpnp->get('num');
  # Package version number
  $fpnp->get('ver');
  # Package milestone number
  $fpnp->get('milst');
  # Package distribution tag
  $fpnp->get('dist');
  # Package resository tag
  $fpnp->get('repo');

  # Get rest of string
  $fpnp->get('rest');

  # Get full package name (composed)
  $fpnp->fullname;

=head1 DESCRIPTION

Parse the Fedora RPM package name and get its parts separately.

=head1 METHODS

=head2 C<new>

  my $fpnp = FedoraPackage::NameParser->new;

Create a new FedoraPackage::NameParser object.

=head2 C<parse>

  $fpnp->parse($string);

Parse the first package name in the C<$string> and store the results internally. Package name components can be returned by the C<-E<gt>get($component_name)> method. If the C<$string> contains more than one package name, the first name is removed and rest of the C<$string> is stored internally and can be found by a C<-E<gt>get('rest')> method call. Returns C<1> if the package name was successfully parsed, C<0> otherwise.

=head2 C<get>

  $fpnp->get($component_name);
  $fpnp->get('rest');

Get single component of the package name or the rest of string (without the first package name already parsed).

Available component names (C<$component_name>):

=over

=item *

C<name> - Package name. Package base name string (any character to first period).

=item *

C<arch> - Package architecture (one of 'x86_64', 'i686', 'noarch').

=item *

C<num> - Package number (optional).

=item *

C<ver> - Package version number.

=item *

C<milst> - Package milestone number (release).

=item *

C<dist> - Package distribution tag (optional, 'fc' = Fedora Core + number).

=item *

C<repo> - Package resository tag (optional).

=item *

C<rest> - Rest of string (if the string contains more package names).

=back

=head2 C<fullname>

  $fpnp->fullname;

Get full package name (composed again).

=head1 NOTES

=head2 Names of Fedora RPM Packages

  <name>.<arch> <num>:<ver>-<milst>.<dist>.<repo>

=head3 Links to Source Fedora Project Wiki Pages

=over

=item *

L<Guidelines for Naming Fedora Packages - Fedora Project Wiki|https://fedoraproject.org/wiki/Packaging:Naming>

=item *

L<Guidelines for Versioning Fedora Packages - Fedora Project Wiki|https://fedoraproject.org/wiki/Packaging:Versioning>

=back

=cut

