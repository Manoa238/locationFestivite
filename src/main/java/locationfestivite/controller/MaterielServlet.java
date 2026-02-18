package locationfestivite.controller;

import locationfestivite.model.Type;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/materiels")
public class MaterielServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Type> materiels = new ArrayList<>();
        
        // Récupération paramètre filtrage
        String catIdParam = request.getParameter("catId");
        String currentCategoryName = "Tout notre matériel";

        try (Connection conn = DBConnection.getConnection()) {
            
            // Si on filtre par catégorie, on récupère son nom titre du catalogue
            if (catIdParam != null && !catIdParam.isEmpty()) {
                String sqlCat = "SELECT categorie_nom FROM categorie WHERE categorie_id = ?";
                try (PreparedStatement stmtCat = conn.prepareStatement(sqlCat)) {
                    stmtCat.setInt(1, Integer.parseInt(catIdParam));
                    ResultSet rsCat = stmtCat.executeQuery();
                    if (rsCat.next()) {
                        currentCategoryName = rsCat.getString("categorie_nom");
                    }
                }
            }

            // Préparation requête SQL pour matériels
            String sql;
            if (catIdParam == null || catIdParam.isEmpty()) {
                sql = "SELECT * FROM type ORDER BY type_id";
            } else {
                sql = "SELECT * FROM type WHERE categorie_id = ? ORDER BY type_id";
            }

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (catIdParam != null && !catIdParam.isEmpty()) {
                    stmt.setInt(1, Integer.parseInt(catIdParam));
                }

                ResultSet rs = stmt.executeQuery();

                // Parcourir résultats et créer les objets Type
                while (rs.next()) {
                    Type type = new Type(
                        rs.getInt("type_id"),
                        rs.getString("type_nom"),
                        rs.getString("type_description"),
                        rs.getInt("type_quantite"),
                        rs.getDouble("type_montant"),
                        rs.getString("type_image"),
                        rs.getInt("categorie_id")
                    );
                    materiels.add(type);
                }
            }

            System.out.println("✅ " + materiels.size() + " produits affichés pour : " + currentCategoryName);

        } catch (SQLException | NumberFormatException e) {
            System.err.println("❌ Erreur MaterielServlet : " + e.getMessage());
            e.printStackTrace();
        }

        // Envoi des données à liste.jsp
        request.setAttribute("materiels", materiels);
        request.setAttribute("pageTitle", currentCategoryName);
        request.getRequestDispatcher("/views/materiels/liste.jsp").forward(request, response);
    }
}