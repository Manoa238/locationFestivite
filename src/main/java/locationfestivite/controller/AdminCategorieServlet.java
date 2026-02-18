package locationfestivite.controller;

import locationfestivite.model.Categorie;
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

@WebServlet("/admin/categories")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminCategorieServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            deleteCategorie(request, response);
        } else {
            listCategories(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addCategorie(request, response);
        } else if ("update".equals(action)) {
            updateCategorie(request, response);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Categorie> categories = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM categorie ORDER BY categorie_id ASC");
            while(rs.next()) {
                categories.add(new Categorie(
                    rs.getInt("categorie_id"), 
                    rs.getString("categorie_nom"), 
                    rs.getString("categorie_description"), 
                    rs.getString("categorie_image")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/admin/categorie.jsp").forward(request, response);
    }

    private void addCategorie(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String desc = request.getParameter("description");
        
        Part filePart = request.getPart("image_file");
        String fileName = filePart.getSubmittedFileName();
        
        // Chemin vers dossier de destination
        String uploadPath = getServletContext().getRealPath("/") + "views" + File.separator + "images" + File.separator + "categories";
        
        // CRÉATION SÉCURISÉE DU DOSSIER
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); 
        }

        filePart.write(uploadPath + File.separator + fileName);
        String dbPath = "views/images/categories/" + fileName;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO categorie (categorie_nom, categorie_description, categorie_image) VALUES (?, ?, ?)");
            stmt.setString(1, nom);
            stmt.setString(2, desc);
            stmt.setString(3, dbPath);
            stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("categories");
    }

    private void updateCategorie(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String oldImage = request.getParameter("old_image");
        
        Part filePart = request.getPart("image_file");
        String dbPath = oldImage; // Par défaut, on garde l'ancienne image

        // Si l'admin a sélectionné un nouveau fichier
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/") + "views" + File.separator + "images" + File.separator + "categories";
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
            dbPath = "views/images/categories/" + fileName;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE categorie SET categorie_nom = ?, categorie_image = ? WHERE categorie_id = ?");
            stmt.setString(1, nom);
            stmt.setString(2, dbPath);
            stmt.setInt(3, id);
            stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("categories");
    }

    private void deleteCategorie(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM categorie WHERE categorie_id = ?");
            stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("categories");
    }
}