package locationfestivite.controller;

import locationfestivite.model.Categorie;
import locationfestivite.model.Type;
import locationfestivite.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/types")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AdminTypeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            deleteType(request, response);
        } else {
            showList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addType(request, response);
        } else if ("update".equals(action)) {
            updateType(request, response);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Type> types = new ArrayList<>();
        List<Categorie> cats = new ArrayList<>();
        String catId = request.getParameter("catId");
        String titre = "Tous les Matériels";

        try (Connection conn = DBConnection.getConnection()) {
            ResultSet rsC = conn.createStatement().executeQuery("SELECT * FROM categorie ORDER BY categorie_nom");
            while(rsC.next()){
                int id = rsC.getInt("categorie_id");
                String nom = rsC.getString("categorie_nom");
                cats.add(new Categorie(id, nom, "", ""));
                if(catId != null && Integer.parseInt(catId) == id) titre = "Matériels : " + nom;
            }

            String sql = (catId == null) ? "SELECT * FROM type ORDER BY type_id DESC" : "SELECT * FROM type WHERE categorie_id = ? ORDER BY type_id DESC";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            if(catId != null) pstmt.setInt(1, Integer.parseInt(catId));
            ResultSet rsT = pstmt.executeQuery();
            while(rsT.next()){
                types.add(new Type(rsT.getInt("type_id"), rsT.getString("type_nom"), rsT.getString("type_description"), rsT.getInt("type_quantite"), rsT.getDouble("type_montant"), rsT.getString("type_image"), rsT.getInt("categorie_id")));
            }
        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("materiels", types);
        request.setAttribute("categories", cats);
        request.setAttribute("titrePage", titre);
        request.getRequestDispatcher("/views/admin/types.jsp").forward(request, response);
    }

    private void addType(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String desc = request.getParameter("description");
        int qte = Integer.parseInt(request.getParameter("quantite"));
        double prix = Double.parseDouble(request.getParameter("montant"));
        int catId = Integer.parseInt(request.getParameter("categorie_id"));

        Part filePart = request.getPart("image_file");
        String fileName = filePart.getSubmittedFileName();
        
        // --- SÉCURISATION DU DOSSIER ---
        String uploadPath = getServletContext().getRealPath("/") + "views" + File.separator + "images" + File.separator + "materiels";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        filePart.write(uploadPath + File.separator + fileName);
        String dbPath = "views/images/materiels/" + fileName;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO type (type_nom, type_description, type_quantite, type_montant, type_image, categorie_id) VALUES (?,?,?,?,?,?)");
            ps.setString(1, nom);
            ps.setString(2, desc);
            ps.setInt(3, qte);
            ps.setDouble(4, prix);
            ps.setString(5, dbPath);
            ps.setInt(6, catId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("types?catId=" + catId);
    }

    private void updateType(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String desc = request.getParameter("description");
        int qte = Integer.parseInt(request.getParameter("quantite"));
        double prix = Double.parseDouble(request.getParameter("montant"));
        int catId = Integer.parseInt(request.getParameter("categorie_id"));
        String oldImage = request.getParameter("old_image");

        Part filePart = request.getPart("image_file");
        String dbPath = oldImage;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/") + "views" + File.separator + "images" + File.separator + "materiels";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
            dbPath = "views/images/materiels/" + fileName;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE type SET type_nom=?, type_description=?, type_quantite=?, type_montant=?, type_image=?, categorie_id=? WHERE type_id=?");
            ps.setString(1, nom);
            ps.setString(2, desc);
            ps.setInt(3, qte);
            ps.setDouble(4, prix);
            ps.setString(5, dbPath);
            ps.setInt(6, catId);
            ps.setInt(7, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("types?catId=" + catId);
    }

    private void deleteType(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM type WHERE type_id = ?");
            ps.setInt(1, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("types");
    }
}