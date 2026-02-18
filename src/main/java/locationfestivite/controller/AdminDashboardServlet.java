package locationfestivite.controller;

import locationfestivite.model.Type;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            Statement st = conn.createStatement();
            
            // 1. Compter les matériels
            ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM type");
            if(rs1.next()) request.setAttribute("totalTypes", rs1.getInt(1));

            // 2. Compter les réservations
            ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM reservation");
            if(rs2.next()) request.setAttribute("totalReservations", rs2.getInt(1));

            // 3. Récupérer les alertes de stock faible (< 10 unités)
            List<Type> alertesStock = new ArrayList<>();
            ResultSet rs4 = st.executeQuery("SELECT * FROM type WHERE type_quantite < 10 ORDER BY type_quantite ASC LIMIT 5");
            while(rs4.next()){
                alertesStock.add(new Type(rs4.getInt("type_id"), rs4.getString("type_nom"), "", rs4.getInt("type_quantite"), 0, "", 0));
            }
            request.setAttribute("alertesStock", alertesStock);

        } catch (Exception e) { e.printStackTrace(); }
        
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}