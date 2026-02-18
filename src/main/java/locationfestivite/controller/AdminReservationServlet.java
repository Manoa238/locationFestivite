package locationfestivite.controller;

import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reservations")
public class AdminReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("details".equals(action)) {
            getReservationDetails(request, response);
        } else {
            listReservations(request, response);
        }
    }

    private void listReservations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> reservations = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            // AJOUT DE u.telephone DANS LA REQUÊTE
            String sql = "SELECT r.*, u.nom as client_nom, u.telephone as client_tel FROM reservation r " +
                         "JOIN utilisateur u ON r.client_id = u.utilisateur_id ORDER BY r.date_creation DESC";
            
            ResultSet rs = conn.createStatement().executeQuery(sql);
            while (rs.next()) {
                Map<String, Object> res = new HashMap<>();
                res.put("id", rs.getInt("reservation_id"));
                res.put("client", rs.getString("client_nom"));
                res.put("telephone", rs.getString("client_tel")); // Sauvegarde du tel
                res.put("debut", rs.getDate("reservation_date_debut"));
                res.put("fin", rs.getDate("reservation_date_fin"));
                res.put("total", rs.getDouble("reservation_montant_total"));
                reservations.add(res);
            }
        } catch (Exception e) { e.printStackTrace(); }
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/views/admin/reservations.jsp").forward(request, response);
    }

    private void getReservationDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT l.*, t.type_nom FROM ligne_reservation_type l " +
                         "JOIN type t ON l.type_id = t.type_id WHERE l.reservation_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            out.println("<table style='width:100%; border-collapse:collapse;'>");
            out.println("<tr style='background:#f8f9fa; text-align:left;'><th style='padding:10px;'>Article</th><th style='padding:10px;'>Qté</th><th style='padding:10px;'>Prix Unit.</th></tr>");
            while (rs.next()) {
                out.println("<tr style='border-bottom:1px solid #eee;'>");
                out.println("<td style='padding:10px;'>" + rs.getString("type_nom") + "</td>");
                out.println("<td style='padding:10px;'>" + rs.getInt("quantite_reservee") + "</td>");
                out.println("<td style='padding:10px;'>" + (int)rs.getDouble("prix_unitaire_applique") + " Ar</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (Exception e) { e.printStackTrace(); out.print("Erreur chargement"); }
    }
}