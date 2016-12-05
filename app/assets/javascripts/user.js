//User is ture when a new user is being registared.
var user = false;

//Loads with the page
function onLoad()
{
  change();
  //Adds event listener to the change customer info button.
  document.getElementById("change").addEventListener("click", change, false);
  //Adds event listener to the next button.
  document.getElementById("next").addEventListener("click", next, false);
  //If no user has logged in.
  if(document.getElementById("account") !=null)
  {
    //Adds event listener to the create account button.
    document.getElementById("account").addEventListener("click", account, false);
    //Hides the username and passwords inputs.
    document.getElementById("user").style.display = "none";
    //Hides the 'do not create account' button
    document.getElementById("no_account").style.display = "none";
    //Adds event listener to the 'do not create account' button
    document.getElementById("no_account").addEventListener("click", no_account, false);
  }
}

//Adds the load even listener
document.addEventListener("turbolinks:load", onLoad, false);

//When the user wants to create an account.
function account()
{
  //Shows the username and passwords inputs.
  document.getElementById("user").style.display = "inline";
  //Hides the create account button.
  document.getElementById("account").style.display = "none";
  //Shows the 'do not create account' button
  document.getElementById("no_account").style.display = "inline";
  //Creates a hidden boolean input for the controller.
  user_create = document.createElement("input");
  user_create.type ="hidden";
  user_create.id = "user_create";
  user_create.name = "user_create";
  user_create.value = "1";
  //Adds the hidden input too the form.
  document.getElementById("new_user").appendChild(user_create);
  user = true;
  change();
}

//After the user has click the create account button and they
//have decided that do not want to create an account.
function no_account()
{
  //Hides the username and passwords inputs.
  document.getElementById("user").style.display = "none";
  //Shows the create account button.
  document.getElementById("account").style.display = "inline";
  //Hides the 'do not create account' button
  document.getElementById("no_account").style.display = "none";
  user = false;
  //Gets the form object
  new_user = document.getElementById("new_user");
  //If the hidden input exists
  if(new_user.hasChildNodes())
  {
    //Destorys the hidden boolean input.
    new_user.removeChild(document.getElementById("user_create"));
  }
}

//For when the next button is clicked.
function next()
{
  //If all the inputs have valid info.
  if(validate())
  {
    //Diplays the stripe form.
    document.getElementById("payment").style.display = "inline";
    //Shows the change customer info button.
    document.getElementById("change").style.display = "inline";
    //Hides the nest button.
    document.getElementById("next").style.display = "none";
    //Sets all input to read only.
    readOnlyInputs(true);
  }
}

//When user want to change the input in the Customer info form.
function change()
{
  //Hides the stripe form.
  document.getElementById("payment").style.display = "none";
  //Hides the the change customer info button.
  document.getElementById("change").style.display = "none";
  //Shows the next button.
  document.getElementById("next").style.display = "inline";
  readOnlyInputs(false);
}


//Set the form inputs to read only and none read only.
function readOnlyInputs(setValue)
{
  document.getElementById("user_fname").readOnly= setValue;
  document.getElementById("user_lname").readOnly= setValue;
  document.getElementById("user_address").readOnly = setValue;
  document.getElementById("user_pcode").readOnly = setValue;
  document.getElementById("user_email").readOnly = setValue;
  //If the use has selected create acccount.
  if (user)
  {
    document.getElementById("user_username").readOnly = setValue;
    document.getElementById("password").readOnly = setValue;
  }
}

//Checks if the form has errors.
function formHasErrors(e)
{
    hideErrors();

    var errorFlag = false;

    if (!user)
    {
      //Validates that all required input fields contain data.
      errorFlag = checkRequiredFields(new Array("user_fname","user_lname","user_address","user_pcode","user_email"));
    }
    //If the use has selected create acccount.
    else if (user)
    {
      //Validates that all required input fields contain data.
      errorFlag = checkRequiredFields(new Array("user_fname","user_lname","user_address","user_pcode","user_email", "user_username","password"));
    }

    //Determines if the value in postal code is valid.
    if(!validatePostalCode($("#user_pcode").val()) && textFieldHasValue($("#user_pcode")[0]))
    {
      $("<label class=error>Invalid Postal Code</label>").insertAfter($("#user_pcode"));
      //Sets errorFlag to true as there are errors.
      errorFlag = true;
    }

    //Determines if the value in email is valid
    if(!validateEmail($("#user_email").val()) && textFieldHasValue($("#user_email")[0]))
    {
      $("<label class=error>Invalid email address</label>").insertAfter($("#user_email"));
      //Sets errorFlag to true as there are errors.
      errorFlag = true;
    }

    return errorFlag;
}
