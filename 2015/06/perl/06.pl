use List::Util qw[max];

my $part1 = [[0 x 1000] x 1000]; 
my $part2 = [[0 x 1000] x 1000]; 

foreach $line (<>) {
    my ($mode, $x1, $y1, $x2, $y2) = $line =~ /(.*) (\d+),(\d+) through (\d+),(\d+)/;
    foreach $x ($x1..$x2) {
        foreach $y ($y1..$y2) {
            if ($mode eq "turn on") {
                $part1->[$x]->[$y] = 1;
                $part2->[$x]->[$y] += 1;
            } elsif ($mode eq "toggle") {
                $part1->[$x]->[$y] = 1 - $part1->[$x]->[$y];
                $part2->[$x]->[$y] += 2;
            } elsif ($mode eq "turn off") {
                $part1->[$x]->[$y] = 0;
                $part2->[$x]->[$y] = max($part2->[$x]->[$y] - 1, 0);
            }
        }
    }
}

my $sol1 = 0;
my $sol2 = 0;
foreach $x (0..999) {
    foreach $y (0..999) {
        $sol1 += $part1->[$x]->[$y];
        $sol2 += $part2->[$x]->[$y];
    }
}

print $sol1 . "\n" . $sol2 . "\n";
