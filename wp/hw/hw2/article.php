<?php 

/* HTML */
/*
echo '<form action="article.php" method="get">';
echo    '<input type="number" name="art_id" placeholder="Article id"><br>';
echo    '<input type="submit">';
echo '</form>';
*/
$debug = false;

require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');

ORM::configure('id_column_overrides', array(
    'pw_article' => 'art_id'
));

function test_input($data)
{
     $data = trim($data);
     $data = stripslashes($data);
     $data = htmlspecialchars($data);
     return $data;
}

class ArrayValue implements JsonSerializable {
    public function __construct($id, $title, $content, $views, $publish_date, $update_date, $author) {
        $this->id = $id;
        $this->title = $title;
        $this->content = $content;
        $this->views = $views; 
        $this->publish_date = $publish_date;  
        $this->update_date = $update_date; 
        $this->author = $author;
    }

    public function jsonSerialize() {
       return [
            'id' => $this->id, 
            'title' => $this->title, 
            'content' => $this->content, 
            'views' => $this->views, 
            'publish_date' => $this->publish_date, 
            'update_date' => $this->update_date, 
            'author' => $this->author
        ];
    }
}

/*  */
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    if (!isset($_GET['art_id']) || empty($_GET['art_id']) || !is_numeric($_GET['art_id'])) {
        echo "wrong_art";
        return;
    }
    
    $art_id = test_input($_GET['art_id']);
    if (empty($art_id)){
        echo "wrong_art";
        return;
    }
    
    $article = ORM::for_table('pw_article')
        ->raw_query('SELECT a.art_id, a.art_title, a.art_content, a.art_views, a.art_publish_date, a.art_update_date, u.usr_username FROM pw_article a, pw_user u WHERE a.art_author = u.usr_id AND a.art_id = :art_id', array('art_id' => $art_id))
        ->find_one();

    if ($article === false) {
        echo "wrong_art";
        return;
    }
    
    $list_of_json[] = new ArrayValue($article->art_id, $article->art_title, $article->art_content, $article->art_views, $article->art_publish_date, $article->art_update_date, $article->usr_username);
    
    echo json_encode($list_of_json);
    
    $article->art_views++;
    $article->save();
}
?>