package Character;
use POSIX;

sub new
{
	my $class = shift;
	my $health = shift;
	my $properties =
	{
		# The position (relative to the main window, not stdscr):
		position =>
		{
			x => 0,
			y => 0,
		},

		# The characters stats (these are initalised with generate_new_stats):
		stats =>
		{
			strength => 0,
			defence => 0,
		},

		# The amount of health the character has:
		health => $health,

		# The amount of candy the player has:
		candy => 5,

		# The character's current costume:
		costume => { name => "", buffs => { strength => 0, defence => 0 } },
	};
	bless $properties, $class;
}

# The symbol we use to identify the character on screen:
sub symbol
{
	die "Attempt to call Character::symbol called!\n";
}

# Modifies the player's position:
sub move
{
	my $self = shift;
	my $vector = shift;
	$self->{position}->{x} += $vector->{x};
	$self->{position}->{y} += $vector->{y};
	if($self->{position}->{x} < 0)
	{
		$self->{position}->{x} = 0;
	}
	elsif($self->{position}->{x} > $main::map->get_size->{x})
	{
		$self->{position}->{x} = $main::map->get_size->{x};
	}
	if($self->{position}->{y} < 0)
	{
		$self->{position}->{y} = 0;
	}
	elsif($self->{position}->{y} > $main::map->get_size->{y})
	{
		$self->{position}->{y} = $main::map->get_size->{y};
	}
}

# Returns the player's position:
sub position
{
	my $self = shift;
	$self->{position};
}

# Adds the given amount of health:
sub add_health
{
	my $self = shift;
	my $value = shift;
	$self->{health} += $value;
}

# Gets health:
sub health
{
	my $self = shift;
	$self->{health};
}

# Adds the given amount of candy:
sub add_candy
{
	my $self = shift;
	my $value = shift;
	$self->{candy} += $value;
}

# Gets candy:
sub candy
{
	my $self = shift;
	$self->{candy};
}

# Generates a new stat spread:
sub generate_new_stats
{
	my $self = shift;
	my $total = shift;
	if($total < 1) { $total = 2 };
	my $a = int(rand($total - 5) + 5);
	my $b = int(rand($total - 5) + 5);
	my $k = (($a + $b) / $total);
	my @values = map { floor($_ /= $k) } ($a, $b);
	$self->{stats} =
	{
		strength => $values[0],
		defence => $values[1],
	};
}

# Gets the player's stats:
sub stats
{
	my $self = shift;
	$self->{stats};
}

# Gets the sum of the base stats and the buffs:
sub total_stats
{
	my $self = shift;
	my $total = { };
	for my $stat(qw/strength defence/)
	{
		$total->{$stat} = $self->{stats}->{$stat} +
			$self->{costume}->{buffs}->{$stat};
	}
	$total;
}

# Returns an anonymous hash reference that can be passed to Window::draw
sub get_drawable
{
	my $self = shift;
	return { x => $self->{position}->{x}, y => $self->position->{y},
		text => $self->symbol };
}

# Sets the character's costume:
sub set_costume
{
	my $self = shift;
	my $value = shift;
	$self->{costume} = $value;
}

# Gets the character's costume:
sub costume
{
	my $self = shift;
	$self->{costume};
}

1;
