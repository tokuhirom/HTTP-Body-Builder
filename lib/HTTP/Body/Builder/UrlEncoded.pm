package HTTP::Body::Builder::UrlEncoded;
use strict;
use warnings;
use utf8;
use 5.010_001;

use HTTP::Request::Common ();
use Carp ();

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

    my @content;
    for my $row (@{$self->{content}}) {
        push @content, @$row;
    }

    my $post = HTTP::Request::Common::POST(
        'http://example.com/',
        Content => [@content],
    );
    $post->content;
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

=item $builder->add_file($key => $real_file_name);

Add C<$real_file_name> as C<$key>.

=back
