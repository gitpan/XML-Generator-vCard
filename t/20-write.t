# $Id: 20-write.t,v 1.4 2004/10/07 22:28:02 asc Exp $

use strict;
use Test::More;

plan tests => 7;

my $res = "<?xml version='1.0' encoding='UTF-8'?><vCard:vCard xmlns:foaf='http://xmlns.com/foaf/0.1/' vCard:version='3.0' vCard:class='PUBLIC' xmlns:vCard='x-urn:cpan:ascope:xml-generator-vcard#'><vCard:fn>Senzala</vCard:fn><vCard:adr vCard:del.type='pref;work'><vCard:street>177 Bernard o.</vCard:street><vCard:locality>Montreal</vCard:locality><vCard:region>Quebec</vCard:region><vCard:country>Canada</vCard:country></vCard:adr><vCard:org><vCard:orgnam>Senzala</vCard:orgnam></vCard:org><vCard:categories><vCard:item>montreal</vCard:item></vCard:categories><vCard:note><![CDATA[I had breakfast here with Maciej - the food is good, the coffee not so]]></vCard:note></vCard:vCard>";

SKIP: {
  eval { 
    require XML::SAX::Writer;
  };

  if ($@) {
    skip("XML::SAX::Writer not installed", 7);
  }

  use_ok("XML::Generator::vCard");
  use_ok("XML::SAX::Writer");
  
  #
  
  my $vcard = "t/Senzala.vcf";
  ok((-f $vcard),"found $vcard");
  
  #
  
  my $str_xml = "";
  my $writer  = XML::SAX::Writer->new(Output=>\$str_xml);
  isa_ok($writer,"XML::Filter::BufferText");
  
  #
  
  my $parser = XML::Generator::vCard->new(Handler=>$writer);
  isa_ok($parser,"XML::Generator::vCard");
  
  #
  
  ok($parser->parse_files($vcard),"parsed $vcard");

  cmp_ok($str_xml,"eq",$res,$str_xml);
}
