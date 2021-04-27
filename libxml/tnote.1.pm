use strict;


use XML::LibXML;
use XML::LibXML::XPathContext;
use Data::Dumper;

sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    my $parser = XML::LibXML->new();
    my $dom = $parser->parse_string($xml);

    my @nodes = $dom->findnodes('//*[@xsi:schemaLocation]');

    my $node = $nodes[0];
    my $attr = $node->getAttribute('xsi:schemaLocation');

    my ($schema_ns, $schema_url) = split(' ', $attr);
    print "$schema_url\n";

    my $schema = XML::LibXML::Schema->new( location => $schema_url );

    my $dom2 = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $new_dom =$dom->cloneNode( 0 );
    my $new_subt =$node->cloneNode( 1 );

    print "------------1\n", Dumper $dom, "\n";
    print "------------2\n", Dumper $node, "\n";
    print "------------N\n", Dumper $new_dom, "\n";
    print "------------N\n", Dumper $new_subt, "\n";

    print "------------3\n", $dom->toString(), "\n";
    print "------------4\n", $node->toString(), "\n";
    print "------------N\n", $new_dom->toString(), "\n";
    print "------------N\n", $new_subt->toString(), "\n";

    print "------------5\n", $dom->nodeName(), "\n";
    print "------------6\n", $node->nodeName(), "\n";
    print "------------N\n", $new_dom->nodeName(), "\n";
    print "------------N\n", $new_subt->nodeName(), "\n";

    $dom2->setDocumentElement($new_subt);
    print "------------X\n", Dumper $dom2, "\n";
    print "------------X\n", $dom2->toString(), "\n";
    print "------------X\n", $dom2->nodeName(), "\n";

    my $valid = eval { $schema->validate($dom2); 1 } ? '' : 'in';

    print "document is ${valid}valid\n";
}

main();

__DATA__
<?xml version="1.0"?>
<note
  xmlns="https://raw.githubusercontent.com"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="https://raw.githubusercontent.com basic.git.xsd">
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>


