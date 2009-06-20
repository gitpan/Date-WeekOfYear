
use strict;
use warnings;

use Test::More;
plan tests => 8;

use Date::WeekOfYear;
use Time::Local;

ok(1);
my $time = timelocal(0,0,12,1,0,108);
is(WeekOfYear($time),1);

$time = timelocal(0,0,12,5,0,108); #Saturday
is(WeekOfYear($time),1);

$time = timelocal(0,0,12,29,0,108);
is(WeekOfYear($time),5);

$time = timelocal(0,0,12,1,1,108);
is(WeekOfYear($time),5);

$time = timelocal(0,0,12,1,0,116);
is(WeekOfYear($time),1);

$time = timelocal(0,0,12,2,0,116);
is(WeekOfYear($time),1);

$time = timelocal(0,0,12,6,0,116);
is(WeekOfYear($time),2);
