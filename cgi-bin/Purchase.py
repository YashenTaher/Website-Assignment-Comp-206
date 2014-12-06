#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import cgi, cgitb, csv 

print "Content-Type: text/html;charset=utf-8"
print
cgitb.enable() 

def addRow(item, price, quantity):
	amount = price*quantity 
	row = """<tr>
					<td>%s</td>
					<td>%s</td>
					<td>%s</td>
					<td>%s</td>
			</tr>"""%(item, price, quantity, amount)
	return row 

nestpr=300000
buildingpr=4100000
ballotspr=0.05
nestq=1
buildingq=1
ballotsq=10000
form = cgi.FieldStorage() 
namenaked = form.getvalue('user') 
namestr = str(namenaked)
name = "'" + namestr + "'" 

with open('LoggedIn.csv', 'r') as names:
	compare = csv.reader(names, delimiter=",")
	rows = list(compare) 
	rows1 = []
	for row in rows: 
		member = str(row[0])
		rows1.append(member)
		
	if name in rows1 or namenaked in rows1 or namestr in rows1:
		buildingamount = form.getvalue('build')			
		nestamount = form.getvalue('thenest')
		ballotsamount = form.getvalue('ballot')
		buildingamount = int(buildingamount)
		nestamount = int(nestamount)
		ballotsamount = int(ballotsamount)
		check = form.getlist('checkbox')
		addnest=""
		addbuilding=""
		addballots=""
		nestcst=0
		ballotcst=0
		buildingcst=0
		
		html = """<html>
		<center>
		<style type="text/css" >
		body
		{
		background:url(../image/white-blanket-647343.jpeg) no-repeat center;
		}
		</style>
		<img src="../image/bleeding_martletcircle.png" alt="Logo" style="width:304px;height:228px">
<br> <br>

<table align="center" cellspacing="40">	
<center>	
     <tr id="menu">
 	<td><a href="../home_page.html">     <IMG SRC="../image/Home_page.png" alt="Homepage">      </a></td>
	<td><a href="../catalogue.html">      <IMG SRC="../image/Catalouge.png" alt="Catalogue">                </a></td>
	<td><a href="../login.html" target="_blank">       <IMG SRC="../image/login.png" alt="Login">                  </a>  </td>
   </tr>
</table>
</center>
<br> <center> INVOICE for: """ 
		html = html+namenaked 
		htmlextra = """ <table border="1"><th>
				<td>Price ($)</td>
				<td>Quantity</td>
				<td>Cost ($)</td>
			</th>"""
		html=html+htmlextra

		if "nest" in check:
			nestcst=nestpr*nestamount
			nestq = nestq-nestamount
			addnest = addRow("THE NEST CAFE", nestpr, nestamount)
			html = html+addnest
			
		if "ballots" in check:
			ballotcst=ballotspr*ballotsamount
			ballotsq=ballotsq-ballotsamount
			addballots = addRow("GA BALLOTS", ballotspr, ballotsamount)
			html = html+addballots

		if "building" in check:
			buildingcst=buildingpr*buildingamount
			buildingq=buildingq-buildingamount 
			addbuilding = addRow("SSMU BROWN BUILIDNG", buildingpr, buildingamount)
			html=html+addbuilding

		with open('inventory.csv', 'wb') as invfile:
			reader = csv.writer(invfile, delimiter=',')
			reader.writerow(['nest', nestq, nestpr])
			reader.writerow(['building',  buildingq, buildingpr])
			reader.writerow(['ballots', ballotsq, ballotspr])
		subtotal = buildingcst+ballotcst+nestcst
		tax = subtotal * .13
		total = subtotal+tax
		htmlsubtotal= """ <tr>
		<td>subtotal</td>
		<td></td>
		<td></td>
		<td>%s</td> </tr>"""%(subtotal)
		htmltax = """<tr>
		<td>tax</td>
		<td></td>
		<td></td>
		<td>%s</td> </tr>"""%(tax)
		htmltotal = """<tr>
		<td>total</td>
		<td></td>
		<td></td>
		<td>%s</td> </tr>"""%(total)
		html = html+htmltax
		html = html+htmlsubtotal
		html=html+htmltotal
		htmlend = """</table> """
		html=html+htmlend
		links = """<body>
		<a href="http://cgi.cs.mcgill.ca/~ytaher1/home_page.html">Return to where the heart is</a><br>
		<a href="http://cgi.cs.mcgill.ca/~ytaher1/catalogue.html">Buy more stuff</a>
		</body></center>"""
		html=html+links
		htmlfinal = """</html>"""
		html=html+htmlfinal
		print html
		
	else: 
			
		notlogged = """<html> <header><h1>ERROR 2342384-3453143143143143143143143143141212121212199</h1></header> \
		<body> 
		  <p> We're sorry, you  are currently not logged in. Please select one of the following options:			<ul>
		<li><a href="http://cgi.cs.mcgill.ca/~ytaher1/login.html">Login</a></li>
		<li><a href="http://cgi.cs.mcgill.ca/~ytaher1/register_test.html">Register</a</li>
		<li><a href="http://cgi.cs.mcgill.ca/~ytaher1/catalogue.html">Return to Catalogue</a></li>
			</ul>	    	
		</p>
		</html>"""
		print notlogged






