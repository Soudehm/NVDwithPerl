package NVD;

#  Extract vulnerability records from the XML files provided by NIST in their
#  public data feed at: https://nvd.nist.gov/download.cfm
#
#  This module supports only the NVD XML version 1.2.1 schema. The version 2.0
#  schema is not supported.

use strict;
use warnings;

use XML::LibXML;
use XML::LibXML::Error;
use DBI;
use DBD::SQLite;


sub extract {
    my $fname = shift
        or warn("please provide the XML file to load\n"),
        return;
        
	my $parser = XML::LibXML-> new();
	my $xml_text =eval{$parser->parse_string($fname);};
	print $@;
		
    my $xml = XML::LibXML->load_xml(location => $fname);
    my( $nvd ) = $xml->nonBlankChildNodes;

    my @vuln;
    my %vuln;
    
    for my $entry ($nvd->nonBlankChildNodes) {
        my %value;
        # %value = parse_nvd_entry($entry);

        for my $attr ($entry->attributes) {
            $value{$attr->nodeName} = $attr->nodeValue;
        }

        # rename 'name' to 'cve_id'
        my $cve_id = $value{cve_id} = delete $value{name};
        
        $vuln{$cve_id} = \%value;
    }

    return %vuln;
    

}

sub save2db {
	my $entry = shift;
	my %entry;
	
	
	my $driver 	="SQLite";
	
	
   # my $dbfile  = "log/test5.db";

	my $dsn     = "dbi:$driver:dbname=$entry";
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
 

 
 my $textfile = $entry;
 open (INPUT, "$textfile") or die "Could not open:$!\n";
 
 my @line = <INPUT>;

 for (@line) {
 	if ($_=~ /$cve_id/){
 	#print "$_";
 	my $sql = 'INSERT INTO nvdtable (cve_id) VALUES (?)';
	my $sth= $dbh -> prepare($sql);
	$sth->execute($_) ;
 	}
 		if ($_=~ /$severity/){
 		#print "$_";
 		}
 			if ($_=~/$published/){
 			#print "$_";
 			}
 				if ($_=~/$published/){
 				#print "$_";
 				}
 					if ($_=~ /$modified/ ){
 						#print "$_";
 					}
	
	}
	return %entry;
	$dbh->disconnect or die;
}

sub parse_nvd_entry {
    my $entry = shift;

    my %entry;
    for my $node ($entry->nonBlankChildNodes) {
        my $name = $node->nodeName;
        my $value = $node->textContent;
        $value =~ s/^\s+|\s+$//g;

        if ($node->nodeName eq '#text') {
            # The node content is held in an element called: '#text'. This is 
            # returned by the call to the method: textContent. As we recurse 
            # through the document, we rename it to "body".

            $name = "body";
        }

        if ($node->hasChildNodes) {
            my %value = parse_nvd_entry($node);
            $value = \%value;
        }

        if (defined $entry{$name}) {
            # This node name is reused within the same parent node
            my $existing_entry = $entry{$name};

            $value = {$name, $value};
            if (ref $existing_entry eq "ARRAY") {
                push @$existing_entry, $value;
            } else {
                $entry{$name} = [$existing_entry, $value];
            }

        } else {
            $entry{$name} = $value;
        }

        if ($node->hasAttributes) {
            my %attr ;
            for my $attr ($node->attributes) {
                $attr{$attr->nodeName} = $attr->nodeValue;
            }

            if (ref $value eq "HASH") {
                @$value{keys %attr} = values %attr;
            } else {
                $entry{$name} = {$name => $value, %attr};
            }
        }
    }

    return %entry;
}


1;
