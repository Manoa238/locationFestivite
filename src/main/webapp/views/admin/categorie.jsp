<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Catégories - Admin</title>
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #f8f9fa; display: flex; }
        .sidebar { width: 260px; background: linear-gradient(180deg, #FF512F 0%, #DD2476 100%); min-height: 100vh; color: white; padding: 25px 20px; position: fixed; }
        .sidebar a { display: block; color: white; text-decoration: none; padding: 12px 15px; border-radius: 12px; margin-bottom: 5px; font-size: 14px; transition: 0.3s; }
        .sidebar a:hover { background: rgba(255,255,255,0.15); transform: translateX(5px); }
        .main { margin-left: 260px; flex: 1; padding: 40px; }
        
        .cat-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; margin-top: 30px; }
        .cat-card { background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.05); transition: 0.3s; cursor: pointer; text-align: center; position: relative; border: 2px solid transparent; }
        .cat-card:hover { transform: translateY(-5px); border-color: #FF512F; }
        .cat-card img { width: 100%; height: 160px; object-fit: cover; }
        
        .btn-add { background: #FF512F; color: white; padding: 12px 25px; border-radius: 50px; border:none; font-weight: bold; cursor: pointer; }
        
        /* MODALS */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background: white; margin: 8% auto; padding: 30px; border-radius: 25px; width: 450px; animation: slideDown 0.4s; }
        @keyframes slideDown { from {transform: translateY(-50px); opacity:0;} to {transform: translateY(0); opacity:1;} }
        input, textarea { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; }
        
        .action-btn { position: absolute; top: 10px; background: white; border-radius: 50%; width: 32px; height: 32px; border:none; cursor:pointer; box-shadow: 0 2px 5px rgba(0,0,0,0.2); transition: 0.2s; }
        .action-btn:hover { transform: scale(1.1); }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>ADMIN 🎉</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Tableau de bord</a>
        <a href="${pageContext.request.contextPath}/admin/categories" style="background:rgba(255,255,255,0.2)">📁 Catégories</a>
        <a href="${pageContext.request.contextPath}/admin/types">✨ Matériels</a>
        <hr style="opacity:0.2; margin:20px 0;">
        <a href="${pageContext.request.contextPath}/admin/reservations">📅 Réservations</a>
        <a href="${pageContext.request.contextPath}/index.jsp">🏠 Retour site</a>
        <a href="${pageContext.request.contextPath}/logout" style="color: #ffdce5;">🚪 Déconnexion</a>
    </div>

    <div class="main">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <h1>Gestion des Catégories</h1>
            <button onclick="document.getElementById('addModal').style.display='block'" class="btn-add">+ Ajouter</button>
        </div>

        <div class="cat-grid">
            <c:forEach items="${categories}" var="cat">
                <div class="cat-card">
                    <!-- BOUTONS ACTIONS -->
                    <button class="action-btn" style="right:10px; color:red;" onclick="openDelModal('${cat.id}')" title="Supprimer">🗑️</button>
                    <button class="action-btn" style="right:50px; color:#3399ff;" onclick="openEditModal('${cat.id}', '${cat.nom}', '${cat.image}')" title="Modifier">📝</button>
                    
                    <!-- CLIC VERS LES TYPES -->
                    <div onclick="location.href='${pageContext.request.contextPath}/admin/types?catId=${cat.id}'">
                        <img src="${pageContext.request.contextPath}/${cat.image}">
                        <h3 style="padding: 15px 10px 20px;">${cat.nom}</h3>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- MODAL AJOUT -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <h2>Nouvelle Catégorie</h2>
            <form action="categories?action=add" method="post" enctype="multipart/form-data">
                <label style="font-size: 13px; font-weight: bold; color: #666;">Nom de la catégorie</label>
                <input type="text" name="nom" required placeholder="Ex: Mobilier">
                
                <label style="font-size: 13px; font-weight: bold; color: #666;">Description</label>
                <textarea name="description" rows="2" placeholder="Optionnel..."></textarea>
                
                <label style="font-size: 13px; font-weight: bold; color: #666;">Image (Fichier local)</label>
                <input type="file" name="image_file" accept="image/*" required>
                
                <button type="submit" class="btn-add" style="width:100%;">ENREGISTRER</button>
                <button type="button" onclick="document.getElementById('addModal').style.display='none'" style="width:100%; background:none; border:none; color:#999; margin-top:10px; cursor:pointer;">Annuler</button>
            </form>
        </div>
    </div>

    <!-- MODAL MODIFICATION -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h2>Modifier <span>Catégorie</span></h2>
            <form action="categories?action=update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" id="edit_id">
                <input type="hidden" name="old_image" id="edit_old_image">
                
                <label style="font-size: 13px; font-weight: bold; color: #666;">Nom</label>
                <input type="text" name="nom" id="edit_nom" required>
                
                <label style="font-size: 13px; font-weight: bold; color: #666;">Changer l'image (Laisser vide pour garder l'actuelle)</label>
                <input type="file" name="image_file" accept="image/*">
                
                <button type="submit" class="btn-add" style="width:100%;">SAUVEGARDER</button>
                <button type="button" onclick="document.getElementById('editModal').style.display='none'" style="width:100%; background:none; border:none; color:#999; margin-top:10px; cursor:pointer;">Annuler</button>
            </form>
        </div>
    </div>

    <!-- MODAL SUPPRESSION -->
    <div id="delModal" class="modal">
        <div class="modal-content" style="text-align:center;">
            <h2 style="color:#FF3333;">Supprimer ?</h2>
            <p>Voulez-vous vraiment supprimer cette catégorie et tous ses matériels ?</p>
            <div style="margin-top:25px;">
                <button onclick="document.getElementById('delModal').style.display='none'" style="padding:12px 25px; border-radius:50px; border:none; cursor:pointer; margin-right:10px;">Annuler</button>
                <a id="delLink" href="#" style="background:#FF3333; color:white; padding:12px 25px; border-radius:50px; text-decoration:none; font-weight:bold;">Confirmer</a>
            </div>
        </div>
    </div>

    <script>
        function openEditModal(id, nom, img) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_nom').value = nom;
            document.getElementById('edit_old_image').value = img;
            document.getElementById('editModal').style.display = 'block';
        }
        function openDelModal(id) {
            document.getElementById('delLink').href = "${pageContext.request.contextPath}/admin/categories?action=delete&id=" + id;
            document.getElementById('delModal').style.display = 'block';
        }
        window.onclick = function(e) {
            if (e.target.className == 'modal') { e.target.style.display = 'none'; }
        }
    </script>
</body>
</html>