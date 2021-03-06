# Copyright (C) 2008, Sebastian Riedel.

package MojoX::Routes::Match;

use strict;
use warnings;

use base 'Mojo::Base';

use Mojo::Transaction;
use Mojo::URL;

__PACKAGE__->attr('captures', chained => 1, default => sub { {} });
__PACKAGE__->attr('endpoint', chained => 1);
__PACKAGE__->attr('path',
    chained => 1,
    default => sub { shift->tx->req->url->path->to_string }
);
__PACKAGE__->attr('stack', chained => 1, default => sub { [] });
__PACKAGE__->attr('transaction',
    chained => 1,
    default => sub { Mojo::Transaction->new }
);

*tx = \&transaction;

# I'm Bender, baby, please insert liquor!
sub new {
    my $self = shift->SUPER::new();
    $self->transaction($_[0]);
    return $self;
}

sub url_for {
    my $self   = shift;
    my $values = ref $_[0] eq 'HASH' ? $_[0] : {@_};

    # Merge values
    $values = {%{$self->captures}, %$values};

    my $url = Mojo::URL->new;

    # No endpoint
    return $url unless $self->endpoint;

    # Render
    $self->endpoint->url_for($url, $values);

    return $url;
}

1;
__END__

=head1 NAME

MojoX::Routes::Match - Match

=head1 SYNOPSIS

    use MojoX::Routes::Match;

    my $match = MojoX::Routes::Match->new;

=head1 DESCRIPTION

L<MojoX::Routes::Match> is a match container.

=head2 ATTRIBUTES

=head2 C<captures>

    my $captures = $match->captures;
    $match       = $match->captures({foo => 'bar'});

=head2 C<endpoint>

    my $endpoint = $match->endpoint;
    $match       = $match->endpoint(1);

=head2 C<path>

    my $path = $match->path;
    $match   = $match->path('/foo/bar/baz');

=head2 C<stack>

    my $stack = $match->stack;
    $match    = $match->stack([{foo => 'bar'}]);

=head2 C<tx>

=head2 C<transaction>

    my $tx = $match->tx;
    my $tx = $match->transaction;
    $match = $match->tx(Mojo::Transaction->new);
    $match = $match->transaction(Mojo::Transaction->new);

=head1 METHODS

L<MojoX::Routes::Match> inherits all methods from L<Mojo::Base> and
implements the follwing the ones.

=head2 C<new>

    my $match = MojoX::Routes::Match->new;
    my $match = MojoX::Routes::Match->new(Mojo::Transaction->new);

=head2 C<url_for>

    my $url = $match->url_for;
    my $url = $match->url_for(foo => 'bar');
    my $url = $match->url_for({foo => 'bar'});

=cut