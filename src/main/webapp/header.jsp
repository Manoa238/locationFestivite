<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Taglib pour gérer l'affichage dynamique (Si connecté ou non) -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header style="background: white; padding: 15px 40px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 20px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;">
    
    <!-- 1. LOGO FESTIF -->
    <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration: none;">
        <div style="font-size: 28px; font-weight: 800; font-family: 'Segoe UI', sans-serif; letter-spacing: -1px;">
            <span style="color: #FF512F;">Location</span><span style="color: #DD2476;">Festivité</span> 🎉
        </div>
    </a>

    <!-- 3. ZONE UTILISATEUR (CONNEXION / PROFIL) -->
    <div style="display: flex; gap: 15px; align-items: center;">
        
        <c:choose>
            <%-- CAS : L'utilisateur est CONNECTÉ --%>
            <c:when test="${not empty sessionScope.utilisateurConnecte}">
                <!-- Affichage du NOM uniquement (Rôle supprimé) -->
                <div style="text-align: right; margin-right: 15px;">
                    <span style="color: #DD2476; font-weight: bold; font-size: 16px; font-family: 'Segoe UI', sans-serif;">
                        ${sessionScope.utilisateurConnecte.nom}
                    </span>
                </div>
                
                <!-- Bouton Déconnexion -->
                <a href="${pageContext.request.contextPath}/logout" 
                   style="background: #FFF0F5; color: #DD2476; padding: 10px 22px; border-radius: 50px; text-decoration: none; font-weight: bold; font-size: 14px; transition: all 0.3s; box-shadow: 0 2px 10px rgba(221, 36, 118, 0.1);">
                    Déconnexion
                </a>
            </c:when>
            
            <%-- CAS : L'utilisateur est DÉCONNECTÉ (Visiteur) --%>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" 
                   style="background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%); color: white; padding: 12px 30px; border-radius: 50px; text-decoration: none; font-weight: bold; font-size: 15px; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 15px rgba(221, 36, 118, 0.3); transition: all 0.3s;" 
                   onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 20px rgba(221, 36, 118, 0.4)';" 
                   onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 15px rgba(221, 36, 118, 0.3)';">
                    👤 Se connecter
                </a>
            </c:otherwise>
        </c:choose>
        
    </div>
</header>