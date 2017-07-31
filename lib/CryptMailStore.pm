package CryptMailStore;
use MooseX::App qw(Color);

option 'server' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "imap server to use"
);

option 'user' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "username on imap server"
);

option 'keyid' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "pgp key to use (master email address)"
);

option 'mailbox' => (
  is          => 'rw',
  isa         => 'Str',
  required    => '1',
  documentation => "mailbox on imap server"
);

option 'ssl' => (
  is          => 'rw',
  isa         => 'Bool',
  documentation => "use ssl"
);

1;
