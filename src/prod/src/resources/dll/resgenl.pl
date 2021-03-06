use strict;
use warnings;
use File::Compare;

my $in = shift(@ARGV);
my $out = shift(@ARGV);
my $tmp = shift(@ARGV);

open (my $if, "<:crlf", $in) or die "can't read from $in: $!";
open (my $of, ">", $tmp) or die "can't write to $tmp: $!";

print $of "//------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//------------------------------------------------------------

// *** DO NOT EDIT: This file was generated by \"resgenl.pl\" ***

";
while (<$if>)
{
    if (/^#define\s*(IDS_\w*).*\/\/\s*(.*)$/) 
    { 
        print $of "DEFINE_STRING_RESOURCE($1, L\"$2\")\n"; 
    }
    elsif (/^#define\s*IDS_.*RESOURCE_ID/)
    {
        # intentional no-op for recognized component definition
    }
    elsif (/^#define\s*IDS_/)
    {
        # looks like a resource definition but doesn't match
        # the expected pattern - it's probably an error
        die "invalid resource definition: \"$_\"";
    }
}
close $of;

if (compare($out, $tmp)!=0)
{
    system "cp", $tmp, $out;
}

