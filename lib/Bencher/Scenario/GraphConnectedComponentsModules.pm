package Bencher::Scenario::GraphConnectedComponentsModules;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

our $scenario = {
    summary => 'Benchmark graph topological sort modules',
    modules => {
    },
    participants => [
        {
            module => 'Data::Graph::Util',
            function => 'connected_components',
            code_template  => 'Data::Graph::Util::connected_components(<graph>)',
            result_is_list => 1,
        },
        {
            module => 'Graph',
            function => 'connected_components',
            code_template  => <<'CODE',

my $g = Graph->new(undirected => 1);
my $connections = <graph>;
for my $src (keys %$connections) {
    for my $dest (@{ $connections->{$src} }) {
        $g->add_edge($src, $dest);
    }
}

my @subgraphs = $g->connected_components;
my @allgraphs;

for my $subgraph (@subgraphs) {
    push @allgraphs, {};
    for my $node (@$subgraph) {
        if (exists $connections->{$node}) {
            $allgraphs[-1]{$node} = [ @{ $connections->{$node} } ];
        }
    }
}
@allgraphs;
CODE
            result_is_list => 1,
        },
    ],

    datasets => [
        {
            name => 'empty',
            args => {
                graph => {
                },
            },
        },

        {
            name => '2nodes-1edge',
            args => {
                graph => {
                    a => ['b'],
                },
            },
        },

        {
            name => '6nodes-5edges-2subgraphs',
            args => {
                graph => {
                    a => ['b'],
                    b => ['c','d'],
                    d => ['c'],
                    e => ['f'],
                },
            },
        },

        {
            name => '100nodes-500edges-1subgraph',
            args => {
                graph => {
                    (map { (sprintf("%03d",$_) => [$_==1 ? ("002".."021") : (grep {$_<=100} sprintf("%03d", $_+1), sprintf("%03d", $_+2), sprintf("%03d", $_+3), sprintf("%03d", $_+4), sprintf("%03d", $_+5))]) } 1..100)
                },
            },
        },
    ], # datasets
};

1;
# ABSTRACT:
