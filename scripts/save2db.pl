#! /usr/bin/perl -w
#This file is not written by Soudeh Mousavi
package NVD;

use strict;
use warnings;

use DBI;
use DBD::SQLite;
use Dumpvalue;
use Data::Dumper;


my $driver 	="SQLite";
my $dbfile  = "db/test5.db";

my $dsn     = "dbi:$driver:dbname=$dbfile";
my $user    = "";
my $password= "";



my $dbh = DBI->connect($dsn, $user, $password , {'AutoCommit' => 0 })
						or die $DBI::errstr;

 my $cve_id = "cve_id";  
 my $severity = "severity";
 my $published = "published";
 my $modified = "modified";

 my $table = $dbh -> prepare ('CREATE TABLE IF NOT EXISTS nvdtable (
	cve_id      VARHCAR (100) UNIQUE NOT NULL,
    severity    text,
    published   VARCHAR (100),
    modified    VARCHAR (100)
    )');
$table->execute() or die $table->errstr;
 

 
 my $textfile = "log/nvdcve-2011.log";
 open (INPUT, "$textfile") or die "Could not open:$!\n";
 
 my @line = <INPUT>;

 for (@line) {
 	if ($_=~ /$cve_id/){
 	print "$_";
 	my $sql = 'INSERT INTO nvdtable (cve_id) VALUES (?)';
	my $sth= $dbh -> prepare($sql);
	$sth->execute($_) ;
 	}
 		if ($_=~ /$severity/){
 		print "$_";
 	}
 			if ($_=~/$published/){
 			print "$_";
 	}
 				if ($_=~/$published/){
 				print "$_";
 	}
 					if ($_=~ /$modified/ ){
 						print "$_";
 	}
 					
 		#while (<INPUT>) {
		#for my $chunk (split/\n/){
		#$chunk =~/RegExp to extract data from string/;
		#my $cve_id 		= $1;
		#my $severity	= $2;
		#my $published	= $3;
		#my $modified 	= $4;
		# send them to DB
		#$table->execute($cve_id,$severity,$published,$modified) or die $table->errstr;
		
 	
 	
 				
 
 	#if ($_=~ /$cve_id/){
	#	my $sql = 'INSERT INTO nvdtable (cve_id) VALUES (?)';
	#	my $sth= $dbh -> prepare($sql);
	#	$sth->execute($_) ;
	#	}
	#if ($_=~ /$severity/){
	#	#my @vals = $_;
	#	print "$_";
	#	my $sql = 'INSERT INTO nvdtable (severity) VALUES (?)';
	#	my $sth=$dbh->prepare($sql);
	#}
	#if ($_=~/$published/){
		#my @vals = $_;
		#print "$_";
	#	my $sql = 'INSERT INTO nvdtable (published) VALUES (?)';
	#	my $sth=$dbh->prepare($sql);
	#}  
	#if ($_=~ /$modified/ ){
		#my @vals = $_;
		#print "$_";
	#	my $sql = 'INSERT INTO nvdtable (modified ) VALUES (?)';
	#	my $sth=$dbh->prepare($sql);
	#}	
		#for (@_){
			#my $sth ->execute($_->{cve_id}, $_->{severity},$_->{published},$_->{modified});
		#	my $sth ->execute(@ {$_}{'cve_id,severity, published,modified'})
	#		 }
		 #$sql = 'INSERT INTO nvdtable1 (severity) VALUES (?)';
		 #$sql = 'INSERT INTO nvdtable1 (published ) VALUES (?)';
		 #$sql = 'INSERT INTO nvdtable1 (modified) VALUES (?)';
		#my $sth = $dbh->prepare($sql);
		#$sth->execute (@vals);
 	

 	#}
  
# $table =  $dbh -> prepare ("INSERT INTO nvdtable\ (
#	cve_id,	severity, published, modified ) VALUES (
#	 ?,  ?, ?, ?
#  )");

#my $cve_id = quotemeta 'cve_id';
#my $severity = quotemeta 'severity';
#my $published = quotemeta 'published';
#my $modified = quotemeta 'modified';

#my $textfile = "log/nvdcve-2011.log";
#local $/ = undef;
#open (INPUT, "$textfile") or die "Could not open:$!\n";
#my $slurp = <INPUT>;

#close INPUT;

#while ($slurp =~ m/ ($cve_id.{0,16}) gisx /){
#	print "hello";
#} 


#while (<INPUT>) {
		#for my $chunk (split/\n/){
		#$chunk =~/RegExp to extract data from string/;
		#my $cve_id 		= $1;
		#my $severity	= $2;
		#my $published	= $3;
		#my $modified 	= $4;
		# send them to DB
		#$table->execute($cve_id,$severity,$published,$modified) or die $table->errstr;
		
#		}	
}
	
#$table->finish;
#close(INPUT);
#$table->execute();
$dbh->commit();
