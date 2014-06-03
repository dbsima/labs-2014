EGC - TEMA4
Imperiul Contraataca (SpaceEscape 2012)
Sima Dragos-Bogdan 332CA

Cuprins
1.Cerinta
2.Utilizare
3.Implementare
4.Testare
5.Probleme Aparute
6.Fisiere sursa
7.Functionalitati si bonusuri

1. Cerinta
Dezvoltati un program in C++, folosind OpenGL, care va implementa jocul Imperiul
Contraataca. In acest joc, personajul principal conduce o nava printr-o centura 
de asteroizi, singurul avantaj al eroului fara nume fiind viteza navei sale si 
priceperea sa in manevrarea acesteia.

2. Utilizare
1) deschidere program
2) jocul se afla by default in camera dinamica care priveste spatiul de joc 
dintr-o directie perpendiculara pe una din fetele laterale ale paralelipipedului
 3D al zonei de joc (din acest moment este posibila trecerea intr-un alt tip 
 de fereastra)
4) directionare "erou" prin centura spre evitarea asteroizilor sau distrugerea 
asteroizilor potential periculosi pentru integritatea navei
5) in cazul in care nava este distrusa, sau se doreste reinceperea jocului 
aceasta activitate este posibila

2.1 Taste :
		
	"1" - camera dinamica
	"2" - Camera Nava
	"3" + click stanga pe asteroidul dorit - Camera Asteroid
	
	"W"   - deplasarea camera dinamica inainte
	"S"   - deplasarea camera dinamica inapoi
	"A"   - deplasarea camera dinamica stanga
	"D"   - deplasarea camera dinamica dreapta
	"Q"   - deplasarea camera dinamica sus
	"E"   - deplasarea camera dinamica jos
	
	"I"   - deplasarea nava inainte
	"K"   - deplasarea nava inapoi
	"J"   - deplasarea nava stanga
	"L"   - deplasarea nava dreapta
	"U"   - deplasarea nava sus
	"O"   - deplasarea nava jos
	
	"R"   - new game
	"ESC" - incetarea rularii programului
	
2.2 Butoane :

Click stanga pe un asteroid in orice moment diferit de cel in care jocul se afla
in mod Camera asteroid va duce la distrugerea acestuia, iar daca inainte a fost
selectata modul camerei pe asteroid atunci se va pozitiona camera pe asteroidul
pe care s-a facut click.

3. Implementare

IDE : Microsoft Visual C++ 2012

Sistem de operare: Windows 7 Ultimate

Algoritm:
	Inainte de inceperea jocului in sine se citesc datele din fisierul cube.off
sper a fi trimise functiei care creaza nava. Crearea scenei presupune initiali-
zarea camerelor, a navei si a scutului ei, a asteroizilor si a luminilor. In
ceea ce priveste asteroizii, dimensiunea, viteza, culoarea si pozitia sunt gene-
rate aleator cu conditia ca ei sa fie pozitionati in stanga lumii si avansand
sper dreapta acesteia (privind din pozitia default a observatorui).
	Pozitia luminilor omnnidirectionale este una care favorizeaza expunerea 
obiectelor din scena, culorile emanate fiind diferite(una alba si una albastra).
Pozitia luminilor de tip spot de pe nava este de asa maniera incat lumina emana-
ta sa bata spre asteroizi.
	Daca nava este ciocnita de asteroizi de 4 ori va avea loc distrugerea navei 
si implicit oprirea jocului (reluare joc prin restart).
	Daca jocul se afla in mod camera dinamica sau camera nava atunci selectarea
cu click stanga a unui asteroid va duce la distrugerea acestuia, altfel are loc
trecerea in mod camera asteroid.
	Daca un asteroid paraseste lumea 3D descrisa de un paralelipiped imaginar
atunci acesta nu va mai fi desenat in continuare ci i se vor asigna noi date el
urmand sa "reintre" din nou in lume pentru a asigura un numar suficient de aste-
roizi in orice moment al jocului.
	Daca un asteroid se ciocneste de nava va rezulta diminuarea intensitarii
scutului protector, iar la disparitia acestuia la distrugerea navei.
	Jocul nu se termina niciodata decat prin distrugerea navei sau restartarea
jocului.

4. Testare
	Am efectuat teste pe mai multe cazuri diferite, cum ar fi cazul in care ca-
mera se afla pe un asteroid si acesta dispare din "lume" moment in care se va 
reveni la camera dinamica.

5. Probleme aparute

	Problemele cele mai grele au fost in alegerea unui algoritm cat mai cores-
punzator pentru pozitionarea camerei pe asteroid si indreptarea centrului de 
atentie intotdeauna catre nava. O alta probleme rezolvata mai greu a fost conto-
rizarea ciocnirilor nava-asteroid, culminand intr-un final cu distrugerea navei.

6. Fisiere sursa

Vector3D.h				- sursa cu functiile pentru clasa Vector3D
Vector4D.h				- sursa cu functiile pentru clasa Vector4D
Camera.cpp				- sursa cu functiile pentru clasa Camera
Camera.h				- fisier header pentru sursa de mai sus
Object3D.cpp			- sursa cu functiile pentru clasa Object3D
Object3D.h				- fisier header pentru sursa de mai sus
World.cpp				- sursa cu functiile pentru clasa World
World.h					- fisier header pentru sursa de mai sus
Light.cpp				- sursa cu functiile pentru clasa Light
Light.h					- fisier header pentru sursa de mai sus
Main.cpp 				- sursa principala a aplicatiei
README.txt				- descrierea temei
cube.off				- fisierul .off continand configuatii pentru nava

7. Functionalitati si bonusuri

Functionalitati Standard (ca in enunt) 
+ asigurarea ca in interiorul zonei de joc se afla un numar suficient de 
asteroizi pentru a avea ce sa evitati cu nava, realizata prin reintroducerea
astedoizilor in lumea 3D imediat ce acestia au fost distrusi sau au iesit din ea
+ resetare joc in cazul in care nava a fost distrusa

