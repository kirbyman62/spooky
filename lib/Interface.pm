package Interface;
use Curses;
use Data::Dumper;

# Lump windows in an easy-to-use package:
package Window
{
	# The box drawing chracters for the window's border:
	my %BOX_CHARS =
	(
		corners =>
		{
			topleft => "┌",
			topright => "┐",
			bottomleft => "└",
			bottomright => "┘"
		},
		horizontal => "─",
		vertical => "│"
	);

	# Creates a new window:
	sub new
	{
		my $class = shift;
		my $properties = shift;
		$$properties{window} = Curses::newwin(
			$$properties{height},
			$$properties{width},
			$$properties{y},
			$$properties{x}
		);
		bless $properties, $class;
	}

	# Draws the window:
	sub draw
	{
		my $self = shift;
		my $args = shift;
		Curses::clear($self->{window});
		Curses::border(
			$self->{window},
			$BOX_CHARS{vertical},
			$BOX_CHARS{vertical},
			$BOX_CHARS{horizontal},
			$BOX_CHARS{horizontal},
			$BOX_CHARS{corners}{topleft},
			$BOX_CHARS{corners}{topright},
			$BOX_CHARS{corners}{bottomleft},
			$BOX_CHARS{corners}{bottomright}
		);
		# If we have anything else to print, print that:
		if(defined $args)
		{
			for my $drawable(@$args)
			{
				Curses::addstr(
					$self->window,
					$drawable->{y} + 1,
					$drawable->{x} + 1,
					$drawable->{text}
				);
			}
		}
		Curses::refresh($self->{window});
	}

	# Returns the Curses::Window object:
	sub window
	{
		my $self = shift;
		$self->{window};
	}
};

# Set up curses and the interface:
sub new
{
	my $class = shift;

	# Initialise curses:
	Curses::initscr();
	Curses::curs_set(0);
	Curses::noecho();
	Curses::clear();

	# Create the main window:
	Curses::getmaxyx(my $y, my $x);
	my $properties =
	{
		windows =>
		{
			main => Window->new({
				width => ($x - 16),
				height => ($y - 16),
				x => 8,
				y => 8,
			}),

			stats => Window->new({
				width => 19,
				height => 5,
				x => 8,
				y => ($y - 7),
			}),

			textbox => Window->new({
				width => (($x - 16) - 22),
				height => 5,
				x => 30,
				y => ($y - 7),
			}),
		},
	};
	bless $properties, $class;
}

# Various input forms:
sub input_yesno
{
	my $input;
	while(($input = Curses::getch) !~ /^[YyNn\n]$/) { };
	if($input =~ /^[Yy\n]$/) { return 1; } else { return 0; }
}

# Sets the text within the textbox:
sub set_textbox
{
	my $self = shift;
	$self->{textbox} = shift;
}

# Gets the textbox text:
sub get_textbox
{
	my $self = shift;
	$self->{textbox};
}

# Draw the interface:
sub draw
{
	my $self = shift;
	my $args = shift;
	Curses::clear();
	Curses::refresh;
	for my $win(keys %{$self->{windows}})
	{
		$self->{windows}->{$win}->draw($args->{$win});
	}
}

# Close curses:
sub close
{
	Curses::endwin;
}

1;
