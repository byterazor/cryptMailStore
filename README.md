## Name

cryptMailStore

## Description

Programm allows the enryption of email in imap mailboxes with GPG.

Its similar to the https://github.com/n0g/arcane project bit is written in Perl.

The reason for this project is, I like Perl more than Python and the arcane project did not create PGP encrypted emails which are readable by the android email program r2mail2. cryptMailStore creates pgp mime encrypted and signed messages readable by r2mail2.

## Warning

Please be careful when you encrypt emails with cryptMailStore because the unencrypted emails will
be deleted from the imap server. Therefore, if you loose your PGP secret key, or you choose the wrong keyid to encrypt with, you loose all access to your emails.

Best practise is to try this software with a submailbox on your imap server with a copy of some of your emails. If everything works fine, use it on your real mailstore.

Still this Software is provided as is without any warranty. I am not repsonsible if your emails are lost or not accessible anymore !

## Requirements

### Debian
```bash
apt-get install libnet-imap-client-perl
apt-get install libmoosex-app-perl
apt-get install libmail-gnupg-perl
apt-get install libterm-progressbar-perl
apt-get install libdatetime-perl
```

### CPAN
```bash
cpan -i MooseX::App
cpan -i Net::IMAP::Client
cpan -i Mail::GnuPG
cpan -i MIME::Parser
cpan -i Term::ProgressBar
cpan -i DateTime
```

## Example Usage
```bash
 git clone git@github.com:byterazor/cryptMailStore.git
 cd cryptMailStore
 ./cryptMailStore encrypt -server imap.server.de -user username -mailbox INBOX -ssl -sign -unseen --keyid dmeyer@federationhq.de
```
## Todo
- improve documentation
- create CPAN Module
- add decryption command
- add recrypt command
- add message selection by subject
