var user = false;

function onLoad()
{
  change();
  document.getElementById("change").addEventListener("click", change, false);
  document.getElementById("next").addEventListener("click", next, false);
  if(document.getElementById("account") !=null)
  {
    document.getElementById("account").addEventListener("click", account, false);
    document.getElementById("user").style.display = "none";
    document.getElementById("no_account").style.display = "none";
    document.getElementById("no_account").addEventListener("click", no_account, false);
  }
  // document.getElementsByClassName("stripe-button-el")[0].disabled = true;alert('Here2');
}

//Adds the load even listener
document.addEventListener("turbolinks:load", onLoad, false);

function account()
{
  document.getElementById("user").style.display = "inline";
  document.getElementById("account").style.display = "none";
  document.getElementById("no_account").style.display = "inline";
  user_create = document.createElement("input");
  user_create.type ="hidden";
  user_create.id = "user_create";
  user_create.name = "user_create";
  user_create.value = "1";
  document.getElementById("new_user").appendChild(user_create);
  user = true;
  change();
}

function no_account()
{
  document.getElementById("user").style.display = "none";
  document.getElementById("account").style.display = "inline";
  document.getElementById("no_account").style.display = "none";
  user = false;
  new_user = document.getElementById("new_user");
  if(new_user.hasChildNodes())
  {
    new_user.removeChild(document.getElementById("user_create"));
  }
}

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
  if (user)
  {
    document.getElementById("user_username").readOnly = setValue;
    document.getElementById("password").readOnly = setValue;
  }
}

function formHasErrors(e)
{
    hideErrors();

    var errorFlag = false;

    if (!user)
    {
      errorFlag = checkRequiredFields(new Array("user_fname","user_lname","user_address","user_pcode","user_email"));
    }
    else if (user)
    {
      errorFlag = checkRequiredFields(new Array("user_fname","user_lname","user_address","user_pcode","user_email", "user_username","password"));
    }


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
