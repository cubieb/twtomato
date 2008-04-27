#!/usr/bin/perl
#
#	uversion.pl
#	Copyright (C) 2006 Jonathan Zarate
#
#	- update the build number for Tomato
#

use POSIX qw(strftime);

sub error
{
	print "\nuversion error: $@\n";
	exit(1);
}

sub help
{
	print "Usage: uversion --bump|--gen\n";
	exit(1);
}

#
#

if ($#ARGV != 0) {
	help();
}

$path = "router/shared";
$major = 0;
$minor = 0;
$build = 0;

open(F, "$path/tomato_version") || error("opening tomato_version: $!");
$_ = <F>;
if (!(($major, $minor, $build) = /^(\d+)\.(\d+)\.(\d+)$/)) {
	error("Invalid version: '$_'");
}
close(F);


if ($ARGV[0] eq "--bump") {
	++$build;
	open(F, ">$path/tomato_version.~") || error("creating temp file: $!");
	printf F "%d.%02d.%04d", $major, $minor, $build;
	close(F);
	rename("$path/tomato_version.~", "$path/tomato_version") || error("renaming: $!");
	exit(0);
}

if ($ARGV[0] ne "--gen") {
	help();
}

$time = strftime("%Y/%m/%d %H:%M %A", localtime());
$minor = sprintf("%02d", $minor);
$build = sprintf("%04d", $build);

open(F, ">$path/tomato_version.h~") || error("creating temp file: $!");
print F <<"END";
#ifndef __TOMATO_VERSION_H__
#define __TOMATO_VERSION_H__
#define TOMATO_MAJOR		"$major"
#define TOMATO_MINOR		"$minor"
#define TOMATO_BUILD		"$build"
#define	TOMATO_BUILDTIME	"$time"
#define TOMATO_VERSION		"$major.$minor.$build"
#endif
END
close(F);
rename("$path/tomato_version.h~", "$path/tomato_version.h") || error("renaming: $!");

print "Version: $major.$minor.$build ($time)\n";
exit(0);
