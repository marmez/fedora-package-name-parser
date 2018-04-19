#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Test::More;

use lib 'lib';

my @modules = (
  # Just to be sure
  'lib/*.pm',
  # FedoraPackage::NameParser
  'lib/*/*.pm',
);

foreach my $module (map {
  s|^lib/||;
  s|/|::|g;
  s|\.pm$||;
  $_;
} glob "@modules") {
  BAIL_OUT("Bail out! Can't load module: '$module' does not compile")
    unless require_ok($module);
}

done_testing;

