<?php 

/* HTML */
/*
echo '<form action="register.php" method="post">';
echo    '<input type="text" name="username" placeholder="Username"><br>';
echo    '<input type="password" name="pass" placeholder="Password"><br>';
echo    '<input type="password" name="cpass" placeholder="Confirm Password"><br>';
echo    '<input type="submit">';
echo '</form>';
*/
require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');

/*  */
function generateRandomString($length = 32) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $randomString;
}

/*  */
function checkPassword($pwd, &$errors) {
    $errors_init = $errors;
 
    if (strlen($pwd) < 6) {
        $errors[] = "Password too short!";
    }
 
    if (!preg_match("#[0-9]+#", $pwd)) {
        $errors[] = "Password must include at least one number!";
    }
 
    if (!preg_match("#[a-zA-Z]+#", $pwd)) {
        $errors[] = "Password must include at least one letter!";
    }     
 
    return ($errors == $errors_init);
}


function test_input($data)
{
     $data = trim($data);
     $data = stripslashes($data);
     $data = htmlspecialchars($data);
     return $data;
}

function insertUser($username, $pass){
    $salt = generateRandomString();
    
    $user = ORM::for_table('pw_user')->create();    
    $user->usr_username = $username;
    $user->usr_password = sha1($pass.$salt);
    $user->usr_salt = $salt;
    $user->usr_register_date = date("Y-m-d H:i:s");
    $last_login = date_create('0000-00-00');
    $user->save();
    
    //var_dump($user);
    
    return "ok";
}

$username = $pass = $cpass = "";

/*  */
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (!isset($_POST['username']) || empty($_POST["username"]) || strlen($_POST["username"]) < 6) {
        echo "username";
        return;
    }
    else {
        $username = test_input($_POST["username"]);
        if (empty($username)){
            echo "username";
            return;
        }
    }
    /*  */
    if (!isset($_POST['pass']) || empty($_POST["pass"]) || strlen($_POST["pass"]) < 6) {
        echo "password";
        return;
    }
    else {
        $pass = test_input($_POST["pass"]);
        if (empty($pass)) {
            echo "password";
            return;
        }
        
        /* test password strenght */
        $errors = [];
        checkPassword($pass, $errors);
        if (count($errors) > 0) {
            echo "password_strength";
            return;
        }
    }
    /*  */
    if (!isset($_POST['cpass']) || empty($_POST["cpass"]) || strlen($_POST["cpass"]) < 6) {
        echo "confirm";
        return;
    }
    else {
        $cpass = test_input($_POST["cpass"]);
        if (empty($cpass) || strcmp($pass, $cpass) != 0) {
            echo "confirm";
            return;
        }    
    }
    
    $user = ORM::for_table('pw_user')->where('usr_username', $_POST["username"])->find_one();
    if ($user === true) {
        echo "user_exists";
        return;
    }
    echo "ok";
    
    insertUser($_POST["username"], $_POST["pass"]);
}
?>