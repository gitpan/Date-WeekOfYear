
use strict;
use warnings;

use Test::More;
plan tests => 33;

use Date::WeekOfYear;
use Time::Local;

ok(1, 'Date::WeekOfYear compiled, a good start');
##2
#my $time = timelocal(0,0,12,1,0,108);
#is(WeekOfYear($time),1);
#
##3
#$time = timelocal(0,0,12,5,0,108); #Saturday
#is(WeekOfYear($time),1);
#
##4
#$time = timelocal(0,0,12,29,0,108);
#is(WeekOfYear($time),5);
#
##5
#$time = timelocal(0,0,12,1,1,108);
#is(WeekOfYear($time),5);
#
##6
#$time = timelocal(0,0,12,1,0,116);
#is(WeekOfYear($time),1);
#
##7
#$time = timelocal(0,0,12,2,0,116);
#is(WeekOfYear($time),1);
#
##8
#$time = timelocal(0,0,12,6,0,116);
#is(WeekOfYear($time),2);
#
##9,10
## 2005-01-01    2004-W53-6
#$time = timelocal(0,0,12,6,0,2005-1900);
#my ($wk_num, $year) = WeekOfYear($time);
#is($wk_num, 53);
#is($year, 2004);

my @tests = (
    # Date,            YYYY-MM-DD,   ISO Wk YYYY-WkNo-Day, Comment
    ['Sat 1 Jan 2005',  '2005-01-01', '2004-W53-6', '',],
    ['Sun 2 Jan 2005',  '2005-01-02', '2004-W53-7', '',],
    ['Sat 31 Dec 2005', '2005-12-31', '2005-W52-6', '',],
    ['Mon 1 Jan 2007',  '2007-01-01', '2007-W01-1', 'Both years 2007 start with the same day.',],
    ['Sun 30 Dec 2007', '2007-12-30', '2007-W52-7', '',],
    ['Mon 31 Dec 2007', '2007-12-31', '2008-W01-1', '',],
    ['Tue 1 Jan 2008',  '2008-01-01', '2008-W01-2', 'Gregorian year 2008 is a leap year, ISO year 2008 is 2 days shorter: 1 day longer at the start, 3 days shorter at the end.',],
    ['Sun 28 Dec 2008', '2008-12-28', '2008-W52-7', 'The ISO year 2009 is 3 days into the previous Gregorian year.',],
    ['Mon 29 Dec 2008', '2008-12-29', '2009-W01-1', '',],
    ['Tue 30 Dec 2008', '2008-12-30', '2009-W01-2', '',],
    ['Wed 31 Dec 2008', '2008-12-31', '2009-W01-3', '',],
    ['Thu 1 Jan 2009',  '2009-01-01', '2009-W01-4', '',],
    ['Thu 31 Dec 2009', '2009-12-31', '2009-W53-4', 'ISO year 2009 has 53 weeks, thus it is 3 days into the Gregorian year 2010.',],
    ['Fri 1 Jan 2010',  '2010-01-01', '2009-W53-5', '',],
    ['Sat 2 Jan 2010',  '2010-01-02', '2009-W53-6', '',],
    ['Sun 3 Jan 2010',  '2010-01-03', '2009-W53-7', '',],
    );

# Run through the test cases
foreach my $t (@tests)
{
    my $comment = $t->[0];
    $comment .= ' - ' . $t->[2] if $t->[2];
    $comment .= ' - ' . $t->[3] if $t->[3];

    # Generate the time value. Use midday so we don't run into any daylight saving time issues
    #$time = timelocal($sec,$min,$hour,$mday,$mon,$year);
    my ($year, $mon, $mday) = split /-/, $t->[1];
    my $time = timelocal(0, 0, 12, $mday, $mon - 1, $year - 1900);

    # Get the required answer
    my ($wk_num_year_answer, $wk_num_answer, $day_answer) = split /-/, $t->[2];
    $wk_num_answer =~ s/W0*//;

    # Run the test
    my ($wk_num, $wk_num_year) = WeekOfYear($time);

    # Check the results for week number and year
    #diag($t->[0] . ' --> ' . scalar(localtime($time)));
    is ($wk_num, $wk_num_answer, 'Wk Num test - ' . $comment);
    is ($wk_num_year, $wk_num_year_answer, 'Year test - ' . $comment);
}