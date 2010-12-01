# $Id: TAG.t,v 1.12 2009-11-26 22:38:46 dpchrist Exp $

use Test::More tests => 9;

use strict;
use warnings;

use Carp;
use Data::Dumper;
use Dpchrist::Tag	qw( :all );

$Data::Dumper::Sortkeys = 1;

$| = 1;

my @r;

@r = (__TAG__, __TAG0__, __TAG1__, __TAG2__);
ok(                                                             #     1
    $r[0] eq __FILE__ . ' 18  '
    && $r[1] eq $r[0],
    'verify level 0 call in main'
) && ok(							#     2
    $r[2] eq '',
    'verify level 1 call in main'
) && ok(							#     3
    $r[3] eq '',
    'verify level 2 call in main'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Foo::foo();
ok(                                                             #     4
    $r[0] eq __FILE__ . ' 72 foo()  '
    && $r[1] eq $r[0],
    'verify level 0 call to Foo::foo()'
) && ok(							#     5
    $r[2] eq __FILE__ . ' 33  ',
    'verify level 1 call to Foo::foo()'
) && ok(							#     6
    $r[3] eq '',
    'verify level 2 call to Foo::foo()'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Bar::bar();
ok(                                                             #     7
    $r[0] eq __FILE__ . ' 72 foo()  '
    && $r[1] eq $r[0],
    'verify level 0 call to Bar::bar()'
) && ok(							#     8
    $r[2] eq __FILE__ . ' 82 bar()  ',
    'verify level 1 call to Bar::bar()'
) && ok(							#     9
    $r[3] eq __FILE__ . ' 48  ',
    'verify level 2 call to Bar::bar()'
) or confess join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

package Foo;

use strict;
use warnings;

use Dpchrist::Tag	qw( :all );

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

