package locationfestivite.controller;

import locationfestivite.model.Categorie;
import locationfestivite.model.Type;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Type> topMateriels = new ArrayList<>();
        List<Categorie> categories = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            Statement st = conn.createStatement();
            
            //  Récupérer sélection matériels 4 derniers
            ResultSet rsT = st.executeQuery("SELECT * FROM type ORDER BY type_id DESC LIMIT 4");
            while(rsT.next()) {
                topMateriels.add(new Type(rsT.getInt("type_id"), rsT.getString("type_nom"), rsT.getString("type_description"), rsT.getInt("type_quantite"), rsT.getDouble("type_montant"), rsT.getString("type_image"), rsT.getInt("categorie_id")));
            }

            // Récupérer catégories
            ResultSet rsC = st.executeQuery("SELECT * FROM categorie ORDER BY categorie_nom");
            while(rsC.next()) {
                categories.add(new Categorie(rsC.getInt("categorie_id"), rsC.getString("categorie_nom"), rsC.getString("categorie_description"), rsC.getString("categorie_image")));
            }
            
        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("topMateriels", topMateriels);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}