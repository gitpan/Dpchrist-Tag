# $Id: 3_PACKAGE.t,v 1.4 2009-11-22 02:35:19 dpchrist Exp $

use strict;
use warnings;

use Test::More tests => 9;

use Dpchrist::Tag	qw( :all );

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

$| = 1;

my @r;

@r = (__PACKAGE0__, __PACKAGE1__, __PACKAGE2__);
ok(                                                             #     1
    $r[0] eq 'main',
    'verify level 0 call in main'
) && ok(							#     2
    $r[1] eq '',
    'verify level 1 call in main'
) && ok(							#     3
    $r[2] eq '',
    'verify level 2 call in main'
) or print STDERR join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Foo::foo();
ok(                                                             #     4
    $r[0] eq 'Foo',
    'verify level 0 call to Foo::foo()'
) && ok(							#     5
    $r[1] eq 'main',
    'verify level 1 call to Foo::foo()'
) && ok(							#     6
    $r[2] eq '',
    'verify level 2 call to Foo::foo()'
) or print STDERR join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);

@r = Bar::bar();
ok(                                                             #     7
    $r[0] eq 'Foo',
    'verify level 0 call to Bar::bar()'
) && ok(							#     8
    $r[1] eq 'Bar',
    'verify level 1 call to Bar::bar()'
) && ok(							#     9
    $r[2] eq 'main',
    'verify level 2 call to Bar::bar()'
) or print STDERR join(" ", __FILE__, __LINE__,
    Data::Dumper->Dump([\@r], [qw(*r)])
);



package Foo;

use strict;
use warnings;

use Dpchrist::Tag	qw( :all );

sub foo
{
    return __PACKAGE0__, __PACKAGE1__, __PACKAGE2__;
}

package Bar;

use strict;
use warnings;

sub bar
{
    return Foo::foo();
}

