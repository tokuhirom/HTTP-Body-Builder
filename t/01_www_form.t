use strict;
use warnings;
use utf8;
use Test::More;

use HTTP::Body::Builder::UrlEncoded;

subtest 'simple' => sub {
    my $builder = HTTP::Body::Builder::UrlEncoded->new();
    $builder->add_content('x' => 'y');
    is $builder->as_string, 'x=y';
};

subtest 'binary' => sub {
    my $builder = HTTP::Body::Builder::UrlEncoded->new();
    $builder->add_content('x' => "y\0");
    is $builder->as_string, 'x=y%00';
};

subtest 'file' => sub {
    my $builder = HTTP::Body::Builder::UrlEncoded->new();
    eval {
        $builder->add_file('foo' => "t/dat/foo");
    };
    ok $@;
};

done_testing;

