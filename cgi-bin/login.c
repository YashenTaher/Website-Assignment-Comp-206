#include <stdlib.h>
#include <stdio.h>
#include <string.h>



int unencode(char *src, char *last, char *user, char *pw, int *ulen, int *pwlen){   // read username and password from html form input
	
	
	int i=0;
	int j;
	
		for(;*src !='&';user++,src++){												// read username until ampersand
			*user=*src;
			i++;																	// i tracks length of username
		}
		*ulen=i;

		src=src+10; 																// src+10 to skip past "&password="
		i=0;

		for(; src != last; src++, pw++){
			*pw = *src;	
			if(!isalnum(*pw)) return 1;
																					// read password until end of string(includes newline)
																					// returns 1 to main if password not alphanumerical
			i++;																
		}
		*pwlen=i;

		return 0;
}


int stringcompare(char * string, char *tmp, int *size){								// compare strings from input and from members list

	int i,c,result;

		result =0;																	
		
		for(i=0;i<size;i++){
			if(string[i]!=tmp[i]) result++;											// check if each character in the input string matches with string from members list
		}
		
		
		if(size==0) result ++;														// check that input exists
		c=size;
		if(isalnum(tmp[c])) result ++;												// if members string is longer than input string, password/username does not match 
		return result;																// returns 0 to verification if strings match																

}

int verification(char *username, char *password, int *ulen, int *pwlen){			

	char line[100], *tmp[3][50];													// line stores form input
																					// tmp temporarily holds 3 strings of max 50 char
	FILE *memlist=fopen("members.csv", "r");									// read from members list
	int i,j;
	char*token, *ch, field[100];


	if(memlist==NULL){
		printf("can't find file..\n");
	}

	else{
		
		while(!feof(memlist)){

			for(i=0;i<3;i++){
				for(j=0;j<50;j++) tmp[i][j] = NULL;									// initilize tmp 
			}

			fgets(&line,100,memlist);												// read first line from members.csv
			
				i=0;
				for(token=strtok(line,",");token!=NULL; token=strtok(NULL,",")){	// separate string by commas
					strcpy(tmp[i], token);											// there are three fields separated by two commas: name, username, password
																					// store in tmp[0], tmp[1], tmp[2] 
					i++;
				}
				if((stringcompare(username,tmp[1], ulen)==0)&&(stringcompare(password,tmp[2],pwlen) == 0)){
					
					//printf("%s\n", tmp[0]);										// tmp[0] should hold full name
											
					FILE *edit=fopen("../catalogue.html", "a+");							//copy index.html
					FILE *file=fopen("../tempcatalogue.html", "w");					//into tempcatalogue.html - this is what gets called


					fseek(file, 0, SEEK_SET);										

					for(i=0;i<1060;i++){												//copy characters into tempcatalogue, insert value = full name, copy rest of file
						ch=fgetc(edit);
						fputc(ch,file);
					}
						
					fprintf(file, "value=\"");					
					fprintf(file, "%s\"", tmp[1]);
			
					while((ch=fgetc(edit)) !=EOF) fputc(ch,file);
					

					fclose(file);
					fclose(edit);

					return 0;
				}
																					// if inputted username and password match both the username and password stored in tmp return 0 to main
		}	
		
		return 1;	
	}


	fclose(memlist);
}


void append(char *username, char *password){										// append logged in users to list

	FILE *loglist=fopen("LoggedIn.csv","a+");
	fprintf(loglist, "%s, %s\n", username, password);
	fclose(loglist);

}


int main(){
	char input[100], user[100], pw[100];
	int i;
	int *ulen, *pwlen;
	
	int n=atoi(getenv("CONTENT_LENGTH"));											// retrieve length of html form input =n
	printf("Content-Type: text/html;charset=us-ascii\n\n");
	if(n==NULL) printf("something went wrong(content_length=NULL)\n");				

	fgets(input, n+1, stdin);														// read form input
	if(unencode(input+9, input+n, user, pw, &ulen, &pwlen)==0){						// unencode input, do if pw is only alphanumerical
																					// input +9 to skip past "username="
	

		char *username = (char*)malloc(ulen +1);									// malloc for strings with exact length to hold username, password
		for(i=0;i<ulen;i++){
			username[i]=user[i];
		}
		
		char *password = (char*)malloc(pwlen +1);
		for(i=0;i<pwlen;i++){
			password[i]=pw[i];
		}

		if(verification(username,password, ulen, pwlen)==0){
																					// after logging in, redirect to catalogue page
																					
			printf("<meta http-equiv=\"refresh\" content=\"0; url=http://cgi.cs.mcgill.ca/~ytaher1/tempcatalogue.html\">\n");
			append(username, password);
		}
		else {
																					// if login fails, redirect to errors page

			 printf("<meta http-equiv=\"refresh\" content=\"0; url=http://cgi.cs.mcgill.ca/~ytaher1/error.html\">\n");
			 return 0;

		}
	}

	else{
		printf("<meta http-equiv=\"refresh\" content=\"0; url=http://cgi.cs.mcgill.ca/~ytaher1/error.html\">\n");
	}

	
}