<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- AJOUT DE LA LIBRAIRIE FMT -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Location Festivité - Accueil</title>
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #fdfdfd; color: #333; }
        .hero {
            background: linear-gradient(135deg, rgba(255,102,0,0.7) 0%, rgba(51,153,255,0.6) 100%),
                        url('${pageContext.request.contextPath}/views/images/hero-bg.jpg') center/cover no-repeat;
            height: 80vh; position: relative; display: flex; flex-direction: column; justify-content: flex-start;
        }
        .hero::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.2); }
        .hero-content { text-align: center; color: white; margin-top: 200px; position: relative; z-index: 1; }
        .hero-content h1 { font-size: 56px; text-shadow: 3px 3px 15px rgba(0,0,0,0.8); margin-bottom: 10px; font-weight: 900; }
        
        .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        
        /* HEADER SECTION */
        .section-header { display: flex; justify-content: space-between; align-items: center; margin: 80px 0 40px; border-bottom: 2px solid #f9f9f9; padding-bottom: 15px; }
        .section-title-left { font-size: 30px; font-weight: 800; text-transform: uppercase; background: linear-gradient(to right, #FF512F, #DD2476); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin: 0; }
        .btn-view-all { color: #777; text-decoration: none; font-weight: 700; font-size: 14px; text-transform: uppercase; transition: 0.3s; display: flex; align-items: center; gap: 10px; border: 1px solid #eee; padding: 10px 20px; border-radius: 50px; }
        .btn-view-all:hover { color: white; background: linear-gradient(to right, #FF512F, #DD2476); border-color: transparent; transform: translateX(5px); }

        /* CARDS */
        .materiel-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 35px; margin-bottom: 60px; }
        .materiel-card { background: white; border-radius: 25px; padding: 25px; border: 1px solid rgba(0,0,0,0.05); box-shadow: 0 10px 30px rgba(0,0,0,0.04); transition: all 0.4s; position: relative; overflow: hidden; text-align: center; }
        .materiel-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 5px; background: linear-gradient(to right, #FF512F, #DD2476); opacity: 0; transition: 0.3s; }
        .materiel-card:hover { transform: translateY(-12px); box-shadow: 0 20px 40px rgba(221, 36, 118, 0.12); border-color: rgba(255, 81, 47, 0.3); }
        .materiel-card:hover::before { opacity: 1; }
        .materiel-card img { width: 100%; height: 200px; object-fit: contain; margin-bottom: 20px; transition: 0.5s; }
        .materiel-card:hover img { transform: scale(1.1); }
        .materiel-card h3 { font-size: 16px; text-transform: uppercase; margin: 10px 0; color: #333; min-height: 40px; font-weight: 700; }
        
        .price { font-size: 22px; font-weight: 900; color: #DD2476; background: #FFF0F5; padding: 5px 15px; border-radius: 50px; display: inline-block; margin-bottom: 20px; }
        
        .btn-know-more { display: block; border: 2px solid #FF8833; color: #FF8833; padding: 12px; border-radius: 50px; text-decoration: none; font-weight: 800; font-size: 13px; transition: 0.3s; text-transform: uppercase; }
        .btn-know-more:hover { background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%); color: white; border-color: transparent; }

        /* CATEGORIES */
        .section-center { text-align: center; margin: 80px 0 50px; }
        .section-center h2 { font-size: 36px; font-weight: 900; text-transform: uppercase; background: linear-gradient(to right, #FF512F, #DD2476); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin: 0; display: inline-block; }
        .title-line { width: 80px; height: 4px; background: linear-gradient(to right, #FF512F, #DD2476); margin: 15px auto; border-radius: 2px; }
        .categories-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; margin-bottom: 100px; }
        .cat-card { position: relative; border-radius: 20px; overflow: hidden; height: 200px; cursor: pointer; box-shadow: 0 10px 30px rgba(0,0,0,0.08); transition: 0.4s; }
        .cat-card img { width: 100%; height: 100%; object-fit: cover; transition: 0.6s; }
        .cat-card:hover img { transform: scale(1.1); }
        .cat-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.3); display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 22px; text-transform: uppercase; text-shadow: 0 2px 10px rgba(0,0,0,0.5); }

        /* FOOTER */
        footer { background: #1a1a1a; color: white; padding: 60px 0 20px; }
        .footer-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 40px; margin-bottom: 40px; }
        .footer-col h4 { color: #FF512F; font-size: 18px; margin-bottom: 20px; text-transform: uppercase; }
        .footer-col p, .footer-col a { color: #bbb; text-decoration: none; font-size: 14px; line-height: 1.8; }
        .footer-bottom { text-align: center; border-top: 1px solid #333; padding-top: 20px; color: #777; font-size: 13px; }
    </style>
</head>
<body>
    <%@ include file="/header.jsp" %>
    <%@ include file="/nav-menu.jsp" %>

    <div class="hero">
        <div class="hero-content">
            <h1>LOCATION MATÉRIEL ÉVÉNEMENTIEL</h1>
            <p>Rendez chaque instant inoubliable</p>
        </div>
    </div>

    <div class="container">
        
        <div class="section-header">
            <h2 class="section-title-left">Nos Nouveautés</h2>
            <a href="${pageContext.request.contextPath}/materiels" class="btn-view-all">
                Voir tout le catalogue ➔
            </a>
        </div>

        <div class="materiel-grid">
            <c:forEach items="${topMateriels}" var="m">
                <div class="materiel-card">
                    <img src="${pageContext.request.contextPath}/${m.typeImage}" alt="${m.typeNom}">
                    <h3>${m.typeNom}</h3>
                    <!-- PRIX FORMATÉ -->
                    <div class="price">
                        <fmt:formatNumber value="${m.typeMontant}" pattern="#,##0"/> Ar
                    </div>
                    <a href="${pageContext.request.contextPath}/materiels?id=${m.typeId}" class="btn-know-more">En savoir +</a>
                </div>
            </c:forEach>
        </div>

        <div class="section-center">
            <h2>Nos Univers Festifs</h2>
            <div class="title-line"></div>
        </div>

        <div class="categories-grid">
            <c:forEach items="${menuCategories}" var="cat">
                <div class="cat-card" onclick="location.href='${pageContext.request.contextPath}/materiels?catId=${cat.id}'">
                    <img src="${pageContext.request.contextPath}/${cat.image}">
                    <div class="cat-overlay">${cat.nom}</div>
                </div>
            </c:forEach>
        </div>
    </div>

    <footer>
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h4>LocationFestivité</h4>
                    <p>Votre partenaire pour des fêtes mémorables à Antananarivo.</p>
                </div>
                <div class="footer-col">
                    <h4>Navigation</h4>
                    <a href="${pageContext.request.contextPath}/home">Accueil</a><br>
                    <a href="${pageContext.request.contextPath}/materiels">Catalogue Complet</a><br>
                    <a href="#">Contact</a>
                </div>
                <div class="footer-col">
                    <h4>Contact</h4>
                    <p>📍 Antsirabe, Madagascar<br>📞 +261 38 25 839 35<br>✉️ ravomanoapro@gmail.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                &copy; 2025 Location Festivité 🚀
            </div>
        </div>
    </footer>
   <%@ include file="/views/client/mini-panier.jsp" %>
</body>
</html>