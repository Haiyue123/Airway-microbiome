#!/usr/bin/perl -w
use strict;
if ($#ARGV ne 1)
{
 print "perl $0 <newname.fa.list> <output directory>
        please list the absolute path of newname.fa flies into newname.fa.list file         \n";
 exit;
}

open I,"$ARGV[0]" || die "can not open I:$!";
`mkdir $ARGV[1]`;
while(<I>)
{
 chomp; 
 my $rawfa = $_;
 my @dir = split/\//;
 my $test = "$ARGV[1]\/$dir[-3]";
 if (! -e $test)
 {
 `mkdir $test`;
 }
 `mkdir $ARGV[1]/$dir[-3]/$dir[-2]`;
 my @file = split/\./;
 pop @file;
 my $prefix = join ".",@file;
 my $unqfa = "$prefix.ranked.unique.fa";
 my $unqna = "$prefix.ranked.unique.names";
 my $uchout = "$prefix.ranked.unique.fa.out";
 my $out = "$ARGV[1]\/$dir[-3]\/$dir[-2]\/$dir[-2].nochimera.fa";
 ##print "$rawfa\n$uchout\n$out\n";die;
 open II,"$unqfa" ||die "can not open II:$!";
 open III,"$uchout"|| die "can not open III:$!";
 open IV,"$unqna" || die "can not open IV:$!";
 open OUT,">$out" || die "can not open OUT:$!";
 my %chimera;
 while (<III>)
 {
  chomp;
  my @item = split/\s+/;
  my $result = "Y";
  if ($item[-1] eq $result)
  {
   my @na1 = split/\//,$item[1];
   $chimera{$na1[0]} = 1; 
  }
 }
 
 my %fasta;
 while(<II>)
 {
  chomp;
  if(/^>/)
  {
   my $name = substr$_,1;
   my @tnames = split/\//,$name;
   my $seq = <II>;
   $fasta{$tnames[0]} = $seq;
  }
 } 
 
 while(<IV>)
 {
  chomp;
  my @otun = split/\s+/;
  if(!exists $chimera{$otun[0]})
   {
    my @temp = split/\,/,$otun[1];
    for my $j(@temp)
    {
     if (exists $fasta{$otun[0]})
    {
     print OUT ">$j\n$fasta{$otun[0]}";
    }
    }
   }
  }
 %chimera=();
 %fasta=();
 }


