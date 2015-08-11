#!/usr/bin/perl

use strict;

use warnings;

use DBI;

my $number = $ARGV[0];

my $db_host = '192.168.254.9';

my ( $db_user, $db_name, $db_pass ) =
  ( 'phonelookup', 'owncloud', 'PASSWORD' );

my $dbh = DBI->connect( "DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass );

# Temp-Table löschen
my $query_test;
$query_test = $dbh->do('drop table if exists  test;') or die $query_test->err_str;

$query_test = $dbh->do('create table test (name varchar(30), value varchar(30));') or die $query_test->err_str;

$query_test = $dbh->do("insert into test (value,name) 
   select prop.value,cards.fullname from oc_contacts_cards_properties as prop 
   LEFT JOIN (oc_contacts_cards as cards) on (prop.contactid=cards.id) where name='TEL'") or die $query_test->err_str;

$query_test = $dbh->do("update test set value = replace(value,'+49','0');") or die $query_test->err_str;
$query_test = $dbh->do("update test set value = replace(value,' ','');") or die $query_test->err_str;
$query_test = $dbh->do("update test set value = replace(value,' ','');") or die $query_test->err_str;
$query_test = $dbh->do("update test set value = replace(value,'-','');") or die $query_test->err_str;
$query_test = $dbh->do("update test set value = replace(value,')','');") or die $query_test->err_str;
$query_test = $dbh->do("update test set value = replace(value,'(','');") or die $query_test->err_str;
$query_test = $dbh->do("update test set value = replace(value,'/','');") or die $query_test->err_str;

$query_test = $dbh->prepare("select name from test where value='$number' limit 1;");
$query_test->execute() or die $query_test->err_str;

if ($query_test->rows > 0)
{
  my ($col1, $col2) = $query_test->fetchrow_array();
  print "$col1\n";
} else { print "Unbekannt\n"; }

$query_test="";

$dbh->disconnect();

