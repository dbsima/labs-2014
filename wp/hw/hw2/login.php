<?php 

/* HTML */
/*
echo '<form action="login.php" method="post">';
echo    '<input type="text" name="username" placeholder="Username"><br>';
echo    '<input type="password" name="pass" placeholder="Password"><br>';
echo    '<input type="submit">';
echo '</form>';
*/
$debug = false;

require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');

ORM::configure('id_column_overrides', array(
    'pw_user' => 'usr_id',
    'pw_article' => 'art_id',
    'pw_category' => 'cat_id',
    'pw_article_category' => ''
));

function test_input($data)
{
     $data = trim($data);
     $data = stripslashes($data);
     $data = htmlspecialchars($data);
     return $data;
}

$username = $pass = "";

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
    }
    
    $user = ORM::for_table('pw_user')->where('usr_username', $_POST["username"])->find_one();
    if ($user === false) {
        echo "user_doesnt_exist";
        return;
    }
    
    $computed_password = sha1($_POST["pass"].$user->usr_salt); 
    if ($user->usr_password !== $computed_password) {
        echo "wrong_password";
        return;
    }
        
    
    $user->usr_last_login = date("Y-m-d H:i:s");
    $user->save();
    
    if ($debug === true)
        var_dump($user);
}
?>