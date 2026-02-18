<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter une Catégorie</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #fdfdfd; padding: 50px; }
        .form-card { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        h2 { color: #DD2476; text-align: center; margin-bottom: 30px; }
        .field { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        input, textarea { width: 100%; padding: 12px; border: 2px solid #eee; border-radius: 10px; outline: none; }
        input:focus { border-color: #FF512F; }
        .btn-save { width: 100%; padding: 15px; background: linear-gradient(to right, #FF512F, #DD2476); border: none; color: white; font-weight: bold; border-radius: 10px; cursor: pointer; }
    </style>
</head>
<body>

    <div class="form-card">
        <h2>Nouvelle Catégorie</h2>
        <form action="${pageContext.request.contextPath}/admin/add-categorie" method="post">
            <div class="field">
                <label>Nom de la catégorie</label>
                <input type="text" name="nom" placeholder="Ex: Technique, Vaisselle..." required>
            </div>
            <div class="field">
                <label>Description</label>
                <textarea name="description" rows="3" placeholder="A quoi sert cette catégorie ?"></textarea>
            </div>
            <div class="field">
                <label>URL de l'image</label>
                <input type="text" name="image_url" placeholder="http://...">
            </div>
            <button type="submit" class="btn-save">ENREGISTRER LA CATÉGORIE</button>
            <br><br>
            <a href="${pageContext.request.contextPath}/admin/dashboard" style="display:block; text-align:center; color:#999; text-decoration:none;">Annuler</a>
        </form>
    </div>

</body>
</html>