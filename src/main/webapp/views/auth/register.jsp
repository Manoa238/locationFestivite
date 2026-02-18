<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription - Location Festivité</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #FFF5F7; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .wrapper { background: white; width: 950px; height: 600px; border-radius: 25px; box-shadow: 0 20px 60px rgba(221, 36, 118, 0.15); overflow: hidden; display: flex; }
        
        .left-panel { flex: 1; background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%); display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; text-align: center; padding: 40px; }
        .rocket-box { width: 140px; height: 140px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 70px; margin-bottom: 20px; animation: pulse 2s infinite;}
        
        .right-panel { flex: 1.2; padding: 50px; display: flex; flex-direction: column; justify-content: center; }
        .title { font-size: 30px; font-weight: 800; text-align: center; margin-bottom: 30px; color: #333; }
        .title span { color: #DD2476; }
        
        .input-group { margin-bottom: 15px; }
        .input-group input { width: 100%; padding: 14px 20px; border: 2px solid #f0f0f0; background: #fafafa; border-radius: 12px; font-size: 15px; outline: none; transition: 0.3s; }
        .input-group input:focus { border-color: #FF512F; background: white; }
        
        .btn-reg { width: 100%; padding: 16px; background: linear-gradient(to right, #FF512F, #DD2476); border: none; border-radius: 12px; color: white; font-size: 16px; font-weight: bold; cursor: pointer; box-shadow: 0 5px 20px rgba(221, 36, 118, 0.3); transition: 0.3s; margin-top: 10px; }
        .btn-reg:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(221, 36, 118, 0.4); }
        
        .error { background: #ffebee; color: #c62828; padding: 12px; border-radius: 8px; text-align: center; font-size: 13px; margin-bottom: 20px; }
        .link { text-align: center; margin-top: 25px; font-size: 14px; color: #666; }
        .link a { color: #FF512F; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

    <div class="wrapper">
        <div class="left-panel">
            <div class="rocket-box">🚀</div>
            <h2>Prêt pour la fête ?</h2>
            <p>Rejoignez-nous pour réserver le meilleur matériel en quelques clics.</p>
        </div>

        <div class="right-panel">
            <h3 class="title">Créer un <span>Compte</span></h3>

            <c:if test="${not empty error}">
                <div class="error">⚠️ ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="input-group">
                    <input type="text" name="nom" placeholder="Votre nom complet" required>
                </div>
                <div class="input-group">
                    <input type="email" name="email" placeholder="Adresse Email" required>
                </div>
                <div class="input-group">
                    <input type="tel" name="telephone" placeholder="Téléphone (ex: 034...)">
                </div>
                <div class="input-group">
                    <input type="password" name="password" placeholder="Mot de passe" required>
                </div>

                <button type="submit" class="btn-reg">S'INSCRIRE MAINTENANT</button>
                
                <div class="link">
                    Déjà inscrit ? <a href="${pageContext.request.contextPath}/login">Se connecter</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>