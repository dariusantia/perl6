#!/usr/bin/env perl6


my $hostfile = "sample.txt";

sub MAIN {
    my %group;

    # Parse a hosts file such as:
    #
    #   10.2.7.210  lxc210  mfs211LXC mongo211LXC mongo250LXC
    #   10.2.7.220  lxc220  admn221LXC api221LXC cp221LXC db221LXC 
    #   10.2.7.230  lxc230  db231LXC
    #   10.2.7.240  lxc240  admn241LXC db241LXC db242LXC
    #   10.2.8.105  api105  apiSignup1 apiOrder1
    #
    # and generate a mapping such as
    #
    #   lxc210:mfs   => 211
    #   lxc210:mongo => [211,250] 
    #   lxc220:admn  => 221 
    #   ...
    #
    
    for $hostfile.IO.lines {
        next unless /^ (10\.\d+\.\d+\.\d+) \s+ 
                       $<lxc> = (lxc\d\d\d) \s+
                       $<rest> = (.+)/;
        my $lxchost = $<lxc>;
        
        for $<rest>.split(/\s/) {
            next unless /$<type>=(<alpha>+) $<unum>=(\d+) 'LXC'/;
            %group.push("$lxchost:$<type>" => "$<unum>");
        }
    }

    my @lxchosts  = %group.keys.map({ .subst(/\:.*/, "") }).sort.unique;
    my @hosttypes = %group.keys.map({ .subst(/.*\:/, "") }).sort.unique;

    $*OUT.printf("%-7s"~("%-9s"x@hosttypes.elems)~"\n", " ", @hosttypes);
    $*OUT.printf("%-7s%s\n"," ", "-------  " x @hosttypes.elems);

    
    for @lxchosts -> $lxchost {
        $*OUT.printf("%-7s", $lxchost);

        for @hosttypes -> $hosttype {
            my $display = %group{"$lxchost:$hosttype"};

            $display = $display ?? $display.join(",") !! ".";
            $*OUT.printf("%-9s", $display);
        }
        $*OUT.printf("\n");
    }
}
