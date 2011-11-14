#!/usr/bin/env perl
use 5.14.0;
use utf8::all;
use warnings;
use Text::CSV_XS;
use Sort::Naturally;

my $csv = Text::CSV_XS->new ({ binary => 1, allow_loose_quotes => 1 }) or
die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
open my $fh, "<:encoding(utf8)", "goodreads_export.csv" or die "goodreads_export.csv: $!";
scalar <$fh>;
my @books;
while (my $row = $csv->getline ($fh)) {
    push @books, $row->[1]
        if $row->[16] =~ /japanese/;
}
$csv->eof or $csv->error_diag ();
close $fh;

for (@books) {
    # cruft
    s/\(Bunch comics\)/ /g;
    s/\(集英社文庫―コミック版\)/ /g;
    s/\(ハヤカワ文庫 SF \d+\)/ /g;
    s/\(ハヤカワ文庫 SF \(\d+\)\)/ /g;
    s/\(早川文庫 SF \(\d+\)\)/ /g;
    s/\(てんとう虫コミックススペシャル\)/ /g;
    s/\(ドラえもんの学習シリーズ―ドラえもんの国語おもしろ攻略\)/ /g;
    s/\(新潮文庫\)/ /g;
    s/小飼弾の頭が強くなる読書法 \(East Press Business\)/ /g;
    s/\(Beam comix\)/ /g;
    s/\(集英社文庫ヘリテージシリーズ\)/ /g;
    s/\(アスペクトコミックス\)/ /g;
    s/\(アニメコミックス\)/ /g;
    s/\(in Japanese\)/ /g;
    s/^新版 / /;
    s/\(Kodansha's Children's Classics\)/ /g;
    s/\(ヤングサンデーコミックス\)/ /g;
    s/\(CodeZine BOOKS\)/ /g;
    s/\(ジャンプ・コミックス\)/ /g;
    s/\(講談社 青い鳥文庫\)/ /g;
    s/\(てんとう虫コミックス\)/ /g;
    s/\(少年サンデーコミックス\)/ /g;
    s/縄文時代~室町時代 ドラえもんの学習シリーズ ドラえもんの社会科おもしろ攻略/ /g;
    s/\[WEB\+DB PRESS plus\] \(WEB\+DB PRESS plusシリーズ\)/ /;
    s/〈高学年〉/ /g;
    s/\(指導者の手帖\)/ /g;
    s/\(講談社青い鳥文庫 \(\d+‐\d+\)\)/ /g;
    s/\(竹書房文庫\)/ /g;
    s/\(角川文庫\)/ /g;
    s/\(ドラえもんの学習シリーズ\)/ /g;
    s/\[第四版・注釈版\]/ /g;
    s/\(ハヤカワ文庫SF\)/ /g;
    s/Shogakukan English comics/ /g;
    s/\(カラー版 ナルニア国物語\)/ /g;
    s/\(Jojo's Bizarre Adventures Part 1, Phantom Blood #1\)/ /;
    s/\(海外SFノヴェルズ\)/ /g;
    s/\(Takutikusu\)/ /g;
    s/\[Jump C\]/ /g;
    s/\(Perfect version\)/ /g;
    s/\(American Gods\)/ /g;
    s/\(Dragon Ball \(Kanzen ban\)\)/ /g;
    s/\(クリムゾンコミック\)/ /g;
    s/\[新訳版\]/ /g;
    s/\(ハヤカワepi文庫 オ \d+-\d+\)/ /g;
    s/Doraemon ― Gadget cat from the future/ /g;
    s/\(SPコミックス\)/ /g;
    s/\(ヤンマガKC \(\d+\)\)/ /g;
    s/\(講談社KK文庫\)/ /g;
    s/\(Japanese Edition\)/ /g;
    s/\(ハヤカワ文庫 SF\)/ /g;
    s/ハヤカワ文庫SF/ /g;
    s/\(Power Japanese Series\)/ /g;
    s/\(Japanese\)/ /g;
    s/\(Tentomusi comics\)/ /g;
    s/\(Dragonball\)/ /g;
    s/\(秋田文庫\)/ /g;
    s/―?完全版/ /g;
    s/\(上下巻セット\)/ /g;
    s/, Volume/ /g;
    s/―実戦で学ぶ関数型言語プログラミング/ /g;
    s/〔決定版〕/ /g;

    # numbering
    s/〈(\d+)〉/ ($1)/g;
    s/\(Vol\.\s*(\d+)\)/($1)/g;
    s/Vol\.\s*\((\d+)\)/($1)/g;
    s/Vol\.\s*(\d+)/($1)/g;
    s/Part\s*(\d+)/($1)/g;
    s/\(Volume\s*(\d+)\)/($1)/g;
    s/\(No\.\s*(\d+)\)/($1)/g;
    s/\(巻(\d+)\)/($1)/g;
    s/ (\d+)\s+$/ ($1)/g;
    s/ (\d+)\s*\(\1\)/ ($1)/g;
    #s/(\(\d+\))\s*\1/$1/g;

    # formatting
    s/(デューン)(?! )/$1 /;
    s/Hokuto No Ken/北斗の拳/;
    s/DEATH\s*NOTE/Death Note/i;
    s/One piece/One Piece/;
    s/ドラゴンボール/Dragonball/;

    # trim
    s/\s+$//g;
    s/^\s+//g;
    s/\s{2,}/ /g;
}

for my $book (nsort @books) {
    say $book;
}
