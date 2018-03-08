#!/usr/bin/env perl6

use Text::Table::Simple;

# Parse input such as the following:
#
#   10.2.7.100 lxc100 mfs101LXC mongo101LXC web101LXC
#   10.2.7.101 lxc101 db101LXC
#   10.2.7.105 lxc105 api105LXC lb105LXC mfs105LXC
#   10.2.7.106 lxc106 db103LXC mfs102LXC
#   10.2.7.110 lxc110 mfs111LXC mongo111LXC
#   10.2.7.120 lxc120 api121LXC cp121LXC key121LXC lb121LXC mfs121LXC 
#   10.2.7.130 lxc130 db131LXC db132LXC
#   10.2.7.140 lxc140 db141LXC mongo141LXC
#   10.2.7.200 lxc200 admn201LXC mfs201LXC mongo201LXC
#   10.2.7.201 lxc201 db201LXC db202LXC mongo202LXC
#   10.2.7.205 lxc205 api205LXC lb205LXC mfs205LXC
#   10.2.7.206 lxc206 db206LXC mongo206LXC
#   10.2.7.210 lxc210 mfs211LXC
#   10.2.7.220 lxc220 admn221LXC api221LXC cp221LXC key221LXC lb221LXC
#   10.2.7.240 lxc240 db203LXC mfs202LXC


my $hostfile = "./sample.txt"; # "/etc/hosts";


grammar HOST {
    rule  TOP     { <ip> <lxchost> <lxckids>   }
    token ip      { \d+ \. \d+ \. \d+ \. \d+   } 
    token lxchost { 'lxc' <hnum>               }
    token lxckids { <lxckid> [ \s+ <lxckid> ]+ }
    token lxckid  { <htype> <hnum> 'LXC'       }
    token htype   { <alpha>+                   }
    token hnum    { \d\d\d                     }
}


class HOST-actions {
    has $!cur;
    has %.known-lxc-unums  = ();
    has %.known-host-types = ();
    has %.found            = ();
    
    method lxckid ($/) {
        %!known-host-types{"$<htype>"} = True;
        %!found{"$!cur$<htype>"} ~= "$<hnum> ";
    }

    method lxchost ($/) {
        $!cur = "$<hnum>";
        %!found{$!cur} = $!cur;
        %!known-lxc-unums{$!cur} = True;
    }
}


sub MAIN {
    my $actions = HOST-actions.new;
    
    for $hostfile.IO.lines -> $line {
        HOST.parse($line, :$actions);
    }

    my @header = "", |$actions.known-host-types.keys.sort;
    my @rows = gather {
        for $actions.known-lxc-unums.keys.sort -> $lxc {
            my @keys = @header.map: { "$lxc$_" };
            take $actions.found{@keys}.map: { $_ || "." } ;
        }
    }

    .say for lol2table @header, @rows;
}
