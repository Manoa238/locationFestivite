<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Catalogue - Location Festivité</title>
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #fdfdfd; }
        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        
        .page-title { text-align: center; margin-bottom: 50px; }
        .page-title h1 { 
            font-size: 38px; color: #333; font-weight: 800; text-transform: uppercase;
            background: linear-gradient(to right, #FF512F, #DD2476);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .page-title .line { width: 80px; height: 5px; background: linear-gradient(to right, #FF512F, #DD2476); margin: 15px auto; border-radius: 10px; }

        /* GRID */
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 35px; }
        
        /* --- STYLE DES CARTES --- */
        .product-card { 
            background: white; 
            border-radius: 25px; 
            overflow: hidden; 
            border: 1px solid rgba(0,0,0,0.05); 
            box-shadow: 0 10px 25px rgba(0,0,0,0.03); 
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 5px;
            background: linear-gradient(to right, #FF512F, #DD2476);
            opacity: 0;
            transition: 0.3s;
            z-index: 2;
        }

        .product-card:hover { 
            transform: translateY(-12px); 
            box-shadow: 0 20px 40px rgba(221, 36, 118, 0.15); 
            border-color: rgba(255, 81, 47, 0.3); 
        }
        
        .product-card:hover::before { opacity: 1; }
        
        .img-container { 
            width: 100%; height: 220px; position: relative; overflow: hidden; padding: 20px; box-sizing: border-box; 
        }
        .img-container img { 
            width: 100%; height: 100%; object-fit: contain; 
            transition: transform 0.5s; 
            filter: drop-shadow(0 5px 10px rgba(0,0,0,0.05));
        }
        .product-card:hover .img-container img { transform: scale(1.1); } 

        .price-badge { 
            position: absolute; top: 15px; right: 15px; 
            background: #FFF0F5; color: #DD2476; 
            padding: 8px 15px; border-radius: 50px; 
            font-weight: 900; font-size: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .card-body { 
            padding: 0 25px 30px; text-align: center; 
            flex: 1; display: flex; flex-direction: column; justify-content: space-between; 
        }
        .card-body h3 { margin: 0 0 10px; font-size: 18px; color: #333; text-transform: uppercase; font-weight: 700; }
        .card-body p { font-size: 14px; color: #777; line-height: 1.5; margin-bottom: 20px; }

        .btn-reserve { 
            display: block; width: 100%; padding: 12px 0;
            background: white; border: 2px solid #FF8833; color: #FF8833; 
            border-radius: 50px; text-decoration: none; 
            font-weight: 800; font-size: 13px; text-transform: uppercase; 
            transition: 0.3s; letter-spacing: 1px; cursor: pointer;
        }
        .btn-reserve:hover { 
            background: linear-gradient(135deg, #FF512F 0%, #DD2476 100%); 
            color: white; border-color: transparent;
            box-shadow: 0 5px 15px rgba(255, 81, 47, 0.4);
        }
        
        .stock-status { font-size: 12px; margin-top: 15px; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 5px;}
        .in-stock { color: #2ecc71; }
        .out-stock { color: #e74c3c; }

        /* MODAL STYLE */
        .modal { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
        .modal-content { background: white; margin: 8% auto; padding: 35px; border-radius: 25px; width: 450px; box-shadow: 0 20px 50px rgba(0,0,0,0.2); animation: slideDown 0.4s; text-align: center; }
        @keyframes slideDown { from {transform: translateY(-50px); opacity:0;} to {transform: translateY(0); opacity:1;} }
        
        .modal-content input { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 10px; outline: none; }
        .modal-content label { display: block; text-align: left; font-size: 12px; font-weight: bold; color: #666; margin-bottom: 5px; }
    </style>
</head>
<body>
    <%@ include file="/header.jsp" %>
    <%@ include file="/nav-menu.jsp" %>

    <div class="container">
        <div class="page-title">
            <h1>${not empty pageTitle ? pageTitle : 'Tout notre matériel'}</h1>
            <div class="line"></div>
        </div>

        <div class="product-grid">
            <c:forEach items="${materiels}" var="m">
                <div class="product-card">
                    <div class="img-container">
                        <img src="${pageContext.request.contextPath}/${m.typeImage}" alt="${m.typeNom}">
                        <div class="price-badge"><fmt:formatNumber value="${m.typeMontant}" pattern="###0"/> Ar</div>
                    </div>
                    <div class="card-body">
                        <div>
                            <h3>${m.typeNom}</h3>
                            <p>${m.typeDescription}</p>
                        </div>
                        
                        <div>
                            <c:choose>
                                <c:when test="${m.typeQuantite > 0}">
                                    <!-- BOUTON QUI OUVRE LE MODAL -->
                                    <button type="button" class="btn-reserve" 
                                            onclick="openBookingModal('${m.typeId}', '${m.typeNom}', '${pageContext.request.contextPath}/${m.typeImage}', '${m.typeQuantite}')">
                                        AJOUTER AU PANIER
                                    </button>
                                    <div class="stock-status in-stock">● Disponible</div>
                                </c:when>
                                <c:otherwise>
                                    <span class="btn-reserve" style="background:#eee; border-color:#eee; color:#999; cursor:not-allowed;">RUPTURE</span>
                                    <div class="stock-status out-stock">● Victime de son succès</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- MODAL DE SÉLECTION RAPIDE -->
    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <h2 id="m_name" style="margin-top:0; color:#333;">Nom</h2>
            <img id="m_img" src="" style="width: 120px; height: 120px; object-fit: contain; margin-bottom: 20px;">
            
            <form action="${pageContext.request.contextPath}/panier" method="get">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="id" id="m_id">
                
                <div style="display:flex; gap:10px;">
                    <div style="flex:1">
                        <label>Date Début</label>
                        <input type="date" name="date_debut" required value="${sessionScope.dateDebut}">
                    </div>
                    <div style="flex:1">
                        <label>Date Fin</label>
                        <input type="date" name="date_fin" required value="${sessionScope.dateFin}">
                    </div>
                </div>
                
                <label>Quantité souhaitée</label>
                <input type="number" name="quantite" id="m_qty" value="1" min="1" required>
                <p id="m_stock" style="font-size:11px; color:#999; margin-bottom:20px;"></p>

                <button type="submit" class="btn-reserve" style="width:100%; border:none;">CONFIRMER L'AJOUT</button>
                <button type="button" onclick="closeBookingModal()" style="width:100%; background:none; border:none; color:#999; margin-top:10px; cursor:pointer;">Annuler</button>
            </form>
        </div>
    </div>

    <script>
        function openBookingModal(id, nom, img, stock) {
            document.getElementById('m_id').value = id;
            document.getElementById('m_name').innerText = nom;
            document.getElementById('m_img').src = img;
            document.getElementById('m_qty').max = stock;
            document.getElementById('m_stock').innerText = "Stock disponible : " + stock;
            document.getElementById('bookingModal').style.display = 'block';
        }
        function closeBookingModal() {
            document.getElementById('bookingModal').style.display = 'none';
        }
        window.onclick = function(e) { if(e.target.className == 'modal') closeBookingModal(); }
    </script>

    <%@ include file="/views/client/mini-panier.jsp" %>
</body>
</html>