<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion - Location Festivité</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #FFF5F7; /* Fond page légèrement rosé */
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            background: white;
            width: 900px;
            height: 550px;
            border-radius: 25px;
            box-shadow: 0 20px 60px rgba(221, 36, 118, 0.15); /* Ombre rosée */
            overflow: hidden;
            display: flex;
        }

        /* --- GAUCHE : Dégradé Festif --- */
        .left-panel {
            flex: 1;
            /* Le dégradé "Sunset Party" */
            background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            padding: 40px;
            position: relative;
        }

        /* Confettis décoratifs (cercles flous) */
        .confetti { position: absolute; border-radius: 50%; background: rgba(255,255,255,0.15); }
        .c1 { width: 150px; height: 150px; top: -30px; left: -30px; }
        .c2 { width: 80px; height: 80px; bottom: 40px; right: 40px; }
        .c3 { width: 40px; height: 40px; top: 20%; right: 20%; }

        .left-panel h2 { font-size: 34px; margin-bottom: 10px; font-weight: 800; z-index: 2; }
        .left-panel p { font-size: 16px; opacity: 0.9; max-width: 300px; z-index: 2; margin-bottom: 30px; }

        .icon-container {
            width: 140px; height: 140px;
            background: rgba(255,255,255,0.25);
            backdrop-filter: blur(5px);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 70px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            z-index: 2;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.05); } 100% { transform: scale(1); } }

        /* --- DROITE : Formulaire --- */
        .right-panel {
            flex: 1;
            background: white;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-title { font-size: 28px; color: #333; margin-bottom: 30px; text-align: center; font-weight: 800; }
        .login-title span { color: #DD2476; }

        .input-group { margin-bottom: 20px; }
        
        .input-group input {
            width: 100%; padding: 15px 20px;
            border: 2px solid #f0f0f0;
            background: #fafafa;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            outline: none;
        }
        .input-group input:focus {
            background: white;
            border-color: #FF512F;
            box-shadow: 0 0 0 4px rgba(255, 81, 47, 0.1);
        }

        .btn-submit {
            width: 100%; padding: 16px;
            background: linear-gradient(to right, #FF512F, #DD2476);
            border: none; border-radius: 12px;
            color: white; font-size: 16px; font-weight: bold;
            cursor: pointer;
            box-shadow: 0 5px 20px rgba(221, 36, 118, 0.3);
            transition: transform 0.2s;
            margin-top: 10px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(221, 36, 118, 0.4); }

        .error-message { background: #ffebee; color: #c62828; padding: 12px; border-radius: 8px; text-align: center; font-size: 13px; margin-bottom: 20px; }
        .signup-link { text-align: center; margin-top: 25px; font-size: 14px; color: #666; }
        .signup-link a { color: #FF512F; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

    <div class="login-wrapper">
        <div class="left-panel">
            <div class="confetti c1"></div>
            <div class="confetti c2"></div>
            <div class="confetti c3"></div>
            
            <h2>BIENVENUE</h2>
            <p>Que la fête commence ! Connectez-vous.</p>
            
            <div class="icon-container">
                🥂
            </div>
        </div>

        <div class="right-panel">
            <h3 class="login-title">Se <span>Connecter</span></h3>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="input-group">
                    <input type="email" name="email" placeholder="Votre email..." required />
                </div>
                <div class="input-group">
                    <input type="password" name="password" placeholder="Mot de passe..." required />
                </div>

                <div style="display: flex; justify-content: space-between; font-size: 13px; color: #888; margin-bottom: 20px;">
                    <label><input type="checkbox"> Se souvenir</label>
                    <a href="#" style="color: #DD2476; text-decoration: none;">Mot de passe oublié ?</a>
                </div>

                <button type="submit" class="btn-submit">SE CONNECTER</button>
                
                <div class="signup-link">
				    Pas de compte ? <a href="${pageContext.request.contextPath}/register">S'inscrire</a>
				</div>
            </form>
        </div>
    </div>

</body>
</html>