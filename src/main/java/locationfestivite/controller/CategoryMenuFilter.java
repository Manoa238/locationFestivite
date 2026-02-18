package locationfestivite.controller;

import locationfestivite.model.Categorie;
import locationfestivite.model.Type;
import locationfestivite.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebFilter("/*")
public class CategoryMenuFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        try (Connection conn = DBConnection.getConnection()) {
            //  Récupérer catégories
            List<Categorie> categories = new ArrayList<>();
            String sqlCat = "SELECT * FROM categorie ORDER BY categorie_nom";
            ResultSet rsC = conn.createStatement().executeQuery(sqlCat);
            while(rsC.next()) {
                categories.add(new Categorie(rsC.getInt("categorie_id"), rsC.getString("categorie_nom"), 
                        rsC.getString("categorie_description"), rsC.getString("categorie_image")));
            }
            request.setAttribute("menuCategories", categories);

            // Récupérer 4 derniers matériels 
            List<Type> topMateriels = new ArrayList<>();
            String sqlTop = "SELECT * FROM type ORDER BY type_id DESC LIMIT 4";
            ResultSet rsT = conn.createStatement().executeQuery(sqlTop);
            while(rsT.next()) {
                topMateriels.add(new Type(rsT.getInt("type_id"), rsT.getString("type_nom"), 
                        rsT.getString("type_description"), rsT.getInt("type_quantite"), 
                        rsT.getDouble("type_montant"), rsT.getString("type_image"), rsT.getInt("categorie_id")));
            }
            request.setAttribute("topMateriels", topMateriels);

        } catch (Exception e) {
            e.printStackTrace();
        }
        chain.doFilter(request, response);
    }
}