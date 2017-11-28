package CryptMailStore::Encrypt;
use MooseX::App::Command;
extends qw(CryptMailStore);
use Net::IMAP::Client;
use Term::ReadKey;
use Data::Dumper;
use Mail::GnuPG;
use MIME::Parser;
use Term::ProgressBar;
use DateTime;

=head1 NAME

CryptMailStore::Encrypt - Class for the encrypt command of CryptMailStore

=cut

option 'sign' => (
  is          => 'rw',
  isa         => 'Bool',
  documentation => "also sign each message"
);

option 'days' => (
  is          => 'rw',
  isa         => 'Int',
  documentation => "only process messages up to this number of days"
);

option 'unseen' => (
  is          => 'rw',
  isa         => 'Bool',
  documentation => "only process unseen messages"
);

sub run {
      my ($self) = @_;

    print "Imap Password:";
    ReadMode 'noecho';
    my $password = <STDIN>;
    ReadMode 'original';
    chomp($password);
    my $passphrase;
    if ($self->sign)
    {
      print "\nPGP Key Passphrase:";
      ReadMode 'noecho';
      $passphrase = <STDIN>;
      ReadMode 'original';
      chomp($passphrase);
    }
    my $gpg;
    if ($self->sign)
    {
      $gpg=new Mail::GnuPG(keydir=>$ENV{'HOME'}."/.gnupg/",use_agent=>0, passphrase=>$passphrase);
    }
    else
    {
      $gpg=new Mail::GnuPG(keydir=>$ENV{'HOME'}."/.gnupg/");
    }

    my $imap = Net::IMAP::Client->new(
               server => $self->server,
               user   => $self->user,
               pass   => $password,
               ssl    => $self->ssl,                              # (use SSL? default no)
               ssl_verify_peer => 0,                     # (use ca to verify server, default yes)
    ) or die "Could not connect to IMAP server";

    $imap->login or die('Login failed: ' . $imap->last_error);
    $imap->select($self->mailbox)or die('Mailbox selection failed: ' . $imap->last_error);

    my $messages;

    if ($self->days && $self->unseen)
    {
      my $dt=DateTime->now;
      my $days=$self->days*-1;
      $dt->add(days=>$days);
      my $date = $dt->day . "-" . $dt->month_abbr . $dt->year;
      $messages = $imap->search('UNSEEN SINCE ' . $date) or die($imap->last_error);
    }
    elsif($self->days)
    {
        my $dt=DateTime->now;
        my $days=$self->days*-1;
        $dt->add(days=>$days);
        my $date = $dt->day . "-" . $dt->month_abbr . $dt->year;
        $messages = $imap->search('SINCE ' . $date) or die($imap->last_error);
    }
    elsif($self->unseen)
    {
      $messages = $imap->search('UNSEEN');
    }
    else
    {
      $messages = $imap->search('ALL');
    }
    my @msgs=@{$messages};
    my $nr=@msgs;
    print "Nr of messages: " .$nr . "\n\n";
    my $progress = Term::ProgressBar->new ({
        name  => 'Messages',
        count => $nr,
        ETA   => 'linear',
    });
    my $encrypted=0;
    my $error=0;
    my $count=0;
    for my $id (@{$messages})
    {
      my $data         = $imap->get_rfc822_body($id);
      my $flags        = $imap->get_flags($id);
      my $sum          = $imap->get_summaries($id);
      my $internaldate = $sum->[0]->internaldate;

      my $parser = new MIME::Parser;
      $parser->decode_bodies(1);
      $parser->output_to_core(1);
      my $mime = $parser->parse_data($$data);
      $count++;
      $progress->update($count);
      if ($gpg->is_encrypted($mime))
      {
        $encrypted++;

        next;
      }
      my $err;
      if ($self->sign)
      {
        $err=$gpg->mime_signencrypt( $mime, $self->keyid);
      }
      else
      {
        $err=$gpg->mime_encrypt( $mime, $self->keyid);
      }
      if ($err != 0)
      {
        print Dumper($gpg->{last_message}) . "\n";
        $error++;
        next;
      }
      my $msg=$mime->stringify;
      $imap->delete_message($id);
      $imap->append($self->mailbox,\$msg,$flags,$internaldate) or die('message appending failed: ' . $imap->last_error);
      $imap->expunge();
    }
    $progress->update($count);
    my $successful=$count-$encrypted-$error;
    print "Successful: " . $successful . " Already Encrypted: " . $encrypted . " Error: " .$error . "\n";
}

1;
