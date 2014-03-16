#
#  WeekOfYear.pm
#
#  Synopsis: see POD at end of file
#
package Date::WeekOfYear;

use strict;
use warnings;
use Time::Local;

our $VERSION = '1.05';

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw( WeekOfYear ) ] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw( WeekOfYear );

# Weekday constants
use constant {
    SUNDAY    => 0,
    MONDAY    => 1,
    TUESDAy   => 2,
    WEDNESDAY => 3,
    THURSDAY  => 4,
    FRIDAY    => 5,
    SATURDAY  => 6,
    };

sub WeekOfYear
{
    my ($time, $compat) = @_;

    # Set to the current time if nothing provided
    $time = time unless (defined($time) && $time =~ /^\s*\d+\s*$/);

    # wkday is the day of the week, 0=Sunday, 1=Monday.. 4=Thursday
    my ($tm_day, $tm_mth, $tm_year, $wkday, $yrday) = (localtime($time))[3..7];

    # 1 Jan of the year in question
    my $startOfYear = timelocal(0, 0, 0, 1, 0, $tm_year);

    # What is the week day for 1 Jan of the week in question
    my ($soywkday)  = (localtime($startOfYear))[6];
    my $wkNo;

    if ($compat)
    {
        # Pre version 1.4 functionality
        $wkNo = int($yrday / 7) + 1 + (($wkday < $soywkday)? 1:0);
    }
    else
    {
        # Version 1.5 and beyound ISO 8601 based week number
        # Week 1 is the first week of the year containing a Thursday
        # Is the first day of the week Friday or greater, if so this must be week 2
        my $offset = ($soywkday > THURSDAY) ? 1 : 0;

        # Note, yrday starts at 0, ie 1 Jan has yrday = 0
        if ($offset)
        {
            # 1 Jan is in week 53 of the previous year
            $wkNo = 53 + int(($yrday + $soywkday - 1)/ 7);
        }
        else
        {
            $wkNo = 1 + int(($yrday + $soywkday - 1)/ 7);
        }

        if ($wkNo == 53)
        {
            if ($tm_mth == 11 && $wkday < THURSDAY && $wkday > 0 && $tm_day >= 29)
            {
                $wkNo = 1;
                $tm_year++;
            }
            elsif ($offset && $tm_mth == 0 && (($soywkday == SUNDAY && $yrday < 1) || ($soywkday == SATURDAY && $yrday < 2) || ($soywkday == FRIDAY && $yrday < 3)))
            {
                $tm_year--;
            }
        }

        $wkNo -= 53 if ($wkNo >  53);
    }

    return wantarray ? ($wkNo, $tm_year + 1900) : $wkNo;
}


1;
__END__

=head1 NAME

Date::WeekOfYear - Simple routine to return the ISO 8601 week of the year (as well as the ISO week year)

=head1 SYNOPSIS

  use Date::WeekOfYear;

  # Get the week number (and year for the end/start of year transitions)
  my ($wkNo, $year) = WeekOfYear();

  # Get the week number for the time passed in time_stamp
  my ($wkNo, $year) = WeekOfYear($time_stamp);

  # Use the data for someThing ...
  my $logFile = "/someDir/$year/someApp_$wkNo.log"

  # Only want the week number, don't care which year in the week around
  # the end/start of the year !
  my $weekNo = WeekOfYear();


=head1 DESCRIPTION

Date::WeekOfYear is small and efficient.  The only purpose is to return the
week of the year.  This can be called in either a scalar or list context.

In a scalar context, just the week number is returned (the year starts at week 1).

In a list context, both the week number and the year (YYYY) are returned.  This
ensures that you know which year the week number relates too.  This is only an
issue in the week where the year changes (ie depending on the day you can be in
either week 52, week 53 or week 1.

B<NOTE> The year returned is not always the same as the Gregorian year for that day
for further details see ISO 8601.

=head1 CHANGES

As of version 1.5 the ISO 8601 week number is calculated.  For backwards compatibility
a flag can be passed after the time to give the previous functionality.

For example:

  my $weekNo = WeekOfYear(undef, 1);  # Week number now in pre ISO 8601 mode
  or
  my $weekNo = WeekOfYear($the_time, 1);  # Week number for $the_time in pre ISO 8601 mode


=head1 ISO 8601

Weeks in a Gregorian calendar year can be numbered for each year. This style of
numbering is commonly used (for example, by schools and businesses) in some European
and Asian countries, but rare elsewhere.

ISO 8601 includes the ISO week date system, a numbering system for weeks - each week
begins on a Monday and is associated with the year that contains that week's Thursday
(so that if a year starts in a long weekend Friday-Sunday, week number one of the year
will start after that). For example, week 1 of 2004 (2004W01) ran from Monday 29
December 2003 to Sunday, 4 January 2004, because its Thursday was 1 January 2004,
whereas week 1 of 2005 (2005W01) ran from Monday 3 January 2005 to Sunday 9 January
2005, because its Thursday was 6 January 2005 and so the first Thursday of 2005. The
highest week number in a year is either 52 or 53 (it was 53 in the year 2004).

An ISO week-numbering year (also called ISO year informally) has 52 or 53 full weeks.
That is 364 or 371 days instead of the usual 365 or 366 days.  The extra week is
referred to here as a leap week, although ISO 8601 does not use this term.  Weeks start
with Monday. The first week of a year is the week that contains the first Thursday
(and, hence, 4 January) of the year. ISO week year numbering therefore slightly
deviates from the Gregorian for some days close to 1 January.

=head1 EXPORT

=head2 WeekOfYear

WeekOfYear.  That's it, nice and simple

=head1 KNOWN ISSUES

B<Versions prior to 1.5 did not follow ISO 8601.>

None, however please contact the author at gng@cpan.org should you
find any problems and I will endevour to resolve then as soon as
possible.

=head1 AUTHOR

 Greg George, IT Technology Solutions P/L, Australia
 Mobile: +61-404-892-159, Email: gng@cpan.org

=head1 SEE ALSO

Date::Parse or check CPAN http://search.cpan.org/search?query=Date&mode=all

=head1 ACKNOWLEDGEMENTS

Thanks to Alexandr Ciornii for the V1.3 updates
Thanks to Niel Bowers for [rt.cpan.org #93599] Not clear what type of week number is returned

=head1 Log

Revision 1.5  2014/03/16 Greg
 - Updated to conform to ISO 8601
 - Added compatability flag to allow backwards usage

Revision 1.4  2009/06/21 07:29:05  Greg
- Added ACKNOWLEDGEMENTS

Revision 1.3  2009/06/20 09:31:39  Greg
- Real tests with Test::More
- Tests moved to t/
- Better Makefile.PL
- Now WeekOfYear can take an argument (unixtime)

Revision 1.2  2006/06/11 02:28:55  Greg
- Correction to name of function

Revision 1.1.1.1  2004/08/09 11:07:15  Greg
- Initial release to CPAN


=head2 CVS ID

$Id: WeekOfYear.pm,v 1.4 2009/06/21 07:29:05 Greg Exp $

=cut
