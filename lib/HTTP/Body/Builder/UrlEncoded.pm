package HTTP::Body::Builder::UrlEncoded;
use strict;
use warnings;
use utf8;
use 5.008_005;

use Carp ();
use URI;

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

sub content_type {
    my $self = shift;
    return 'application/x-www-form-urlencoded';
}

sub add_file {
    Carp::croak "You cannot add file with application/x-www-form-urlencoded.";
}

sub as_string {
    my ($self) = @_;

    my $uri = URI->new('http:');
    $uri->query_form(@{$self->{content}});
    my $content = $uri->query;

    # HTML/4.01 says that line breaks are represented as "CR LF" pairs (i.e., `%0D%0A')
    $content =~ s/(?<!%0D)%0A/%0D%0A/g if defined($content);
    $content;
}

1;
__END__

=head1 NAME

HTTP::Body::Builder::UrlEncoded - application/x-www-encoded

=head1 SYNOPSIS

    use HTTP::Body::Builder::UrlEncoded;

    my $builder = HTTP::Body::Builder::UrlEncoded->new();
    $builder->add('x' => 'y');
    $builder->as_string;
    # => x=y

=head1 METHODS

=over 4

=item my $builder = HTTP::Body::Builder::UrlEncoded->new()

Create new instance of HTTP::Body::Builder::UrlEncoded.

=item $builder->add_content($key => $value);

Add new parameter in raw string.

=item $builder->as_string();

Generate body as string.

=back
