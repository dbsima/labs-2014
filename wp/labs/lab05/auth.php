<?php
require_once 'idiorm.php';
ORM::configure('sqlite:/tmp/db.sqlite');

function logIn($username, $pass){
    $user = ORM::for_table('users')->where('username', $username)->where('password', $pass)->find_one();
    if ($user == false) {
        echo('NOK');
    }
    else {
        
        session_start();
        $_SESSION['user'] = $username;
        setcookie('user_cookie', $username);
        echo('OK');
    }
}

logIn($_POST['user'], $_POST['pass']);

?>
