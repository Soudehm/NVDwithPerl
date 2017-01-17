#! /usr/bin/perl -w
#
#  Extract vulnerability records detailed in NIST NVD XML files. Save the
#  records into a database.
#  This code has been modified by Soudeh Mousavi on March 29 2016
#  soudeh.mousavi@me.com

use strict;
use warnings;
use File::Slurp;

use XML::LibXML;

use FindBin;
use lib qq($FindBin::Bin/../lib);

use NVD;
use Dumpvalue;
use Data::Dumper;





if (@ARGV == 0) {
    die "Extract NVD vulnerability records into a SQLite database file\n",
        "Usage:\n    $0 <NVD_XML_files>\n\n";
}


my $index=0;

foreach  $index (0 .. $#ARGV+1) {
    my $filelocation; 
    # if (-e $ARGV[$index] and -s $ARGV[$index]){
     		   	 		
     	 	$filelocation  = $ARGV[$index];
     		my %vuln = NVD::extract($filelocation);
     		my $logname = substr($filelocation,9,11); #using substring to be able to name out log file later on
     
     		write_file "log/$logname.log", Dumper (\%vuln); # writes the output of NVD::extract into a log file
			# my %entry = NVD::save2db(\%vuln);
			
	#}
}
#print "Please check the directory or your file name for '$ARGV[$index]' \n it is empty \n";

#Dumpvalue->new->dumpValue(\%vuln); # wites the output of NVD::extract on screen








