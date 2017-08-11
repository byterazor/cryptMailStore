#!/usr/bin/perl -I lib

=pod

=head1 NAME

CryptMailStore.pl - program to manage pgp encrypted mail stores

=head1 AUTHOR

Dominik Meyer <dmeyer@federationhq.de>

=head1 LICENSE

GPLv2

=cut

 use CryptMailStore;
 CryptMailStore->new_with_command->run;
