<?php 
$debug = false;

require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');

function test_input($data)
{
     $data = trim($data);
     $data = stripslashes($data);
     $data = htmlspecialchars($data);
     return $data;
}

class ArticleValue implements JsonSerializable {
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
            'art_id' => $this->id, 
            'art_title' => $this->title, 
            'art_content' => $this->content, 
            'art_views' => $this->views, 
            'art_publish_date' => $this->publish_date, 
            'art_update_date' => $this->update_date, 
            'art_author' => $this->author
        ];
    }
}

class CategoryValue implements JsonSerializable {
    public function __construct($id, $title) {
        $this->id = $id;
        $this->title = $title;
    }

    public function jsonSerialize() {
       return [
            'cat_id' => $this->id, 
            'cat_title' => $this->title
        ];
    }
}

class UserValue implements JsonSerializable {
    public function __construct($id, $username, $password, $salt, $register_date, $last_login) {
        $this->id = $id;
        $this->username = $username;
        $this->password = $password;
        $this->salt = $salt; 
        $this->register_date = $register_date;  
        $this->last_login = $last_login;
    }

    public function jsonSerialize() {
       return [
            'usr_id' => $this->id, 
            'usr_username' => $this->username, 
            'usr_password' => $this->password, 
            'usr_salt' => $this->salt, 
            'usr_register_date' => $this->register_date, 
            'usr_last_login' => $this->last_login
        ];
    }
}

class ArticleCategoryValue implements JsonSerializable {
    public function __construct($art_id, $cat_id) {
        $this->cat_id = $cat_id;
        $this->art_id = $art_id;
    }

    public function jsonSerialize() {
       return [
            'artc_art_id' => $this->art_id, 
            'artc_cat_id' => $this->cat_id
        ];
    }
}

/*  */
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    if (!isset($_GET['table']) || empty($_GET['table'])) {
        echo "wrong_table";
        return;
    }
    if (preg_match('/[^A-Za-z0-9_]/', $_GET['table'])){
        echo "wrong_table";
        return;
    }
    
    $table = $_GET['table'];
    
    if ($table !== 'pw_article' && $table !== 'pw_user' && $table !== 'pw_category' && $table !== 'pw_article_category') {
        echo "wrong_table";
        return;
    }
    
    $rows = ORM::for_table($table)->find_many();
    
    if ($table === 'pw_article'){
        foreach($rows as $row){
            $list_of_json[] = new ArticleValue($row->art_id, $row->art_title, $row->art_content, $row->art_views, $row->art_publish_date, $row->art_update_date, $row->art_author);
        }
    }
    else if ($table === 'pw_category'){
        foreach($rows as $row){
            $list_of_json[] = new CategoryValue($row->cat_id, $row->cat_title);
        }
    }
    else if ($table === 'pw_user'){
        foreach($rows as $row){
            $list_of_json[] = new UserValue($row->usr_id, $row->usr_username, $row->usr_password, $row->usr_salt, $row->usr_register_date, $row->usr_last_login);
        }
    }
    else {
        foreach($rows as $row){
            $list_of_json[] = new ArticleCategoryValue($row->artc_art_id, $row->artc_cat_id);
        }
    }
    echo json_encode($list_of_json);
    
}
?>