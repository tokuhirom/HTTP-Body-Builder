use strict;
use warnings;
use utf8;
use Test::More;
use HTTP::Body::Builder::MultiPart;

my $CRLF = "\015\012";

subtest 'simple' => sub {
    my $builder = HTTP::Body::Builder::MultiPart->new;
    $builder->add_content(x => "y\0z");
    is $builder->content_type, 'multipart/form-data';
    is $builder->as_string, join('',
        "--xYzZY$CRLF",
        qq{Content-Disposition: form-data; name="x"$CRLF},
        "$CRLF",
        "y\0z$CRLF",
        "--xYzZY--$CRLF",
    );
};

subtest 'simple case with file' => sub {
    my $builder = HTTP::Body::Builder::MultiPart->new;
    $builder->add_content(x => "y\0z");
    $builder->add_file(x => 't/dat/foo');
    is $builder->content_type, 'multipart/form-data';
    is $builder->as_string, join('',
        "--xYzZY$CRLF",
        qq{Content-Disposition: form-data; name="x"$CRLF},
        "$CRLF",
        "y\0z$CRLF",
        "--xYzZY$CRLF",
        qq{Content-Disposition: form-data; name="x"; filename="foo"$CRLF},
        "Content-Type: text/plain$CRLF",
        "$CRLF",
        "foofoofoo$CRLF",
        "--xYzZY--$CRLF",
    );
};

done_testing;

