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
  my ($name_arch, $fullversion_milestone_other) = split / /, $string;
  my ($__1, $__2, $__3, $__4, $__5, $__6);
  my $milestone_other;
  $name_arch =~ /^(.+)\.(x86_64|i686|noarch)$/;
  ($__1, $__2) = ($1, $2);
  ($__3, $milestone_other) = split /-/, $fullversion_milestone_other;
  if ($milestone_other =~ /\.fc\d+\.?/) {
    ($__4, $__6) = split /\.fc\d+\.?/, $milestone_other;
    $milestone_other =~ /\.(fc\d+)/;
    $__5 = $1;
  }
  else {
    $__4 = $milestone_other;
    $__5 = q{};
    $__6 = q{};
  }
  my $name = $__1 // return 0;
  my $arch = $__2 // return 0;
  my $version_full = $__3 // return 0;
  my $milestone = $__4 // return 0;
  my $distver = $__5 // q{};
  my $repomark = $__6 // q{};
  my $number = q{};
  my $version = $version_full;
  if ($version =~ /:/) {
    $number = (split q{:}, $version)[0];
    my $number_length = length $number . q{:};
    $version = substr $version, $number_length;
  }
  $self->{name} = $name;
  $self->{arch} = $arch;
  $self->{num} = $number;
  $self->{ver} = $version;
  $self->{milst} = $milestone;
  $self->{dist} = $distver;
  $self->{repo} = $repomark;
  $self->{rest} = q{};
  my $package_string = $name . q{.} . $arch . q{ } . $version_full . q{-} . $milestone;
  $package_string .= q{.} . $distver
    if $distver;
  $package_string .= q{.} . $repomark
    if $repomark;
  my $package_string_length = length $package_string;
  my $string_length = length $string;
  if ($string_length > $package_string_length) {
    $self->{rest} = substr $string, $package_string_length;
  }
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

