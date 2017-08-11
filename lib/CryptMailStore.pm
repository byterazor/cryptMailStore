package CryptMailStore;
use MooseX::App qw(Color);

=head1 NAME

CryptMailStore - Main MooseX::App Module

=head1 AUTHOR

Dominik Meyer <dmeyer@federationhq.de>

=head1 DESCRIPTION

This class represents the main MooseX::App application module. It manages
global parameters.

=head1 LICENSE

GPLv2

=head1 PARAMETERS

=head2 server

The IMAP Server to connect to.

=cut
option 'server' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "imap server to use"
);

=head2 user

The username to authenticate against the IMAP server

=cut
option 'user' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "username on imap server"
);

=head2 keyid

The default PGP keyid to use for encryption. In this case use the email address.

=cut
option 'keyid' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "pgp key to use (master email address)"
);

=head2 mailbox

The mailbox on the IMAP server to work on.

=cut
option 'mailbox' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "mailbox on imap server"
);

=head2 ssl

Use SSL to connect to the IMAP server.

=cut
option 'ssl' => (
  is          => 'rw',
  isa         => 'Bool',
  documentation => "use ssl"
);

1;
