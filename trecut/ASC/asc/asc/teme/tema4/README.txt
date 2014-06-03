ASC - TEMA4
Optimizari pentru TV Channel preview rendering
Sima Dragos-Bogdan 332CA

Cuprins
1.Functionalitate
2.Utilizare
3.Implementare
4.Testare
5.Continutul Arhivei

1. Functionalitate
Avand la dispozitie 16 stream-uri video convertite in imagini PNM de tip P6, 
astfel incat fiecare frame dintr-un stream e reprezentat de o imagine cu o 
rezolutie de 640x384. Folosind arhitectura Cell se poate genera un stream 
"PREVIEW" tot de rezolutie 640x384 ale carui cadre sunt generate prin dispunerea
intr-o matrice 4x4 cadrelor din stream-urile de intrare.

2. Utilizare
- $ unzip tema4_dragos_sima_332CA
- $ scp -R tema4_dragos_sima_332CA username@fep.grid.pub.ro:/asc/tema4
- $ ssh username@fep.grid.pub.ro
- $ cd asc/tema4/tema4_dragos_sima_332CA
- $  ./program input_folder output_folder num_frames num_spus mode
* input_folder: calea catre folderul ce contine imaginile de intrare.
* output_folder: calea catre folderul ce va contine imaginile de iesire
(acesta trebuie sa existe).
* num_frames: numarul de cadre ce se doresc a fi procesate [1,100]
* num_spus: poate fi 1, 2, 4 sau 8.
* mode ia valoarea: 0 (implementarea de baza),
					1 (optimizarea dimensiunii transferului), 
					2 (double buffering), 
					3 (liste DMA).
					
Example:
	./program /tmp/images results/0/ 100 8 0
	./program /tmp/images results/2/ 100 8 2
	diff results/0/result94.pnm results/2/result94.pnm

3. Implementare
Implementarea de baza: 
	* process_image_simple - functia prelucreaza 4 linii din imaginea de input.
	
Optimizarea dimensiunii transferului:
	* process_image_2lines - functia prelucreaza de 2 ori mai multe date pentru
	fiecare transfer (se iau cate 8 linii din imaginea originala, se scaleaza si
	se pun inapoi 2 linii din imaginea scalata).

Double buffering: 
	* process_image_double - functia optimizeaza folosind double buffering.
	
Liste DMA:
	* process_image_dmalist - functia prelucreaza folosind liste DMA (se iau 
	cate 32 de linii din imaginea originala, se scaleaza si se vor pun inapoi 8
	linii din imaginea scalata).
	
4. Testare
	4.1 Mediu de testare:
	Hardware:
		Memory: 3.7 GiB
		Processor: Intel Core i5-2410M CPU @ 2.30GHz x 4
	Software:
		Release 13 (maya) 64-bit Kernel: Linux 3.2.0-23-generic 

	4.2 Rezultate
	num_frames=100
		num_spus=1		
			./program /tmp/images results/0/ 100 1 0
														Scale time: 1.905585
														Total time: 7.531263
			./program /tmp/images results/1/ 100 1 1
														Scale time: 1.636592
														Total time: 7.227683
			./program /tmp/images results/2/ 100 1 2
														Scale time: 1.792791
														Total time: 7.354001
		num_spus=2
			./program /tmp/images results/0/ 100 2 0	
														Scale time: 1.008564
														Total time: 6.600146
			./program /tmp/images results/1/ 100 2 1
														Scale time: 0.866002
														Total time: 6.453217
			./program /tmp/images results/2/ 100 2 2
														Scale time: 0.949403
														Total time: 6.543389
		num_spus=4
			./program /tmp/images results/0/ 100 4 0
														Scale time: 0.557170
														Total time: 6.101586
			./program /tmp/images results/1/ 100 4 1
														Scale time: 0.478975
														Total time: 5.866016
			./program /tmp/images results/2/ 100 4 2
														Scale time: 0.51117
														Total time: 6.009154
		num_spus=8
			./program /tmp/images results/0/ 100 8 0
														Scale time: 0.344434
														Total time: 6.046320
			./program /tmp/images results/1/ 100 8 1
														Scale time: 0.281640
														Total time: 5.935196
			./program /tmp/images results/2/ 100 8 2
														Scale time: 0.303714
														Total time: 5.888889
		
5. Continutul Arhivei
Fisiere noi sau modificate
- README - fisier curent
- spu/spu.c - fisier pt SPU
- results - director cu directoarele pentru rezultate
