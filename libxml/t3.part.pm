use strict;

use XML::LibXML;
use XML::LibXML::XPathContext;

use Try::Tiny qw(try catch);

use Data::Dumper;

our $name_space = 'http://www.w3.org/2001/XMLSchema-instance';

sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    #warn "working on this xml:[\n$xml]";
    #my $compiled_xpath = XML::LibXML::XPathExpression->new('/*/@xsi:schemaLocation');
    my $is_valid = 0;
    try {
    my $compiled_xpath = XML::LibXML::XPathExpression->new('//@xsi:schemaLocation');

    my $parser = XML::LibXML->new(XML_LIBXML_LINENUMBERS => 1);
    my $dom = $parser->load_xml(string => $xml);
    #my $dom = XML::LibXML->load_xml(string => $xml);


    #foreach my $node ($dom->findnodes('//@xsi:schemaLocation')) {
    #foreach my $node ($dom->findnodes($compiled_xpath)) {
    #    my ($schema_ns, $schema_url) = split(' ', $node->to_literal());
    #    print $schema_url, "\n";
    #}
    my ($schema_ns, $schema_url) = split(' ', $dom->findvalue($compiled_xpath));
        print $schema_url, "\n";

    my $xpc = XML::LibXML::XPathContext->new ($dom);
    $xpc->registerNs( xsi => $name_space );

    my $schema = XML::LibXML::Schema->new( location => $schema_url );
    print "validating\n";
    $is_valid = 1 if eval { $schema->validate($dom); 1 };
    }
    catch {
        print "error: [$_]\n";
    };
    my $valid_msg = $is_valid ? '' : 'in';
    print "document is ${valid_msg}valid\n";
    print "done\n";


    #my @nodes = $xpc->findnodes($compiled_xpath);
    #warn Dumper @nodes;

    #my $doc = XML::LibXML->new->parse_XXX(...);
    #my $schema_loc = $xpc->findvalue('/*/@xsi:schemaLocation', $doc) or die("...\n");
}

main();

__DATA__
<?xml version="1.0" encoding="utf-8"?>
<GovTalkMessage
        xmlns="http://www.govtalk.gov.uk/CM/envelope"
        xmlns:dsig="http://www.w3.org/2000/09/xmldsig#"
        xmlns:gt="http://www.govtalk.gov.uk/schemas/govtalk/core"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.govtalk.gov.uk/CM/envelope http://xmlgw.companieshouse.gov.uk/v1-0/schema/Egov_ch-v2-0.xsd" >
        <!-->
        xsi:schemaLocation="http://www.govtalk.gov.uk/CM/envelope file:///schemas/Egov_ch-v2-0.xsd" >
        -->
          <EnvelopeVersion>1.0</EnvelopeVersion>
  <Header>
    <MessageDetails>
      <Class>ChangeRegisteredOfficeAddress</Class>
      <Qualifier>request</Qualifier>
      <TransactionID>1</TransactionID>
    </MessageDetails>
    <SenderDetails>
      <IDAuthentication>
        <SenderID>chris001</SenderID>
        <Authentication>
          <Method>CHMD5</Method>
          <Value>8b0ea097ad9ebd45d0decb624afbed51</Value>
        </Authentication>
      </IDAuthentication>
    </SenderDetails>
  </Header>
  <GovTalkDetails>
    <Keys/>
  </GovTalkDetails>
  <Body>
          <Address>
            <Premise>Devonshire House</Premise>
            <Street>582 Honeypot Lane</Street>
            <PostTown>Stanmore</PostTown>
            <County>Middlesex</County>
            <Country>GBR</Country>
            <Postcode>HA7 1JS</Postcode>
          </Address>
  </Body>
</GovTalkMessage>

