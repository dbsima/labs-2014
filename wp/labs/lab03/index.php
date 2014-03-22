<?php

echo("hello, world!");

echo(date("Y-m-d H:i:s"));


class ParseHomework {
	private $name, $surname, $group, $hw, $course;
	private $no_tasks;
	private $scores;

	public function  __construct($hw_name) {
		$this->scores = array();
		
		list($this->name, $this->surname, $this->group, $this->hw, $this->course) = explode(".", $hw_name);
		$name = $name;
		$surname = $surname;
		$group = $group;
		$hw = $hw;
	}

	public function _toString(){
		return "[".$this->name.",".$this->surname.",".$this->group.",".$this->hw.",".$this->course."]";	
	}

	public function setNumberOfTasks(){
		$no_hw = preg_replace("/[^0-9]/", '', $this->hw);
		$this->no_tasks = rand(2, 10)/$no_hw + 1;
	}

	public function getNumberOfTasks(){
		return $this->no_tasks;
	}

	function generateRandomString($length = 16) {
   		 $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    		$randomString = '';
    		for ($i = 0; $i < $length; $i++) {
        		$randomString .= $characters[rand(0, strlen($characters) - 1)];
    		}
    		return $randomString;
}
	
	public function initScore() {
		for ($i = 0; $i < $this->no_tasks; $i++) {
			$randomString = $this->generateRandomString(16);
			$tmp_array = ["nota" => rand(1, 10), "obs" => $randomString,];		
			$this->scores[] = $tmp_array;
		}
		var_dump($this->scores);
	}
	
	public function sortTasks(){
		for ($i = 0; $i < $this->no_tasks - 1; $i++) {
			for ($j = $i+1; $j < $this->no_tasks; $j++) {
				if( $this->scores[$i]["nota"] > $this->scores[$j]["nota"]){
					$aux = $this->scores[$i];
					$this->scores[$i] = $this->scores[$j];
					$this->scores[$j] = $aux;
				}
			}
		}
		var_dump($this->scores);
	}
	
}

$details = new ParseHomework("Dragos.Sima.342C5.t1.hw1");

echo($details->_toString());

$details->setNumberOfTasks();

echo("\n".$details->getNumberOfTasks());

echo($details->initScore());

echo("<br>");

echo($details->sortTasks());
?>
