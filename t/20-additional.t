#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Test::More;

use lib 'lib';
use FedoraPackage::NameParser;

my $fpnp = FedoraPackage::NameParser->new;

$fpnp->parse('package-name.noarch 1234:1.20.40.60-1.1.fc28');

my @parts = $fpnp->get('name', 'dist', 'arch', 'milst', 'ver', 'num');

is_deeply(\@parts, [
  # Package name (name)
  'package-name',
  # Package distribution tag (dist)
  'fc28',
  # Package architecture tag (arch)
  'noarch',
  # Package milestone number (milst)
  '1.1',
  # Package version (ver)
  '1.20.40.60',
  # Package number (num)
  '1234',
], 'All values returned by ->get() method in an array');

my $arch = $fpnp->get('arch', 'dist', 'name');

is($arch, 'noarch', 'First value returned by ->get() method in a scalar');

done_testing;

