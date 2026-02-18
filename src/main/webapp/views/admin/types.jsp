<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion Matériel - Admin</title>
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #f8f9fa; display: flex; }
        .sidebar { width: 260px; background: linear-gradient(180deg, #FF512F 0%, #DD2476 100%); min-height: 100vh; color: white; padding: 25px 20px; position: fixed; }
        .sidebar h2 { font-size: 20px; text-align: center; margin-bottom: 30px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 15px; }
        .sidebar a { display: block; color: white; text-decoration: none; padding: 12px 15px; border-radius: 12px; margin-bottom: 5px; font-size: 14px; }
        .main { margin-left: 260px; flex: 1; padding: 40px; }
        .content-box { background: white; border-radius: 20px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 15px; border-bottom: 1px solid #eee; text-align: left; }
        .btn-add { background: #FF512F; color: white; padding: 10px 25px; border-radius: 50px; border:none; font-weight: bold; cursor: pointer; }
        
        /* MODAL */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background: white; margin: 5% auto; padding: 30px; border-radius: 25px; width: 500px; animation: slideDown 0.4s; }
        @keyframes slideDown { from {transform: translateY(-50px); opacity:0;} to {transform: translateY(0); opacity:1;} }
        input, select, textarea { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; }
        
        .btn-confirm { background: #FF3333; color: white; padding: 12px 25px; border-radius: 50px; border:none; font-weight: bold; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-cancel { background: #f0f0f0; color: #666; padding: 12px 25px; border-radius: 50px; border:none; font-weight: bold; cursor: pointer; }
        .action-icon { border:none; background:none; cursor:pointer; font-size:18px; margin-right:10px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>ADMIN 🎉</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Tableau de bord</a>
        <a href="${pageContext.request.contextPath}/admin/categories">📁 Catégories</a>
        <a href="${pageContext.request.contextPath}/admin/types" style="background:rgba(255,255,255,0.2)">✨ Matériels</a>
       	<a href="${pageContext.request.contextPath}/admin/reservations">📅 Réservations</a>
        <hr style="opacity:0.2; margin:20px 0;">
        <a href="${pageContext.request.contextPath}/index.jsp">🏠 Retour site</a>
    </div>

    <div class="main">
        <a href="${pageContext.request.contextPath}/admin/categories" style="color:#888; text-decoration:none; font-size:13px;">← Retour aux catégories</a>
        
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:10px; margin-bottom:20px;">
            <h1>${titrePage}</h1>
            <button onclick="document.getElementById('addTypeModal').style.display='block'" class="btn-add">+ Ajouter</button>
        </div>

        <div class="content-box">
            <table>
                <thead>
                    <tr><th>Image</th><th>Nom</th><th>Prix/J (Ar)</th><th>Stock</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <c:forEach items="${materiels}" var="m">
                        <tr>
                            <td><img src="${pageContext.request.contextPath}/${m.typeImage}" style="width:40px; height:40px; border-radius:5px; object-fit:cover;"></td>
                            <td><strong>${m.typeNom}</strong></td>
                            
                            <!-- AFFICHAGE ARIARY SANS POINT -->
                            <td style="color:#DD2476; font-weight:bold;">
                                <fmt:formatNumber value="${m.typeMontant}" pattern="###0"/> Ar
                            </td>
                            
                            <td>${m.typeQuantite}</td>
                            <td>
                                <button class="action-icon" style="color:#3399ff;" onclick="openEditTypeModal('${m.typeId}', '${m.typeNom}', '${m.typeDescription}', '${m.typeQuantite}', '${m.typeMontant}', '${m.typeImage}', '${m.categorieId}')">📝</button>
                                <button class="action-icon" style="color:red;" onclick="openDelTypeModal('${m.typeId}')">🗑️</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- MODAL AJOUT -->
    <div id="addTypeModal" class="modal"><div class="modal-content">
        <h2>Nouveau Matériel</h2>
        <form action="${pageContext.request.contextPath}/admin/types?action=add" method="post" enctype="multipart/form-data">
            <input type="text" name="nom" required placeholder="Nom du produit">
            <select name="categorie_id">
                <c:forEach items="${categories}" var="c">
                    <option value="${c.id}" ${param.catId == c.id ? 'selected' : ''}>${c.nom}</option>
                </c:forEach>
            </select>
            <div style="display:flex; gap:10px;">
                <input type="number" step="1" name="montant" placeholder="Prix (Ar)" required>
                <input type="number" name="quantite" placeholder="Stock" value="1" required>
            </div>
            <input type="file" name="image_file" required>
            <textarea name="description" placeholder="Description"></textarea>
            <button type="submit" class="btn-add" style="width:100%;">ENREGISTRER</button>
            <button type="button" onclick="document.getElementById('addTypeModal').style.display='none'" style="width:100%; background:none; border:none; color:#999; margin-top:10px; cursor:pointer;">Annuler</button>
        </form>
    </div></div>

    <!-- MODAL MODIF -->
    <div id="editTypeModal" class="modal"><div class="modal-content">
        <h2>Modifier Matériel</h2>
        <form action="${pageContext.request.contextPath}/admin/types?action=update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" id="et_id">
            <input type="hidden" name="old_image" id="et_old_image">
            
            <label style="font-size:12px; font-weight:bold; color:#666;">Nom</label>
            <input type="text" name="nom" id="et_nom" required>
            
            <label style="font-size:12px; font-weight:bold; color:#666;">Catégorie</label>
            <select name="categorie_id" id="et_cat">
                <c:forEach items="${categories}" var="c">
                    <option value="${c.id}">${c.nom}</option>
                </c:forEach>
            </select>
            
            <div style="display:flex; gap:10px;">
                <div style="flex:1;">
                    <label style="font-size:12px; font-weight:bold; color:#666;">Prix (Ar)</label>
                    <input type="number" step="1" name="montant" id="et_montant">
                </div>
                <div style="flex:1;">
                    <label style="font-size:12px; font-weight:bold; color:#666;">Stock</label>
                    <input type="number" name="quantite" id="et_quantite">
                </div>
            </div>
            
            <label style="font-size:12px; font-weight:bold; color:#666;">Description</label>
            <textarea name="description" id="et_desc"></textarea>
            
            <label style="font-size:12px; font-weight:bold; color:#666;">Changer l'image (Optionnel)</label>
            <input type="file" name="image_file">
            
            <button type="submit" class="btn-add" style="width:100%;">MODIFIER</button>
            <button type="button" onclick="document.getElementById('editTypeModal').style.display='none'" style="width:100%; background:none; border:none; color:#999; margin-top:10px; cursor:pointer;">Annuler</button>
        </form>
    </div></div>

    <!-- MODAL SUPPR -->
    <div id="delTypeModal" class="modal"><div class="modal-content" style="text-align:center;">
        <h2>Supprimer ?</h2>
        <p>Retirer définitivement cet article du stock ?</p>
        <div style="margin-top:20px;">
            <button onclick="document.getElementById('delTypeModal').style.display='none'" style="padding:10px 20px; border-radius:20px; border:none; cursor:pointer;">Annuler</button>
            <a id="delTypeLink" href="#" style="background:#FF3333; color:white; padding:10px 20px; border-radius:20px; text-decoration:none; font-weight:bold; display:inline-block;">Confirmer</a>
        </div>
    </div></div>

    <script>
        function openEditTypeModal(id, nom, desc, qte, prix, img, catId) {
            document.getElementById('et_id').value = id;
            document.getElementById('et_nom').value = nom;
            document.getElementById('et_desc').value = desc;
            document.getElementById('et_quantite').value = qte;
            document.getElementById('et_montant').value = prix;
            document.getElementById('et_old_image').value = img;
            document.getElementById('et_cat').value = catId;
            document.getElementById('editTypeModal').style.display = 'block';
        }
        function openDelTypeModal(id) {
            document.getElementById('delTypeLink').href = "${pageContext.request.contextPath}/admin/types?action=delete&id=" + id;
            document.getElementById('delTypeModal').style.display = 'block';
        }
        window.onclick = function(e) { if(e.target.className == 'modal') e.target.style.display='none'; }
    </script>
</body>
</html>