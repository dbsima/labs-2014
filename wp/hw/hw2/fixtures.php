<?php

require_once 'idiorm.php';
ORM::configure('sqlite:/var/local/pweb-lab4/db.sqlite');

ORM::get_db()->exec('DROP TABLE IF EXISTS pw_user;');
ORM::get_db()->exec(
    'CREATE TABLE pw_user (' .
        'usr_id INTEGER PRIMARY KEY AUTOINCREMENT, ' .
        'usr_username VARCHAR(256), ' .
        'usr_password CHAR(40), ' .
        'usr_salt CHAR(32), ' .
        'usr_register_date DATETIME, ' .
        'usr_last_login DATETIME)'
);
 
function create_user($username, $password, $salt, $register_date, $last_login) {
    $user = ORM::for_table('pw_user')->create();    
    $user->usr_username = $username;
    $user->usr_password = $password;
    $user->usr_salt = $salt;
    $user->usr_register_date = $register_date;
    $user->usr_last_login = $last_login;
    $user->save();
    return $user;
}
 
$user_list = array(
    create_user('hdTGH9hUyI', 'e8c84d3121b63387530ed52af138589587071bda', 'KuBlkIB5cdKOsfTsGvmvZe0VW6bcFnIh', '2014-03-23 13:35:42', '0000-00-00 00:00:00'),
    create_user('KXDesKeMcr', '159a4282f59154ed3ce99a725ca0e2a7c03a41e7', 'J4pQ1HwyTQMok5TGNv5ggJ4vcP4eyoNN', '2014-03-26 20:13:15', '0000-00-00 00:00:00'),
    create_user('xt2YQPjsp3', 'edfeef6cb02f3e8dc7ffead62bf97a7ad807e1a4', 'a93NWHzMYqjfAOnpCOmZrUkdR4UNfKbX', '2014-03-14 10:02:30', '0000-00-00 00:00:00')
);

echo('user ' . ORM::for_table('pw_user')->count() . '<br>');

ORM::get_db()->exec('DROP TABLE IF EXISTS pw_article;');
ORM::get_db()->exec(
    'CREATE TABLE pw_article (' .
        'art_id INTEGER PRIMARY KEY AUTOINCREMENT, ' .
        'art_title TEXT, ' .
        'art_content TEXT, ' .
        'art_views INTEGER, ' .
        'art_publish_date DATETIME, ' .
        'art_update_date DATETIME, ' .
        'art_author INTEGER, ' .
        'FOREIGN KEY(art_author) REFERENCES pw_user(usr_id))'
);

function create_art($title, $content, $views, $publish_date, $update_date, $author) {
    $art = ORM::for_table('pw_article')->create();    
    $art->art_title = $title;
    $art->art_content = $content;
    $art->art_views = $views;
    $art->art_publish_date = $publish_date;
    $art->art_update_date = $update_date;
    $art->art_author = $author;
    $art->save();
    return $art;
}

$article_list = array(
    create_art(' pL5Gn5aB KEAdAwe WeD FKoz xAc APT lbQzMhMhn', ' U6vXOqk9P fcjcm 56gfw 3brhjQ Z9tC 8L4unV JtIUJ kuv5us ipFDJN suUHT9 HrOAj1 6S9 cfL AMmVu SwD8O d96x HfC7Bc3ne WXoVRz 7Ush0H a2hpZ io4W whgpvWBd UWOqxKh DZeUz Ksc qGPw Nkb9w DS4 Q8aYf21n 9mm7AoMZW XXiXLZfpw Tr5CPM D9CuBrGw NdJHPUshB yFJbmliHI UgYT 5Yd6T3G T3h5P thTJe OA04PKM Cx1wq H9YXimsL ICAxlFhE kbxeO8bb u2LE44zV LHTQ Jid MkcXqJ XKHU nXNUnJ jmKU7pd i7Qdj Rv8oZvf r3BXWuF HFqwr luo8nSgB0 gbbK8dpV zCT yiKy2q41 rXslk ymz ye7t8 rAzsw xZOu MhZt pNo awJt1fHEV 2NmBWJi 8ObCRS1hO g0cSS MZkzJ B4ND90 nWZC r6k EW0PZ TdsFHRw DD9V ROMjos ZzAYFe Z5J zsUVju7 iqbA9Xs WjMRg vAdT vp214U ZgjaKxJ46 KlqLsby8s PtQY5 cRGqCcst IKmxBp4 BM3mWHh2 veQW4 mzIEIohys 73J 575 udEydiZa RdNrQU9 Kar wBqSCh 83OLA i36c T1mXv IPBU 0o4l7B04 ryQV 4akqnY0 PK46hs V4z c13Z vowtmxp UXIG1 5Z10zzL M7B OSmEg oAcnw5 38Cv 28wlA8rU zPcvTMr', 7, '2014-03-04 07:34:46', '2014-03-29 02:21:20', 2),
    create_art(' ga5vuzJ ENqx Ax8G8 Vf9Nn7S9r 1gBHO0O5X zbGcOyH', ' idu 2YsJ cBEizgpv iZ4d3 4qlX7GxM bthcG XVnqJ3 E7GKY3qmL m3R 4xBpF2PhK T3nr HbioGf2 Y9n 30yKSog2V Kz9EI 1dndwHs 7bbsMg lY2V E5S ixlGTX2QS baeAv2 udfsJ2 KqaF am3y1 avCfnB1S PQqUDa q0A pqdiGOC CGT92ZFj cZrd teaIe YrPb0Xmi5 rXyH ngm4 zGkS CuTNE yUKqzYn aQuD3SzLs BS6e12bKP rNtt5cVpQ ENVZD 2ykL RI2Ngf nAU RaaEuSY Y2O4xvF9 CY8heIznF AqMSL VJcM UuZ8RI2py D4tSZY uPskqnm hk3b8Vl ASCLKpF bfSRZ 5jM9CbE kqan vrX9o4 sy9FjYf 47u3zVsm UeRE qiq 8RkWViG VNkv 5Dfmoqq r3vcqm 45GLbE n9NhL4NJT jzfBCF UolZxRrN LjH iNGLcfa FuaIqT8 Hh2H 0kfb 0sjjwqP6R sAsvpDji ATdFg SV2y mJ5dJ dBeMU6B CM2al gEwA D8purF qW3m1rNa PQPCpF x3ez05 kem kWe EmwTRcz 6FfD vSzsUk0gB psPtKChou atBKf4ypH jpg mR9XEl56 XiYmitV rRNb aXK BeS UX1D ZbMs NPDPRky OpqvEEXd 9oMiuqyz hnzBGBO4 4dKv7hKR YFDQLA2 B6OwYj9 QONU GWGsxkM sa2b3bQ oz0M44R dUiZ MBrGU zI2ORym hOBdhzYFQ dAquwO kDF 3L1 fCdX1q eWT Q8gJLaeGt 1HU n7ANtLr 40WR F4s46 3p9zg 9na YGlYV V4SbsoaN4 CMl6 BmrWfKS azE lqs7dpx N7AHw QXmB2tN l7N wePlMDR OGmhSehaF 7CpEPeP S68FeP2P uM1gH Cmw sEA TAXQJ9f mOxMBx qNM1EN TaWf9b Tns WFacmD mDl TIpH8 VoW t9D0894 x9A Ll1s sKkxI LLPRec1 Hp0HDv qZ5 ZgepepwL T50CHu XhQwlBJJ 8gI R0bM 4lOf VCl 93v JqbSTCn lXwnjh ivV6h9L VY7FkbQb5 hYh8g1 P8MSML XItP Q6xbT0R05 JW8 D3ghxX HUK7 I0MnqPp 0PHfV4Sz aE6a gFWM EUZlR', 9, '2014-03-14 02:32:57', '2014-03-27 09:15:24', 2),
    create_art(' QTlP SSvwu L24AJ8 dYwXNB tjdzjf 9lydUTGj3 EKjpSDTA', ' vEyBos ngmtYl DYkg ustH6 82Uv6n nIbYfP VQLzrp A7D1X KwC se4y00hP aHI yiQiyyhlX CN9oZT qWmHZAng3 IY4QyF 8CH u9U8v EIiVK6q7 MZDUHB akk1 ENPf 5Qf MLwUYPVF LMrL Vd2yJscm 8QU J2oX pyMY Ct5 gnYULk RMFtsAg gRrcnP wqe Vsgoo Flo D5T4TZ 4FSK3 5y69uJO pKgNHz5V Glne2DS 64DRRdo Mbk OzcMr cnDr4p C0K3AJKK udRLXx EowMHux00 qya5vS vEXU bfbcXI pkRuk6B FFsW QmhYYNi UJB50DiN4 YKtHH8 j6I MfFE KJP H7ynGzb Ngy5DW0qi oUmD3YWz ABn3ftfz 8VK1FBqzG V2f 6mZqi Zmm QTE CfYiX9H1 PEW5YcvAP H06V q0ikrhCc9 Jz9 0UxU bSNR j8DUoEWNe AvqxXu SSI fHFwSgi3 T5oktZ 4jup gyMGGEkup F6LiTJCh 5jbRoGX m44Ye uvHMG ZiDZQcNDr 9vx59 kgMNxcv nKiBAfB0n pHr1bL tTN f0U8duGAH dpxY5l6o Cc3LV rgvX t3MJvP 5Wvz1T IwWZj bKe dhMz7QO v8H snfxA P5X6g avUAlKCY2 IAn43m 5YONOkSAY 2nKcfM T0RCofeD2 Z9FBIV aw8M5Yv RchuqL eiLm oOCJdZ EJT FoBjCaJ PynGau7iX 2Z3qLt QmY1Iqc5 4nP8Se 7VYdpQj uHu j5cem6GLA ERsUj YnoIz 7DdWcwpIR 5MO2 dhSkDY1j 7mG rdSa rTqY c76RJ ieZIKmWj y2IO gxm64R3 shBARTe giEN7A5dq', 35, '2014-03-09 00:30:43', '2014-03-19 20:49:54', 2),
    create_art(' oIaal UQaS 7bo3eg 7TK8Pjs LdK71Ot3 PY5l', ' b7v Oz62 kZ31so42y ptJ Wgz YU91o 5Mv6t b4TYKMrm3 IJrH jLlkNmBk 4prVeg tH6QQOpO q9gj NhnYjs67a I7lbVkipY ZazfUzV 0bLD 7jy9YgeC Rx9hPNdq RLRb4 GwgKt NCk vRR KW8Tl LAEZPBvp FgybZKn8i lVOQr eC8 NvnCeRFB wWo1PG3k RbnfWTm UK1ScS 4OQKscL UkdfLGiy eBkwqeND LHv9 eZ7r8 ChBGBp 5zUDt o9bLW7 r9f X7Liiq MTblP ZlLkUBsA RdZ1iU UFSEia lMxv4sYlM cPXhsOz6q 6um7u2X eRs0hvy 67tfFfW s1ay 1Sp4ki ky8LFMB 4Cr408 vrXy5Q9L bjdzVx7 2rbgZ5D L6cV x69512h6 e9NYp6E NZC 69bMxpj Q8sjdaCto evz1i1u1 6mH5 TofPk JbmJ0tdz1 CNfKN Erri rNMplz1c YT2M IpZ5khuJ 7nS TegX496eC 7114vbdL 3HT tr4INSnQ 1oYZiei4 uxpIgUR 79MR sZs1 RvJHd0W ppHmgF P9hOcUc aSUPXTml i1upX R0bnxiQv8 hJK k0X3l Ql972U7p 04C9kle 6Od13N23 8GqPc fANM7oj 6tyeOxS lN8NiYFfJ jfhsp 1IOi LSNYOp RBNyjlQg LVjN4RFwY ObI HnZO d2E5hy41 MVBWryf IMY7 ZdIAY A68GP7gk4 Jnm6n kYy42f59 Dkv k7795Or 5fre5LBs dT5pV dELcsL3F XE86WS4cW rMFbHUl QdHGl WO8bM9Ix x2qFkz EliG7XGKh GJR MI5eWiFC zPOO7h8 4fs2Zr7xY XoC j6172CLrs X5rsc kdyIXEEE gyMhYSP iH1d C4G4 ctYE7Tlq O9G zRwlZrvD mLOLBR hCTcRnt PlGh3 6GQkRM Mwi jbs UsYf1q4 EFt9ein LTvvGz5 ZUQ48Z Z5rfBjjPM frQZilES cxU hm4FgsP', 19, '2014-03-13 10:18:55', '2014-03-25 16:44:37', 1),
    create_art(' ktBri bjUCFb0R MX07lz2 zcoJGI4w qwfWb v2l8pTKJ', ' JZXh RjJk FP8RCiTq ksud avwuRtO TQb56z MP9Y Vx63JdGz6 h8m 1Xl5uLqz MrasHIlF 66XHXSsH EJu TTidAwQla k8C6vYqI Ewbdyp Hv3yJRU wrW NCD4MdX6a m9cAPNB P8zhkK aNLC3bJC ZM5G uIBb JS0MRS72j tkORx A3iUkjdS vff8 S88y480Bh WWuhF b7qpirUJj kIdoq rHqBZR1H XrPoB nGR89 mmvi gi2T RTDz2NX aeZO6ai1b ZJg EGF8o5fKM mdWBPtr 01o4KOn nkucKw ScRYL l3zepCv 1ij GabL ORWsm B0mX6t kiNGmutGi swPPdj 9JD5 sBLQnMUoW Ln8H 7q7 tL8dNDQ3V Qcc dRsCz 3iZ4Pl5A eVt W6t9VKO4 pbT6 PrJJ 5w5gEq 0vV6SsZs S51rAbm XJA OJh1uCy RoYif EavVcD 7FVu4GMoe nxAct Bogr utnW jVJiwr2 jKQnndC YEkuNr B4oWnw gTlJpMihP you RoSWr9 90YabLJwD LsAfUX VvuSGp1 eX0OM0rc4 M9jrYge0w 2soRr61 GOp sU130fOC afu wjhUDt4G HsP4r yzGVzd G6R3pRPBc YwF EiSdGS 6qJsiI vyUEF4Qa yRPifOB S1Z3C VNe9T VeRrpYh2 c978gVLj0 yaMyCUp wffVnq8K 8qNNCW12 3TBfAp4 U0y3P D8IQpNo tKebUd LkU KO4y Xnp R5Dk7 yDO32axeq pGxnZ7 toKSHdih xZNTYx iAa3HZAZ h1pR2c 4mjAaR6 ABMmjc nPJ s5OP zwfEes9Wy KFuRLaw qhC slfg2em0 fs8lftfYB p37HfjalQ zNMIHxaNm AVWd8j ApGD vfX 0Jx21mfR RqH qTxxM0 v9BAXf2e jaK92iBAE MRSwJ UMq vrlfRlsSH cOfKAEcq vNJ YLZE7i3 y7gJ ssba2 313HixfVn PwgrwPrw HQDBrZ VWOPewMBK SNa', 81, '2014-03-18 16:35:53', '2014-03-25 10:10:54', 3),
);

echo('art ' . ORM::for_table('pw_article')->count() . '<br>');

ORM::get_db()->exec('DROP TABLE IF EXISTS pw_category;');
ORM::get_db()->exec(
    'CREATE TABLE pw_category (' .
        'cat_id INTEGER PRIMARY KEY AUTOINCREMENT, ' .
        'cat_title VARCHAR(254))'
);

function create_cat($title) {
    $cat = ORM::for_table('pw_category')->create();    
    $cat->cat_title = $title;
    $cat->save();
    return $cat;
}

$category_list = array(
    create_cat(' ia36iFIn X07 gOiSjqnz'),
    create_cat(' lrY3Dywf'),
    create_cat(' GEDrF6'),    
);

echo('cat ' . ORM::for_table('pw_category')->count() . '<br>');

ORM::get_db()->exec('DROP TABLE IF EXISTS pw_article_category;');
ORM::get_db()->exec(
    'CREATE TABLE pw_article_category (' .
        'artc_art_id INTEGER, ' .
        'artc_cat_id INTEGER, ' .
        'FOREIGN KEY(artc_art_id) REFERENCES pw_article(art_id), ' .
        'FOREIGN KEY(artc_cat_id) REFERENCES pw_category(cat_id))'
);

function create_art_cat($art_id, $cat_id) {
    $art_cat = ORM::for_table('pw_article_category')->create();    
    $art_cat->artc_art_id = $art_id;
    $art_cat->artc_cat_id = $cat_id;
    $art_cat->save();
    return $art_cat;
}

$category_list = array(
    create_art_cat(1, 1),
    create_art_cat(2, 3),
    create_art_cat(3, 3 ),
    create_art_cat(4, 1),
    create_art_cat(4, 2),
    create_art_cat(5, 2),
    create_art_cat(5, 3)
);
 
echo('art_cat ' . ORM::for_table('pw_article_category')->count() . '<br>');

ORM::configure('id_column_overrides', array(
    'pw_user' => 'usr_id',
    'pw_article' => 'art_id',
    'pw_category' => 'cat_id',
    'pw_article_category' => ''
));

