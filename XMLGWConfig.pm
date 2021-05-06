package My::XMLGWConfig;
use strict;
use vars qw(%c %servers);

#my $machine = "wstuxtest2.orctel.internal";
my $machine = "frontend.tuxedo.staging.heritage.aws.internal";
my $ois_port = 3000;
my $search_port = 3001;
my $chips_port = 3002;
my $ef_port = 3003;
my $IXBRL_port = 3004;
my $TNEP_port = 3005;
my $TRANS_port = 3006;
my $gen_port = 3007;

my $SERVERBASE    = "http://xmlgw-stg-aws.companieshouse.gov.uk";
# my $IMAGEBASE  = '/mnt/ewf/';

my $HOSTNAME = 'wswebtest2';
my $VERSION  = 'v1-0';
my $INSBASE  = '/home/xml/htdocs';
my $SCHEMABASE  = "http://xmlgw-stg-aws.companieshouse.gov.uk";

#Cloud Mounts:
my $IMAGEBASE  = '/mnt/nfs/filings/recent_filings';
my $UPLOADBASE  = '/mnt/nfs/filings';
my $SUBBASE  = '/mnt/nfs/filings/submissions';
my $ARCHIVEBASE  = '/mnt/nfs/filings';

# Internal Mounts
#my $IMAGEBASE   = '/mnt/nfs/ewf/image';
#my $UPLOADBASE  = '/mnt/nfs/ewf';
#my $SUBBASE     = '/mnt/nfs/ewf';
#my $ARCHIVEBASE = '/mnt/nfs/ewf';


%c =
(
forceRenderSet => 1, #Force WCK render set for development
  xmlplatePath  => "/home/xml/DATA/xmlplates",

  uri => "$SERVERBASE/$VERSION/xmlgw/Gateway",

  #my $INSBASE = "/home/www/htdocs";
  #xmlplatePath   => "$INSBASE/$VERSION/xmlplates",
  replyTmplPath  => "/home/xml/htdocs/XMLGW/templates",

 defaultTemplatePath => "/home/xml/htdocs/XMLGW/templates",
 SCHEMAURI      => 'xmlgw-stg-aws.companieshouse.gov.uk/'.$VERSION.'/schema',
 uri             => "$SERVERBASE/$VERSION/xmlgw/Gateway",
 CHECK_SCHEMAURI      => 'http://xmlgw-stg-aws.companieshouse.gov.uk/',

   # Make sure a '/' ends the URI below
   IMAGE_FTP_URI  => 'ftp://xmlpreprodtest.orctel.internal/',
   IMAGE_BASE_DIR => 'xmlgw',

   govTalkTmpl    => "$INSBASE/XMLGW/templates/govtalk.tmpl",

  hostname      => "$HOSTNAME",
  project       => "XMLd",
  ch_proj_name  => "XML",
  default_repind => 0,   # Enable Charging where appropriate
  Cap09ChangeDate => 20091001,
  crpChangeDate   => '20130406',
  #singleGovTalkError => 1, # suppress multiple errors in xml response
  #dumbDownXBRLError => 1,  # Dumb down XBRL Error Messages
  testDataPath => "$INSBASE/XMLGW/testdata",
  defaultTestCompanyNumber => '03176906',
  companyTestDataPath => "$INSBASE/XMLGW/testdata/companies",
  #pscEarliestNotificationAllowedDate => '20150630', # the earliest 'notification' date for a PSC
  pscEarliestNotificationAllowedDate => '20160406', # the earliest 'notification' date for a PSC


jointFilingAccounts => {
        #minimumJointFilingTemplateVersion => '2.0.0',
        #minimumCHAccountsTemplateVersion => '2.0.0',
        minimumCHAccountsTemplateVersion => '2.0.1',
  },

  systempath =>
  {
    convert => '/usr/X11R6/bin/convert',
  },

 dates => {
            microAccStartDate   => '20130930',
           },

form_upload => {
     tmp_dir => $UPLOADBASE .'/tmp',
     post_max => 1024*1024,
},
  email => {
    fromUser         => 'noreply@companies-house.gov.uk',
    errorReturnEmail => 'noreply@companies-house.gov.uk',
    smtp             => 'localhost',
    efsupport        => 'ajames@companieshouse.gov.uk',
  },

corporationTax => {
        email   => {
            to => 'sussex.ct@hmrc.gsi.gov.uk,rtaylor@companieshouse.gov.uk',
            #to => 'cheryl.baker@hmrc.gsi.gov.uk',
        },
        threshold => {
            days    => 0,
            hours   => 0,
            minutes => 0,
        },
        cipherKey => 'HMRC TEST',
    },

  AIS =>
  {  # We do not require trailing '/' on each path
    # online   => $IMAGEBASE . '/online',
    # download => $IMAGEBASE . '/image',
    # fax      => $IMAGEBASE . '/fax',
    # email    => $IMAGEBASE . '/email',
    # post     => $IMAGEBASE . '/post',
    # collect  => $IMAGEBASE . '/collect',
    # upload   => $IMAGEBASE . '/upload',
    # archive   => $IMAGEBASE . '/archive',
    # submission   => $IMAGEBASE . '/submissions',
    # scratch  => '/tmp',

    # AWS Mounts
    online     => $IMAGEBASE . '/online',
    download   => $IMAGEBASE . '/image',
    fax        => $IMAGEBASE . '/fax',
    email      => $IMAGEBASE . '/email',
    post       => $IMAGEBASE . '/post',
    collect    => $IMAGEBASE . '/collect',
    upload     => $UPLOADBASE . '/upload',
    archive    => $ARCHIVEBASE . '/archive',
    submission => $SUBBASE . '/submissions',
    scratch  => '/tmp',

    faxincoming => '/incoming',
    faxreport   => '/report',

    ftponline   => '/online',
    ftpdownload => '/image',

    ftpurl   => 'ftp://chd3webdev.orctel.internal',

    phonePrefix => '9',

    uid      => 600,
    gid      => 600,

    location => {
        16 => 'CAR',
        17 => 'LON',
        18 => 'EDI',
    },

    server_ip   => '172.16.2.102',
    server_user => 'orchid',
    server_pass => 'orchid',
  },


  duplicateSubmissions => {

      checkForDuplicates => 1,

      formsToCheck => {
        'OfficerAppointment'   => 1,
        'OfficerChangeDetails' => 1,
        'OfficerResignation'   => 1,
      },
},

features => {
    cocoa_enabled => 20991231,
    cocoa_mandatory => 20991231,
    cs01_go_live_date => 20160630,
    pscEarliestDate         => 20160630,
    sbeeIncorporationIsEnabled => 20160630,
    hmrc_handovers_enabled      => 0,
    authentication_lockout => 20150231,
    pscFormsEnabled => 0,
    aml_enabled => 20170101,
    aml_phaseTwo => 20171103,
    countries_list => 20171206,
    #brexit => 20990101,
    brexit => 20201214,
    scrs_data_mem => 20200101,
    same_day_filing => 20990101,
 },

 chargeRegistrationExtensionPeriodStartDate => 20200606,
 chargeRegistrationExtensionPeriodEndDate   => 20210404,
 lateFilingWarningOffStartDate => 20200101,
 lateFilingWarningOffEndDate   => 20200702,

   schemaValidation => {
      ignoreNoSchemaRef => 1,
      ignoreSchemaLiveDates => 1,

   supportAlerts => {
        sendEmails => 1,
        from => 'sender@test.com',
        to => 'recipient@test.com',
        smtp => 'localhost',
      },
},

  schemaStatus => {
        schemaBaseUri   => "xmlgw-stg-aws.companieshouse.gov.uk/v1-0/schema",
        exampleBaseUri  => "xmlgw-stg-aws.companieshouse.gov.uk/examples",
    },

xmlGatewayLogConf => q(
      log4perl.rootLogger=TRACE, XMLGW
      log4perl.appender.XMLGW=Log::Log4perl::Appender::Screen
      log4perl.appender.XMLGW.layout=PatternLayout
      log4perl.appender.XMLGW.layout.ConversionPattern=[%d{yyyy/MM/dd} %d{HH:mm:ss.SSS} %P] [%c] [%p] %m%n
  ),

  gsrv =>
  {
    timeout        => 60,
    keepalive      => 10,
    #dumpxmlfile    => '/tmp/xmlpreprodtest.out',
    logrequest     => 1,
    session_cache  => 1,
    feature_flags  => 3,
  },

  esdatabase =>
  {
    source => 'dbi:Oracle:XMLSTG',
    user   => 'XML',
    pass   => 'al0n50'
  },
  commondb =>
  {
    source => 'dbi:Oracle:XMLSTG',
    user   => 'XML',
    pass   => 'al0n50'
  },

 bcddatabase =>
  {
    source => 'dbi:Oracle:BCDSTG',
    user   => 'bcd',
    pass   => 'bcd',
    managed => 0,
  },

  chxmldb =>
  {
    source => 'dbi:Oracle:XMLSTG',
    user   => 'XML',
    pass   => 'al0n50'
  },

  comdatabase =>
  {
    source => 'dbi:Oracle:XMLSTG',
    user   => 'XML',
    pass   => 'al0n50'
  },

  #New Config
  func01 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func01_request.xml",
  },
  func02 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func02_request.xml",
  },
  func03 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func03_request.xml",
  },
  func04 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func04_request.xml",
  },
  func04v2 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func04_request.xml",
  },
   func05 =>
  {
    machine => $machine,
    port    => $ois_port,
    xmlplate => "func05_request.xml",
  },
   func06 =>
  {
    machine => $machine,
    port    => $ois_port,
    xmlplate => "func06_request.xml",
  },
  func07 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func07_request.xml",
  },
  func08 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func08_request.xml",
  },
  func09 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func09_request.xml",
  },
 func10 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func10_request.xml",
  },
  func11 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func11_request.xml",
  },
    func12 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func12_request.xml",
  },
  func17 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func17_request.xml",
  },
  func18 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func18_request.xml",
  },
 func20 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func20_request.xml",
  },
  func23 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func23_request.xml",
  },
  func24 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func24_request.xml",
  },
  func25 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func25_request.xml",
  },
  func27 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func27_request.xml",
  },
   func28 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func28_request.xml",
  },
  func30 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func30_request.xml",
  },
  func31 =>
  {
    machine  => $machine,
    port     => $ois_port,
    xmlplate => "func31_request.xml",
  },


  #Search_Port
  alphakey =>
  {
    machine  => $machine,
    port     => $search_port,
    xmlplate => "alphakey_request.xml",
  },

  saalphakey =>
  {
    machine  => $machine,
    port     => $search_port,
    xmlplate => "alphakey_request.xml",
  },
  numsearch =>
  {
    machine  => $machine,
    port     => $search_port,
    xmlplate => "numsearch_request.xml",
  },

  sensitivename => {
  machine => $machine,
  port    => $search_port,
  xmlplate=> "sensitivename.xml",
  },

 #Chips_Port
 shuttle31 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

 shuttle32 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle33 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle34 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle35 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

 shuttle36 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle37 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle38 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle03 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc03_request.xml",
  },

  shuttle02 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc02_request.xml",
  },

  shuttle01 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "esfunc01_request.xml",
  },

   chips4 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "chips04_request.xml",
  },
 chips5 =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "chips05_request.xml",
  },

 chips8 =>
  {
    machine  => $machine,
    port     => $chips_port             ,
    xmlplate => "chips08_request.xml",
  },

    chargeread =>
  {
    machine  => $machine,
    port     => $chips_port,
    xmlplate => "chargeread_request.xml",
  },


  #EF_Port
  efstatuscomp =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efstatus_request.xml",
  },
  efstatuspres =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efstatus_request.xml",
  },
  efstatusenv =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efstatus_request.xml",
  },

  efstatusack =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efstatusack_request.xml",
  },

  efdocget =>
  {
    machine => $machine,
    port     => $ef_port,
    xmlplate => "efdocget_request.xml",
  },
  efpackget =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efpackget_request.xml",
  },
  prescheck =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "prescheck_request.xml",
  },

  efauthput =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efauthput_request.xml",
  },

  efauthget =>
  {
    machine  => $machine,
    port     => $ef_port,
    xmlplate => "efauthget_request.xml",
  },





#Gen_Port
   ref_seq_get =>
  {
    machine  => $machine,
    port     => $gen_port,
    xmlplate => "ref_seq_get.xml",
  },

  genBarcode =>
  {
    machine  => $machine,
    port     => $gen_port,
    xmlplate => "genBarcode.xml",
  },

  #Stand Alone
 validateXBRL =>
  {
    machine  => $machine,
    port     => $IXBRL_port,
    xmlplate => "validateXBRL_request.xml",
  },

  xmlTransform =>
  {
    machine  => $machine,
    port     => $TRANS_port,
    xmlplate => "xmlTransform_request.xml",
  },


  validateTNEP =>
  {
    machine  => $machine,
    port     => $TNEP_port,
    xmlplate => "validateAccounts_request.xml",
  },

  validateTNEPb64 =>
  {
    machine  => $machine,
    port     => $TNEP_port,
    xmlplate => "validateAccounts_request.xml",
  },

  iXBRLtoPDF =>
  {
    machine  => $machine,
    port     => $IXBRL_port,
    xmlplate => "iXBRLtoPDF_request.xml",
  },

  XMLvalidation => {
    useLocalSchemas => 1,
    localSchemasPath => '/home/xml/htdocs/XMLGW',
  },
);

1;
