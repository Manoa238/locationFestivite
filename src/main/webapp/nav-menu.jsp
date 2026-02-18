<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav style="background: white; padding: 15px 0; text-align: center; border-bottom: 1px solid #eee; position: sticky; top: 70px; z-index: 90; box-shadow: 0 2px 10px rgba(0,0,0,0.02);">
    <style>
        .nav-link { 
            margin: 0 12px; color: #444; font-weight: 600; text-decoration: none; 
            font-size: 13px; transition: 0.3s; padding: 10px 20px; border-radius: 50px; 
            font-family: 'Segoe UI', sans-serif; display: inline-block;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .nav-link:hover { color: #DD2476; background: #FFF0F5; transform: translateY(-2px); }
        .nav-active { color: #DD2476; background: #FFF0F5; }
    </style>
    
    <!-- LIEN ACCUEIL -->
    <a href="${pageContext.request.contextPath}/home" class="nav-link">Accueil</a>
    
    <a href="${pageContext.request.contextPath}/materiels" class="nav-link">Tous les produits</a>
    
    <!-- BOUCLE DYNAMIQUE -->
    <c:forEach items="${menuCategories}" var="cat">
        <a href="${pageContext.request.contextPath}/materiels?catId=${cat.id}" class="nav-link">${cat.nom}</a>
    </c:forEach>

    <!-- LIEN CONTACT -->
    <a href="${pageContext.request.contextPath}/views/contact.jsp" class="nav-link">Contact</a>
</nav>