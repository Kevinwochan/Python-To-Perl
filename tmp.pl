#!/usr/bin/perl -w
use strict;

foreach my $line (<>){
	$line =~ m/^(\s+)/;
	my $spaces += () = $1 =~  m/\s/g;
	print "$spaces\n";
}
