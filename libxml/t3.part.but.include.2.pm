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

    my $dom = XML::LibXML->load_xml(string => $xml);

    #my $xpc = XML::LibXML::XPathContext->new ($dom);
    #$xpc->registerNs( xsi => $name_space );


    #foreach my $node ($dom->findnodes('//@xsi:schemaLocation')) {
    #foreach my $node ($dom->findnodes($compiled_xpath)) {
    #    my ($schema_ns, $schema_url) = split(' ', $node->to_literal());
    #    print $schema_url, "\n";
    #}
    my ($schema_ns, $schema_url) = split(' ', $dom->findvalue($compiled_xpath));
    #my ($schema_ns, $schema_url) = split(' ', $xpc->findvalue($compiled_xpath));
        print $schema_url, "\n";

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
