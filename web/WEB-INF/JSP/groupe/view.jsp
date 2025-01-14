<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.Collection" %>
<%@ page import="classes.entity.*" %>
<%@ page import="classes.entity.Module" %>
<%@ page import="classes.repository.EtudiantDAO" %>
<%@ page import="classes.repository.EvaluationDAO" %>
<%@ page import="classes.repository.ModuleDAO" %>
<%@ page import="classes.utils.CalculUtils" %>

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
            <p class="lead"><b>Modules d'enseignement</b></p>
            <table class="table">
                <% for (Module module: groupeModules) {%>
                <tr>
                    <td>
                        <div>
                            <span class="text-info">
                                <%= module.getNom() %> - <span class="font-italic">Moyenne: <%= CalculUtils.echoDoubleHTML(module.getMoyenne(groupe)) %></span>
                            </span><br />
                            <% for (Evaluation evaluation: EvaluationDAO.getByGroupeAndModule(groupe, module)) { %>
                            <% java.text.DateFormat df = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
                            <li class="list-unstyled ml-4">
                                <a class="text-dark" href="<%= application.getContextPath() %>/groupe/evaluation?id=<%= evaluation.getId() %>">
                                    <%= df.format(evaluation.getDate()) %> - <%= evaluation.getNom() %>
                                </a>
                            </li>
                            <% } %>
                            <a data-toggle="collapse" class="ml-4" href="#ajouterEvaluationCollapse<%= module.getId() %>" role="button" aria-expanded="false" aria-controls="ajouterEvaluationCollapse<%= module.getId() %>">
                                <i class="fa fa-plus mt-1"></i> Nouvelle évaluation
                            </a>
                        </div>

                        <div class="collapse multi-collapse" id="ajouterEvaluationCollapse<%= module.getId() %>">
                            <form method="post" action="<%= application.getContextPath() %>/groupe/createEvaluation">
                                <input type="hidden" name="gid" value="<%= groupe.getId() %>" required />
                                <input type="hidden" name="mid" value="<%= module.getId() %>" required />
                                <input class="btn btn-outline-info btn-sm" type="text" name="nomEvaluation" placeholder="Intitulé de l'évaluation" required />
                                <input class="btn btn-outline-info btn-sm" type="date" name="dateEvaluation" placeholder="Date" required />
                                <input class="btn btn-outline-info btn-sm" type="text" name="descriptionEvaluation" placeholder="Description" required />
                                <input class="btn btn-info btn-sm" type="submit" />
                            </form>
                        </div>

                    </td>
                    <td class="text-right">
                        <a href="<%= application.getContextPath() %>/groupe/retirerModule?id=<%= groupe.getId() %>&mid=<%= module.getId() %>"><i class="fa fa-trash fa-fw text-primary mt-1"></i></a>
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
            <p class="lead"><b>Gestion des absences</b></p>
            <table class="table table-borderless m-0">
                <tr>
                    <td><a href="<%= application.getContextPath() %>/absence/appelGroupe?id=<%= groupe.getId() %>" class="btn btn-outline-info w-100">Faire un appel</a></td>
                    <td><a href="<%= application.getContextPath() %>/absence/viewGroupe?id=<%= groupe.getId() %>" class="btn btn-outline-info w-100">Liste des appels</a></td>
                </tr>
            </table>
        </div>

        <div class="bg-white p-5 rounded my-5 shadow-sm">
            <p class="lead"><b>Liste des étudiants</b></p>
            <table class="table table-sm">
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
            <a href="<%= application.getContextPath() %>/etudiant/list" class="btn btn-outline-info w-100">Ajouter un étudiant</a>
        </div>
    </div>

</div>

<jsp:include page='<%= application.getInitParameter("pieddepage")%>'/>
