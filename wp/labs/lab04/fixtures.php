<?php
require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');
 
ORM::get_db()->exec('DROP TABLE IF EXISTS person;');
ORM::get_db()->exec(
    'CREATE TABLE person (' .
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' .
        'name TEXT, ' .
        'age INTEGER)'
);
 
function create_person($name, $age) {
    $person = ORM::for_table('person')->create();
    $person->name = $name;
    $person->age = $age;
    $person->save();
    return $person;
}
 
$person_list = array(
    create_person('Corina', 41),
    create_person('Delia', 43),
    create_person('Tudor', 56),
    create_person('Adina', 32),
    create_person('Ada', 50),
    create_person('Camelia', 40),
    create_person('Vlad', 72),
    create_person('Emil', 27),
    create_person('Ștefan', 46),
    create_person('Dan', 63),
    create_person('Roxana', 67),
    create_person('Octavian', 34),
    create_person('Radu', 78),
    create_person('Marina', 63),
    create_person('Cezar', 19),
    create_person('Laura', 36),
    create_person('Andreea', 61),
    create_person('George', 28),
    create_person('Liviu', 44),
    create_person('Eliza', 19),
);

echo('0.<br>'); 
echo('ok<br>');
echo('person ' . ORM::for_table('person')->count() . '<br>');



ORM::get_db()->exec('DROP TABLE IF EXISTS msg;');
ORM::get_db()->exec(
    'CREATE TABLE msg (' .
        'id INTEGER  KEY, ' .
        'text TEXT, ' .
	'FOREIGN KEY(id) REFERENCES person(id))'
);
 
function create_msg($id, $text) {
    $msg = ORM::for_table('msg')->create();
    $msg->id = $id;
    $msg->text = $text;
    $msg->save();
    return $msg;
}

for ($i = 1; $i <= 25; $i++) {
	$random_no = rand(1, 20);
    create_msg($random_no, 'hello!'.$i."_".$random_no);
}


echo('msg ' . ORM::for_table('msg')->count() . '<br>');


ORM::get_db()->exec('DROP TABLE IF EXISTS friendship;');
ORM::get_db()->exec(
    'CREATE TABLE friendship (' .
        'id1 INTEGER  KEY, ' .
        'id2 INTEGER  KEY, ' .
	'FOREIGN KEY(id1) REFERENCES person(id), ' .
	'FOREIGN KEY(id2) REFERENCES person(id))'
);
 
function create_friendship($id1, $id2) {
    $fs = ORM::for_table('friendship')->create();
    $fs->id1 = $id1;
    $fs->id2 = $id2;
    $fs->save();
    return $fs;
}

for ($i = 1; $i <= 10; $i++) {
	$random_no = rand(11, 20);
    	create_friendship($random_no, $i);
    	create_friendship($i, $random_no);
}


echo('fs ' . ORM::for_table('friendship')->count() . '<br>');
