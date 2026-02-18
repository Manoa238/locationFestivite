<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/views/css/admin-style.css">

</head>
<body>
    <div class="sidebar">
        <h2>ADMIN </h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard" style="background:rgba(255,255,255,0.2)">📊 Tableau de bord</a>
        <a href="${pageContext.request.contextPath}/admin/categories">📁 Catégories</a>
        <a href="${pageContext.request.contextPath}/admin/types">✨ Matériels</a>
        <a href="${pageContext.request.contextPath}/admin/reservations">📅 Réservations</a>
        <hr style="opacity:0.2; margin:20px 0;">
        <a href="${pageContext.request.contextPath}/index.jsp">🏠 Retour site</a>
    </div>

    <div class="main">
        <h1 style="margin-bottom: 40px;">Tableau de Bord</h1>
        
        <div class="stats-grid">
            <!-- CARTE MATÉRIELS CLIQUABLE -->
            <a href="${pageContext.request.contextPath}/admin/types" class="stat-card materiels">
                <h3>Total Matériels</h3>
                <p>${totalTypes}</p>
                <small style="color: #FF512F;">Gérer le stock →</small>
            </a>

            <!-- CARTE RÉSERVATIONS CLIQUABLE -->
            <a href="${pageContext.request.contextPath}/admin/reservations" class="stat-card reservations">
                <h3>Réservations</h3>
                <p>${totalReservations}</p>
                <small style="color: #3399ff;">Voir les détails →</small>
            </a>
        </div>

        <div class="widget">
            <h2>Alertes Stock Faible ⚠️</h2>
            <table class="alert-table">
                <c:forEach items="${alertesStock}" var="a">
                    <tr>
                        <td style="color:#555;">${a.typeNom}</td>
                        <td style="color:#FF3333; font-weight:bold; text-align:right;">${a.typeQuantite} restants</td>
                    </tr>
                </c:forEach>
            </table>
            <c:if test="${empty alertesStock}">
                <p style="text-align:center; color:#2ecc71; padding:20px;">✅ Tous les stocks sont suffisants.</p>
            </c:if>
        </div>
    </div>
</body>
</html>