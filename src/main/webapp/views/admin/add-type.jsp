<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Matériel - Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #FFF5F7; padding: 40px; }
        .form-card { max-width: 600px; margin: auto; background: white; padding: 40px; border-radius: 25px; box-shadow: 0 15px 40px rgba(221, 36, 118, 0.1); }
        h2 { text-align: center; margin-bottom: 30px; font-weight: 800; }
        h2 span { background: linear-gradient(to right, #FF512F, #DD2476); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .field { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        input, select, textarea { width: 100%; padding: 12px; border: 2px solid #f0f0f0; border-radius: 12px; background: #fafafa; outline: none; transition: 0.3s; }
        input:focus, select:focus { border-color: #FF512F; background: white; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .btn-save { width: 100%; padding: 16px; background: linear-gradient(to right, #FF512F, #DD2476); border: none; color: white; font-weight: bold; border-radius: 12px; cursor: pointer; margin-top: 15px; box-shadow: 0 5px 15px rgba(221, 36, 118, 0.2); }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(221, 36, 118, 0.3); }
    </style>
</head>
<body>

    <div class="form-card">
        <h2>Ajouter un <span>Matériel</span></h2>
        
        <form action="${pageContext.request.contextPath}/admin/add-type" method="post">
            
            <div class="field">
                <label>Nom du matériel</label>
                <input type="text" name="nom" placeholder="Ex: Baffle de sonorisation" required>
            </div>

            <div class="field">
                <label>Catégorie</label>
                <select name="categorie_id" required>
                    <option value="">-- Sélectionner une catégorie --</option>
                    <c:forEach items="${categories}" var="cat">
                        <option value="${cat.id}">${cat.nom}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid">
                <div class="field">
                    <label>Quantité disponible</label>
                    <input type="number" name="quantite" value="1" min="0" required>
                </div>
                <div class="field">
                    <label>Prix par jour (€)</label>
                    <input type="number" step="0.01" name="montant" placeholder="0.00" required>
                </div>
            </div>

            <div class="field">
                <label>URL de l'image</label>
                <input type="text" name="image_url" placeholder="https://image-source.com/photo.jpg">
            </div>

            <div class="field">
                <label>Description</label>
                <textarea name="description" rows="3" placeholder="Détails techniques..."></textarea>
            </div>

            <button type="submit" class="btn-save">ENREGISTRER LE MATÉRIEL</button>
            <a href="${pageContext.request.contextPath}/admin/dashboard" style="display:block; text-align:center; margin-top:20px; color:#999; text-decoration:none;">Annuler et revenir</a>
        </form>
    </div>

</body>
</html>