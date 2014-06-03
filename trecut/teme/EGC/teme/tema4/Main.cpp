// INCLUDES
//-------------------------------------------------
#include <stdlib.h>
#include <freeglut.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <time.h>
#include <math.h>

#include "Camera.h"
#include "Object3D.h"
#include "Light.h"
#include "World.h"
#include "Vector3D.h"
#include "Vector4D.h"

// tasta escape
#define ESC	27

float *Vector3D::arr;
float *Vector4D::arr;

// VARIABILE
//-------------------------------------------------
// numarul de obiecte
int objectCount;

// obiectul selectat
int selectedIndex = -1;

// camera
Camera *camera_front, *camera_on_spaceship, *camera_on_asteroid;

// vector de obiecte 3D
Object *objects;

// nava
Object *spaceship;

//scutul
Object *shield;

// lumina omni
Light *light_o1, *light_o2;
// lumina spot
Light *light_s1, *light_s2;

// identificatori ferestre
int fereastraStanga = -1, mainWindow = -1;

// pe ce obiect a fost executat pick
int obiect = -1;

// pozitii asteroizi
int onX[4] = {-8, -7, -6, -5};
int onY[7] = {-3, -2, -1, 0, 1, 2, 3};
int onZ[11] = {-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5};

// dimenstiune asteroizi
GLfloat dim[5] = {0.30, 0.25, 0.20, 0.15, 0.10};

//viteza asteroizi
float speed[3] = {0.001, 0.002, 0.004};

// culori asteroizi
float color[4][3] = {{0.752941, 0.752941, 0.752941}, {0.647059, 0.164706, 0.164706}, {0.36, 0.25, 0.20}, {0.35, 0.16, 0.14}};
// Gray			 = (0.752941, 0.752941, 0.752941)
// Brown		 = (0.647059, 0.164706, 0.164706)
// DarkBrown	 = (0.36, 0.25, 0.20)
// VeryDarkBrown = (0.35, 0.16, 0.14)

// camera type
bool front		  = true;
bool on_spaceship = false;
bool on_asteroid  = false;

// matrici pentru configurare obiect .off
float vertices[8][3];
int facades[6][4];

// id-ul asteroidului purtator de camera
int asteroid = -1;

// asteroid i lovit -> crash[i]=1
int *crash;

// numarul de cioniri nava-asteroid
int destroyed = 0;

// asteroid purtator de camera neales
bool chosen = false;

// FUNCTII
//-------------------------------------------------

// functie ce verifica daca un obiect de tip sphera are vre-un
// punct de intersectie cu un cub
inline float squared(float v) { return v * v; }
bool doesObjectIntersectSphere(Object *spaceship, Object asteroid)
{
	Vector3D as = spaceship->GetPosition();
	float R = sqrtf(3)*asteroid.GetLatura();

	//C1, C2 - doua varfuri opuse ale cubului (navei)
	Vector3D C1;
	C1.x = as[0] - 0.125;
	C1.y = as[1] - 0.125;
	C1.z = as[2] + 0.125;
	Vector3D C2;
	C1.x = as[0] + 0.125;
	C1.y = as[1] + 0.125;
	C1.z = as[2] - 0.125;

	//S - centrul sferei (asteroidului)
	Vector3D S = asteroid.GetPosition();
	
    float dist_squared = R * R;
    
    if (S.x < C1.x) 
		dist_squared -= squared(S.x - C1.x);
    else if (S.x > C2.x) 
		dist_squared -= squared(S.x - C2.x);
    if (S.y < C1.y) 
		dist_squared -= squared(S.y - C1.y);
    else if (S.y > C2.y) 
		dist_squared -= squared(S.y - C2.y);
    if (S.z < C1.z) 
		dist_squared -= squared(S.z - C1.z);
    else if (S.z > C2.z) 
		dist_squared -= squared(S.z - C2.z);

    return dist_squared > 0;
}

// functie de initializare a setarilor ce tin de contextul OpenGL asociat ferestrei
void init(void)
{
	// pregatim o scena noua in opengl
	glClearColor(0.0, 0.0, 0.0, 0.0);	// stergem tot
	glEnable(GL_DEPTH_TEST);			// activam verificarea distantei fata de camera (a adancimii)
	glShadeModel(GL_SMOOTH);			// mod de desenare SMOOTH
	glEnable(GL_LIGHTING);				// activam iluminarea
	glEnable(GL_NORMALIZE);				// activam normalizarea normalelor
}

// functie de initializare a scenei 3D
void initScene(void)
{
	// initialize vector arrays
	Vector3D::arr = new float[3];
	Vector4D::arr = new float[4];

	// initializam camera pentru vedere front ( cea default )
	camera_front = new Camera();

	// set the number of asteroids
	objectCount = 25;
	objects = new Object[objectCount];

	// initially no astedoids has hit the spaceship
	crash = new int[objectCount];
	for (int i = 0; i < objectCount; i++)
		crash[i] = 0;

	// initiate the spaceship
	spaceship = new Object();
	spaceship->SetDiffuse(new Vector4D(1.0, 0.0, 0.0, 1.0));
	spaceship->SetPosition(new Vector3D(5.0, 0.0, 0.0));

	// initializam lumina 1 spot de pe nava
	light_s1 = new Light();
	// setam tipul de lumina
	light_s1->SetLightType(IlluminationType::Spot);
	// setam pozitia
	light_s1->SetPosition(new Vector3D(5, 0, -0.1));

	// initializam lumina 2 spot de pe nava
	light_s2 = new Light();
	// setam tipul de lumina
	light_s2->SetLightType(IlluminationType::Spot);
	// setam pozitia
	light_s2->SetPosition(new Vector3D(5, 0, 0.1));

	//setare camera de pe nava
	camera_on_spaceship = new Camera();

	camera_on_spaceship->SetPosition(new Vector3D(5.0, 0.0, 0.0));
	camera_on_spaceship->SetForwardVector(new Vector3D(-1, 0, 0));
	camera_on_spaceship->SetRightVector(new Vector3D(0, 0, -1));
	camera_on_spaceship->SetUpVector(new Vector3D(0, 1, 0));

	//setare scut
	shield = new Object();
	shield->SetDiffuse(new Vector4D(1.0, 1.0, 0.0, 0.8));
	shield->SetPosition(new Vector3D(5.0, 0.0, 0.0));

	//setare camera pe asteroid
	camera_on_asteroid = new Camera();
	camera_on_asteroid->SetPosition(new Vector3D(-4.5, 0, 0));
	camera_on_asteroid->SetForwardVector(new Vector3D(1, 0, 0));
	camera_on_asteroid->SetRightVector(new Vector3D(0, 0, -1));
	camera_on_asteroid->SetUpVector(new Vector3D(0, 1, 0));

	// pentru fiecare obiect
	for (int index = 0; index < objectCount; index++ )
	{
		int X, Y, Z, D, S, C;
		X = rand() % 4;
		Y = rand() % 7;	
		Z = rand() % 11;
		D = rand() % 5;
		S = rand() % 3;
		C = rand() % 4;
		
		objects[index].SetLatura(dim[D]);

		objects[index].transX = onX[X];
		objects[index].transY = onY[Y];
		objects[index].transZ = onZ[Z];

		objects[index].speed = speed[S];

		// setam culoarea
		GLfloat R = color[C][0];
		GLfloat G = color[C][1];
		GLfloat B = color[C][2];
		objects[index].SetDiffuse(new Vector4D(R, G, B, 1.0));
	}

	// initializam lumina omnidirectionala 1
	light_o1 = new Light();
	// setam pozitia
	light_o1->SetPosition(new Vector3D(-2, 0, 3));
	//setam culoarea
	//light_o1->SetLightColor(new Vector4D(0, 1, 0, 1));

	// initializam lumina omnidirectionala 2
	light_o2 = new Light();
	//setam culoarea
	light_o2->SetLightColor(new Vector4D(0, 0, 1, 1));
	// setam pozitia
	light_o2->SetPosition(new Vector3D(2, 0, 6));

}

// functie pentru output 
void output(GLfloat x, GLfloat y, char *format,...)
{
	va_list args;

	char buffer[1024],*p;

	va_start(args, format);

	vsprintf(buffer, format, args);

	va_end(args);

	glPushMatrix();
	
	glTranslatef(x,y,-15);

	glScalef(0.007, 0.007, 0.0);

	for (p = buffer; *p; p++)
		glutStrokeCharacter(GLUT_STROKE_MONO_ROMAN, *p);

	glPopMatrix();
}

// AFISARE SCENA
//-------------------------------------------------

// functie de desenare a scenei 3D
void drawScene(void)
{
	// daca nava a fost lovita de mai mult de 4 ori
	// atunci se va afisa un mesaj de rigoare
	if (destroyed == 4)	
	{
		camera_front->Render();

		glColor3f(1.0, 1.0, 1.0);
		glDisable(GL_LIGHTING);
		glLineWidth(1.0);
		output(-7, 4, "The spaceship was destroyed!");
		output(-7, 2, "Press R for new game.");
		glEnable(GL_LIGHTING);
		
	}
	// altfel se afiseaza lumea 3D
	else
	{
		// deselectie obiect vechi
		if (selectedIndex > -1)
			objects[selectedIndex].Deselect();
		
		// selectie obiect nou
		if (obiect > -1)
		{	
			if (on_asteroid && asteroid == -1)
			{
				asteroid = obiect;
			}
			else
			{
				objects[obiect].Select();
				selectedIndex = obiect;
			}
		}
		// activare lumini omnidirectionale
		light_o1->Render();
		light_o2->Render();
	
		// activare lumini spot
		light_s1->Render();
		light_s2->Render();
	
		// desenare obiecte
		for ( int i = 0 ; i < objectCount; i ++ )
		{
			// setare pozitie astedoizi
			objects[i].SetPosition(new Vector3D(objects[i].transX, objects[i].transY, objects[i].transZ));
			objects[i].transX += objects[i].speed;

			//mecanism pinking
			glPushName(i);

			// daca asteroidul se afla in cutia virtuala si nu a fost selectat
			// pentru distrugere sau a fost selectat pentru distrugere dar inca
			// nu a trecut suficient timp pentru observarea acestei actiuni
			if (objects[i].transX >= -5 && objects[i].transX <= 5 && !objects[i].isShowedSelection() && !chosen && crash[i] == 0)
			{ 
				objects[i].Draw(vertices, facades, 0);	// afisare obiect
				
				// daca a trecut suficient timp pentru observarea selectiei
				// se afiseaza raza laser
				if (objects[i].isSelected())
				{
					objects[i].SetShowedSelection();
				
					Vector3D at = spaceship->GetPosition();
					glBegin(GL_LINES);
						glVertex3f(objects[i].transX, objects[i].transY, objects[i].transZ);
						glVertex3f(at[0], at[1], at[2]);
					glEnd();
				}
			}
			// daca asteroidul a parasit lumea 3D sau a fost distrus si
			else if (objects[i].transX > 5 || objects[i].isShowedSelection() || crash[i] == 1)
			{
				// daca camera se afla pe un asteroid iar acesta paraseste
				// lumea 3D atunci se revine la camera default
				if (objects[i].transX > 5 && on_asteroid && asteroid == i)
				{
					for (int j = 0; j < objectCount; j++)
						objects[j].SetNotShowedSelection();

					front		 = true;
					on_spaceship = false;
					on_asteroid  = false;
					selectedIndex = -1;
					obiect		 = -1;
					asteroid	 = -1;
					chosen		 = false;
				}
				// iar altfel se atribuie noi date pentru 
				// creearea unui nou asteroid
				else
				{
					int X, Y, Z, D, S, C;
					X = rand() % 4;
					Y = rand() % 7;	
					Z = rand() % 11;
					D = rand() % 5;
					S = rand() % 3;
					C = rand() % 4;
		
					//setam dimensiunea
					objects[i].SetLatura(dim[D]);
			
					//setam pozitia
					objects[i].transX = onX[X];
					objects[i].transY = onY[Y];
					objects[i].transZ = onZ[Z];

					//setam viteza
					objects[i].speed = speed[S];

					// setam culoarea
					GLfloat R = color[C][0];
					GLfloat G = color[C][1];
					GLfloat B = color[C][2];
					objects[i].SetDiffuse(new Vector4D(R, G, B, 1.0));

					objects[i].SetNotShowedSelection();

					objects[i].Deselect();
					selectedIndex = -1;
					obiect = -1;

					crash[i] = 0;
				}
			}
			glPopName();
		}
		// in orice moment al jocului daca vre-un asteroid se loveste
		// de nava atunci
		for (int i = 0; i < objectCount; i++)
			if (doesObjectIntersectSphere(spaceship, objects[i]))
			{
				if (crash[i] == 0)
				{
					Vector4D ast = shield->GetDiffuse();
					
					// daca numarul de lovituri este egal cu 4
					// nava este distrusa
					if (destroyed == 4)
					{
						// Debugging
						printf("\n\ncrash! %d \n\n", destroyed);			
					}
					// altfel scade intensitatea scutului
					else
					{
						destroyed ++;
						shield->SetDiffuse(new Vector4D(ast[0], ast[1], ast[2], ast[3] - 0.2));
					}
					crash[i] = 1;
					printf("%d\n", i);
				}
			}
		// daca camera de pe nava este activa atunci nu vor
		// fi afisate nava si scutul
		if (!on_spaceship)
		{
			spaceship->Draw(vertices, facades, 1);
			shield->Draw(vertices, facades, 2);
		}
		// dezactivare luminile
		light_o1->Disable();
		light_o2->Disable();

		light_s1->Disable();
		light_s2->Disable();

		// daca camera de pe asteroid este actica atunci se
		// pozitioneaza camera pe asteroidul selectat
		if (asteroid > -1)
		{
			chosen = true;
			Vector3D ast = objects[asteroid].GetPosition();
			camera_on_asteroid->SetPosition(new Vector3D(ast[0], ast[1], ast[2]));
		}

		// vizualizare observator in functie de fereastra
		if (front)
			camera_front->Render();
		else if (on_spaceship)
			camera_on_spaceship->Render();
		else if(on_asteroid && chosen)
			camera_on_asteroid->Render();
	}

}

// functie de desenare (se apeleaza cat de repede poate placa video)
// se va folosi aceeasi functie de display pentru toate subferestrele ( se puteau folosi si functii distincte 
// pentru fiecare subfereastra )
void display(void)
{
	// stergere ecran
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	// mecanismul de transparenta folosind ALPHA TESTING / BLENDING
	// First Pass - alpha test
	glEnable(GL_ALPHA_TEST);
	glAlphaFunc(GL_EQUAL, GL_ONE);
	drawScene();
	
	// Second Pass - blending
	glAlphaFunc(GL_LESS, GL_ONE);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_DST_ALPHA);
	glDepthMask(GL_FALSE);
	drawScene();
	
	glDisable(GL_BLEND);
	glDepthMask(GL_TRUE);

	// double buffering
	glutSwapBuffers();

	// redeseneaza scena
	glutPostRedisplay();
		
}

// PICKING
//-------------------------------------------------

// functia care proceseaza hitrecordurile pentru a vedea daca s-a click pe un obiect din scena
void processhits (GLint hits, GLuint buffer[])
{
   int i;
   GLuint names, *ptr, minZ, *ptrNames, numberOfNames;

   // pointer la inceputul bufferului ce contine hit recordurile
   ptr = (GLuint *) buffer;
   // se doreste selectarea obiectului cel mai aproape de observator
   minZ = 0xffffffff;
   for (i = 0; i < hits; i++) 
   {
      // numarul de nume numele asociate din stiva de nume
      names = *ptr;
	  ptr++;
	  // Z-ul asociat hitului - se retine 
	  if (*ptr < minZ) {
		  numberOfNames = names;
		  minZ = *ptr;
		  // primul nume asociat obiectului
		  ptrNames = ptr+2;
	  }
	  // salt la urmatorul hitrecord
	  ptr += names+2;
  }

  // identificatorul asociat obiectului
  ptr = ptrNames;
  
	obiect = *ptr;
     
}

// functie ce realizeaza picking la pozitia la care s-a dat click cu mouse-ul
void pick(int x, int y)
{
	// buffer de selectie
	GLuint buffer[1024];

	// numar hituri
	GLint nhits;

	// coordonate viewport curent
	GLint	viewport[4];

	// se obtin coordonatele viewportului curent
	glGetIntegerv(GL_VIEWPORT, viewport);
	// se initializeaza si se seteaza bufferul de selectie
	memset(buffer, 0x0, 1024);
	glSelectBuffer(1024, buffer);
	
	// intrarea in modul de selectie
	glRenderMode(GL_SELECT);

	// salvare matrice de proiectie curenta
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();

	// se va randa doar intr-o zona din jurul cursorului mouseului de [1,1]
	glGetIntegerv(GL_VIEWPORT,viewport);
	gluPickMatrix(x, viewport[3] - y, 1.0f, 1.0f, viewport);

	gluPerspective(45,(viewport[2]-viewport[0])/(GLfloat) (viewport[3]-viewport[1]),0.1,1000);
	glMatrixMode(GL_MODELVIEW);

	// se "deseneaza" scena : de fapt nu se va desena nimic in framebuffer ci se va folosi bufferul de selectie
	drawScene();

	// restaurare matrice de proiectie initiala
	glMatrixMode(GL_PROJECTION);						
	glPopMatrix();				

	glMatrixMode(GL_MODELVIEW);
	// restaurarea modului de randare uzual si obtinerea numarului de hituri
	nhits = glRenderMode(GL_RENDER);	
	
	// procesare hituri
	if(nhits != 0)
		processhits(nhits, buffer);
	else
		obiect = -1;
}

// handler pentru tastatura
void keyboard(unsigned char key , int x, int y)
{
	Vector3D at;
	switch (key)
	{
		// la escape se iese din program
		case ESC : exit(0);

		//front camera
		case '1':
			front		 = true;
			on_spaceship = false;
			on_asteroid  = false;
			asteroid	 = -1;
			chosen		 = false;
			break;

		//camera on the spaceship
		case '2':
			front		 = false;
			on_spaceship = true;
			on_asteroid	 = false;
			asteroid	 = -1;
			chosen		 = false;
			break;

		// camera on an asteroid
		case '3':
			front		 = false;
			on_spaceship = false;
			on_asteroid  = true;
			obiect		 = -1;
			asteroid	 = -1;
			chosen		 = false;
			break;

		// cu W A S D Q E camera dinamica se misca prin scena
		case 'w' : case 'W' : 
			 camera_front->MoveForward(0.1);break;
		case 's' : case 'S' : 
			camera_front->MoveBackward(0.1);break;
		case 'a' : case 'A' : 
			 camera_front->MoveRight(0.1);break;
			break;
		case 'd' : case 'D' : 
			camera_front->MoveLeft(0.1);break;
			break;
		case 'q' : case 'Q' : 
			camera_front->MoveUpward(0.1);break;
			break;
		case 'e' : case 'E' : 
			camera_front->MoveDownward(0.1);break;
			break;

		// cu I K J L U O nava se misca prin scena
		case 'i' : case 'I' :
			// setare pozitie nava
			at = spaceship->GetPosition();
			spaceship->SetPosition(new Vector3D(at[0] - 0.1, at[1], at[2]));
			// setare pozitie lumini nava
			light_s1->SetPosition(new Vector3D(at[0] - 0.1, at[1], at[2]));
			light_s2->SetPosition(new Vector3D(at[0] - 0.1, at[1], at[2]));
			// setare pozitie scut
			at = shield->GetPosition();
			shield->SetPosition(new Vector3D(at[0] - 0.1, at[1], at[2]));
			// setare pozitie camera nava
			camera_on_spaceship->MoveForward(0.1);
			break;break;

		case 'k' : case 'K' :
			// setare pozitie nava
			at = spaceship->GetPosition();
			spaceship->SetPosition(new Vector3D(at[0] + 0.1, at[1], at[2]));
			// setare pozitie lumini nava
			light_s1->SetPosition(new Vector3D(at[0] + 0.1, at[1], at[2]));
			light_s2->SetPosition(new Vector3D(at[0] + 0.1, at[1], at[2]));
			// setare pozitie scut
			at = shield->GetPosition();
			shield->SetPosition(new Vector3D(at[0] + 0.1, at[1], at[2]));
			// setare pozitie camera nava
			camera_on_spaceship->MoveBackward(0.1);
			break;break;

		case 'u' : case 'U' :
			// setare pozitie nava
			at = spaceship->GetPosition();
			spaceship->SetPosition(new Vector3D(at[0], at[1] + 0.1, at[2]));
			// setare pozitie lumini nava
			light_s1->SetPosition(new Vector3D(at[0], at[1] + 0.1, at[2]));
			light_s2->SetPosition(new Vector3D(at[0], at[1] + 0.1, at[2]));
			// setare pozitie scut
			at = shield->GetPosition();
			shield->SetPosition(new Vector3D(at[0], at[1] + 0.1, at[2]));
			// setare pozitie camera nava
			camera_on_spaceship->MoveUpward(0.1);
			break;break;

		case 'o' : case 'O' :
			// setare pozitie nava
			at = spaceship->GetPosition();
			spaceship->SetPosition(new Vector3D(at[0], at[1] - 0.1, at[2]));
			// setare pozitie lumini nava
			light_s1->SetPosition(new Vector3D(at[0], at[1] - 0.1, at[2]));
			light_s2->SetPosition(new Vector3D(at[0], at[1] - 0.1, at[2]));
			// setare pozitie scut
			at = shield->GetPosition();
			shield->SetPosition(new Vector3D(at[0], at[1] - 0.1, at[2]));
			// setare pozitie camera nava
			camera_on_spaceship->MoveDownward(0.1);
			break;break;

		case 'j' : case 'J' :
			// setare pozitie nava
			at = spaceship->GetPosition();
			spaceship->SetPosition(new Vector3D(at[0], at[1], at[2] - 0.1));
			// setare pozitie lumini nava
			light_s1->SetPosition(new Vector3D(at[0], at[1], at[2] - 0.1));
			light_s2->SetPosition(new Vector3D(at[0], at[1], at[2] - 0.1));
			// setare pozitie scut
			at = shield->GetPosition();
			shield->SetPosition(new Vector3D(at[0], at[1], at[2] - 0.1));
			// setare pozitie camera nava
			camera_on_spaceship->MoveRight(0.1);
			break;break;

		case 'l' : case 'L' :
			// setare pozitie nava
			at = spaceship->GetPosition();
			spaceship->SetPosition(new Vector3D(at[0], at[1], at[2] + 0.1));
			// setare pozitie lumini nava
			light_s1->SetPosition(new Vector3D(at[0], at[1], at[2] + 0.1));
			light_s2->SetPosition(new Vector3D(at[0], at[1], at[2] + 0.1));
			// setare pozitie scut
			at = shield->GetPosition();
			shield->SetPosition(new Vector3D(at[0], at[1], at[2] + 0.1));
			// setare pozitie camera nava
			camera_on_spaceship->MoveLeft(0.1);
			break;break;

		//New game -> reset the world
		case 'r': case 'R':
			destroyed = 0;

			obiect = -1;
			selectedIndex = -1;

			front		 = true;
			on_spaceship = false;
			on_asteroid  = false;

			asteroid = -1;
			chosen	 = false;

			for (int i = 0; i < objectCount; i++)
				crash[i] = 0;

			camera_front->SetPosition(new Vector3D(0.0, 0.0, 16));
			camera_front->SetForwardVector(new Vector3D(0.0, 0.0, -1.0));
			camera_front->SetRightVector(new Vector3D(1.0, 0.0, 0.0));
			camera_front->SetUpVector(new Vector3D(0.0, 1.0, 0.0));

			spaceship->SetDiffuse(new Vector4D(1.0, 0.0, 0.0, 1.0));
			spaceship->SetPosition(new Vector3D(5.0, 0.0, 0.0));
			
			camera_on_spaceship->SetPosition(new Vector3D(5.0, 0.0, 0.0));
			camera_on_spaceship->SetForwardVector(new Vector3D(-1, 0, 0));
			camera_on_spaceship->SetRightVector(new Vector3D(0, 0, -1));
			camera_on_spaceship->SetUpVector(new Vector3D(0, 1, 0));

			shield->SetDiffuse(new Vector4D(1.0, 1.0, 0.0, 0.8));
			shield->SetPosition(new Vector3D(5.0, 0.0, 0.0));

			camera_on_asteroid->SetPosition(new Vector3D(-4.5, 0, 0));
			camera_on_asteroid->SetForwardVector(new Vector3D(1, 0, 0));
			camera_on_asteroid->SetRightVector(new Vector3D(0, 0, 1));
			camera_on_asteroid->SetUpVector(new Vector3D(0, 1, 0));

			for (int index = 0; index < objectCount; index++ )
			{
				int X, Y, Z, D, S, C;
				X = rand() % 4;
				Y = rand() % 7;	
				Z = rand() % 11;
				D = rand() % 5;
				S = rand() % 3;
				C = rand() % 4;
		
				objects[index].SetLatura(dim[D]);

				objects[index].transX = onX[X];
				objects[index].transY = onY[Y];
				objects[index].transZ = onZ[Z];

				objects[index].speed = speed[S];

				GLfloat R = color[C][0];
				GLfloat G = color[C][1];
				GLfloat B = color[C][2];
				objects[index].SetDiffuse(new Vector4D(R, G, B, 1.0));

				objects[index].Deselect();
			}
			light_o1->SetPosition(new Vector3D(-2, 0, 3));
			light_o2->SetPosition(new Vector3D(2, 0, 6));
			break;
	
		default: break;
	}
}

// Callback pentru a procesa inputul de mouse
void mouse(int buton, int stare, int x, int y)
{
	switch(buton)
	{
		// Am apasat click stanga : porneste animatia si realizeaza picking
		case GLUT_LEFT_BUTTON:
			if(stare == GLUT_DOWN)
			{
				// in aceasta variabila se va intoarce obiectul la care s-a executat pick
				obiect = -1;
			
				if (!chosen)
					pick(x, y);

			}
			break;
		case GLUT_RIGHT_BUTTON:
			if(stare== GLUT_DOWN)
				glutIdleFunc(NULL);
			break;
	}
}

// Functie pentru redimensionarea subferestrei stanga
void reshapeStanga(int w, int h)
{
	glViewport(0,0, (GLsizei) w, (GLsizei) h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(45, (float)w/h, 1.0, 60.0); 

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	// Initializeaza contextul OpenGL asociat ferestrei
	init();
}

// functie de proiectie
void reshape(int w, int h)
{
	// Main Window
	glViewport(0,0, (GLsizei) w, (GLsizei) h);
	// calculare aspect ratio ( Width/ Height )
	GLfloat aspect = (GLfloat) w / (GLfloat) h;

	// intram in modul proiectie
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	// incarcam matrice de perspectiva 
	gluPerspective(45, aspect, 1.0, 60);

	// Initializeaza contextul OpenGL asociat ferestrei
	init();

	// Fereastra aplicatiei a fost redimensionata : trebuie sa recream subferestrele
	if(fereastraStanga != -1)
		glutDestroyWindow(fereastraStanga);

	// Creeaza fereastra stanga
	fereastraStanga = glutCreateSubWindow(mainWindow, 0, 0, w, h);

 	glutDisplayFunc(display);
	glutReshapeFunc(reshapeStanga);
	glutMouseFunc(mouse);
	glutKeyboardFunc(keyboard);
	
}

// functie main
int main(int argc, char** argv)
{
	// deschidere fisier .off
	FILE *fp;
	if((fp = fopen("cube.off", "rb")) == NULL)
	{
		printf("\n file can not be opened");
		//exit(0);
	}
	// citire date fisier
	char off[3];
	fscanf(fp, "%s", off);
	
	int numVertices;
	fscanf(fp, "%d", &numVertices);

	int numFaces;
	fscanf(fp, "%d", &numFaces);
	
	int numEdges;
	fscanf(fp, "%d", &numEdges);

	for (int i = 0; i < numVertices; i++)
	{
		GLfloat x, y, z;
		fscanf(fp, "%f %f %f", &x, &y, &z);
		vertices[i][0] = x;
		vertices[i][1] = y;
		vertices[i][2] = z;
	}

	for (int i = 0; i < numFaces; i++)
	{
		int nV, v1, v2, v3, v4;
		fscanf(fp, "%d %d %d %d %d", &nV, &v1, &v2, &v3, &v4);
		facades[i][0] = v1;
		facades[i][1] = v2;
		facades[i][2] = v3;
		facades[i][3] = v4;
	}

	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGB);
	
	int w = 800, h = 600;
	glutInitWindowSize(w, h);
	glutInitWindowPosition(100, 100);
	
	// Main window
	mainWindow = glutCreateWindow("Tema4");
		
	glutDisplayFunc(display);
	glutKeyboardFunc(keyboard);
	glutReshapeFunc(reshape);
	glutMouseFunc(mouse);

	// Initializeaza scena 3D
	initScene();

	glutMainLoop();

	return 0;
}