use strict;
use warnings;
use LWP::UserAgent;

my $base = 'http://www.uniprot.org';
my $tool = 'mapping';

my $infile = $ARGV[0];
my $outfile = $ARGV[1];
my $from = $ARGV[2];
my $to = $ARGV[3];

print "syntax: up_mapping.pl 'input file' 'output file' 'from' 'to' \n\nCheck http://www.uniprot.org/help/api_idmapping for reference using 'from' and 'to' codes.\n\n";

open( INFILE, "<$infile" ) or die( "Couldn't open $infile: $!\n" );
my @query = <INFILE>;
close( INFILE );

chomp @query;

my $query = join(' ', @query);

open( OUTFILE, ">$outfile" ) or die( "Couldn't open $outfile: $!\n" );


my $params = {
  from => $from,
  to => $to,
  format => 'tab',
  query => $query,
};

my $contact = ''; # Please set your email address here to help us debug in case of problems.
my $agent = LWP::UserAgent->new(agent => "libwww-perl $contact");
push @{$agent->requests_redirectable}, 'POST';

my $response = $agent->post("$base/$tool/", $params);

while (my $wait = $response->header('Retry-After')) {
  print STDERR "Waiting ($wait)...\n";
  sleep $wait;
  $response = $agent->get($response->base);
}

$response->is_success ?
  print OUTFILE $response->content :
  die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";

close OUTFILE;
exit;