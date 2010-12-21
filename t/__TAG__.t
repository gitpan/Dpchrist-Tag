# $Id: __TAG__.t,v 1.15 2010-12-20 06:05:19 dpchrist Exp $

use strict;
use warnings;

use Test::More tests => 9;

use Dpchrist::Tag		qw(
    __TAG__
    __TAG0__
    __TAG1__
    __TAG2__
);

use Carp;
use Data::Dumper;
use File::Basename;

$|				= 1;
$Data::Dumper::Sortkeys 	= 1;

my @r;
@r = (__TAG__, __TAG0__, __TAG1__, __TAG2__);
ok(                                                             #     1
    $r[0] eq __FILE__ . ' 23  '
    && $r[1] eq $r[0],
    'verify level 0 call in main'
) && ok(							#     2
    $r[2] eq '',
    'verify level 1 call in main'
) && ok(							#     3
    $r[3] eq '',
    'verify level 2 call in main'
) or confess join(" ", basename(__FILE__), __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Foo::foo();
ok(                                                             #     4
    $r[0] eq __FILE__ . ' 82 foo()  '
    && $r[1] eq $r[0],
    'verify level 0 call to Foo::foo()'
) && ok(							#     5
    $r[2] eq __FILE__ . ' 38  ',
    'verify level 1 call to Foo::foo()'
) && ok(							#     6
    $r[3] eq '',
    'verify level 2 call to Foo::foo()'
) or confess join(" ", basename(__FILE__), __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Bar::bar();
ok(                                                             #     7
    $r[0] eq __FILE__ . ' 82 foo()  '
    && $r[1] eq $r[0],
    'verify level 0 call to Bar::bar()'
) && ok(							#     8
    $r[2] eq __FILE__ . ' 92 bar()  ',
    'verify level 1 call to Bar::bar()'
) && ok(							#     9
    $r[3] eq __FILE__ . ' 53  ',
    'verify level 2 call to Bar::bar()'
) or confess join(" ", basename(__FILE__), __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

package Foo;

use strict;
use warnings;

use Dpchrist::Tag		qw(
    __TAG__
    __TAG0__
    __TAG1__
    __TAG2__
);

sub foo
{
    return __TAG__, __TAG0__, __TAG1__, __TAG2__;
}

package Bar;

use strict;
use warnings;

sub bar
{
    return Foo::foo();
}

