<?php
require_once 'idiorm.php';
require_once 'header.php';
ORM::configure('sqlite:/tmp/db.sqlite');

$articles = ORM::for_table('articles')->find_many();

foreach($articles as $article) {
    echo('<br><a href="index.php?id=');
    echo($article->id);
    echo('">');
    echo($article->title);
    echo('</a>');
    echo('<img src="uploads/');
    echo($article->id);
    echo('.jpg">');
    
}

echo $_COOKIE['user_cookie'];

    
?>
