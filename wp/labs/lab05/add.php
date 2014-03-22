<?php
require_once 'idiorm.php';
require_once 'header.php';
ORM::configure('sqlite:/tmp/db.sqlite');

function addArticle($title, $text){
    $article = ORM::for_table('articles')->create();
    $article->title=$title;
    $article->text=$text;
    $article->save();
    
    $target_path = "uploads/"; 
    $target_path = $target_path . basename( $article->id. ".jpg"); 

    if( move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) { 
        echo "Fisierul ". basename( $_FILES['uploadedfile']['name']). " a fost uploadat"; 
    } 
    else { 
        echo "Eroare la uploadarea fisierului!"; 
    } 
}

addArticle($_POST['title'], $_POST['text']);

?>
