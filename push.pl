#!/usr/bin/perl
use cPanelUserConfig;

use CGI;
use DBI;
# use strict;
use JSON;
use Data::Dumper;
use LINE::Bot::API;
use LINE::Bot::API::Builder::SendMessage;

my $bot = LINE::Bot::API->new(
	channel_secret       => "91f5ac961c69afb96438444d010bf52b",
	channel_access_token => "+iCMDakD04j1W4YV99sOPWQ24CfuY3OfKtOmCEH6UT+53g5xDDf31f+sCzAQxsVxYa4VVCwtJkwD1Gr2wVWDIN8Y2i2eNEpZxZ0Boq3/iQ5/1kqmETFwn7aG+b3bLCiQpFIIZtP8XNcRY4dfycHTlwdB04t89/1O/w1cDnyilFU=",
);

my $file = 'group_clean.txt';
open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>)  {   
	my $messages = LINE::Bot::API::Builder::SendMessage->new(
		)->add_text(
			text => 'fus ro dah',
		);
	my $res = $bot->push_message($line, $messages->build);
	unless ($res->is_success) {
		# error handling
		open(my $fh, '>>', 'log_error.txt');
		print $fh localtime()."\t"."push\n";
		close $fh;
	}
	last if $. == 2;
}

close $info;