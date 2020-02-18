		/*************************
		 *         OBJECTS
		/*************************/
		
		String names[] = new String {"Toto", "Jo"};
		int ages[] = new int[] {106, 29}
		short toto = 0, jo = 1;
		
		System.out.println(names[toto] + " a " + ages[toto] + " ans");
		
		// En objet (plus long mais plus structuré)
		
		//Méthode 1 ://
		
		//Avant Main
		class Person {
			String name;
			int age;
		}
		//Dans Main	
			Person persons []= new Person[2];
			short totoIndex = 0, joIndex = 1;
			
			Person toto = new Person();
			toto name = "toto";
			toto age = 106;
			
			Person jo = new Person();
			toto name = "jo";
			toto age = 29;
			
			persons[totoIndex] = toto;
			persons[joIndex] = jo;
			
			Person p = persons[totoIndex]
			
			System.out.println(p.name + " a " + p.age);
			
		//Méthode 2 :// Utilise un constructeur
			
		//Avant Main
		class Person {
			String name;
			int age;
			
		Person(String name, int age) {
			this.name = name;
			this.age = age;
		}
		}
		//Dans Main	
			Person persons []= new Person[]{;
				new Person("toto", 106),
				new Person("jo", 29)
			};
			short toto = 0, jo = 1;
			
			Person p = persons[toto]
			
			System.out.println(p.name + " a " + p.age);
		
		//******************
		  //Encapsulation//
		//******************
			//Déf :L'encapsulation consiste à rendre les membres d'un objet plus ou moins visibles 
			//	   pour les autres objets. La visibilité dépend des membres:certains membres peuvent
			//	   être visibles et d'autres non.
			//	   La visibilité dépend de l'observateur : les membres de l'objet encapsulé peuvent 
			//	   être visibles pour certains objets mais pas pour d'autres.
			//	   L'encapsulation a  pour  objectif  d'améliorer  la robustesse et l'évolutivité
			//	   des programmes. (https://home.mis.u-picardie.fr/~furst/docs/4-Encapsulation_Classes_Internes.pdf)
			
			//	----> public | private | protected (public pour les enfants et private pour les autres) | default(ou package)
		
		//soit dans l'exemple précédent :
		//Dans un nouveau fichier "Person"(car un fichier par classe)
		public class Person {
			private String name;
			private int age;
			
		Person(String name, int age) {
			this.name = name;
			this.age = age;
		}
		
		public String describe() {
			return this.name + " a " + this.age;
		
		//* ou
		//@Override(imposer méthode)
		// public String toString() {
		//	return this.name + " a " + this.age;
		}
		}
		
		//Dans Main (se trouvant dans un autre fichier)	
			Person persons []= new Person[]{
				new Person("toto", 106),
				new Person("jo", 29)
			};
			
			System.out.println("Liste des utilisateurs :");
			
			for (Person p : persons){
			
			System.out.println(" - " + p.describe()); //*ou System.out.println(" - " + p); 
													//pas besoin d'appeler toString (comme describe()) car mécanique interne
			}
			
		//******************
		  //Héritage//
		//******************
		//suite de l'exemple précédent nouvelle Classe "Customer"
			public class Customer extends Person {
				public Customer(String name, int age) {
					super(name,age); //super appelle le parent
				}
			}
			
			@Override
			public String toString() {
				return "Le client " + super.toString();
			}
				
		//Main
		System.out.println(new Customer("Crésus", 10002));
		//--->cela renvoi le sysout du parent + sysout de customer soit :
				Liste des utilisateurs :
				 - toto a 106
				 - jo a 29
				Le client Crésus a 10002