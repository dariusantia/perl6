# Goal

In our /etc/host file, the naming convention dictates which container
resides on which host. For example
```
10.2.7.100 lxc100 mfs101LXC mongo101LXC web101LXC
10.2.7.101 lxc101 db101LXC
10.2.7.105 lxc105 api105LXC lb105LXC mfs105LXC
10.2.7.106 lxc106 db103LXC mfs102LXC
10.2.7.110 lxc110 mfs111LXC mongo111LXC
10.2.7.120 lxc120 api121LXC cp121LXC key121LXC lb121LXC mfs121LXC 
10.2.7.130 lxc130 db131LXC db132LXC
10.2.7.140 lxc140 db141LXC mongo141LXC
10.2.7.200 lxc200 admn201LXC mfs201LXC mongo201LXC
10.2.7.201 lxc201 db201LXC db202LXC mongo202LXC
10.2.7.205 lxc205 api205LXC lb205LXC mfs205LXC
10.2.7.206 lxc206 db206LXC mongo206LXC
10.2.7.210 lxc210 mfs211LXC
10.2.7.220 lxc220 admn221LXC api221LXC cp221LXC key221LXC lb221LXC
10.2.7.240 lxc240 db203LXC mfs202LXC
```
Here, from line 1, we know that containers mfs101, mongo101 and web101
can be found on host lxc100. Parse this file accordingly, and present
the data in a tabular format such as
```
       admn     api      cp       db       key      lb     
       -------  -------  -------  -------  -------  -------
lxc100 .        .        .        .        .        .      
lxc101 .        .        .        101      .        .      
lxc105 .        105      .        .        .        105    
lxc106 .        .        .        103      .        .      
lxc110 .        .        .        .        .        .      
lxc120 .        121      121      .        121      121    
lxc130 .        .        .        131,132  .        .      
lxc140 .        .        .        141      .        .      
lxc200 201      .        .        .        .        .      
lxc201 .        .        .        201,202  .        .      
lxc205 .        205      .        .        .        205    
lxc206 .        .        .        206      .        .      
lxc210 .        .        .        .        .        .      
lxc220 221      221      221      .        221      221    
lxc240 .        .        .        203      .        .      
```

# Attempt 1

This uses perl6, but with a perl5 mentality. 

# Attmpt 2

Realize that a grammar can cleanly capture the meaning of the
input. Appropriate actions can be triggered as various rules are
matched.

The MAIN function can still be improved. There probably is a better
way to build the @rows list.

