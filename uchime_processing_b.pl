#!/usr/bin/perl -w
use strict;

if($#ARGV ne 1)
{
 print "perl $0 <number> <tag.list>
        number£º\tdivide the tag.list file into n parts
        tag.list:\tlist the path of the files you need to detect chimera\n";
exit;
}

open I, "$ARGV[1]" || die "can not open file I :$!";

`/root/bin/dechimera/split_file.pl  $ARGV[0] $ARGV[1]`;
for my $i(1..$ARGV[0])
{
 my $file = "$ARGV[1]_$i";
 `nohup /root/bin/dechimera/uchime_batch_processing.pl $file >>$ARGV[1].log 2>&1 &`;
}

##for my $j(0..$ARGV[0]-1)
##{
 ##my $del = "$ARGV[1]\_$j";
 ##unlink $del;
##}

close I;
