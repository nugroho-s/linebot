#!/usr/bin/perl
use cPanelUserConfig;

use CGI;
use DBI;
# use strict;
use JSON;
use Data::Dumper;
use LINE::Bot::API;
use LINE::Bot::API::Builder::SendMessage;

print "Content-Type: text/html\n\n";

my $driver = "mysql"; 
my $database = "u1087731_linebot";
my $dsn = "DBI:$driver:database=$database";
my $userid = "u1087731_nugroho";
my $password = "rikudou123";

my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

my $bot = LINE::Bot::API->new(
    channel_secret       => "91f5ac961c69afb96438444d010bf52b",
    channel_access_token => "+iCMDakD04j1W4YV99sOPWQ24CfuY3OfKtOmCEH6UT+53g5xDDf31f+sCzAQxsVxYa4VVCwtJkwD1Gr2wVWDIN8Y2i2eNEpZxZ0Boq3/iQ5/1kqmETFwn7aG+b3bLCiQpFIIZtP8XNcRY4dfycHTlwdB04t89/1O/w1cDnyilFU=",
);

print "\noutput:\n";

$q = new CGI;
my $value = $q->param("POSTDATA");
# open(my $fh, '>', 'report.txt');
# print $fh $value."\n";
# close $fh;
$decoded = decode_json($value);
print $value."\n\n";
for ( @{$decoded->{events}} ) {
	if ($_->{type} eq "message"){
		if ($_->{message}->{text} eq "!kuis"){
			# do kuis
			$msg = "jawaban kuis hari ini : ";
			my $sth = $dbh->prepare("SELECT `jawaban` FROM `kuis` WHERE `tanggal`=(SELECT DATE(DATE_SUB(NOW(),INTERVAL 7 HOUR)));");
			$sth->execute() or die $DBI::errstr;
			print "Number of rows found :" + $sth->rows;
			if ($sth->rows==0){
				$msg = $msg."belum ditambahkan"
			}
			else{
				while (my @row = $sth->fetchrow_array()) {
					my ($jawaban ) = @row;
					$msg = $msg.$jawaban
				}
			}
			my $messages = LINE::Bot::API::Builder::SendMessage->new(
				)->add_text(
				    text => $msg,
				);
			my $res = $bot->reply_message($_->{replyToken}, $messages->build);
			unless ($res->is_success) {
				# error handling
				open(my $fh, '>>', 'log_error.txt');
				print $fh localtime()."\t".e."\n";
				close $fh;
			}
		}
		elsif ($_->{message}->{text} eq "!about"){
			my $msg = "bot Nugsky\ncreated by Nugroho Satriyanto";
			my $messages = LINE::Bot::API::Builder::SendMessage->new(
				)->add_text(
				    text => $msg,
				);
			my $res = $bot->reply_message($_->{replyToken}, $messages->build);
			unless ($res->is_success) {
				# error handling
				open(my $fh, '>>', 'log_error.txt');
				print $fh localtime()."\t".e."\n";
				close $fh;
			}
		}
	} elsif ($_->{type} eq "join"){
		open(my $fh, '>>', 'group.txt');
		print $fh localtime()."\t".$_->{source}->{groupId}."\n";
		close $fh;
		my $msg = "halo\nUntuk melihat list perintah yang dapat dipakai, silakan cek beranda kami\nTerima kasih";
		my $messages = LINE::Bot::API::Builder::SendMessage->new(
			)->add_text(
			    text => $msg,
			);
		my $res = $bot->reply_message($_->{replyToken}, $messages->build);
		unless ($res->is_success) {
			# error handling
			open(my $fh, '>>', 'log_error.txt');
			print $fh localtime()."\t".e."\n";
			close $fh;
		}
	} elsif ($_->{type} eq "follow"){
		my $msg = "halo ";
		my $usrid = $_->{source}->{userId};
		my $ret = $bot->get_profile($usrid);
		unless ($ret->is_success) {
			# error handling
			open(my $fh, '>>', 'log_error.txt');
			print $fh localtime()."\t".e."\n";
			close $fh;
		}
		$msg = $msg.($ret->display_name);
		$msg = $msg.".\nUntuk melihat list perintah yang dapat dipakai, silakan cek beranda kami\nTerima kasih";
		my $messages = LINE::Bot::API::Builder::SendMessage->new(
			)->add_text(
			    text => $msg,
			);
		my $res = $bot->reply_message($_->{replyToken}, $messages->build);
		unless ($res->is_success) {
			# error handling
			open(my $fh, '>>', 'log_error.txt');
			print $fh localtime()."\t".e."\n";
			close $fh;
		}
	}
}