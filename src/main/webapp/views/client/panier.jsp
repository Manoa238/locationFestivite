<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mon Panier - Location Festivité</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #fdfdfd; margin: 0; }
        .container { max-width: 900px; margin: 50px auto; padding: 30px; background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        h1 { text-align: center; color: #333; }
        table { width: 100%; border-collapse: collapse; margin: 30px 0; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid #f0f0f0; color: #999; text-transform: uppercase; font-size: 12px; }
        td { padding: 15px; border-bottom: 1px solid #f9f9f9; }
        .total-box { text-align: right; font-size: 24px; font-weight: 800; color: #DD2476; }
        .btn-confirm { display: block; width: 100%; padding: 15px; background: linear-gradient(to right, #FF512F, #DD2476); color: white; border: none; border-radius: 50px; font-weight: bold; cursor: pointer; text-decoration: none; text-align: center; margin-top: 30px; }
    </style>
</head>
<body>
    <%@ include file="/header.jsp" %>

    <div class="container">
        <h1>Ma Sélection de Matériel</h1>

        <c:choose>
            <c:when test="${empty panier}">
                <p style="text-align:center; padding:50px;">Votre panier est vide. <a href="${pageContext.request.contextPath}/materiels">Voir le catalogue</a></p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr><th>Produit</th><th>Prix/J</th><th>Quantité</th><th>Sous-total</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <c:set var="total" value="0" />
                        <c:forEach items="${panier}" var="item">
                            <tr>
                                <td><strong>${item.materiel.typeNom}</strong></td>
                                <td><fmt:formatNumber value="${item.materiel.typeMontant}" pattern="###0"/> Ar</td>
                                <td>${item.quantite}</td>
                                <td><fmt:formatNumber value="${item.sousTotal}" pattern="###0"/> Ar</td>
                                <td><a href="panier?action=remove&id=${item.materiel.typeId}" style="text-decoration:none;">❌</a></td>
                            </tr>
                            <c:set var="total" value="${total + item.sousTotal}" />
                        </c:forEach>
                    </tbody>
                </table>

                <div class="total-box">
                    Total par jour : <fmt:formatNumber value="${total}" pattern="###0"/> Ar
                </div>

                <a href="${pageContext.request.contextPath}/views/client/reservation_details.jsp" class="btn-confirm">PASSER À LA RÉSERVATION</a>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>