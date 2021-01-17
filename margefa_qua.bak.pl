#!usr/bin/perl -w 
use strict;
use Getopt::Long;
use PerlIO::gzip;
my $usage = " -i <input.fa> -q <input.quality> -o <output.file>";
my ($in,$qu,$out);
GetOptions (
	'i=s'=>\$in,
	'q=s'=>\$qu,
	'o=s'=>\$out,
);
die $usage if (!$in|!$qu|!$out);
if ($in=~/.gz/){open IN,"<:gzip","$in" or die "$!";}else{open IN,"<$in" or die "$!";}
$/=">";
if ($qu=~/.gz/){open INT,"<:gzip","$qu" or die "$!";}else{open INT,"<$qu" or die "$!";}
$/=">";
<IN>;
<INT>;
open OUT,">$out" or die "$!";
while (<IN>){
	chomp;
	my $qua= <INT>;
	chomp $qua;
	my $quality=(split /\s+/,$qua)[-1];
#	print $quality,"\n";
	print OUT "$_"."+\n$quality\n";
}
close IN;
close INT;
close OUT;
