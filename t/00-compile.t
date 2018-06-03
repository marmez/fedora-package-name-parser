#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Test::More;

use lib 'lib';

my @modules = (
  # Just to be sure
  # Yep, this is too sophisticated for one module name
  'lib/*.pm',
  # FedoraPackage::NameParser
  'lib/*/*.pm',
);

foreach my $module (map {
  # Get rid of superfluous parts of the path
  s|^lib/||;
  s|/|::|g;
  s|\.pm$||;
  $_;
} glob "@modules") {
  BAIL_OUT("Bail out! Can't load module: '$module' does not compile")
    unless require_ok($module);
}

done_testing;

