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
   print "---------- adding ERROR $_[0]\n";
   push @validation_errors, shift;
}
#-----------------------------------------
sub _validate_xmlnode_vs_its_schema {
   my ($xml_node, $schema_location) = @_;
           my $stef = $xml_node->getAttribute('stef');

    my $dom = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $subtree =$xml_node->cloneNode( 1 );
    $dom->setDocumentElement($subtree);
    #print "------------1\n", $dom->nodeName(), "\n";
    #print "------------2\n", Dumper $dom, "\n";
    #print "------------3\n", $dom->toString(), "\n";

   #_log __LINE__, "validating node\n". $dom->toString()." vs schema: $schema_location";
   _log __LINE__, "validating node vs schema: $schema_location";

   my $schema = XML::LibXML::Schema->new( location => $schema_location );
   #my $valid = eval { $schema->validate($dom); 1 };
   my $valid = eval { 
    try {
          $schema->validate($dom); 
          1 
    }
    catch {
         _add_validation_error $_;
         0
    };
   };
   _log __LINE__,  'doc is '. ($valid ? '' : 'in') . 'valid';
   return $valid;
}
#-----------------------------------------
sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    try {
      #my $dom = XML::LibXML->load_xml(string => $xml);
       my $parser = XML::LibXML->new;
       my $dom = $parser->parse_string($xml);

       foreach my $node ($dom->findnodes($xpath_el_schemaloc_ns)) {
           my $attr = $node->getAttribute('xsi:schemaLocation');
           my ($schema_ns, $schema_location) = split(' ', $attr);
           _validate_xmlnode_vs_its_schema ($node, $schema_location) &&
           _log __LINE__, 'doc is valid';
       }
    }
    catch {
    warn "-----catch excp ---1----\n";
         _add_validation_error $_;
    warn "-----catch excp ---2----\n";
    };
   warn "-----main ---1----\n";
    _log __LINE__, join "<------->", @validation_errors;
    my $valid_msg = @validation_errors ? '' : 'in';
    _log __LINE__, "document is ${valid_msg}valid";
}
#-----------------------------------------

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
    <FormSubmission 
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns="http://xmlgw.companieshouse.gov.uk/Header"
                    xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk/Header http://xmlgw.companieshouse.gov.uk/v2-1/schema/forms/FormSubmission-v2-11.xsd">
      <FormHeader>
        <CompanyNumber>08116604</CompanyNumber>
        <CompanyName>BARCLAYS AFRICA GROUP HOLDINGS LIMITED</CompanyName>
        <CompanyAuthenticationCode>222222</CompanyAuthenticationCode>
        <PackageReference>0951</PackageReference>
        <FormIdentifier>ChangeRegisteredOfficeAddress</FormIdentifier>
        <SubmissionNumber>000FC7</SubmissionNumber>
      </FormHeader>
      <DateSigned>2021-03-23</DateSigned>
      <Form>
        <ChangeRegisteredOfficeAddress
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://xmlgw.companieshouse.gov.uk"
        xsi:schemaLocation="http://xmlgw.companieshouse.gov.uk http://xmlgw.companieshouse.gov.uk/v2-1/schema/forms/ChangeRegisteredOfficeAddress-v2-5.xsd">
          <Address>
            <Premise>Devonshire House</Premise>
            <Street>582 Honeypot Lane</Street>
            <PostTown>Stanmore</PostTown>
            <County>Middlesex</County>
            <Country>GBR</Country>
            <Postcode>HA7 1JS</Postcode>
          </Address>
        </ChangeRegisteredOfficeAddress>
      </Form>
    </FormSubmission>
  </Body>
</GovTalkMessage>
