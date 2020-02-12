package classes.repository;

import classes.entity.Module;
import classes.utils.GestionFactory;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.List;

public class ModuleDAO {

    public static Module find(int id) {
        EntityManager em = GestionFactory.factory.createEntityManager();
        Module module = em.find(Module.class, id);
        em.close();

        return module;
    }

    public static List<Module> getAll() {
        // Creation de l'entity manager
        EntityManager em = GestionFactory.factory.createEntityManager();

        // Recherche
        Query q = em.createQuery("SELECT m FROM Module m");

        @SuppressWarnings("unchecked")
        List<Module> moduleList = q.getResultList();

        return moduleList;
    }

    public static Module create(String nom) {

        // Creation de l'entity manager
        EntityManager em = GestionFactory.factory.createEntityManager();

        // create
        em.getTransaction().begin();

        // create new groupe
        Module module = new Module();
        module.setNom(nom);
        em.persist(module);

        // Commit
        em.getTransaction().commit();

        // Close the entity manager
        em.close();

        return module;
    }

    public static Module update(Module module) {

        // Creation de l'entity manager
        EntityManager em = GestionFactory.factory.createEntityManager();

        em.getTransaction().begin();
        em.merge(module);
        em.getTransaction().commit();

        // Close the entity manager
        em.close();

        return module;
    }

    public static void remove(Module module) {
        EntityManager em = GestionFactory.factory.createEntityManager();

        em.getTransaction().begin();

        module = em.find(Module.class, module.getId());
        em.remove(module);

        em.getTransaction().commit();
        em.close();
    }
}
