package FedoraPackage::NameParser;

use strict;
use warnings;
use diagnostics;

sub new {
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
=comment
  $string =~ m/
    ([^\.]+) # Package base name string (any character to first period)
    \. # Period (not needed)
    (\w+) # Package architecture string (x86_64, i686, noarch)
    \s # One space (not needed)
    ([^\-]+) # Package full version string (including number but without milestone number)
    - # Dash (not needed)
    ([^\.]+) # Package milestone number - release
    (?: # Optionally
      \. # Period (not needed)
      (fc\d+) # Package distribution version string (fc = Fedora Core + number)
    )?
    (?: # Optionally
      \. # Period (not needed)
      (\w+) # Package repository mark
    )?
  /x;
=cut
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
  $self->{number} = $number;
  $self->{version} = $version;
  $self->{milestone} = $milestone;
  $self->{distver} = $distver;
  $self->{repomark} = $repomark;
  $self->{restofstr} = q{};
  my $package_string = $name . q{.} . $arch . q{ } . $version_full . q{-} . $milestone;
  $package_string .= q{.} . $distver
    if $distver;
  $package_string .= q{.} . $repomark
    if $repomark;
  my $package_string_length = length $package_string;
  my $string_length = length $string;
  if ($string_length > $package_string_length) {
    $self->{restofstr} = substr $string, $package_string_length;
  }
  return 1;
}

sub get_name {
  return shift->{name};
}

sub get_arch {
  return shift->{arch};
}

sub get_number {
  return shift->{number};
}

sub get_version {
  return shift->{version};
}

sub get_milestone {
  return shift->{milestone};
}

sub get_distver {
  return shift->{distver};
}

sub get_repomark {
  return shift->{repomark};
}

sub get_fullpackname {
  my $self = shift;
  my $fullpackname = $self->{name} . q{.} . $self->{arch} . q{ };
  $fullpackname .= $self->{number} . q{:}
    if $self->{number};
  $fullpackname .= $self->{version} . q{-} . $self->{milestone};
  $fullpackname .= q{.} . $self->{distver}
    if $self->{distver};
  $fullpackname .= q{.} . $self->{repomark}
    if $self->{repomark};
  return $fullpackname;
}

sub get_restofstr {
  return shift->{restofstr};
}

1;

