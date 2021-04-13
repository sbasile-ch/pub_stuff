use strict;
use POSIX qw(strftime);

use XML::Simple;
use XML::Validate::Xerces;
use Data::Dumper;

sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    $xml =~ s/^\s+//g;
    $xml =~ s/\s+$//g;
    warn "working on this xml:[\n$xml\n]";

      my %options;
      my $doc;
      my $validator = new XML::Validate::Xerces(%options);
      if ( $doc = $validator->validate($xml)) {
        warn "Document is valid\n";
      } else {
        warn "Document is invalid\n";
        my $error = $validator->last_error();
        warn ( "XML failed schema validation:");
      }
}

main();
__DATA__
<GovTalkMessage
        xmlns="http://www.govtalk.gov.uk/CM/envelope"
        xmlns:dsig="http://www.w3.org/2000/09/xmldsig#"
        xmlns:gt="http://www.govtalk.gov.uk/schemas/govtalk/core"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.govtalk.gov.uk/CM/envelope http://xmlgw.companieshouse.gov.uk/v1-0/schema/Egov_ch-v2-0.xsd" >
  <EnvelopeVersion>1.0</EnvelopeVersion>
  <Header>
    <MessageDetails>
      <Class>CompanyDetails</Class>
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
   <CompanyDetailsRequest
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="http://xmlgw.companieshouse.gov.uk/v2-1/schema/FilingHistory.xsd">
      <CompanyNumber>10949243</CompanyNumber>
      <CapitalDocInd>false</CapitalDocInd>
   </CompanyDetailsRequest>
</Body>
</GovTalkMessage>
