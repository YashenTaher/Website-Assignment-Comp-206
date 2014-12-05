#!/usr/bin/perl
use warnings;
use CGI qw(:standard);

# takes 3 arguments (name,user,pass), all entries, returns 1 if all of them valid,
#error message if any of them are invalid
sub check_valid
{
    my $username= $_[1];
    my $password= $_[2];
    my $name= $_[0];


    my @entries=($name,$username,$password);
    
    foreach $entry (@entries)
        {   $len=(length($entry));
            if ($entry =~ m/[\(\)\[\]\\\|\/\*\^\{\}\$\.\+\?,<>:;'"=-_&%#@!]/) ########################edit here
	         {
		        my $error_message="Entries can not contain escape characters or commas";
		        return $error_message;
		     }
            
	        elsif ($len==0)
	        {
		        my $error_message="Entries cannot be left blank";
		        return $error_message;
	        }
 	        
 	        elsif ($len > 50)
	        {
		        my $error_message="Entries must be less than 50 characters";
		        return $error_message;
	        }

        }
    return 1; 
}

#takes one argument, being the username, returns error if its taken 1 if its available
sub is_username_available
    {
	my $username= $_[0];

	my $file="members.csv";
	open(INFO,"<$file") or die "Could not open file '$file' $!";
	my @lines=<INFO>;

	my @usernames;

	foreach $line (@lines)
	{

	    my @entries=split(',',$line);

	    push(@usernames, $entries[1]);
	}

	foreach $name (@usernames)
            {
		if ($name eq $username)
	        {
			my $error_message="This username is not available, please choose another one.";
			return "\n".$error_message;
		    }
	    }
	return 1;
    }


#accepts 3 arguments (name,user,pass), returns nothing
sub append_info
{   
    my ($name, $username, $password) = @_;
    
    my $line_to_add="$name".","."$username".","."$password"."\n";
    #the last line of the csv file must have a a fresh empty line
    #since we will initialize the csv file to have 3 files and an empty line already
    my $file="members.csv";
    open(my $members,">>$file") or die "Could not open file '$file' $!";
    print $members "$line_to_add";
    close($members);
}

#accepts 3 arguments (name,user,pass,passreconfirm)
sub main
{   
    my $username= $_[1];
    my $password= $_[2];
    my $name= $_[0];
    my $passreconfirm=$_[3];
    
    my $condition1=check_valid($name,$username,$password);
    if  ($condition1!=1)
        {
         print $condition1."\n";
         return 0;
        }
    
    my $condition2=is_username_available($name,$username,$password);

    if  ($condition2!=1)
        {
         print $condition2."\n";
         return 0;
        }
        
    if ($password ne $passreconfirm)
        {
            print 'Passwords do not match';
            return 0;
        }
    
    
        
    if (($condition1==1) && ($condition2==1) && ($password eq $passreconfirm))
    {
        append_info($name,$username,$password);    
    }
    return 1;
	print "it worked"
}


#(fullname, username,pass, pass reconfirm)
main(param('fullname'),param('username'),param('password'),param('passwordreconfirm'));
