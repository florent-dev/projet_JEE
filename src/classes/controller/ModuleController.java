package classes.controller;

import classes.entity.Groupe;
import classes.entity.Module;
import classes.repository.GroupeDAO;
import classes.repository.ModuleDAO;
import classes.utils.GestionFactory;
import classes.utils.ControllerUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/moduleController")
public class ModuleController extends HttpServlet {

    // URL
    private String urlList;
    private String urlUpdate;
    private String url404;

    @Override
    public void init() throws ServletException {
        // Récupération des URLs en paramètre du web.xml
        urlList = getInitParameter("list");
        urlUpdate = getInitParameter("update");
        url404 = getInitParameter("404");

        // Création de la factory permettant la création d'EntityManager (gestion des transactions)
        GestionFactory.open();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // On passe la main au get
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // On récupère la méthode d'envoi de la requête
        String methode = request.getMethod().toLowerCase();

        // On récupère l'action à exécuter
        String action = request.getPathInfo();
        System.out.println(action);

        if (action == null || action.equals("/")) {
            action = "/list";
            //System.out.println("action == null");
        }

        // Accès aux différentes pages, pas de .jsp dans le nom de l'action
        switch (action) {
            case "/list":
                listAction(request, response);
                break;
            case "/viewNotes":
                viewNotesAction(request, response);
                break;
            case "/create":
                createAction(request, response);
                break;
            case "/delete":
                deleteAction(request, response);
                break;
            default:
                listAction(request, response);
        }
    }

    private void listAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        loadJSP(urlList, request, response);
    }
    // -------------------------


    private void viewNotesAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // On vérifie qu'on ait module et groupe
        String moduleId = request.getParameter("module");
        String groupeId = request.getParameter("groupe");

        if (moduleId == null || groupeId == null) {
            loadJSP(url404, request, response);
            return;
        }

        Module module = ModuleDAO.find(Integer.parseInt(moduleId));
        Groupe groupe = GroupeDAO.find(Integer.parseInt(groupeId));

        if (module == null || groupe == null) {
            loadJSP(url404, request, response);
            return;
        }

        request.setAttribute("module", module);
        request.setAttribute("groupe", groupe);

        // Traitement de formulaires
        String ajouterModuleAction = request.getParameter("ajouterControle");
        String ajouterNoteEtudiantControleAction = request.getParameter("ajouterNoteEtudiantControle");


        loadJSP(url404, request, response);
    }

    private void createAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nomModule = request.getParameter("nomModule");

        if (nomModule != null) {
            ModuleDAO.create(nomModule);
        }

        response.sendRedirect(request.getContextPath() + "/module/list");
    }

    private void updateAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idModule = ControllerUtils.parseRequestId(request.getParameter("id"));
        String nomModule = request.getParameter("nomModule");

        // Protection sur l'idEtudiant.
        if (idModule == 0) {
            response.sendRedirect(request.getContextPath() + "/module/list");
            return;
        }

        if (nomModule != null) {
            Module module = ModuleDAO.find(idModule);
            module.setNom(nomModule);
            ModuleDAO.update(module);

            response.sendRedirect(request.getContextPath() + "/module/list");
            return;
        }

        loadJSP(urlUpdate, request, response);
    }

    private void deleteAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idModule = ControllerUtils.parseRequestId(request.getParameter("id"));

        if (idModule != 0) {
            Module module = ModuleDAO.find(idModule);

            if (module != null) {
                ModuleDAO.remove(module);
            }

        }

        response.sendRedirect(request.getContextPath() + "/etudiant/list");
    }

    private void notFoundAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        loadJSP(url404, request, response);
    }

    public void loadJSP(String url, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext sc = getServletContext();
        RequestDispatcher rd = sc.getRequestDispatcher(url);
        rd.forward(request, response);
    }

    public void destroy() {
        super.destroy();
        GestionFactory.close();
    }
}