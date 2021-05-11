package Framework::xmlScriptBase;

=head1 NAME

Framework xmlScriptBase

=head1 SYNOPSIS

Base/Root abstract class providing basic script input/output processing.

=head1 DESCRIPTION

Base/Root abstract class providing basic script input and output processing
via templates and XML compliant input.
Classes wishing to implement script XML input/output processing should
inherit this class.

=head1 PREREQUISITES

None.

=head1 METHOD

=over 4

=cut

use strict;

use base qw( Framework::scriptBase );

use POSIX qw(strftime);

use Framework::exception;
use XML::Simple;
use XML::Validate::Xerces;
use XML::LibXML;
use XML::LibXML::XPathContext;
use Common::XMLMapper  qw/XMLencode_data/;

use vars qw(%c);
*c = \%My::XMLGWConfig::c;

my @arrayValues = ['DataSet','Document', 'ChannelRouting' ];

our @location_attributes = qw /xsi:schemaLocation xsi:noNamespaceSchemaLocation/;
our %schema_locations = map { $_ => XML::LibXML::XPathExpression->new("//*[\@$_]")} @location_attributes;

# XML VALIDATION NOTE:
# Xerces was used till the migration to Red Hat 6 where it stopped to work.
# It failed to validate against remote schemas (http) while luckily it worked with local-files-schemas.
# The Xerces-library needed to be compiled explicitly with the option -nlibwww.
# This unfortunately proved to be not feasible in RH6, specifically because the required w3c-libwww apps
# weren't maintained and it was impossible to find a version for RH6.
#
# libxml2 was tried as an alternative, but at the time of writing it had these issues:
#
#          - unable to validate against 1 implicit schema (defined in
#            "schemaLocation/noNamespaceSchemaLocation" attributes)
#            workaround: parse the XML, strip the schema-location and validate explicitly.
#
#          - unable to validate against more schemas (case we have the different sections of our XMLGW files)
#            workaround: validate each section against its own schema, and declare the whole doc valid
#            if all the sections are found being valid. This logic might still be inadequate in general.
#
#          - unable to validate XML with xs:decimal > 24 digits
#            (and we have schemas with 26)
#
#          - ... (probably others but the above 3 were enough to drop it as an alternative)
#
# The chosen solution for RH6 was then to still use the limited Xerces valid-only-with-local-schema
# redirecting all the schema locations to the internal files.
# Luckily all the schemas are accessible under ~/htdocs/XMLGW/schema/
# so this seemed a valid workaround.

#
# Encapsulated class data

{
    #                     DEFAULT ACCESSIBILITY
    my %properties = (
        _xml           => [undef,      'read/write'],
        _parentName    => [undef,      'read'      ],
        _contentType   => ['text/xml', 'read/write'],
        _contentLength => [0,          'read'      ],
        );

    sub __properties { \%properties };
}

# -----------------------------------------------------------------------------

=item C<new($class)>

Constructor.

=cut

### Initialises a xmlScriptBase object.
###
### \param Named Arguments
###
### \todo list parameters here
###
sub new
{
    my ($caller, %arg) = @_;

    Framework::objectBase::registerProperties( __properties, \%arg );
    my $self = $caller->SUPER::new(%arg);

    unless( $self->{_parentName}  )
    {
        # Search the call stack for the top level caller before we enter into
        # the realms of ModPerl etc...
        #
        my $ix = 0;
        my ($pack, $packname);
        do {
            $pack = caller(++$ix);
            $packname = $pack if ($pack && $pack !~ /ModPerl|main/);
        } while( $pack );

        $self->{_parentName} = $packname;
    };

    warn "TMR:" . strftime( "%H%M%S", localtime ) . ':'.$$."::Start ".$self->{_parentName}."\n" if $self->{_config}->{sessiondb}{timepoint};

    # Get the input XML
    # Validate that the Content-Type is XML
    #
    if( lc $ENV{CONTENT_TYPE} ne "text/xml" ) {
      warn "BAD CONTENT TYPE [".($ENV{CONTENT_TYPE}||'unset')."]\n";
    }

    $self->{_contentLength} = $ENV{CONTENT_LENGTH};
    $self->{_contentType}   = $ENV{CONTENT_TYPE};

    # Parse the XML document so we can discover the intended Handler
    #
    my $rsep = $/;
    undef $/; # Slurpy Slurp
    $self->{_xml} = <STDIN>;
    $/ = $rsep;

    #if( ! $requestXML ) {
    #  return undef;
    #}
    $self->{_xml} =~ s/^\s+//g;
    $self->{_xml} =~ s/\s+$//g;

    return $self;
}


#-----------------------------------------
sub _swap_to_local_schemas
{
    my ($self) = @_;
    my $dom = XML::LibXML->load_xml(string => $self->{_xml});

    for my $key (keys %schema_locations) {

        for my $node ($dom->findnodes($schema_locations{$key})) {
            my $attr_value = $node->getAttribute($key);
            my ($schema_ns, $schema_location) = split(' ', $attr_value);
            if (index ($key, 'no') > 0){  #noNamespaceSchemaLocation vs schemaLocation
               ($schema_ns, $schema_location) = ('', $schema_ns);
            }
            else {
                $schema_ns .= ' ';
            }

            if ($schema_location =~ m|(/schema/.+?\.xsd$)|i) {
                $node->setAttribute ($key, $schema_ns."file://$c{XMLvalidation}{localSchemasPath}$1");
            }
        }
    }
    $self->{_xml} = $dom->toString;
}
#-----------------------------------------
sub _validate
{
  my ($self) = @_;
  # Validate xml against schema
  # TODO: ignore document->data and form if xbrl
  my %options;
  my $doc;
  my $validator = new XML::Validate::Xerces(%options);
  $self->_swap_to_local_schemas() if $c{XMLvalidation}{useLocalSchemas};
  if ( $doc = $validator->validate( $self->{_xml} ) ) {
    warn "Document is valid\n";
  } else {
    warn "Document is invalid\n";
    my $error = $validator->last_error();
#warn Dumper $error;
    #warn $validator->last_dom();
    throw Framework::exception( desc => 'XML failed schema validation: '. XMLencode_data($$error{message}) . '  line ' . $$error{line} . ' column ' . $$error{column},
                                code => 100 );
  }
}
#-----------------------------------------
sub getXML
{
    my ($self) = @_;

#warn Dumper $self->{_xml};

    if ( $ENV{HTTPS} ) {
      # TODO: This needs to be done for all requests, not just HTTPS.
      throw Framework::exception( desc => "No request XML" ) unless ($self->{_xml});

        $self->_validate();
    } else {
      # TODO: Add warning to reply
    }

    try {
        $self->{_xml} = XMLin( $self->{_xml}, forcearray => @arrayValues, suppressempty =>undef, keeproot => 1 );
    }
    otherwise {
        my ( $pack, $file, $line ) = caller();
        throw Framework::exception( desc => "Failed to parse XML" );
     };

    $self->{_outputSent} = 0;

    return $self->{_xml};
}

# -----------------------------------------------------------------------------

=item C<returnOutput($self, $data_r)>

Terminates/Finalises a script by returning the supplied content to the
client.

Also writes a log entry to stderr indicating that script has completed.

=cut

### \param $data_r [in] - (ref) Content to return
###
### \returns undef
###
sub returnOutput
{
    my ($self, $data_r ) = @_;

    unless( $data_r )
    {
        my ( $pack, $file, $line ) = caller();
        throw Framework::exception( desc => "Undefined value passed to returnOutput", file => $file, line => $line );
    }

    if( $self->{_outputSent} ) {
        my ( $pack, $file, $line ) = caller();
        throw Framework::exception( desc => "returnOuput has allready been called for this script", file => $file, line => $line );
    }

    # Force clean output of utf8
    #
    if ( $self->get_contentType =~ /text\// )
    {
      binmode STDOUT, ":utf8";
    } else {
      binmode STDOUT, ":bytes";
    }

    print 'Content-Type: '.$self->get_contentType."\r\n\r\n";
    print $$data_r;

    warn "TMR:" . strftime( "%H%M%S", localtime ) . ':'.$$."::Finish ".$self->{_parentName}."\n" if $self->{_config}->{sessiondb}{timepoint};

    $self->{_outputSent} = 1;
}

# -----------------------------------------------------------------------------

=head1 AUTHOR

Copyright 2006 Chris Smith - netFluid Technology Limited
http://www.nfluid.com

=cut
1;
