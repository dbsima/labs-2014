<?php
require_once 'idiorm.php';
require_once 'header.php';
ORM::configure('sqlite:/tmp/db.sqlite');

$username = $_COOKIE['user_cookie'];

$user = ORM::for_table('users')->where('username', $username)->find_one();
$articles = $user->rights;

$articles_list = split(',', $articles);

$test = 0;
foreach ($articles_list as $article_id) {
    if ($article_id == $_GET['id']) {
        $article = ORM::for_table('articles')->where('id', $_GET['id'])->find_one();

        echo($article->title);
        echo($article->text);
        
        $test = 1;
    }
    
}

if ($test==0) {
       echo('No right!'); 
    }
    
?>
