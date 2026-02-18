<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Suivi Réservations</title>
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #f8f9fa; display: flex; }
        .sidebar { width: 260px; background: linear-gradient(180deg, #FF512F 0%, #DD2476 100%); min-height: 100vh; color: white; padding: 25px 20px; position: fixed; }
        .sidebar a { display: block; color: white; text-decoration: none; padding: 12px 15px; border-radius: 12px; margin-bottom: 5px; font-size: 14px; transition: 0.3s; }
        .main { margin-left: 260px; flex: 1; padding: 40px; }
        .content-box { background: white; border-radius: 20px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 18px 15px; border-bottom: 1px solid #f0f0f0; text-align: left; }

        /* --- NOUVEAU STYLE DU BOUTON (Bordure uniquement) --- */
        .btn-detail { 
            background: transparent; 
            color: #DD2476; 
            padding: 8px 18px; 
            border-radius: 50px; 
            font-size: 12px; 
            font-weight: 700; 
            border: 1.5px solid #DD2476; /* Bordure stylisée */
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-detail:hover { 
            background: #DD2476; 
            color: white; 
            box-shadow: 0 4px 12px rgba(221, 36, 118, 0.2);
            transform: translateY(-2px);
        }

        .tel-link { color: #888; font-size: 13px; font-weight: normal; margin-left: 10px; text-decoration: none; }

        /* MODAL */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background: white; margin: 10% auto; padding: 30px; border-radius: 20px; width: 500px; animation: slideDown 0.3s; }
        @keyframes slideDown { from {transform: translateY(-20px); opacity:0;} to {transform: translateY(0); opacity:1;} }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>ADMIN 🎉</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Tableau de bord</a>
        <a href="${pageContext.request.contextPath}/admin/categories">📁 Catégories</a>
        <a href="${pageContext.request.contextPath}/admin/types">✨ Matériels</a>
        <a href="${pageContext.request.contextPath}/admin/reservations" style="background:rgba(255,255,255,0.2)">📅 Réservations</a>
        <hr style="opacity:0.2; margin:20px 0;">
        <a href="${pageContext.request.contextPath}/index.jsp">🏠 Retour site</a>
    </div>

    <div class="main">
        <div class="content-box">
            <h1>Liste des Réservations</h1>
            <table>
                <thead>
                    <tr>
                        <th>Client & Contact</th>
                        <th>Début</th>
                        <th>Fin</th>
                        <th>Montant Total</th>
                        <th>Détails</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${reservations}" var="r">
                        <tr>
                            <td>
                                <strong>${r.client}</strong>
                                <span class="tel-link">📞 ${r.telephone}</span>
                            </td>
                            <td><fmt:formatDate value="${r.debut}" pattern="dd/MM/yyyy" /></td>
                            <td><fmt:formatDate value="${r.fin}" pattern="dd/MM/yyyy" /></td>
                            <td style="font-weight:900;"><fmt:formatNumber value="${r.total}" pattern="###0"/> Ar</td>
                            <td>
                                <button class="btn-detail" onclick="showDetails('${r.id}')">Voir articles</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div id="detailModal" class="modal">
        <div class="modal-content">
            <h2 style="margin-top:0; border-bottom:2px solid #eee; padding-bottom:10px;">Articles loués</h2>
            <div id="modalBody" style="margin:20px 0;">Chargement...</div>
            <button onclick="closeModal()" style="width:100%; padding:12px; border-radius:10px; border:none; background:#eee; cursor:pointer; font-weight:bold;">Fermer</button>
        </div>
    </div>

    <script>
        function showDetails(id) {
            document.getElementById('detailModal').style.display = 'block';
            document.getElementById('modalBody').innerHTML = "Chargement...";
            fetch('reservations?action=details&id=' + id)
                .then(response => response.text())
                .then(html => { document.getElementById('modalBody').innerHTML = html; });
        }
        function closeModal() { document.getElementById('detailModal').style.display = 'none'; }
    </script>
</body>
</html>