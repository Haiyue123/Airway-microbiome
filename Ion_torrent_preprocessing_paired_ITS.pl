#This script does
#!/usr/bin/perl -w
use strict;

die "perl $0 <\$PWD/fastq> <\$PWD/primer.txt> <\$PWD/output_dir>\nThis is for 18s sequences." unless @ARGV==3;

#read in the metadata
open MAP,$ARGV[1] or die;

#find out the location of the input file
my @filepath=split(/\//,$ARGV[0]);
my $fastq_name=pop @filepath;
my $input_dir=join("/",@filepath);

#create output dir to store the processed files
my @out_dir=split(/\//,$ARGV[2]);
mkdir $ARGV[2];
#process metadata and find the barcode locus
my $metadata_head=<MAP>;
chomp $metadata_head;

my @metadata_head=split(/\t/,$metadata_head);
my $forward_barcode_locu=0;
my $reverse_barcode_locu=0;

foreach (0..$#metadata_head)
{
	$forward_barcode_locu=$_ if $metadata_head[$_] eq "Forward_Barcode";
	$reverse_barcode_locu=$_ if $metadata_head[$_] eq "Reverse_Barcode";

}

#Ensure all the information we need is stored in the metadata with the right column names
my $error=0;
if ($forward_barcode_locu == 0)
{
	print "Cannot find \"Forward_Barcode\" in metadata head\n";	
	$error=1;
}

if ($reverse_barcode_locu == 0)
{
        print "Cannot find \"Reverse_Barcode\" in metadata head\n";     
        $error=1;
}

if ($error ==1)
{
	print "Program terminated because of incomplete or incorrect metadata\n";
	exit(1);
}


#go through the metadata and extract each sample
my %seq_num; #document the number of sequences for each sample

while (<MAP>)
{
	chomp;
	next if $_ eq "";
	my @line=split(/\t/);
	
	#get the information of this sample 
	my $forward_barcode=$line[$forward_barcode_locu];
	#my $forward_primer=$line[];
	my $reverse_barcode=$line[$reverse_barcode_locu];
	$reverse_barcode="" if $reverse_barcode eq "NA";
	#my $forward_primer=$line[];
	

	mkdir "$out_dir[-1]/$line[0]" unless -e "$out_dir[-1]/$line[0]";
	
	#create output fasta file and metadata for this sample and the metadata for this individual
	open OUT,">$out_dir[-1]/$line[0]/$line[0].clean.fa";
	
=pod
	#output the metadata for the package of this individual
	unless (-e "$input_dir/processed_sequences/$id.$package.$check_period[0]-$check_period[-1]/$id.$package.$check_period[0]-$check_period[-1]/$id.$package.$check_period[0]-$check_period[-1].metadata.txt")
	{
		open OUT_MAP_INDIVIDUAL,">$input_dir/processed_sequences/$id.$package.$check_period[0]-$check_period[-1]/$id.$package.$check_period[0]-$check_period[-1]/$id.$package.$check_period[0]-$check_period[-1].metadata.txt";
		print OUT_MAP_INDIVIDUAL $metadata_head,"\n",$_,"\n";
		close OUT_MAP_INDIVIDUAL;
	}else{
		open OUT_MAP_INDIVIDUAL,">>$input_dir/processed_sequences/$id.$package.$check_period[0]-$check_period[-1]/$id.$package.$check_period[0]-$check_period[-1]/$id.$package.$check_period[0]-$check_period[-1].metadata.txt";		
		print OUT_MAP_INDIVIDUAL $_,"\n";
		close OUT_MAP_INDIVIDUAL;
	}
=cut

	#output the metadata for this sample
	
	#screen the raw fastq file to extract the target sequences
	open FASTA,$ARGV[0] or die "The raw fastq file cannot be found\n";
	
	#prepare the barcode and primer file, the primer file should be determined from the metadata, but here I simply it as V4
	my $forward_primer="CTTGGTCATTTAGAGGAAGTAA";
	my $reverse_primer="GCTGCGTTCTTCATCGATGC";
	$reverse_barcode=~tr/ATGC/TACG/;
	$reverse_barcode=reverse $reverse_barcode;
	$reverse_primer=~tr/ATGC/TACG/;
	$reverse_primer=reverse $reverse_primer;
	my $n=1;#integers to distringuish sequences from the same sample
	while (<FASTA>)
	{
		my $seq=<FASTA>;
		<FASTA>;<FASTA>;
		my $target="";
		#I need a section to document the number of sequences during processing, for example, how many short sequences, how many ....
		
		#I need a section to document the number of sequences
		if ($seq=~/$forward_barcode$forward_primer(.*)$reverse_primer$reverse_barcode/)
		{
			$seq_num{"Total"}++;
			$seq_num{$line[0]}++;
			$target=$1;
		}
		print OUT ">",$line[0],"_",$n,"\n$target\n" if $target ne "" and length($target) > 200;
		$n++ if $target ne "";
	}
	$seq_num{$line[0]} =0 unless $seq_num{$line[0]};
	close FASTA;
	close OUT;
}

#output depth for each sample and total
open OUT,">$out_dir[-1]/$out_dir[-1].depth.txt";
print OUT "SampleID\tDepth\n";
foreach my $keys(sort {$seq_num{$a} <=> $seq_num{$b}} keys %seq_num)
{
	print OUT $keys,"\t",$seq_num{$keys},"\n";
}
close OUT;
close MAP;

