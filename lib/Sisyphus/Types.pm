package Sisyphus::Types;
use MooseX::Types -declare => [
    qw(
        EmailAddress
        States
    )
];
use Email::Address;
use MooseX::Types::Moose qw(Str);
use Moose::Util::TypeConstraints;

subtype EmailAddress,
    as Str,
    where { scalar Email::Address->parse($_) == 1 },
    message { "Cannot extract exactly one email address from ($_)" };

enum States, [qw(PASS FAIL SKIPPED UNTRIED)];

=head1 NAME

Sisyphus::Types - some useful Moose types

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 TYPES

=head2 EmailAddress

A string that parses as an email address.

=head2 States

One of 'PASS', 'FAIL', 'UNTRIED', 'SKIPPED'.

=head1 AUTHOR

Nicholas Bamber, C<< <nicholas at periapt.co.uk> >>

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Nicholas Bamber.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Sisyphus
