use warnings;
use strict;
use utf8;

require Tk;
use Tk;
use Tk::Table;

my $mw = MainWindow->new();
$mw->title("User Manager");
$mw->minsize(qw(500 500));
$mw->maxsize(qw(500 500));
$mw->resizable(0,0);

my $menubar = $mw->Frame(-relief=>'groove',-borderwidth=>3)->pack('-side'=>'top',-fill=>'x');
my $menuUser = $menubar->Menubutton(-text=>'Użytkownicy',-tearoff=>0)->pack(-side=>'left');
$menuUser->AddItems(	["command" => "Dodaj",
			"-command" => \&new_user],
			["command" => "Pokaż",
			"-command" => \&show_users]);

my $frame = $mw->Frame(-background=>'green')->pack(-side =>'top',-fill=>'x');

sub new_user {
$mw->messageBox(-message =>  'dodawanie',-type=>'info');
}

sub show_users {
my $filename = '/etc/passwd';
my @passwd;
my $size=0;
open(FILE, $filename) or die "Could not read from $filename, program halting.";
while(<FILE>)
{
  chomp;
  my @tmp = split(':', $_);
	$passwd[$size][0]=$tmp[0];
	$passwd[$size][1]=$tmp[2];
	$size++;
}
close FILE;
my $table = $frame->Table(-columns => 2,
                                -rows => $size,
                                -fixedrows => 1,
                                -scrollbars => 'oe',
                                -relief => 'raised');
my @columnnames=('Nazwa','UID');
foreach my $col (0 .. @columnnames)
{
  my $tmp_label = $table->Label(-text =>$columnnames[$col] , -width => 8, -relief =>'raised');
  $table->put(0, $col+1, $tmp_label);
}

for(my $i=1;$i<=$size;$i++)
{
	my $tmp_label = $table->Label(-text => $passwd[$i][0],
                                  -padx => 2,
                                  -anchor => 'w',
                                  -background => 'white',
                                  -relief => "groove");
    	$table->put($i, 1, $tmp_label);
	$tmp_label = $table->Label(-text => $passwd[$i][1],
					-padx => 2,
					-anchor => 'w',
					-background => 'white',
					-relief => "groove");
	$table->put($i,2,$tmp_label);
}
$table->pack();
}#end of sub show_users
MainLoop();

