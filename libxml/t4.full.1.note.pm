use strict;

use XML::LibXML;
use XML::LibXML::XPathContext;

use Try::Tiny qw(try catch);

use Data::Dumper;

our $name_space = 'http://www.w3.org/2001/XMLSchema-instance';
# pre-compile xpath (tiny better performance)
  #my $xpath_schemaloc_ns = XML::LibXML::XPathExpression->new('/*/@xsi:schemaLocation');
our $xpath_el_schemaloc_ns     = XML::LibXML::XPathExpression->new('//*[@xsi:schemaLocation]');
our $xpath_attr_schemaloc_ns   = XML::LibXML::XPathExpression->new('@xsi:schemaLocation');
our $xpath_el_schemaloc_nons   = XML::LibXML::XPathExpression->new('//*[@xsi:noNamespaceSchemaLocation]');
our $xpath_attr_schemaloc_nons = XML::LibXML::XPathExpression->new('@xsi:noNamespaceSchemaLocation');
our @validation_errors = ();

#-----------------------------------------
sub _log {
    my ($line, $msg) = @_;
    print "line $line: [$msg]\n";
}
#-----------------------------------------
sub _add_validation_error {
   warn "-----add error---1----\n";
   push @validation_errors, shift;
   warn "-----add error---2----\n";
}
#-----------------------------------------
sub _validate_xmlnode_vs_its_schema {
   my ($xml_node, $schema_location) = @_;
           my $stef = $xml_node->getAttribute('stef');
   _log __LINE__, "validating node [$stef]:".$xml_node->to_literal();
   _log __LINE__, "validating node vs schema: $schema_location";

   warn "========================== 1";
   my $schema = XML::LibXML::Schema->new( location => $schema_location );
   warn "========================== 2";
   eval { $schema->validate($xml_node); 1 };
   warn "========================== 3";
   #return eval { $schema->validate($xml_node); 1 };
   return 1;
}
#-----------------------------------------
sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    #warn "working on this xml:[\n$xml]";
    try {
      #my $dom = XML::LibXML->load_xml(string => $xml);
       my $parser = XML::LibXML->new;
       my $dom = $parser->parse_string($xml);

       #my $xpc = XML::LibXML::XPathContext->new ($dom);
       #$xpc->registerNs( xsi => $name_space );

      #foreach my $node ($dom->findnodes($xpath_el_schemaloc_ns)) {
       my @nodes = $dom->findnodes($xpath_el_schemaloc_ns);
       my $node = $nodes[0];
   warn "-----looping ---1----\n", $node->to_literal();
          #my @attr = $dom->find($xpath_attr_schemaloc_ns, $node ); 
          #my $attr = $attr[0];
           my $stef = $node->getAttribute('stef');
           my $attr = $node->getAttribute('xsi:schemaLocation');
   warn "-----looping ---2----[$stef]\n", $attr;
          #my ($schema_ns, $schema_location) = split(' ', $attr->to_literal());
           my ($schema_ns, $schema_location) = split(' ', $attr);
   warn "-----looping ---3----\n";
           _validate_xmlnode_vs_its_schema ($node, $schema_location) &&
           _log __LINE__, 'doc is valid';
   warn "-----looping ---4----\n";
       #}
    }
    catch {
    warn "-----catch excp ---1----\n";
         _add_validation_error $_;
    warn "-----catch excp ---2----\n";
    };
   warn "-----main ---1----\n";
    _log __LINE__, join "\n", @validation_errors;
   warn "-----main ---2----\n";
    my $valid_msg = @validation_errors ? '' : 'in';
   warn "-----main ---3----\n";
    _log __LINE__, "document is ${valid_msg}valid";
   warn "-----main ---4----\n";
    _log __LINE__, 'done';
   warn "-----main ---5----\n";
}
#-----------------------------------------

main();
__DATA__
<?xml version="1.0"?>
<note
  xmlns="https://www.w3schools.com"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="https://www.w3schools.com /root/stef/basic.xsd">
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>

