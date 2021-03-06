#!/usr/bin/perl

use CGI qw(:standard);
use warnings;
#use strict;        due to the figruation of the apache server, use strict causes my code to crash. I was told by a TA that this isnt my fault and I should just not use it

#this function checks if the user's entries are alphanumeric and less than 50 characters, if conditions are met 1 is returned, else, error message is returned
sub check_valid
{
    my $username= $_[1];
    my $password= $_[2];
    my $name= $_[0];

    my @entries=($name,$username,$password);
    



    foreach $entry (@entries)
        {   my $len=(length($entry));

            	if ($entry =~ /[\(\)\[\]\\\|\/\*\^\{\}\$\.\+\?\,\<\>\:\;\'\"\=\-\_\&\%\#\@\!]/) 
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

#takes one argument, being the username, returns error message if its taken 1 if its available
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


#accepts 3 arguments (name,user,pass), returns nothing, merely appends the given strings in an organized manner into the memberes file
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
    
#check if entries are alpha nummeric, and length les than 50
    my $condition1=check_valid($name,$username,$password);
    if  ($condition1!=1)
        {
         return $condition1;
        }
    
#check is username is available
    my $condition2=is_username_available($name,$username,$password);

    if  ($condition2!=1)
        {
         return $condition2;
        }

#check if passwords match        
    if ($password ne $passreconfirm)
        {
         return "Passwords do not match";
        }
    
    
   #if everything checks out append to members     
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

#if registration successfull, redirect to homepage
if ($reapply==1)
{
print "Content-Type: text/html\n\n\n\n\n";
print qq(<html> \n);
print qq(<head> \n);
print qq(<title>Redirect to homepage</title> \n);
print q(<meta http-equiv="refresh" content="0;url=http://cgi.cs.mcgill.ca/~ytaher1/home_page.html">);  
print qq(\n </head> \n);
print qq(<body> \n);
print qq(<br><br>Registration successfull, Meta refresh will redirect you in 5 seconds if your browser supports it.<br><br>If not, click the following link to be directed to the homepage. Remember to sign in. \n);
print q(<a href="http://cgi.cs.mcgill.ca/~ytaher1/home_page.html"> http://cgi.cs.mcgill.ca/~ytaher1/home_page.html</a>);   
print qq(\n </body> \n);
print qq(</html> \n);

}

#if username is not available, print error page
elsif ($reapply eq "This username is not available, please choose another one.")  
{
print "Content-Type: text/html\n\n\n\n\n";
print qq(<html>\n);
print qq(<head>\n);
print qq(<center><title> Registration Error </title>\n);
print qq(</head>\n);
print qq(<body>\n);
print q(<center>
<style type="text/css" >
body
{
background:url(../image/white-blanket-647343.jpeg) no-repeat center;
}
</style>
<img src="../image/bleeding_martletcircle.png" alt="Logo" style="width:304px;height:228px">
<br> <br>
<font size="35" face="verdana" color="red"> <b><u> Register <u/></b> </font></center>
</center>
<table align="center" cellspacing="40">	
<center>	
     <tr id="menu">
 	<td><a href="home_page.html">     <IMG SRC="../image/Home_page.png" alt="Homepage">      </a></td>
	<td><a href="catalogue.html">      <IMG SRC="../image/Catalouge.png" alt="Catalogue">                </a></td>
	<td><a href="login.html" target="_blank">       <IMG SRC="../image/login.png" alt="Login">                  </a>  </td>
   </tr>
</table>
</center>
<br>);
print qq(<center><i><font color="red"> \* $reapply\*  </font></i> <br> <br>\n);
print q(<a href="http://cgi.cs.mcgill.ca/~ytaher1/register_test.html">GO BACK TO REGISTRATION PAGE</a>); 
print qq(\n <br><br>\n);
print q(<a href="http://cgi.cs.mcgill.ca/~ytaher1/home_page.html">GO BACK TO HOME PAGE</a>);
print qq(</center></html>);
}


#if neither of the above conditions are met, reprint the page, with  the error message  printed at the middle of the page
else
{
print "Content-Type: text/html\n\n\n\n\n";
print qq(<html>\n);
print qq(<head>\n);
print qq(<center><title> Registration Page </title>\n);
print qq(</head>\n);

print qq(<br>\n);
print qq(<br>\n);
print qq(<body>\n);
print q(<center>
<style type="text/css" >
body
{
background:url(../image/white-blanket-647343.jpeg) no-repeat center;
}
</style>
<img src="../image/bleeding_martletcircle.png" alt="Logo" style="width:304px;height:228px">
<br> <br>
<font size="35" face="verdana" color="red"> <b><u> Register <u/></b> </font></center>
</center>
<table align="center" cellspacing="40">	
<center>	
     <tr id="menu">
 	<td><a href="../home_page.html">     <IMG SRC="../image/Home_page.png" alt="Homepage">      </a></td>
	<td><a href="../catalogue.html">      <IMG SRC="../image/Catalouge.png" alt="Catalogue">                </a></td>
	<td><a href="../login.html" target="_blank">       <IMG SRC="../image/login.png" alt="Login">                  </a>  </td>
   </tr>
</table>
</center>
<br>);
print qq(<center>);
print qq(<b>Fill in the following fields (alphanumeric characters only):</b>\n);
print qq(<br>\n);
print qq(<br>\n);
print qq(<i><font color="red"> \* $reapply \*  </font></i>\n);
print qq(<br><br>\n);

print q(<form action="./members_perl_test.pl" method="POST">);
print qq(\nEnter your full name: <br>\n);
print qq(\n<i>\( You may seperate by space \)<i><br>\n);
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
print qq(If you are already a member, click );
print q(<a href="http://cgi.cs.mcgill.ca/~ytaher1/login.html">here</a>);
print qq( to login.\n);

print qq(</body>\n);
print qq(</center>);

print qq(</html>);
}


}

printer($feed);
	
