#
#  WeekOfYear.pm
#
#  Synopsis: see POD at end of file
#
package Date::WeekOfYear;

use 5.000;
use strict;
use warnings;
use Time::Local;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	WeekOfYear
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	WeekOfYear
);
our $VERSION = sprintf("%d.%02d", q'$Revision: 1.1.1.1 $' =~ /(\d+)\.(\d+)/);


sub weekOfYear
{
	#-- Current day & time
	my ($tm_year, $wkday, $yrday) = (localtime())[5..7];

	my $startOfYear = timelocal(0, 0, 0, 1, 0, $tm_year);
	my ($soywkday) = (localtime($startOfYear))[6];

	my $wkNo = int($yrday / 7) + 1 + (($wkday < $soywkday)? 1:0);

	return wantarray ? ($wkNo, $tm_year + 1900) : $wkNo;
}


1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Date::WeekOfYear - Simple routine to return the week of the year (as well as the year)

=head1 SYNOPSIS

  use Date::WeekOfYear;

  # Get the week number (and year for the end/start of year transitions)
  my ($wkNo, $year) = WeekOfYear();

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
either week 52  or week 1.

Note there if you are after other date related functions then there are plenty
of other Date::* modules on CPAN provide the functionality of this module in
addition other ...

=head2 EXPORT

WeekOfYear.  That's it, nice and simple

=head1 KNOWN ISSUES

None, however please contact the author at gng@cpan.org should you
find any problems and I will endevour to resolve then as soon as
possible

=head1 AUTHOR

 Greg George, IT Technology Solutions P/L, Australia
 Mobile: +61-404-892-159, Email: gng@cpan.org

=head1 SEE ALSO

Date::Parse or check CPAN http://search.cpan.org/search?query=Date&mode=all

=head1 Log

 $Log: WeekOfYear.pm,v $
 Revision 1.1.1.1  2004/08/09 11:07:15  Greg
 - Initial release to CPAN


=head2 CVS ID

$Id: WeekOfYear.pm,v 1.1.1.1 2004/08/09 11:07:15 Greg Exp $

=cut
