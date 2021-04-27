use strict;

use XML::LibXML;
use XML::LibXML::XPathContext;

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
    my $valid = eval { $schema->validate($dom); 1 } ? '' : 'in';
    print "document is ${valid}valid\n";
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
