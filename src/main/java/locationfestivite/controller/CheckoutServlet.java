package locationfestivite.controller;

import locationfestivite.model.LignePanier;
import locationfestivite.model.Utilisateur;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateurConnecte");
        List<LignePanier> panier = (List<LignePanier>) session.getAttribute("panier");
        String dateD = (String) session.getAttribute("dateDebut");
        String dateF = (String) session.getAttribute("dateFin");

        //  Vérification
        if (user == null || panier == null || panier.isEmpty() || dateD == null || dateF == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Début de la transaction

            // CALCUL DURÉE & MONTANT
            // ChronoUnit.DAYS calcule la différence exacte entre deux dates (DateFin - DateDebut)
            long jours = ChronoUnit.DAYS.between(LocalDate.parse(dateD), LocalDate.parse(dateF));
            
            // *** MODIFICATION ICI POUR COMPTER LES JOURS INCLUS ***
            if (jours <= 0) {
                // Même jour ou date de fin avant date de début, compte 1 jour
                jours = 1; 
            } else {
                // Ajout de 1 jour pour inclure la date de fin (Ex: 12 au 13 -> 1 jour d'écart + 1 = 2 jours)
                jours = jours + 1; 
            }
            // *****************************************************
            
            double totalParJour = 0;
            for (LignePanier lp : panier) {
                // totalParJour représente ici le coût total du panier pour UNE journée
                totalParJour += lp.getSousTotal();
            }
            
            // Calcul final : (Total de tous les articles par jour) x (Nombre de jours)
            // Si 6ar est le prix pour 1 jour, alors 6ar * 2 jours = 12ar
            double montantTotalFinal = totalParJour * jours;

            // Insert Réservation
            String sqlRes = "INSERT INTO reservation (client_id, reservation_date_debut, reservation_date_fin, reservation_montant_total, statut_reservation) " +
                           "VALUES (?, ?, ?, ?, 'En attente') RETURNING reservation_id";
            
            PreparedStatement psRes = conn.prepareStatement(sqlRes);
            psRes.setInt(1, user.getId());
            psRes.setDate(2, java.sql.Date.valueOf(dateD));
            psRes.setDate(3, java.sql.Date.valueOf(dateF));
            psRes.setDouble(4, montantTotalFinal);
            
            ResultSet rs = psRes.executeQuery();
            if (rs.next()) {
                int resId = rs.getInt(1);

                // Insertion détails
                String sqlLigne = "INSERT INTO ligne_reservation_type (reservation_id, type_id, quantite_reservee, prix_unitaire_applique) VALUES (?, ?, ?, ?)";
                PreparedStatement psLigne = conn.prepareStatement(sqlLigne);

                for (LignePanier lp : panier) {
                    psLigne.setInt(1, resId);
                    psLigne.setInt(2, lp.getMateriel().getTypeId());
                    psLigne.setInt(3, lp.getQuantite());
                    psLigne.setDouble(4, lp.getMateriel().getTypeMontant());
                    psLigne.addBatch();
                }
                psLigne.executeBatch();

                // Sauve reçu
                List<LignePanier> backup = new ArrayList<>(panier);
                session.setAttribute("panierBackup", backup);
                
                // On envoie les variables de calcul à la page success.jsp
                request.setAttribute("nbJours", jours);
                request.setAttribute("montantTotal", (int) montantTotalFinal);
            }

            conn.commit(); // Validation finale
            session.removeAttribute("panier"); // vide panier actif

            request.getRequestDispatcher("/views/client/success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors du calcul de la réservation : " + e.getMessage());
        }
    }
}