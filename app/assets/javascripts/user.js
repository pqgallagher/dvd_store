function onLoad()
{
  change();
  document.getElementById("change").addEventListener("click", change, false);
  document.getElementById("next").addEventListener("click", next, false);
  // alert('Here1');
  // document.getElementsByClassName("stripe-button-el")[0].disabled = true;alert('Here2');
}

//Adds the load even listener
document.addEventListener("turbolinks:load", onLoad, false);

function next()
{
  if(validate())
  {
    document.getElementById("payment").style.display = "inline";
    document.getElementById("change").style.display = "inline";
    document.getElementById("next").style.display = "none";
    // document.getElementsByClassName("stripe-button-el")[0].disabled = false;
    readOnlyInputs(true);
  }
}

function change()
{
  document.getElementById("payment").style.display = "none";
  document.getElementById("change").style.display = "none";
  document.getElementById("next").style.display = "inline";
  // document.getElementsByClassName("stripe-button-el")[0].disabled = true;
  readOnlyInputs(false);
}



function readOnlyInputs(setValue)
{
  document.getElementById("user_fname").readOnly= setValue;
  document.getElementById("user_lname").readOnly= setValue;
  document.getElementById("user_address").readOnly = setValue;
  document.getElementById("user_pcode").readOnly = setValue;
  document.getElementById("user_email").readOnly = setValue;
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
