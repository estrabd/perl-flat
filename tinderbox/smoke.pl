use Test::More 'no_plan';

use strict;
use lib "../lib";

use FLAT;
use FLAT::DFA;
use FLAT::NFA;
use FLAT::PFA;
use FLAT::Regex::WithExtraOps;
use FLAT::Regex::Util;

for my $i (2..4) { 
  for my $j (1..250000) {
    my $PRE = FLAT::Regex::Util::random_pre($i);
    print "PRE: ",$PRE->as_string,"\n";
    ok ( $PRE->as_pfa->as_nfa );
    ok ( $PRE->as_pfa->as_nfa->as_dfa );
    ok ( $PRE->as_pfa->as_nfa->as_dfa->as_min_dfa );
    ok ( $PRE->as_pfa->as_nfa->as_dfa->as_min_dfa->trim_sinks );
  } 
}
