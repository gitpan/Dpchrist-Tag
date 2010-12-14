# $Id: tag.t,v 1.17 2010-12-14 00:26:20 dpchrist Exp $

use Test::More tests => 31;

package Foo;

use Dpchrist::Tag qw( _filename _line _package _subroutine _tag );

use strict;
use warnings;

our $foo = sub {
    my $n = shift;
    return
	_filename($n),
	_line($n),
	_package($n),
	_subroutine($n),
	_tag($n);
};

package Bar;

use strict;
use warnings;

sub bar
{
    my $rc = $Foo::foo;
    return $rc->(@_);
};

package main;

use strict;
use warnings;

use Dpchrist::Tag qw( _filename _line _package _subroutine _tag );

use Carp;
use Data::Dumper;
use File::Basename;
use Test::More;

$Data::Dumper::Sortkeys = 1;

$| = 1;

my $b = basename(__FILE__);
my $r;
my @r;
my $rc = \&_tag;

$r = eval {
    &$rc;
};
ok(                                                             #     1
    !defined $r
    && $@ =~ /Argument is not a whole number/,
    'call with no arguments should fail'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([$r, $@], [qw(r @)])
);

$r = eval {
    &$rc(undef);
};
ok(                                                             #     2
    !defined $r
    && $@ =~ /Argument is not a whole number/,
    'call on the undefined value should fail'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([$r, $@], [qw(r @)])
);


$r = eval {
    _tag '';
};
ok(                                                             #     3
    !defined $r
    && $@ =~ /Argument is not a whole number/,
    'call on empty string should fail'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([$r, $@], [qw(r @)])
);

$r = eval {
    _tag 'foo';
};
ok(                                                             #     4
    !defined $r
    && $@ =~ /Argument is not a whole number/,
    'call on non-numeric string should fail'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([$r, $@], [qw(r @)])
);

$r = eval {
    _tag -1;
};
ok(                                                             #     5
    !defined $r
    && $@ =~ /Argument is not a whole number/,
    'call on negative integer should fail',
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([$r, $@], [qw(r @)])
);

$r = eval {
    _tag 3.1415927;
};
ok(                                                             #     6
    !defined $r
    && $@ =~ /Argument is not a whole number/,
    'call with floating point number should fail',
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([$r, $@], [qw(r @)])
);

@r = eval { Bar::bar(0) };
ok(                                                             #     7
    $r[0] eq __FILE__,
    'verify _filename(0)'
) && ok(							#     8
    13 < $r[1] && $r[1] < 21,
    'verify _line(0)'
) && ok(							#     9
    $r[2] eq 'Foo',
    'verify _package(0)'
) && ok(							#    10
    $r[3] eq 'Foo::__ANON__',
    'verify _subroutine(0)'
) && ok(							#    11
    $r[4] =~ /^[\w\\\/\-\.]+ \d+ __ANON__\(\)  $/,
    'verify _tag(0)'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r, $@, __FILE__, $b],
                     [qw(*r   @  __FILE__   b)])
);

@r = eval { Bar::bar(1) };
ok(                                                             #    12
    $r[0] eq __FILE__,
    'verify _filename(1)'
) && ok(							#    13
    $r[1] == 30,
    'verify _line(1)'
) && ok(							#    14
    $r[2] eq 'Bar',
    'verify _package(1)'
) && ok(							#    15
    $r[3] eq 'Bar::bar',
    'verify _subroutine(1)'
) && ok(							#    16
    $r[4] =~ /^[\w\\\/\-\.]+ \d+ bar\(\)  $/,
    'verify _tag(1)'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r, $@, __FILE__, $b],
                     [qw(*r   @  __FILE__   b)])
);

@r = eval { Bar::bar(2) };
ok(                                                             #    17
    $r[0] eq __FILE__,
    'verify _filename(2)'
) && ok(							#    18
    $r[1] == 163,
    'verify _line(2)'
) && ok(							#    19
    $r[2] eq 'main',
    'verify _package(2)'
) && ok(							#    20
    $r[3] eq '(eval)',
    'verify _subroutine(2)'
) && ok(							#    21
    $r[4] =~ /^[\w\\\/\-\.]+ \d+ \(eval\)  $/,
    'verify _tag(2)'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r, $@, __FILE__, $b],
                     [qw(*r   @  __FILE__   b)])
);

@r = eval { Bar::bar(3) };
ok(                                                             #    22
    $r[0] eq __FILE__,
    'verify _filename(3)'
) && ok(							#    23
    $r[1] == 184,
    'verify _line(3)'
) && ok(							#    24
    $r[2] eq 'main',
    'verify _package(3)'
) && ok(							#    25
    $r[3] eq '',
    'verify _subroutine(3)'
) && ok(							#    26
    $r[4] =~ /^[\w\\\/\-\.]+ \d+  $/,
    'verify _tag(3)'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r, $@, __FILE__, $b],
                     [qw(*r   @  __FILE__   b)])
);

@r = eval { Bar::bar(4) };
ok(                                                             #    27
    $r[0] eq '',
    'verify _filename(4)'
) && ok(							#    28
    $r[1] eq '',
    'verify _line(4)'
) && ok(							#    29
    $r[2] eq '',
    'verify _package(4)'
) && ok(							#    30
    $r[3] eq '',
    'verify _subroutine(4)'
) && ok(							#    31
    $r[4] eq '',
    'verify _tag(4)'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r, $@, __FILE__, $b],
                     [qw(*r   @  __FILE__   b)])
);

