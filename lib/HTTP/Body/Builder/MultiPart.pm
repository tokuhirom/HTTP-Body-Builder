package HTTP::Body::Builder::MultiPart;
use strict;
use warnings;
use utf8;
use 5.010_001;

use HTTP::Request::Common ();

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;
    bless {
        %args
    }, $class;
}

sub add_content {
    my ($self, $name, $value) = @_;
    push @{$self->{content}}, [$name, $value];
}

sub add_file {
    my ($self, $name, $filename) = @_;
    push @{$self->{file}}, [$name, $filename];
}

sub _request {
    my $self = shift;

    $self->{__request} //= do {
        my @content;
        for my $row (@{$self->{content}}) {
            push @content, @$row;
        }
        for my $row (@{$self->{file}}) {
            push @content, $row->[0], [$row->[1]];
        }

        HTTP::Request::Common::POST(
            'http://example.com/',
            Content_Type => 'form-data',
            Content => [@content],
        );
    };
}

sub content_type {
    my $self = shift;
    $self->_request->content_type;
}

sub as_string {
    my ($self) = @_;
    $self->_request->content;
}

# TODO: write it as streamingly.
sub write_file {
    my ($self, $filename) = @_;

    open my $fh, '<', $filename
        or return;
    print {$fh} $self->as_string;
    close $fh;
}


1;

