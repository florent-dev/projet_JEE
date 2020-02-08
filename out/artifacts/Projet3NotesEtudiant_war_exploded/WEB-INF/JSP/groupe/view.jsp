<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.Collection" %>
<%@ page import="classes.entity.*" %>
<%@ page import="classes.entity.Module" %>
<%@ page import="classes.repository.EtudiantDAO" %>
<%@ page import="classes.repository.EvaluationDAO" %>
<%@ page import="classes.repository.ModuleDAO" %>

<jsp:include page='<%= application.getInitParameter("entetedepage") %>' />

<jsp:useBean id="groupe" class="classes.entity.Groupe" scope="request"/>

<%
    // Récupération de la liste d'étudiants
    Collection<Etudiant> listeEtudiants = EtudiantDAO.getAllByGroupe(groupe);

    // Récupération de la liste des modules liés au groupe et tous les modules
    Collection<Module> groupeModules = groupe.getModules();
    Collection<Module> listeModules = ModuleDAO.getAll();
%>

<h2 class="display-4 text-white">Groupe <%= groupe.getNom() %></h2>

<div class="row text-white">

    <div class="col-lg-7">
        <div class="bg-white p-5 rounded my-5 shadow-sm">
            <table class="table">
                <% for (Module module: groupeModules) { %>
                <tr>
                    <td>
                        <%= module.getNom() %>
                        <% for (Evaluation evaluation: EvaluationDAO.getByGroupeAndModule(groupe, module)) { %>
                            blabla
                        <% } %>
                    </td>
                    <td class="text-right">
                        <a href="<%= application.getContextPath() %>/groupe/notes?module=<%= module.getId() %>&groupe=<%= groupe.getId() %>">
                            <i class="fa fa-plus mt-1"></i> Nouvelle évaluation
                        </a>
                    </td>
                </tr>
                <% } %>
            </table>

            <hr>

            <form action="<%= application.getContextPath() %>/groupe/ajouterModule?id=<%= groupe.getId() %>" method="POST">
                <select class="form-control" name="ajouterModuleAuGroupe" onchange="this.form.submit()">
                    <option class="disabled" disabled selected value="">Ajouter un module au groupe</option>
                    <% for (Module module: listeModules) { %>
                        <% if (!groupeModules.contains(module)) { %>
                        <option value="<%= module.getId() %>"><%= module.getNom() %></option>
                        <% } %>
                    <% } %>
                </select>
            </form>
        </div>
    </div>

    <div class="col-lg-5">
        <div class="bg-white p-5 rounded my-5 shadow-sm">
            <table class="table table-striped table-borderless">
                <tr>
                    <th>Liste des étudiants</th>
                </tr>
                <% for (Etudiant etudiant: listeEtudiants) { %>
                <tr>
                    <td>
                        <a href="<%= application.getContextPath() %>/etudiant/view?id=<%= etudiant.getId() %>">
                            <%= etudiant.getNom() %>
                            <%= etudiant.getPrenom() %>
                        </a>
                    </td>
                </tr>
                <% } %>
            </table>

            <a href="<%= application.getContextPath() %>/groupe/absence" class="btn btn-outline-info">Faire l'appel</a>
        </div>
    </div>

</div>

<jsp:include page='<%= application.getInitParameter("pieddepage")%>'/>