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
my $filelocation;
my %vuln2db;
my $logname;

foreach my $index (0 .. $#ARGV+1) {
     $filelocation  = $ARGV[$index];
     %vuln2db = NVD::save2db($filelocation);
     $logname = substr($filelocation,9,11); #using substring to be able to name out log file later on
     write_file "log/$logname.db", Dumper (\%vuln2db); # it would write the output of NVD::safe2db into a db file
}
#Dumpvalue->new->dumpValue(\%vuln); # it would write the output of NVD::save2db on screen








