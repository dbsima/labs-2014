<?php 

/* HTML */
/*
echo '<form action="edit-article.php" method="post">';
echo    '<input type="text" name="id" placeholder="id"><br>';
echo    '<input type="text" name="title" placeholder="title"><br>';
echo    '<input type="text" name="content" placeholder="content"><br>';
echo    '<input type="text" name="author" placeholder="author"><br>';
echo    '<input type="text" name="cat_id" placeholder="cat_id"><br>';
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

function create_art_cat($art_id, $cat_id) {
    $art_cat = ORM::for_table('pw_article_category')->create();    
    $art_cat->artc_art_id = intval($art_id);
    $art_cat->artc_cat_id = intval($cat_id);
    $art_cat->save();
}

$username = $pass = "";

/*  */
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (!isset($_POST['id']) || empty($_POST["id"])) {
        return;
    }
    else {
        $id = test_input($_POST["id"]);
        if (empty($id)){
            return;
        }
    }
    $article = ORM::for_table('pw_article')->where('art_id', $id)->find_one();
    if ($article === false) {
        return;
    }
    /*  */
    if (!isset($_POST['title']) || empty($_POST["title"])) {
        echo "title";
        return;
    }
    else {
        $title = test_input($_POST["title"]);
        if (empty($title)) {
            echo "title";
            return;
        }
    }
    /*  */
    if (!isset($_POST['content']) || empty($_POST["content"])) {
        echo "content";
        return;
    }
    else {
        $content = test_input($_POST["content"]);
        if (empty($content)) {
            echo "content";
            return;
        }
    }
    /*  */
    if (!isset($_POST['author']) || empty($_POST["author"])) {
        echo "author";
        return;
    }
    else {
        $author_id = test_input($_POST["author"]);
        if (empty($author_id) || !is_numeric($author_id)) {
            echo "author";
            return;
        }
    }
    $author = ORM::for_table('pw_user')->where('usr_id', $author_id)->find_one();
    if ($author === false) {
        echo "author";
        return;
    }
    /*  */
    if (!isset($_POST['cat_id']) || empty($_POST["cat_id"])) {
        echo "cat_id";
        return;
    }
    else {
        $categories = test_input($_POST["cat_id"]);
        if (empty($categories)) {
            echo "cat_id";
            return;
        }
    }
    $cat_array = explode(",", $categories);
    foreach ($cat_array as $cat_id) {
        $cat = ORM::for_table('pw_category')->where('cat_id', $cat_id)->find_one();
        if ($cat === false) {
            echo "cat_id";
            return;
        }
    }
    echo "ok";
    
    $article->art_title = $title;
    $article->art_content = $content;
    $article->art_author = intval($author_id);
    $article->art_update_date = date("Y-m-d H:i:s");
    $article->save();
    
    foreach ($cat_array as $cat_id) {
        create_art_cat($id, $cat_id);
    }
    
    if ($debug === true)
        var_dump($article);
    
}
?>