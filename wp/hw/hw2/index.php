<?php

echo("<meta charset=\"UTF-8\">");

require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');	
	

echo("1.<br>");
$person = ORM::forTable('person')->findOne();
echo($person->name." ".$person->age);

echo("<br><br>2.<br>");
$people = ORM::for_table('person')->find_many();
foreach($people as $person) {
	echo($person->name." ".$person->age."<br>");
}

echo("<br><br>3.<br>");
$people = ORM::for_table('person')->where_like('name', '%lia')->find_many();
foreach($people as $person) {
	echo($person->name." ".$person->age."<br>");
}
echo("<br>");
$people = ORM::for_table('person')->where_like('name', '%an')->find_many();
foreach($people as $person) {
	echo($person->name." ".$person->age."<br>");
}

echo("<br><br>5.<br>");
$people = ORM::for_table('person')->find_many();
foreach($people as $person) {
	$no_msgs = ORM::for_table('msg')->where_like('id', $person->id)->count();
	echo("<br>".$person->name." has ".$no_msgs." messages<br>");
}

echo("<br><br>6.<br>");
$people = ORM::for_table('person')->find_many();
foreach($people as $person) {
	$msgs = ORM::for_table('msg')->where_like('id', $person->id)->find_many();
	echo("<br>".$person->name." with the id: ".$person->id."<br>");
	
	foreach($msgs as $msg) {
		echo($msg->text."<br>");
	}
}


echo("<br><br>7.<br>");
$people = ORM::for_table('person')->where_lte('age', 40)->find_many();
foreach($people as $person) {
	echo($person->name." has age ".$person->age."<br>");
}


echo("<br><br>8 + 9.<br>");
$people = ORM::for_table('person')->find_many();
foreach($people as $person) {
	$friends = ORM::for_table('friendship')->where_like('id1', $person->id)->find_many();
	echo("<br>".$person->name." has ".count($friends)." friends<br>");
	
	foreach($friends as $friend) {
		$my_friend = ORM::for_table('person')->where('id', $friend->id2)->find_one();
		echo($my_friend->name."<br>");
	}
}
