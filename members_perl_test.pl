#!/usr/bin/perl

use CGI qw(:standard);


print "Content type: text/html \n\n\n\n\n";
print qq(<html><head><center><title> Registration Page </title></head>);
print qq(<h3>Register now</h3><br>);
print qq(<body><b> <i>  <font color="red"> there could be error here</i> </b></font><br>);
print qq(<form action="members_perl.pl" method="POST"> Enter your full name: <br>);
print qq(<input type ="text" name="fullname"> <br>);
print qq(Choose a username:<br>);
print qq(<input type ="text" name="username">);
print qq(<br>);
print qq(<br>);
print qq(Choose a password  (alphanumeric characters and spaces only):<br>);
print qq(<input type="password" name="password"><br><br>);
print qq(Retype password:<br><input type="password" name="passwordreconfirm"><br>);
print qq(<input type="submit" value="Register"></form></body></html> );

exit(0);
	