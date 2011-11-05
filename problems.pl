#!/usr/bin/env perl
use 5.14.0;
use warnings;
use Text::CSV_XS;

my $csv = Text::CSV_XS->new ({ binary => 1, allow_loose_quotes => 1 }) or
die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
open my $fh, "<:encoding(utf8)", "goodreads_export.csv" or die "goodreads_export.csv: $!";
scalar <$fh>;
while (my $row = $csv->getline ($fh)) {
    warn $row->[1]
        unless $row->[16] =~ /english/ || $row->[16] =~ /japanese/;
}
$csv->eof or $csv->error_diag ();
close $fh;
