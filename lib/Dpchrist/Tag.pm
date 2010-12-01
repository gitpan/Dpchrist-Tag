#######################################################################
# $Id: Tag.pm,v 1.36 2010-11-30 20:57:53 dpchrist Exp $
#######################################################################
# package/ Export:
#----------------------------------------------------------------------

package Dpchrist::Tag;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
                __PACKAGE0__ __PACKAGE1__ __PACKAGE2__
                   __FILE0__    __FILE1__    __FILE2__
                   __LINE0__    __LINE1__    __LINE2__ 
        __SUB__     __SUB0__     __SUB1__     __SUB2__
        __TAG__     __TAG0__     __TAG1__     __TAG2__
) ], );

our @EXPORT_OK = (
    @{ $EXPORT_TAGS{'all'} },
    qw( _filename _line _package _subroutine _tag ),
);

our @EXPORT = qw();

our $VERSION = sprintf "%d.%03d", q$Revision: 1.36 $ =~ /(\d+)/g;

#######################################################################
# uses:
#----------------------------------------------------------------------

use Carp;
use Dpchrist::Is	qw( :all );
use File::Basename;

#######################################################################

=head1 NAME

Dpchrist::Tag - labels for debug, log, etc., messages


=head1 DESCRIPTION

This documentation describes module revision $Revision: 1.36 $.


This is alpha test level software
and may change or disappear at any time.


=head2 SUBROUTINES

=cut

#######################################################################

=head3 _filename($)

    _filename EXPR

Returns the caller's filename, or the empty string if undefined.

If EXPR is 0,
filename corresponds to location where _filename() is called.

If EXPR is a positive integer,
_filename() goes back EXPR stack frames.

Calls Carp::confess() on error.

=cut

#----------------------------------------------------------------------

sub _filename($)
{
    my ($n) = @_;

    confess('Argument is not a whole number',
	    Data::Dumper->Dump([$n], [qw(n)]),
    ) unless is_wholenumber($n);

    my $r = (caller($n))[1] || '';

    return $r;
}

#######################################################################

=head3 _line($)

    _line EXPR

Returns the caller's line number, or the empty string if undefined.

If EXPR is 0,
line name corresponds to location where _line() is called.

If EXPR is a positive integer,
_line() goes back EXPR stack frames.

Calls Carp::confess() on error.

=cut

#----------------------------------------------------------------------

sub _line($)
{
    my ($n) = @_;

    confess('Argument is not a whole number',
	    Data::Dumper->Dump([$n], [qw(n)]),
    ) unless is_wholenumber($n);

    my $r = (caller($n))[2] || '';

    return $r;
}

#######################################################################

=head3 _package($)

    _package EXPR

Returns the package name, or the empty string if undefined.

If EXPR is 0,
package name corresponds to location where _package() is called.

If EXPR is a positive integer,
_package() goes back EXPR stack frames.

Calls Carp::confess() on error.

=cut

#----------------------------------------------------------------------

sub _package($)
{
    my ($n) = @_;

    confess('Argument is not a whole number',
	    Data::Dumper->Dump([$n], [qw(n)]),
    ) unless is_wholenumber($n);

    my $r = (caller($n))[0] || '';

    return $r;
}

#######################################################################

=head3 _subroutine

    _subroutine EXPR

Returns the subroutine name, or the empty string if undefined.
Note that (caller($n))[3] is normally undefined outside of subroutines,
anonymous subroutines, eval's, etc..

If EXPR is 0,
subroutine name corresponds to location where _subroutine() is called.

If EXPR is a positive integer,
_subroutine() goes back EXPR stack frames.

Calls Carp::confess() on error.

=cut

#----------------------------------------------------------------------

sub _subroutine($)
{
    my $n = shift;

    confess('Argument is not a whole number',
    	    Data::Dumper->Dump([$n], [qw(n)]),
    ) unless is_wholenumber($n);

    my $r = (caller($n+1))[3] || '';

    return $r;
}

#######################################################################

=head3 _tag

    _tag EXPR

Returns a string of the form:

    'filename line subbase  '

Where subbase is whatever follows the last '::' of the subroutine name.

If subroutine is the empty string, returns:

    'filename line  '

If filename is the empty string, returns the empty string.

If EXPR is 0,
tag corresponds to location where _tag() is called.

If EXPR is a positive integer,
_tag() goes back EXPR stack frames.

Calls Carp::confess() on error.

=cut

#----------------------------------------------------------------------

sub _tag($)
{
    my $n = shift;

    confess('Argument is not a whole number',
	    Data::Dumper->Dump([$n], [qw(n)]),
    ) unless is_wholenumber($n);

    my $filename	= _filename($n+1);

    my $line		= _line($n+1);

    my $subroutine	= (split('::', _subroutine($n+1)))[-1];
    $subroutine .= '()' if $subroutine
			    && $subroutine ne '(eval)';

    my $r = '';

    if ($subroutine) {
	$r = join ' ', $filename, $line, $subroutine, ' ';
    }
    elsif ($filename) {
	$r = join ' ', $filename, $line, ' ';
    }
    
    return $r;
}

#######################################################################

=head3 __FILE*__

    __FILE0__ 
    __FILE1__
    __FILE2__

A set of subroutines for obtaining the file name
at the present location
and at one and two stack frames up.

=cut

#----------------------------------------------------------------------

sub __FILE0__() { return _filename(1) }
sub __FILE1__() { return _filename(2) }
sub __FILE2__() { return _filename(3) }

#######################################################################

=head3 __LINE*__

    __LINE0__
    __LINE1__
    __LINE2__

A set of subroutines for obtaining the line number
at the present location
and at one and two stack frames up.

=cut

#----------------------------------------------------------------------

sub __LINE0__() { return _line(1) }
sub __LINE1__() { return _line(2) }
sub __LINE2__() { return _line(3) }

#######################################################################

=head3 __PACKAGE*__

    __PACKAGE0__
    __PACKAGE1__
    __PACKAGE2__

A set of subroutines for obtaining the package name
at the present location
and at one and two stack frames up.

=cut

#----------------------------------------------------------------------

sub __PACKAGE0__() { return _package(1) }
sub __PACKAGE1__() { return _package(2) }
sub __PACKAGE2__() { return _package(3) }

#######################################################################

=head3 __SUB*__

    __SUB__
    __SUB0__
    __SUB1__
    __SUB2__

A set of subroutines for obtaining the subroutine name
at the present location (__SUB__ and __SUB0__)
and at one and two stack frames up.

=cut

#----------------------------------------------------------------------

sub __SUB__()  { return _subroutine(1) }
sub __SUB0__() { return _subroutine(1) }
sub __SUB1__() { return _subroutine(2) }
sub __SUB2__() { return _subroutine(3) }

#######################################################################

=head3 __TAG*__

    __TAG__
    __TAG0__
    __TAG1__
    __TAG2__

A set of subroutines for generating message labels
at the present location (__TAG__ and __TAG0__)
and at one and two stack frames up.

=cut

#----------------------------------------------------------------------

sub __TAG__()  { return _tag(1) }
sub __TAG0__() { return _tag(1) }
sub __TAG1__() { return _tag(2) }
sub __TAG2__() { return _tag(3) }

#######################################################################
# end of code:
#----------------------------------------------------------------------

1;
__END__

#######################################################################

=head2 EXPORT

None by default.

All of the subroutines may be imported by using the ':all' tag:

    use Dpchrist::Tag		qw( :all );

See 'perldoc Export' for everything in between.


=head1 INSTALLATION

Old school:

    $ perl Makefile.PL
    $ make    
    $ make test
    $ make install 

Minimal:

    $ cpan Dpchrist::Tag

Complete:

    $ cpan Bundle::Dpchrist

The following warning may be safely ignored:

    Can't locate Dpchrist/Module/MakefilePL.pm in @INC (@INC contains: /
    etc/perl /usr/local/lib/perl/5.10.0 /usr/local/share/perl/5.10.0 /us
    r/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.10 /usr/share/perl/5.10
    /usr/local/lib/site_perl .) at Makefile.PL line 22.


=head2 PREREQUISITES

See Makefile.PL in the source distribution root directory.


=head1 SEE ALSO

    perldoc -f caller


=head1 AUTHOR

David Paul Christensen dpchrist@holgerdanske.com


=head1 COPYRIGHT AND LICENSE

Copyright 2010 by David Paul Christensen dpchrist@holgerdanske.com

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307,
USA.

=cut

#######################################################################
