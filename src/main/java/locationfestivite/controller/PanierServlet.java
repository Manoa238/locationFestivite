package locationfestivite.controller;

import locationfestivite.model.LignePanier;
import locationfestivite.model.Type;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/panier")
public class PanierServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            ajouterAuPanier(request, response);
        } else if ("remove".equals(action)) {
            supprimerDuPanier(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/materiels");
        }
    }

    private void ajouterAuPanier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        
        // 1. SÉCURITÉ : Vérifier si l'utilisateur est connecté
        if (session.getAttribute("utilisateurConnecte") == null) {
            // Optionnel : stocker l'URL actuelle pour y revenir après login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        int qteSaisie = Integer.parseInt(request.getParameter("quantite"));
        String dateDebut = request.getParameter("date_debut");
        String dateFin = request.getParameter("date_fin");

        List<LignePanier> panier = (List<LignePanier>) session.getAttribute("panier");
        if (panier == null) panier = new ArrayList<>();

        session.setAttribute("dateDebut", dateDebut);
        session.setAttribute("dateFin", dateFin);

        boolean existe = false;
        for (LignePanier lp : panier) {
            if (lp.getMateriel().getTypeId() == id) {
                lp.setQuantite(lp.getQuantite() + qteSaisie);
                existe = true;
                break;
            }
        }

        if (!existe) {
            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM type WHERE type_id = ?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Type t = new Type(rs.getInt("type_id"), rs.getString("type_nom"), "", 
                                     rs.getInt("type_quantite"), rs.getDouble("type_montant"), 
                                     rs.getString("type_image"), 0);
                    panier.add(new LignePanier(t, qteSaisie));
                }
            } catch (Exception e) { e.printStackTrace(); }
        }

        session.setAttribute("panier", panier);
        
        // Rediriger vers la page d'où l'on vient pour ouvrir le mini-panier
        String referer = request.getHeader("referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/index.jsp");
    }

    private void supprimerDuPanier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        List<LignePanier> panier = (List<LignePanier>) session.getAttribute("panier");
        if (panier != null) {
            panier.removeIf(lp -> lp.getMateriel().getTypeId() == id);
        }
        String referer = request.getHeader("referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/index.jsp");
    }
}