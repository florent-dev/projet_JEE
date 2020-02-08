package classes.utils;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class GestionFactory {

	// Nom de l'unité de persistence
	// Permet le lien avec le fichier persistence.xml présent dans le dossier META-INF
	// Ce fichier contient les propriétés de connexion à la base de données
	private static final String PERSISTENCE_UNIT_NAME = "Projet_JPA_SQLITE";

	// Factory pour la création d'EntityManager (gestion des transactions)
	public static EntityManagerFactory factory;

	// Création de la factory
	public static void open() {
		factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
	}

	// Fermeture de la factory
	public static void close() {
		factory.close();
	}
}