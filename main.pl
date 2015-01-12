use warnings;
use strict;
use utf8;

require Tk;
use Tk;
use Tk::Table;
use Tk::JBrowseEntry;

my @usernames;
my @uids;

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

my $frame = $mw->Frame()->pack(-side =>'top',-fill=>'x');

sub new_user {

my $textPassword;
my $textLogin;
my $textUID;
my $dir;
my $save;

my $generatedPassword = generatePassword(10);

$frame->destroy();
$frame = $mw->Frame()->pack(-side =>'top',-fill=>'x');
my $i=0; #row index
my $labelInputLogin = $frame->Label(-text => "Login")->grid(-column=>0,-row=>$i);
my $inputLogin = $frame->Entry(-width => 20,-background=>'white',-textvariable=>\$textLogin)->grid(-column=>1,-row=>$i);
$i++;
my $labelInputPassword = $frame->Label(-text => "Hasło")->grid(-column=>0,-row=>$i);
my $inputPassword = $frame->Entry(-width=>20,-background=>'white',-show=>"*",-textvariable=> \$textPassword)->grid(-column=>1,-row=>$i);
$i++;
my $labelGeneratedPasswordLabel = $frame->Label(-text => "Wygenerowane losowe hasło")->grid(-column=>0,-row=>$i);
my $labelGeneratedPassword = $frame->Label(-textvariable=>\$generatedPassword)->grid(-column=>1,-row=>$i);
$i++;
my $buttonGeneratePassword = $frame->Button(-text=>"Użyj hasła",-command=>sub{ $textPassword=$generatedPassword; })->grid(-column=>0,-row=>$i,-columnspan=>2);
$i++;
my @comboboxValue = getUIDs();
my $comboboxUID = $frame->JBrowseEntry(
																				-label=>"UID",
																				-variable => \$textUID,
																				-state => 'normal',
																				-choices=>\@comboboxValue )->grid(-column=>0,-row=>$i,-columnspan=>2); 
$i++;
my $labelCopyDotFiles = $frame->Label(-text => "Skopiuj pliki kropkowe")->grid(-column=>0,-row=>$i);
my $buttonCopyDotFiles = $frame->Button(-text=>"Wybierz folder",-command=>sub{$dir = $frame->chooseDirectory(-initialdir=>'/home',-title =>'Wybierz katalog z ktorego skopiowac pliki');})->grid(-column=>1,-row=>$i);
$i++;
my $types = [['Plik konfiguracji','.conf']];
my $buttonSave = $frame->Button(-text=>'Zapisz konfiguracje',-command=>sub{$save = $frame->getSaveFile(-filetypes=>$types,-defaultextension =>'.conf'); executeSaveFile($textLogin,$textPassword,$textUID,$dir,$save)})->grid(-column=>0,-row=>$i,-columnspan=>2);
$i++;
my $buttonAddUser = $frame->Button(-text=>"Dodaj użytkownika",-command=>sub{executeAddUser($textLogin,$textPassword,$textUID,$dir)})->grid(-column=>0,-row=>$i,-columnspan=>2);
}#end of sub new_user


sub show_users {
$frame->destroy();
$frame = $mw->Frame()->pack(-side =>'top',-fill=>'x');

@usernames = `sort -n -t ':' -k3 /etc/passwd | cut -d ':' -f1`;
@uids = `sort -n -t ':' -k3 /etc/passwd | cut -d ':' -f3`;
my $size = `wc -l /etc/passwd | cut --bytes=1-2`;
my @columnnames=('Nazwa','UID','Edytuj','Usuń');
my $table = $frame->Table(-columns => 4,
                                -rows => $size,
                                -fixedrows => 1,
                                -scrollbars => 'oe',
                                -relief => 'raised');
foreach my $col (0 .. @columnnames)
{
  my $tmp_label = $table->Label(-text =>$columnnames[$col] , -width => 8, -relief =>'raised');
  $table->put(0, $col+1, $tmp_label);
}

for(my $i=1;$i<$size;$i++)
{
	my $tmp_label = $table->Label(-text => $usernames[$i],
                                  -padx => 2,
                                  -anchor => 'w',
                                  -background => 'white',
                                  -relief => "groove");
  $table->put($i, 1, $tmp_label);
	$tmp_label = $table->Label(-text => $uids[$i],
					-padx => 2,
					-anchor => 'w',
					-background => 'white',
					-relief => "groove");
	$table->put($i,2,$tmp_label);	
	my $tempi = $i;
	my	$button_edit = $table->Button(-text => "Edytuj",
            -cursor => 'boat',
            -width => 8,
						-command => sub{edit($tempi)}
            );
	$table->put($i,3,$button_edit);
	my $button_del = $table->Button(-text => "Usuń",
						-width => 8,
						-command => sub{executeDeleteUser($usernames[$tempi]);}
						);
	$table->put($i,4,$button_del);
}
$table->pack();
}#end of sub show_users
sub edit{
my $id = $_[0];

$frame->destroy();
$frame = $mw->Frame()->pack(-side =>'top',-fill=>'x');

#print "$passwd[$id][0]\n";
}#end of sub edit

sub executeAddUser 
{
	my($user,$pass,$uid,$dir) = @_;
	my $command = "useradd -u $uid $user >/dev/null";
	#print $command."\n";
	system($command);
	system("echo $pass | passwd --stdin $user >/dev/null");
	if(defined $dir)
	{
		`cp $dir/.* /home/$user/ &>/dev/null`
	}
	show_users();
}#end of sub executeAddUser

sub executeSaveFile
{
	my($user,$pass,$uid,$dir,$file) = @_;
	`echo User: $user >>$file`;
	`echo Passowrd: $pass >>$file`;
	`echo UID: $uid >>$file`;
  `echo Shell: /bin/bash >>$file`;
	`echo Home Directory: /home/$user >>$file`;
	`sudo chown root:root $file`;
  `sudo chmod 400 $file`;
}#end of sub executeSaveFile

sub executeDeleteUser
{
	my($user) = @_;
	system("userdel -fr $user");
	show_users();
}

sub getUIDs
{
	my @busyUID = `cat /etc/passwd | cut -d ":" -f3 | sort -n`;
	my @output;
	for(my $i=500;$i<601;$i++)
	{
		my $test=0;
		for(my $j=0;$j<@busyUID;$j++)
		{
			if($i==$busyUID[$j])
			{
				$test=1;
				last;
			}
		}
		if($test==0)
		{
				push(@output, $i);
		}
	}
	return @output;
}

sub generatePassword 
{ 
	my $length = $_[0]; 
	my $pwd;
	my @my_char_list = (('A'..'Z'), ('a'..'z'), ('!','@','%','^'), (0..9));
	my $range_dis = $#my_char_list + 1;
	for (1..$length)
	{
  	$pwd .= $my_char_list[int(rand($range_dis))];
	}
	return $pwd
}

MainLoop();

