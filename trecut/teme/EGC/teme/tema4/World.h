#ifndef Object_H
#define Object_H

#include <freeglut.h>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <iostream>
#include <fstream>

#include "Object3D.h"
#include "Camera.h"

class Object : public Object3D
{
public:

	// Construcot
	Object();

	// Draw
	void Draw (float vertices[8][3], int facades[6][4], int type);

public:
	// Functie pentru a seta latura cubului
	void SetLatura(GLfloat latura);
	// Seteaza culoare difuza ( atentie , la testul alfa se foloseste componenta A din culoarea difuza !!!_
	void SetDiffuse(Vector4D *color);

	// Functie pentru a returna latura cubului
	GLfloat GetLatura();

	// Functie pentru a returna difuzia obiectului
	Vector4D GetDiffuse();
	
private:
	// latura cubului
	GLfloat latura;
	// culoare difuza
	Vector4D diffuse;
	// culoare ambientala
	Vector4D ambient;
	// culoare speculara
	Vector4D specular;
};


#endif
