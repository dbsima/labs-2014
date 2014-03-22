<?php
        if (isset($_COOKIE["user_cookie"])){
            echo "Welcome " . $_COOKIE["user_cookie"] . " ";
            echo '<a href="logOut.php">Log Out</a><br>';
        }
        else
            echo "Welcome guest!<br />";
?>