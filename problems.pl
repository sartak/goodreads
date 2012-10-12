#!/usr/bin/env perl
use 5.14.0;
use utf8::all;
use warnings;
use Text::CSV_XS;
use List::MoreUtils 'uniq';

my $csv = Text::CSV_XS->new ({ binary => 1, allow_loose_quotes => 1 }) or
die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
open my $fh, "<:encoding(utf8)", "goodreads_export.csv" or die "goodreads_export.csv: $!";
scalar <$fh>;
while (my $row = $csv->getline ($fh)) {
    my $shelves = join ' ', uniq @{$row}[16, 17, 18];
    warn "Missing japanese or english shelf: $row->[1]\n"
        unless $shelves =~ /english|japanese/;
    warn "Missing review of read book: $row->[1]\n"
        if $shelves !~ /currently-reading|wont-read|to-read/ && $row->[7] eq '0';
    warn "Rated book is unread: $row->[1]\n"
        if $shelves =~ /currently-reading|wont-read|to-read/ && $row->[7] ne '0';

    warn "$shelves book needs rescue: $row->[0]"
        if $shelves =~ /currently-reading|(?<!to-)read/ && $row->[1] =~ /Unknown/;
}
$csv->eof or $csv->error_diag ();
close $fh;
