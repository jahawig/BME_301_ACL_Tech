/******************************************************************************
 * @file: functions.c
 *
 * WISC NETID: hawig@wisc.edu
 * CANVAS USERNAME: hawig
 * WISC ID NUMBER: 9078102226
 * OTHER COMMENTS FOR THE GRADER (OPTIONAL)
 *
 * @creator: Jacob Hawig (hawig@wisc.edu)
 * @modified: SUBMISSION DATE
 *****************************************************************************/
 
#include <stdio.h>
#include "functions.h"

// Some macros that may be useful to you 
#define MAX_USERNAME_LEN    32
#define MAX_EMAIL_LEN       32
#define MAX_DOMAIN_LEN      64
#define MIN_PASSWORD_LEN    8
#define MAX_PASSWORD_LEN    16
#define NEW_LINE_CHAR       10

// Set this to 1 to enable dbgprintf statements, make sure to set it back to 0 
// before submitting!
#define DEBUG               0 
#define dbgprintf(...)      if (DEBUG) { printf(__VA_ARGS__); }

/******************************************************************************
 * Helper functions
 *****************************************************************************/

// ADD ANY HELPER FUNCTIONS YOU MIGHT WRITE HERE 
// Examples: IsLetter, IsDigit, Length, Find...



int IsLetter(char test_character){
	int ASCII_val;
	ASCII_val = (int)(test_character);
	if((ASCII_val >= 65 && ASCII_val <= 90) || (ASCII_val >= 97 && ASCII_val <= 122)){
		return 1;
	} else {
		return 0;
	}
}

int isUpper(char test_character){
	int ASCII_val;
	ASCII_val = (int)(test_character);
	if(ASCII_val >= 65 && ASCII_val <= 90){
		return 1;
	}else{
		return 0;
	}
}

int isLower(char test_character){
	int ASCII_val;
	ASCII_val = (int)(test_character);
	if(ASCII_val >= 97 && ASCII_val <= 122){
		return 1;
	}else{
		return 0;
	}
}	

int IsDigit(char test_character){
	int ASCII_val;
	ASCII_val = (int)(test_character);
	if(ASCII_val >= 48 && ASCII_val <= 57){
		return 1;
	} else {
		return 0;
	}
}

int lengthOf(char string[], size_t len){
	int size = 0;
	for(int i = 0; i < len; i++){
		if(string[i] == '\0'){
			return size;
		}
		size++;
	}
	return -1;
}

int findCharIndex(char string[], char target, int string_len){
	for(int i = 0; i < string_len; i++){
		if(string[i] == target){
			return i;
		}
	}
	return -1;
}

// If 1, top-level domain is present, if -1, it is not!
int top_level(char string[],int string_len){
	if(string_len < 4){
		return -1;
	}
	
	// Checking char array to see if top level domain matches anywhere
	if(string[string_len-4] == '.'){
		if(string[string_len-3]=='e' && string[string_len-2]=='d' && string[string_len-1] =='u'){
			return 1;
		} else if(string[string_len-3]=='c' && string[string_len-2]=='o' && string[string_len-1] =='m') {
			return 1;
		} else if(string[string_len-3]=='n' && string[string_len-2]=='e' && string[string_len-1] =='t'){
			return 1;
		} else {
			return -1;
		}
	} else {
		return -1;
	}
	
}

// Helper method for length of ___ can count the number of characters
// and then multiply that count by 2 to get the space that is would take up
// Have to think about this some more but I think it would work
//

/******************************************************************************
 * Verification functions
 *****************************************************************************/

/*
 * A username must begin with a letter [A-Z, a-z], contain 32 characters
 * or less, and  may only consist of letters, underscores, or 
 * digits [A-Z, a-z, _, 0-9]. An error message is displayed if any of 
 * these conditions are not met. Only print the first applicable error 
 * message. 
 *
 * @param user : The username string
 * @param len : Size of the username input buffer
 * @return 1 if valid, 0 if not
 */
int Verify_Username(char user[], size_t len) {

    /* BEGIN MODIFYING CODE HERE */
    dbgprintf("This line only prints if DEBUG is set to 1\n");
	// Checks the ASCII value of the char at the start of the username
	// If the ASCII value is not one that represents letter, error is thrown.
	if(!IsLetter(user[0])){
		printf(ERROR_01_USER_START_INVALID);
		return 0;
    }
	
	// Checks the length of the Username
	int length = lengthOf(user, len);
	
	if(length > 32){
		printf(ERROR_02_USER_LEN_INVALID);
		return 0;
	}
	
	// Checking the characters in the 
	for (int i = 0; i < length; i++){
		if(IsDigit(user[i]) || IsLetter(user[i]) || user[i] == '_'){
			;
		} else {
			printf(ERROR_03_USER_CHARS_INVALID);
			return 0;
		}
	}
    /* END MODIFYING CODE HERE */

    printf(SUCCESS_1_USER);
    return 1;
}

/*
 * An email address has four parts:
 *      name
 *          exists
 *          must start with letter
 *          max 32 characters
 *          may contain only letters and digits
 *      @ symbol
 *          exists
 *      domain name
 *          exists
 *          max of 64 characters
 *          composed of one or more subdomains separated by .
 *          subdomain must begin with a letter
 *          subdomains may contain only letters and digits
 *      top-level domain 
 *          must be [.edu, .com, .net]
 *
 * If the email address contains one or more errors print only the first
 * applicable error from the list.
 *
 * Note this task is based on a real world problem and may not be the best 
 * order to approach writing the code.
 *
 * @param email : The email string
 * @param len : Size of the email input buffer
 * @return 1 if valid, 0 if not
 */
int Verify_Email(char email[], size_t len) {

    /* BEGIN MODIFYING CODE HERE */
	// TESTED
	if(email[0] == '@'){
		printf(ERROR_04_EMAIL_MISSING_NAME);  // example @domain.com
		return 0;
	}
	// TESTED
	if(!IsLetter(email[0])){
		printf(ERROR_05_EMAIL_START_INVALID); // example 47jaw@gmail.com
		return 0;
	}
	
	int length_of_email = lengthOf(email,len);
    int name_length = 0;
	int at_index = findCharIndex(email,'@',length_of_email);
	int top_present = top_level(email, length_of_email);
	if(at_index != -1){
		name_length = at_index;
	} else if (top_present == 1){
		name_length = length_of_email -4;
	} else {
		name_length = length_of_email;
	}
	
	// TESTED - WORKING
	// example abcdefghijklmnopqrstuvwxyz7890123@gmail.com
	// example abcdefghijklmnopqrstuvwxyz7890123.wisc.edu
	if(name_length > 32){
		printf(ERROR_06_EMAIL_NAME_LEN_INVALID); 
		return 0;
	}
	
	// TESTED - WORKING
	// example mike.wisc.edu
	// example hawig905_jacob@wisc.edu
	for(int i = 0; i < name_length - 1; i++){
		if(IsDigit(email[i]) || IsLetter(email[i])){
			continue;
		} else {
			printf(ERROR_07_EMAIL_NAME_CHARS_INVALID); 
			return 0;
		}
	}
    
	// TESTED - WORKING
	// example hawig
	// Once there is a period for a seprator it will send it to error 7 invalid
	// Can only be inputs without a period and without an @ sign
    if(at_index == -1){
		printf(ERROR_08_EMAIL_MISSING_SYMBOL);
		return 0;
	}
    
	
	int domain_length = 0;
	// At this point we can assume there is an @ in the email address because we 
	// would have already returned if not.
	int domain_start = at_index + 1;
	// Subtracting an additional one because we don't need to include the @ sign.
	if(top_present == 1){
		domain_length = length_of_email - name_length - 4 - 1;
	} else {
		domain_length = length_of_email - name_length - 1;
	}
	
	// TESTED - works with given example
	if(domain_length <= 0){
		printf(ERROR_09_EMAIL_MISSING_DOMAIN); // example mike@.edu
		return 0;
	}
    
	// Tested and working
	// example (works) = ah@abcdefghijklmnopqrstuvwxyz(789(1-0)*3).edy
	// example (doesn't work) = ah@abcdefghijklmnopqrstuvwxyz(789(1-0)*3).edyy
	if(domain_length > 64){
		printf(ERROR_10_EMAIL_DOMAIN_LEN_INVALID);
		return 0;
	}
    
	// TESTED and working
	// Example hawig@.wisc.edu
	if(!IsLetter(email[domain_start])){
		printf(ERROR_11_EMAIL_DOMAIN_START_INVALID);
		return 0;
	}
	
	// TESTED WORKING
	// Example hawig@cs.wisc.345.here.edu
	// Second case of invalid domain start
	// When it is further down the line
	for(int i = domain_start; i < domain_start + domain_length; i++){
		if(email[i] == '.'){
			if((i+1) < domain_start + domain_length){
				if(IsLetter(email[i+1])){
					;
				} else{
					printf(ERROR_11_EMAIL_DOMAIN_START_INVALID);
					return 0;
				}
			}
			
		}
	}
    
	
	// Example hawig@cs.wisc%.edu
	for(int i = domain_start; i < domain_start + domain_length; i++){
		if(!IsLetter(email[i])){
			if(!IsDigit(email[i])){
				if(!(email[i] == '.')){
					printf(ERROR_12_EMAIL_DOMAIN_CHARS_INVALID);
					return 0;
				}
			}
		}
	}
    
	// Any email that does not end with .net, .com or .edu
	if(top_present != 1){
		printf(ERROR_13_TOP_LEVEL_DOMAIN_INVALID);
		return 0;
	}
    
    /* END MODIFYING CODE HERE */
    
    printf(SUCCESS_2_EMAIL);
    return 1;
}

/*
 * The following password requirements must be verified:
 *  - May use any character except spaces (i.e., "my password" is invalid)
 *  - Must contain at least 8 characters (i.e., "Password" has 8 characters 
 *    and is valid)
 *  - May have at most 16 characters (i.e., "1234567890Abcdef" has 16 
 *    characters and is valid)
 *  - Must contain at least one upper case character [A-Z]
 *  - Must contain at least one lower case character [a-z]
 *
 * @param pwd : The original password string
 * @param len : Size of the original password input buffer
 * @return 1 if valid, 0 if not
 */
int Verify_Password(char pwd[], size_t len) {

    /* BEGIN MODIFYING CODE HERE */
	int pwd_length = lengthOf(pwd,len);
	
	// Checking for Space Characters
	for (int i = 0; i < pwd_length; i++){
		if(pwd[i] == ' '){
			printf(ERROR_14_PWD_SPACES_INVALID);
			return 0;
		}
	}
	
	// Checking Password Length (Too Short)
	if(pwd_length < 8){
		printf(ERROR_15_PWD_MIN_LEN_INVALID);
		return 0;
	}
    
	// Checking Password Length (Too Long)
	if(pwd_length > 16){
		printf(ERROR_16_PWD_MAX_LEN_INVALID);
		return 0;
	}
    
	// Checking Upper Case Count
	int upperCount = 0;
	for(int i = 0; i < pwd_length; i++){
		if(isUpper(pwd[i])){
			upperCount++;
		}
	}
	if(upperCount == 0){
		printf(ERROR_17_PWD_MIN_UPPER_INVALID);
		return 0;
	}
	
	// Checking Lower Case Count
	int lowerCount = 0;
	for(int i = 0; i < pwd_length; i++){
		if(isLower(pwd[i])){
			lowerCount++;
		}
	}
	if(lowerCount == 0){
		printf(ERROR_18_PWD_MIN_LOWER_INVALID);
		return 0;
	}
    /* END MODIFYING CODE HERE */

    return 1;
}
/*
 * Original Password and the Reentered Password must match
 *
 * @param pwd1 : The original password string
 * @param len1 : Size of the original password input buffer
 * @param pwd2 : The reentered password string
 * @param len2 : Size of the renetered password input buffer
 * @return 1 if valid, 0 if not
 */
int Verify_Passwords_Match(char pwd1[], size_t len1, char pwd2[], size_t len2) {

    /* BEGIN MODIFYING CODE HERE */
	
	// First checking that the two passwords are the same length
	int length_1 = lengthOf(pwd1,len1);
	int length_2 = lengthOf(pwd2,len2);
	if (length_1 != length_2){
		printf(ERROR_19_PWD_MATCH_INVALID);
		return 0;
	}
	
	// After ensuring that the two passwords are the same length
	// Now want to ensure that the contents of the two are the same.
	for(int i = 0; i < length_1; i++){
		if(pwd1[i] != pwd2[i]){
			printf(ERROR_19_PWD_MATCH_INVALID);
			return 0;
		}
	}
    /* END MODIFYING CODE HERE */

    printf(SUCCESS_3_PASSWORDS);
    return 1;
}

/******************************************************************************
 * I/O functions
 *****************************************************************************/

/*
 * Prompts user with an input and reads response from stdin
 *
 * @param message : Prompt displayed to the user
 * @param data : char array to hold user repsonse
 * @param MAX_LENGTH : Size of user response input buffer
 */
void Get_User_Data(char *message, char *data, const int MAX_LENGTH) {
    printf("%s", message);
    fgets(data, MAX_LENGTH, stdin);
    /* BEGIN MODIFYING CODE HERE */
	for(int i= 0; i < MAX_LENGTH; i++){
		// In here check for new line character and replace it with the /0
		if(data[i] == '\n'){
			data[i] = '\0';
		}
	}
    /* END MODIFYING CODE HERE */
    return;
}
