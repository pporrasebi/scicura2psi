# Reference for uniprot query fields can be found here: http://www.uniprot.org/help/programmatic_access

use strict;
use warnings;
use LWP::UserAgent;

my $file = shift(@ARGV);
open(FILE, $file) || die "cannot open $file";
while(<FILE>) {
         chomp;
         my $query_term = $_;
         # query UniProt for the given identifier and retrieve tab-delimited format
         system ("curl \"http://www.uniprot.org/uniprot/?query=id:$query_term&format=tab&columns=id,organism-id\" -o output");
         open(CURL, "output") || die "cannot open output";
         while(<CURL>) {
                 print $_ if (/[A-Z]/ && !/Entry/); # do not print header
         }
         close(CURL);
}
close(FILE);
