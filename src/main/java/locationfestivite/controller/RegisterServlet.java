package locationfestivite.controller;

import locationfestivite.model.Utilisateur;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Insertion dans BD
            String sql = "INSERT INTO utilisateur (nom, email, telephone, mot_de_passe, role) VALUES (?, ?, ?, ?, 'CLIENT')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, nom);
            stmt.setString(2, email);
            stmt.setString(3, telephone);
            stmt.setString(4, password);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // CONNEXION AUTOMATIQUE 
                Utilisateur user = new Utilisateur();
                user.setNom(nom);
                user.setEmail(email);
                user.setRole("CLIENT");

                HttpSession session = request.getSession();
                session.setAttribute("utilisateurConnecte", user);

                // REDIRECTION VERS L'ACCUEIL
                System.out.println("✅ Nouvel utilisateur inscrit et connecté : " + nom);
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                
            } else {
                request.setAttribute("error", "Erreur lors de la création du compte.");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Cet email est déjà utilisé ou la base de données est inaccessible.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }
}