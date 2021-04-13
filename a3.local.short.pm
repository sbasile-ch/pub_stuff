use strict;
use XML::Validate::Xerces;

sub main {
    my $rsep = $/;
    undef $/;
    my $xml = <DATA>;
    $/ = $rsep;

    warn "working on this xml:[\n$xml]";

    my %options;
    my $validator = new XML::Validate::Xerces(%options);
    my $valid = $validator->validate($xml) ? '' : 'in';
    warn "Document is ${valid}valid\n";
}

main();

__DATA__
<?xml version="1.0"?>
<note
  xmlns="https://www.w3schools.com"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="https://www.w3schools.com file:///root/stef/note.xsd">
  <!--
  xsi:schemaLocation="https://www.w3schools.com http://www.w3schools.com/xml/note.xsd">
  -->
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
