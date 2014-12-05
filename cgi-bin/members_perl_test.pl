#!/usr/bin/perl

use CGI qw(:standard);
use warnings;
#use strict;

sub check_valid
{
    my $username= $_[1];
    my $password= $_[2];
    my $name= $_[0];


    my @entries=($name,$username,$password);
    
    foreach $entry (@entries)
        {   my $len=(length($entry));
            if ($entry =~ m/[\(\)\[\]\\\|\/\*\^\{\}\$\.\+\?\,\<\>\:\;\'\"\=\-\_\&\%\#\@\!]/) 
	         {
		        my $error_message="Entries can not contain special characters or commas";
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
	my $username= $_[1];

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
			return $error_message;
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
         return $condition1;
        }
    
    my $condition2=is_username_available($name,$username,$password);

    if  ($condition2!=1)
        {
         return $condition2;
        }
        
    if ($password ne $passreconfirm)
        {
         return "Passwords do not match";
        }
    
    
        
    if (($condition1==1) && ($condition2==1) && ($password eq $passreconfirm))
    {
        append_info($name,$username,$password);    
    }
    return 1;
}

#$feed will be either 1 for success, or an error message if conditions failed
$feed= main(param('fullname'),param('username'),param('password'),param('passwordreconfirm'));

sub printer {

my $reapply = $_[0];

if ($reapply==1)
{
print "Content-Type: text/html\n\n\n\n\n";
print qq(<html> \n);
print qq(<head> \n);
print qq(<title>Redirect to homepage</title> \n);
print q(<meta http-equiv="refresh" content="5; url="http://cgi.cs.mcgill.ca/~ytaher1/register_test.html">);    ### change this link to the home page ##also this submits all forms on the page so homepage cannot contain a form!
print qq(\n </head> \n);
print qq(<body> \n);
print qq(<br><br>Registration successfull, Meta refresh will redirect you in 5 seconds if your browser supports it.<br><br>If not, click the following link to be directed to the homepage. Remember to sign in. \n);
print q(<a href="http://cgi.cs.mcgill.ca/~ytaher1/register_test.html"> http://cgi.cs.mcgill.ca/~ytaher1/register_test.html</a>);   ## change this link to the homepage
print qq(\n </body> \n);
print qq(</html> \n);

}


elsif ($reapply eq "This username is not available, please choose another one.")    #this line is not being executed!?
{
print "Content-Type: text/html\n\n\n\n\n";
print qq(<html>\n);
print qq(<head>\n);
print qq(<center><title> Registration Error </title>\n);
print qq(</head>\n);
print qq(<body>\n);
print qq(<i><font color="red"> \* $reapply\*  </font></i> <br> <br>\n);
print q(<a href="http://cgi.cs.mcgill.ca/~ytaher1/register_test.html">GO BACK TO REGISTRATION PAGE</a>); ##REMEMBER TO CHANGE THIS ONCE YOU RENAME THE FILE
print qq(\n <br><br>link to the home page should go here </body>\n);
print qq(</html>);
}



else
{
print "Content-Type: text/html\n\n\n\n\n";
print qq(<html>\n);
print qq(<head>\n);
print qq(<center><title> Registration Page </title>\n);
print qq(</head>\n);

print qq(<u><b><h1>Register now</h1></u></b>\n);
print qq(<br>\n);
print qq(<br>\n);
print qq(<body>\n);
print qq(<b>Fill in the following fields (alphanumeric characters and spaces only):</b>\n);
print qq(<br>\n);
print qq(<br>\n);
print qq(<i><font color="red"> \* $reapply \*  </font></i>\n);
print qq(<br>\n);

print q(<form action="./members_perl_test.pl" method="POST">);
print qq(\nEnter your full name: <br>\n);
print q(<input type ="text" name="fullname"> <br> <br>);
print qq(\nChoose a username:<br>\n);
print q(<input type ="text" name="username">);
print qq(\n<br>\n);
print qq(<br>\n);
print qq(Choose a password:<br>\n);
print q(<input type="password" name="password">);
print qq(\n<br>\n);
print qq(<br>\n);
print qq(Retype password:<br>\n);
print q(<input type="password" name="passwordreconfirm">);
print qq(\n<br><br>\n);
print q(<input type="submit" value="Register">);
print qq(\n</form>\n);

print qq(<br>\n);
print qq(If you are already a member, click here to login.\n); ##include login link here

print qq(</body>\n);

print qq(</html>);
}


}

printer($feed);
	
