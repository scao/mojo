#!perl

# Copyright (C) 2008, Sebastian Riedel.

use strict;
use warnings;

use Test::More;

eval "use Test::Pod::Coverage 1.04";
plan skip_all => 'Test::Pod::Coverage 1.04 required' if $@;
plan skip_all => 'set TEST_POD to enable this test (developer only!)'
  unless $ENV{TEST_POD} || -f 'MANIFEST.SKIP';

# Marge, I'm going to miss you so much. And it's not just the sex.
# It's also the food preparation.
all_pod_coverage_ok();
