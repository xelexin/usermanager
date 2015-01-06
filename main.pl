use warnings;
use strict;
use utf8;

require Tk;
use Tk;
use Tk::HList;

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

$frame->Button( -text => 'Punkt',-width => 20,
            -command => \&punkt)->pack();

sub new_user {
$mw->messageBox(-message =>  'dodawanie',-type=>'info');
}

sub show_users {
$mw->messageBox(-message => 'przeglad',-type=>'info');
}
MainLoop();

