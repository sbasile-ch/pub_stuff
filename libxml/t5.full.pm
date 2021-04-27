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
   my ($xml_node, $schema_location, $go) = @_;
           my $stef = $xml_node->getAttribute('stef');
   _log __LINE__, "validating node [$stef]:".$xml_node->to_literal();
   _log __LINE__, "validating node vs schema: $schema_location";

   warn "========================== 1";
   my $schema = XML::LibXML::Schema->new( location => $schema_location );
   warn "========================== 2";
   eval { $schema->validate($xml_node); 1 } if $go;
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

       my $go = 1;
       foreach my $node ($dom->findnodes($xpath_el_schemaloc_ns)) {
   warn "-----looping ---1----\n", $node->to_literal();
          #my @attr = $dom->find($xpath_attr_schemaloc_ns, $node ); 
          #my $attr = $attr[0];
           my $stef = $node->getAttribute('stef');
           my $attr = $node->getAttribute('xsi:schemaLocation');
   warn "-----looping ---2----[$stef]\n", $attr;
          #my ($schema_ns, $schema_location) = split(' ', $attr->to_literal());
           my ($schema_ns, $schema_location) = split(' ', $attr);
           $go = 0 if $go > 2;
   warn "-----looping ---3----[$go]\n";
           _validate_xmlnode_vs_its_schema ($node, $schema_location, $go) &&
           _log __LINE__, 'doc is valid';
           $go ++;
   warn "-----looping ---4----\n";
       }
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
<?xml version="1.0" encoding="utf-8"?>
<ES1
        xmlns="s1"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="s1 file:///s1.xsd" >

  <A> element_A </A>

  <B
         xmlns="s2"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="s2 file:///s2.xsd">

         <C>element_C</C>
         <ES3
           xmlns="s3"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="s3 file:///s3.xsd">

               <D>element_D</D>
         </ES3>
       <B2>
  </B>
</ES1>
