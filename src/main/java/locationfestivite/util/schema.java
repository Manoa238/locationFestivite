package locationfestivite.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class schema {

    public static void main(String[] args) {
        System.out.println("🚀 Mise à jour et Création des tables PostgreSQL...\n");
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("✅ Connexion établie");
            
         
            stmt.execute("DROP TABLE IF EXISTS paiement CASCADE");
            stmt.execute("DROP TABLE IF EXISTS ligne_reservation_pack CASCADE");
            stmt.execute("DROP TABLE IF EXISTS ligne_reservation_type CASCADE");
            stmt.execute("DROP TABLE IF EXISTS reservation CASCADE");
            stmt.execute("DROP TABLE IF EXISTS composition_pack CASCADE");
            stmt.execute("DROP TABLE IF EXISTS pack CASCADE");
            stmt.execute("DROP TABLE IF EXISTS type CASCADE");
            stmt.execute("DROP TABLE IF EXISTS categorie CASCADE");
            stmt.execute("DROP TABLE IF EXISTS utilisateur CASCADE");
            stmt.execute("DROP TABLE IF EXISTS client CASCADE");

            System.out.println("📋 Création des nouvelles tables...");
            
            stmt.execute(createCategorie());
            System.out.println("  ✓ Table categorie");
            
            stmt.execute(createUtilisateur());
            System.out.println("  ✓ Table utilisateur (Clients + Admin)");
            
            stmt.execute(createType());
            System.out.println("  ✓ Table type (Matériel)");
            
            stmt.execute(createPack());
            System.out.println("  ✓ Table pack");
            
            stmt.execute(createComposition_pack());
            System.out.println("  ✓ Table composition_pack");
            
            stmt.execute(createReservation());
            System.out.println("  ✓ Table reservation (liée à utilisateur)");
            
            stmt.execute(createLigne_reservation_type());
            System.out.println("  ✓ Table ligne_reservation_type");
            
            stmt.execute(createLigne_reservation_pack());
            System.out.println("  ✓ Table ligne_reservation_pack");
            
            stmt.execute(createPaiement());
            System.out.println("  ✓ Table paiement");

            System.out.println("\n✅ TOUTES LES TABLES CRÉÉES AVEC SUCCÈS !");
            System.out.println("🔄 Actualisez pgAdmin (F5)\n");

        } catch (SQLException e) {
            System.err.println("❌ ERREUR : " + e.getMessage());
            e.printStackTrace();
        }
    }

    //  REQUÊTES SQL CORRIGÉES 
    
    private static String createCategorie() {
        return "CREATE TABLE categorie (" +
               "categorie_id SERIAL PRIMARY KEY, " +
               "categorie_nom VARCHAR(100) NOT NULL, " +
               "categorie_description TEXT, " +
               "categorie_image VARCHAR(255)" +
               ")";
    }

    private static String createUtilisateur() {
        return "CREATE TABLE utilisateur (" +
               "utilisateur_id SERIAL PRIMARY KEY, " +
               "nom VARCHAR(100) NOT NULL, " +
               "email VARCHAR(150) NOT NULL UNIQUE, " +
               "mot_de_passe VARCHAR(255) NOT NULL, " +
               "telephone VARCHAR(20), " +
               "role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'CLIENT'))" +
               ")";
    }

    private static String createType() {
        return "CREATE TABLE type (" +
            "type_id SERIAL PRIMARY KEY, " +
            "categorie_id INT NOT NULL, " +
            "type_nom VARCHAR(100) NOT NULL, " +
            "type_description TEXT, " +
            "type_quantite INT DEFAULT 0 CHECK (type_quantite >= 0), " +
            "type_montant NUMERIC(10,2) NOT NULL, " +
            "type_image VARCHAR(255), " +
            "CONSTRAINT fk_categorie_type FOREIGN KEY (categorie_id) REFERENCES categorie(categorie_id) ON DELETE CASCADE" +
            ")";
    }

    private static String createPack() {
        return "CREATE TABLE pack (" +
               "pack_id SERIAL PRIMARY KEY, " +
               "pack_nom VARCHAR(100) NOT NULL, " +
               "pack_description TEXT, " +
               "pack_montant DECIMAL(10, 2) NOT NULL, " +
               "pack_image VARCHAR(255)" +
               ")";
    }

    private static String createComposition_pack() {
        return "CREATE TABLE composition_pack (" +
            "pack_id INT NOT NULL, " +
            "type_id INT NOT NULL, " +
            "quantite INT DEFAULT 1 CHECK (quantite > 0), " +
            "PRIMARY KEY (pack_id, type_id), " +
            "FOREIGN KEY (pack_id) REFERENCES pack(pack_id) ON DELETE CASCADE, " +
            "FOREIGN KEY (type_id) REFERENCES type(type_id) ON DELETE CASCADE" +
            ")";
    }

    private static String createReservation() {
        return "CREATE TABLE reservation (" +
            "reservation_id SERIAL PRIMARY KEY, " +
            "client_id INT NOT NULL, " + 
            "date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "reservation_date_debut TIMESTAMP NOT NULL, " +
            "reservation_date_fin TIMESTAMP NOT NULL, " +
            "reservation_montant_total NUMERIC(10,2) NOT NULL DEFAULT 0.00, " +
            "statut_reservation VARCHAR(50) DEFAULT 'En attente', " +
            "CONSTRAINT fk_reservation_utilisateur FOREIGN KEY (client_id) REFERENCES utilisateur(utilisateur_id) ON DELETE CASCADE" +
            ")";
    }

    private static String createLigne_reservation_type() {
        return "CREATE TABLE ligne_reservation_type (" +
               "reservation_id INT NOT NULL, " +
               "type_id INT NOT NULL, " +
               "quantite_reservee INT NOT NULL CHECK (quantite_reservee > 0), " +
               "prix_unitaire_applique NUMERIC(10,2) NOT NULL, " +
               "PRIMARY KEY (reservation_id, type_id), " +
               "FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE, " +
               "FOREIGN KEY (type_id) REFERENCES type(type_id) ON DELETE RESTRICT" +
               ")";
    }

    private static String createLigne_reservation_pack() {
        return "CREATE TABLE ligne_reservation_pack (" +
            "reservation_id INT NOT NULL, " +
            "pack_id INT NOT NULL, " +
            "quantite_reservee INT NOT NULL DEFAULT 1 CHECK (quantite_reservee > 0), " +
            "prix_unitaire_applique NUMERIC(10,2) NOT NULL, " +
            "PRIMARY KEY (reservation_id, pack_id), " +
            "FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE, " +
            "FOREIGN KEY (pack_id) REFERENCES pack(pack_id) ON DELETE RESTRICT" +
            ")";
    }

    private static String createPaiement() {
        return "CREATE TABLE paiement (" +
               "paiement_id SERIAL PRIMARY KEY, " +
               "reservation_id INT NOT NULL, " +
               "paiement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
               "paiement_montant NUMERIC(10,2) NOT NULL, " +
               "paiement_num VARCHAR(100) UNIQUE, " +
               "mode_paiement VARCHAR(50), " +
               "FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE" +
               ")";
    }
}