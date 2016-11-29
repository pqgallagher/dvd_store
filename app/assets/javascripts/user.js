function onLoad()
{
  document.getElementById("payment").style.display = "none";
  document.getElementById("next").style.display = "inline";
  document.getElementById("next").addEventListener("click", next, false);
  document.getElementsByClassName("stripe-button-el")[0].addEventListener("click", enabled, false);
}

//Adds the load even listener
document.addEventListener("turbolinks:load", onLoad, false);

function next()
{
  if(validate())
  {
    document.getElementById("payment").style.display = "inline";
    document.getElementById("next").style.display = "none";

    document.getElementById("user_fname").disabled = true;
    document.getElementById("user_lname").disabled = true;
    document.getElementById("user_address").disabled = true;
    document.getElementById("user_pcode").disabled = true;
    document.getElementById("user_email").disabled = true;
  }
}

function enabled()
{
  document.getElementById("user_fname").disabled = false;
  document.getElementById("user_lname").disabled = false;
  document.getElementById("user_address").disabled = false;
  document.getElementById("user_pcode").disabled = false;
  document.getElementById("user_email").disabled = false;
}

function formHasErrors(e)
{
    hideErrors();

    var errorFlag = false;

    //Ensurse data is in all needed inputs
    errorFlag = checkRequiredFields(new Array("user_fname","user_lname","user_address","user_pcode","user_email"));

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
