#!/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use Test::More;

use lib 'lib';

BEGIN {
  use_ok('FedoraPackage::NameParser');
}

can_ok('FedoraPackage::NameParser', qw(
  new
  parse
  get_name
  get_arch
  get_number
  get_version
  get_milestone
  get_distver
  get_repomark
  get_fullpackname
  get_restofstr
));

my $fpnp = new_ok('FedoraPackage::NameParser');

my %package_names_strings = (
  # String containing package name:
    # 0 - package name,
    # 1 - package architecture,
    # 2 - undef (empty string) or number,
    # 3 - package version,
    # 4 - package milestone,
    # 5 - package distribution version,
    # 6 - undef (empty string) or additional repository mark,
    # 7 - package full name (composed)
    # 8 - undef (empty string) or rest of string (without first package name)
  # Alphabetically sorted hash keys - package names:
  'chromium-libs-media-freeworld.x86_64 59.0.3071.104-1.fc25' => [
    q{chromium-libs-media-freeworld},
    q{x86_64},
    q{},
    q{59.0.3071.104},
    q{1},
    q{fc25},
    q{},
    q{chromium-libs-media-freeworld.x86_64 59.0.3071.104-1.fc25},
    q{},
  ],
  'firefox.x86_64 56.0-4.fc26 updates' => [
    q{firefox},
    q{x86_64},
    q{},
    q{56.0},
    q{4},
    q{fc26},
    q{},
    q{firefox.x86_64 56.0-4.fc26},
    qq{ updates},
  ],
  'flash-plugin.x86_64 27.0.0.170-release' => [
    q{flash-plugin},
    q{x86_64},
    q{},
    q{27.0.0.170},
    q{release},
    q{},
    q{},
    q{flash-plugin.x86_64 27.0.0.170-release},
    q{},
  ],
  'google-chrome-beta.x86_64 62.0.3202.45-1' => [
    q{google-chrome-beta},
    q{x86_64},
    q{},
    q{62.0.3202.45},
    q{1},
    q{},
    q{},
    q{google-chrome-beta.x86_64 62.0.3202.45-1},
    q{},
  ],
  'java-1.8.0-openjdk-headless.x86_64 1:1.8.0.144-7.b01.fc25' => [
    q{java-1.8.0-openjdk-headless},
    q{x86_64},
    q{1},
    q{1.8.0.144},
    q{7.b01},
    q{fc25},
    q{},
    q{java-1.8.0-openjdk-headless.x86_64 1:1.8.0.144-7.b01.fc25},
    q{},
  ],
  'kernel-core.x86_64 4.11.9-200.fc25' => [
    q{kernel-core},
    q{x86_64},
    q{},
    q{4.11.9},
    q{200},
    q{fc25},
    q{},
    q{kernel-core.x86_64 4.11.9-200.fc25},
    q{},
  ],
  'kernel-modules.x86_64 4.11.9-200.fc25' => [
    q{kernel-modules},
    q{x86_64},
    q{},
    q{4.11.9},
    q{200},
    q{fc25},
    q{},
    q{kernel-modules.x86_64 4.11.9-200.fc25},
    q{},
  ],
  'kernel-modules.x86_64 4.13.4-200.fc26 openni.x86_64 1.5.7.10-9.fc26' => [
    q{kernel-modules},
    q{x86_64},
    q{},
    q{4.13.4},
    q{200},
    q{fc26},
    q{},
    q{kernel-modules.x86_64 4.13.4-200.fc26},
    q{ openni.x86_64 1.5.7.10-9.fc26},
  ],
  'kernel.x86_64 4.11.9-200.fc25' => [
    q{kernel},
    q{x86_64},
    q{},
    q{4.11.9},
    q{200},
    q{fc25},
    q{},
    q{kernel.x86_64 4.11.9-200.fc25},
    q{},
  ],
  'nss.x86_64 3.33.0-1.0.fc25' => [
    q{nss},
    q{x86_64},
    q{},
    q{3.33.0},
    q{1.0},
    q{fc25},
    q{},
    q{nss.x86_64 3.33.0-1.0.fc25},
    q{},
  ],
  'opera-stable.x86_64 5:46.0.2597.26-1.fc25.R russianfedora-nonfree-updates' => [
    q{opera-stable},
    q{x86_64},
    q{5},
    q{46.0.2597.26},
    q{1},
    q{fc25},
    q{R},
    q{opera-stable.x86_64 5:46.0.2597.26-1.fc25.R},
    q{ russianfedora-nonfree-updates},
  ],
  'tbb.x86_64 2017.7-1.fc25' => [
    q{tbb},
    q{x86_64},
    q{},
    q{2017.7},
    q{1},
    q{fc25},
    q{},
    q{tbb.x86_64 2017.7-1.fc25},
    q{},
  ],
);

foreach my $package_name_string (sort keys %package_names_strings) {
  subtest("Parse '$package_name_string'" => sub {
    cmp_ok($fpnp->parse($package_name_string), '==', 1, '->parse() ok');
    is(
      $fpnp->get_name(),
      $package_names_strings{$package_name_string}->[0],
      'Package name'
    );
    is(
      $fpnp->get_arch(),
      $package_names_strings{$package_name_string}->[1],
      'Package architecture'
    );
    is(
      $fpnp->get_number(),
      $package_names_strings{$package_name_string}->[2],
      'Number'
    );
    is(
      $fpnp->get_version(),
      $package_names_strings{$package_name_string}->[3],
      'Package version'
    );
    is(
      $fpnp->get_milestone(),
      $package_names_strings{$package_name_string}->[4],
      'Package milestone'
    );
    is(
      $fpnp->get_distver(),
      $package_names_strings{$package_name_string}->[5],
      'Package distribution version'
    );
    is(
      $fpnp->get_repomark(),
      $package_names_strings{$package_name_string}->[6],
      'Additional repository mark'
    );
    is(
      $fpnp->get_fullpackname(),
      $package_names_strings{$package_name_string}->[7],
      'Package full name (composed)'
    );
    is(
      $fpnp->get_restofstr(),
      $package_names_strings{$package_name_string}->[8],
      'Rest of string (without first package name)'
    );
  });
}

done_testing;

