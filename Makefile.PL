use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Date::WeekOfYear',
    'VERSION_FROM'	=> 'WeekOfYear.pm', # finds $VERSION
    'PREREQ_PM'		=> {Time::Local}, # e.g., Module::Name => 1.1
    ($] >= 5.000 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'WeekOfYear.pm', # retrieve abstract from module
       AUTHOR     => 'Greg George, IT Technology Solutions P/L, Australia, gng@cpan.org') : ()),
);
