#!/bin/env perl
use strict;
use warnings;
use Data::Dumper;

# To execute:
# % perl all-acyclic-fromN.pl < graph.dat 

my $NUM_NODES =  0;
my $SRC_NODE  = -1;
my $DST_NODE  = -1;

sub read_graph {
  # FORMAT:
  #  number_of_graph
  #  foreach node
  #    node_number (num_neighbors) neigh1 neigh2 ... neighN 
  my %graph = ();
  while (<>) {       # $_ is the default variable containing the value of the line being processed
    $_ =~ s/#.*//g;  # clear out comments
    $_ =~ s/\s+/ /g; # collapse multiple spaces into a single one
    $_ =~ s/:/ /g;   # get rid of colons in fash output
    if (1 == $.) {
      chomp;         # get rid of the new line character at the end of the line
      if ($_ =~ m/^\s*([1-9][\d]*)\s+([\d\w]+)\s+([\d\w]+)/) {
        $NUM_NODES = $1;
        $SRC_NODE  = $2; # default?
        $DST_NODE  = $3; # default?
	print  "$1 graph in network, $SRC_NODE is the source, $DST_NODE is the destination.\n";
      }
    # build graph data structure
    } elsif ($_ =~ m/([\d\w]+)\s*\(([\d\w]+)\)\s*([\d\w\s]*)/) {
      #              1^^^^^^     2^^^^^^     3^^^^^^^^    
      # $1 -> node number
      my $node = $1;
      # $2 -> number of neighbors
      # $3 -> neighbor list (space delimited)
      ## build neighbor listing
      $graph{$node} = [split(' ',$3)];
    }
  }
  return %graph;
}

sub acyclic {
  my $startNode = shift;
  my $dflabel_ref = shift;
  my $lastDFLabel = shift;
  my $nodes = shift;
  my $string = shift;
  push(@{$string},$startNode);
  # tree edge detection
  if (!exists($dflabel_ref->{$startNode})) {
    $dflabel_ref->{$startNode} = ++$lastDFLabel;  # the order inwhich this link was explored
    foreach my $adjacent (@{$nodes->{$startNode}}) {
      if (!exists($dflabel_ref->{$adjacent})) {      # initial tree edge
        acyclic($adjacent,\%{$dflabel_ref},$lastDFLabel,\%{$nodes},\@{$string});
      } else {
        print join('~>',@{$string}),"\n";
      }
    } 
  }
  pop @{$string};
  # remove startNode entry to facilitate acyclic path determination
  delete($dflabel_ref->{$startNode});
  #$lastDFLabel--;
  return;     
};

my $self = shift;
my %dflabel       = (); # lookup table for dflable
my %backtracked   = (); # lookup table for backtracked edges
my $lastDFLabel   = 0;
my @string        = ();
my %nodes         = read_graph;
# output format is the actual PRE followed by all found strings
acyclic($SRC_NODE,\%dflabel,$lastDFLabel,\%nodes,\@string);

1;
