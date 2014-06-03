#include "World.h"

// constructor care primeste ca parametru latura cubului
Object::Object() : Object3D()
{
	// valori default
	diffuse  = Vector4D(1,1,1,1);
	ambient  = Vector4D(0,0,0,0);
	specular = Vector4D(1,1,1,1);
	color	 = Vector3D(1,1,1);
	scale	 = Vector3D(1.0,1.0,1.0);
	
	// default , nu este wireframe
	Wireframe = false;

	latura = 0.5;

}

// functie care returneaza latura cubului
GLfloat Object::GetLatura()
{
	return latura;
}

// Seteaza culoare difuza ( atentie , la testul alfa se foloseste componenta A din culoarea difuza !!!_
Vector4D Object::GetDiffuse()
{
	return diffuse;
}

// functie care seteaza latura cubului
void Object::SetLatura(GLfloat _latura)
{
	latura = _latura;
}

// Seteaza culoare difuza ( atentie , la testul alfa se foloseste componenta A din culoarea difuza !!!_
void Object::SetDiffuse(Vector4D *color)
{
	diffuse = *color;
}

// DRAW
// Suprascriem prin polimorfism functia de desenare a clasei parinte 
// pentru a avea propria functie de desenare
//-------------------------------------------------

void Object::Draw (float vertices[8][3], int facades[6][4], int type)
{
	// daca nu este vizibil, nu-l desenam
	if(!Visible)
	return;

	glPushMatrix();

	// translatie
	glTranslatef( translation.x , translation.y , translation.z );

	// rotatie
	glRotatef( rotation.x , 1.0 , 0.0 , 0.0 );
	glRotatef( rotation.y , 0.0 , 1.0 , 0.0 );
	glRotatef( rotation.z , 0.0 , 0.0 , 1.0 );

	// scalare
	glScalef( scale.x , scale.y , scale.z);

	// setari de material :
	// daca nu este selectat
	if( !selected )
	{
		// culoare normala
		glColor3f(color.x,color.y,color.z);
		glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE,(Vector4D(diffuse.x,diffuse.y,diffuse.z,diffuse.a)).Array());
	}
	else
	{
		// culoarea atunci cand obiectul este selectat
		glColor3f(SelectedColor.x, SelectedColor.y, SelectedColor.z);
		glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE,(Vector4D(SelectedColor.x,SelectedColor.y,SelectedColor.z,1)).Array());
	}
	// culoare speculara, default
	glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,(Vector4D(0.1,0.1,0.1,1)).Array());

	// daca este wireframe
	if( Wireframe )
	{
		glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	}
	// daca nu este wireframe
	else
	{
		glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	}

	// desenare quaduri care alcatuiesc cubul

	if (type == 0)
	{
		glScaled(latura, latura, latura);
		glutSolidDodecahedron();
	}
	else
	{
		glBegin(GL_QUADS);

		for (int i = 0; i < 6; i++)
		{
			for (int j = 0; j < 4; j++)
			{
				if (i == 0)
					glNormal3f(0.0, 0.0, -1.0);
				else if (i == 1)
					glNormal3f(0.0, 0.0, 1.0);
				else if (i == 2)
					glNormal3f(-1.0, 0.0, 0.0);
				else if (i == 3)
					glNormal3f(1.0, 0.0, 0.0);
				else if (i == 4)
					glNormal3f(0.0, 1.0, 0.0);
				else if (i == 5)
					glNormal3f(0.0, -1.0, 0.0);

				glVertex3f(vertices[facades[i][j]][0]*type, vertices[facades[i][j]][1]*type, vertices[facades[i][j]][2]*type);
			}
		}
		glEnd();
	}
	glPopMatrix();
}