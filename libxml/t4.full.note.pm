use strict;

use XML::LibXML;
use XML::LibXML::XPathContext;

use Try::Tiny qw(try catch);

use Data::Dumper;

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
sub _add_validation_error { push @validation_errors, shift; }
#-----------------------------------------
sub _validate_xmlnode_vs_its_schema {
   my ($xml_node, $schema_location) = @_;
   _log __LINE__, "validating node [$stef]:".$xml_node->to_literal();
   _log __LINE__, "validating node vs schema: $schema_location";

   my $schema = XML::LibXML::Schema->new( location => $schema_location );
   return eval { $schema->validate($xml_node); 1 };
}
#-----------------------------------------
sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    try {
       my $dom = XML::LibXML->load_xml(string => $xml);

       my @nodes = $dom->findnodes($xpath_el_schemaloc_ns);
       my $node = $nodes[0];
           my $attr = $node->getAttribute('xsi:schemaLocation');
           my ($schema_ns, $schema_location) = split(' ', $attr);
           _validate_xmlnode_vs_its_schema ($node, $schema_location) &&
           _log __LINE__, 'doc is valid';
   warn "-----looping ---4----\n";
    }
    catch {
         _add_validation_error $_;
    };
    _log __LINE__, join "\n", @validation_errors;
    my $valid_msg = @validation_errors ? '' : 'in';
    _log __LINE__, "document is ${valid_msg}valid";
    _log __LINE__, 'done';
}
#-----------------------------------------

main();
__DATA__
<?xml version="1.0"?>
<note
  xmlns="https://www.w3schools.com"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="https://www.w3schools.com file:///root/stef/basic.xsd">
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>

