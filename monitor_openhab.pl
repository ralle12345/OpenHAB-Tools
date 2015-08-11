#!/usr/bin/perl
 
use strict;

my $commandline;
my @output;
my $file;
my $line;
my $directory;

# Devel
# $commandline = "cat /root/openhab-2015-08-02.log | egrep 'DefaultResourceDescription|ModelRepositoryImpl.*empty' | egrep 'ERROR|WARN'";
# Produktion
$commandline = "logtail /var/log/openhab/openhab*.log | egrep 'DefaultResourceDescription|ModelRepositoryImpl.*empty' | egrep 'ERROR|WARN'";


@output = `$commandline`;

# 2015-08-02 09:26:03.614 WARN  o.o.m.c.i.ModelRepositoryImpl[:58]- Configuration model 'temp_humidity.rules' is either empty or cannot be parsed correctly!
# 2015-08-02 09:27:55.986 ERROR o.e.x.r.i.DefaultResourceDescription[:75]- test2.sitemap (No such file or directory)
# 	at org.eclipse.xtext.resource.impl.DefaultResourceDescription.computeExportedObjects(DefaultResourceDescription.java:73)

foreach (@output)
{
	if (/ModelRepositoryImpl/)
	{
			$line = $_;
   			$line =~ m/.*model \'(.*)\' is either.*/;
   			$file = $1;
#   			print "$file\n";
	}
	if (/DefaultResourceDescription/)
	{
			$line = $_;
   			$line =~ m/.*DefaultResourceDescription\[:\d+\]- (.*) \(.*/;
   			$file = $1;
#   			print "$file\n";
	}
	
	$file =~ m/.*\.(.*)/;
	$directory = $1;
	
	# sitemap -> sitemaps
	# persist -> persistence
	
	$directory =~ s/sitemap/sitemaps/;
	$directory =~ s/persist/persistence/;
	
	system("touch /etc/openhab/configurations/$directory/$file\n");
	 
} 

