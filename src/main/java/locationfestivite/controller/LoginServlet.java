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
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Affiche page de connexion 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    // Traite le formulaire
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        //  VERIFICATION ADMIN
        if (locationfestivite.util.AppConfig.ADMIN_EMAIL.equals(email) && 
            locationfestivite.util.AppConfig.ADMIN_PASSWORD.equals(password)) {
            
            Utilisateur admin = new Utilisateur();
            admin.setNom(locationfestivite.util.AppConfig.ADMIN_NAME);
            admin.setEmail(locationfestivite.util.AppConfig.ADMIN_EMAIL);
            admin.setRole("ADMIN");

            session.setAttribute("utilisateurConnecte", admin);
            System.out.println("🚀 Admin connecté via AppConfig");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return; // On arrête ici, pas besoin de chercher en base
        }

        // VERIFICATION DES CLIENTS
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM utilisateur WHERE email = ? AND mot_de_passe = ? AND role = 'CLIENT'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Utilisateur client = new Utilisateur();
                client.setId(rs.getInt("utilisateur_id"));
                client.setNom(rs.getString("nom"));
                client.setEmail(rs.getString("email"));
                client.setRole("CLIENT");

                session.setAttribute("utilisateurConnecte", client);
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("error", "Email ou mot de passe incorrect.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }}