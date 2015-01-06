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
my $new_user = $menubar->Menubutton(-text=>'Dodaj uzytkownika')->pack(-side=>'left');
my $users = $menubar->Menubutton(-text=>'Użytkownicy')->pack(-side=>'left');

my $frame = $mw->Frame(-background=>'green')->pack(-side =>'top',-fill=>'x');

$frame->Button( -text => 'Punkt',-width => 20,
            -command => \&punkt)->pack();


MainLoop();

