# $Id: __LINE__.t,v 1.3 2010-12-20 06:05:19 dpchrist Exp $

use strict;
use warnings;

use Test::More tests => 9;

use Dpchrist::Tag	qw(
    __LINE0__
    __LINE1__
    __LINE2__
);

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

$| = 1;

my @r;

@r = (__LINE0__, __LINE1__, __LINE2__);
ok(                                                             #     1
    $r[0] eq 21,
    'verify level 0 call in main'
) && ok(							#     2
    $r[1] eq '',
    'verify level 1 call in main'
) && ok(							#     3
    $r[2] eq '',
    'verify level 2 call in main'
) or print STDERR join(" ", __LINE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Foo::foo();
ok(                                                             #     4
    $r[0] eq 76,
    'verify level 0 call to Foo::foo()'
) && ok(							#     5
    $r[1] eq 35,
    'verify level 1 call to Foo::foo()'
) && ok(							#     6
    $r[2] eq '',
    'verify level 2 call to Foo::foo()'
) or print STDERR join(" ", __LINE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Bar::bar();
ok(                                                             #     7
    $r[0] eq 76,
    'verify level 0 call to Bar::bar()'
) && ok(							#     8
    $r[1] eq 86,
    'verify level 1 call to Bar::bar()'
) && ok(							#     9
    $r[2] eq 49,
    'verify level 2 call to Bar::bar()'
) or print STDERR join(" ", __LINE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

package Foo;

use strict;
use warnings;

use Dpchrist::Tag	qw(
    __LINE0__
    __LINE1__
    __LINE2__
);

sub foo
{
    return __LINE0__, __LINE1__, __LINE2__;
}

package Bar;

use strict;
use warnings;

sub bar
{
    return Foo::foo();
}

