function validate(event)
{
	//If the form as Errors.
	if(formHasErrors(event))
	{
		//Stops the form from submitting
		event.preventDefault();

		//Returning false as there are errors.
		return false;
	}

	//Returns true as the form has no errors.
	return true;
}


function checkRequiredFields(requiredFields)
{
    var errorFlag = false;

    //Loops through the requiredFields for the lenght of the requiredFields.
    for(var x = 0; x < requiredFields.length; x++)
    {
        //Gets the id of the current input.
        var text = document.getElementById(requiredFields[x]);

        //Determine if the requiredFields has input
        if(!textFieldHasValue(text))
        {
            //Shows the error.
            $("<label class=error id="+requiredFields[x]+"Error>This is a required field</label>").insertAfter("#"+requiredFields[x]);

            //If errorFlag is true.
            if(!errorFlag)
            {
                text.focus();
                text.select();
            }

            //Sets errorFlag to true as there are errors.
            errorFlag = true;
        }
    }
    return errorFlag;
}

//Hides the errors on the form.
function hideErrors()
{
	//Creates an array of the error field html ids.
	var errors = document.getElementsByClassName("error");

	//Loops through each error field
	for(var i = 0; i < errors.length; i++)
	{
		//Hides the current error.
		errors[i].style.display = "none";
	}
}

function textFieldHasValue(text)
{

	//Determines if text is null OR has only space bar characters
	if ( text.value == null || trim(text.value) == "")
	{
		//When text has no value
		return false;
	}

	//When text has value.
	return true;
}

function trim(str)
{
	// Uses a regex to remove spaces from a string.
	return str.replace(/^\s+|\s+$/g,"");
}
//Ensures the Postal Code is a valid Postal Code.
function validatePostalCode(postal)
{
    //Test item value for letter number letter number letter number postal
    //code format 'A2A 0R4'
    var item = new RegExp(/^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[ABCEGHJKLMNPRSTVWXYZ]{1} *\d{1}[ABCEGHJKLMNPRSTVWXYZ]{1}\d{1}$/i);
    if (item.test(postal.toString()))
    {
    	//When postal is valid.
    	return true;
    }
    else
    {
    	//When postal is not valid.
    	return false;
    }
}

//Ensures the e-mail is a valid e-mail address
function validateEmail(email)
{
    //Test item value for text@text.text or text@text.text.text e-mail format.
    var item=/^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;

   	//If the value in email is in the text@text.text or text@text.text.text e-mail format.
    if (item.test(email))
    {
    	//When email is valid.
    	return true;
    }
    else
    {
    	//When email is not valid.
    	return false;
    }
}
