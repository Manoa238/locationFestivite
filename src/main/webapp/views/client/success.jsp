<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmation - Location Festivité</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; text-align: center; background: #fdfdfd; padding-top: 100px; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); display: inline-block; max-width: 450px; border: 1px solid #eee; }
        h1 { color: #2ecc71; font-size: 24px; }
        .btn-view { background: #333; color: white; padding: 12px 30px; border-radius: 5px; cursor: pointer; border: none; font-weight: bold; width: 100%; margin-top: 20px; }
        .modal { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); overflow-y: auto; }
        .modal-content { background: white; margin: 50px auto; padding: 40px; width: 600px; text-align: left; border-radius: 10px; position: relative; }
        .receipt-header { border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 20px; }
        .receipt-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        .receipt-table th { border-bottom: 1px solid #000; padding: 10px 5px; text-align: left; font-size: 13px; }
        .receipt-table td { padding: 10px 5px; border-bottom: 1px solid #eee; font-size: 14px; }
        .total-row { text-align: right; font-size: 20px; font-weight: bold; margin-top: 20px; border-top: 2px solid #000; padding-top: 10px; }
        .btn-download { background: #FF512F; color: white; padding: 12px 25px; border: none; font-weight: bold; cursor: pointer; margin-top: 30px; border-radius: 5px; width: 100%; }
    </style>
</head>
<body>

    <div class="card">
        <div style="font-size: 50px;">✅</div>
        <h1>Merci !</h1>
        <p>Votre réservation a été enregistrée.</p>
        <button onclick="openReceipt()" class="btn-view">VOIR LE REÇU</button>
        <a href="${pageContext.request.contextPath}/home" style="display:block; margin-top:15px; color:#999; text-decoration:none; font-size:13px;">Retour à l'accueil</a>
    </div>

    <div id="receiptModal" class="modal">
        <div class="modal-content">
            <span onclick="closeReceipt()" style="position:absolute; right:20px; top:10px; font-size:24px; cursor:pointer;">&times;</span>
            
            <div id="receipt-to-download">
                <div class="receipt-header">
                    <div style="font-size: 22px; font-weight: bold;">LOCATION FESTIVITÉ</div>
                </div>

                <div style="font-size: 14px; margin-bottom: 20px;">
                    <p><strong>Date :</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" /></p>
                    <p><strong>Client :</strong> ${sessionScope.utilisateurConnecte.nom}</p>
                    <p><strong>Période :</strong> Du ${sessionScope.dateDebut} au ${sessionScope.dateFin} (${nbJours} jour(s))</p>
                </div>

                <table class="receipt-table">
                    <thead>
                        <tr>
                            <th>DESCRIPTION</th>
                            <th>QTÉ</th>
                            <th style="text-align:right;">PRIX UNIT.</th>
                            <th style="text-align:right;">TOTAL / J</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="totalParJour" value="0" />
                        <c:forEach items="${panierBackup}" var="item">
                            <tr>
                                <td>${item.materiel.typeNom}</td>
                                <td>${item.quantite}</td>
                                <td style="text-align:right;"><fmt:formatNumber value="${item.materiel.typeMontant}" pattern="###0"/> Ar</td>
                                <td style="text-align:right;"><fmt:formatNumber value="${item.sousTotal}" pattern="###0"/> Ar</td>
                            </tr>
                            <c:set var="totalParJour" value="${totalParJour + item.sousTotal}" />
                        </c:forEach>
                    </tbody>
                </table>

                <div style="text-align: right; font-size: 14px; color: #666;">
                    Total par jour : <fmt:formatNumber value="${totalParJour}" pattern="###0"/> Ar<br>
                    Durée de location : ${nbJours} jour(s)
                </div>

                <div class="total-row">
                    PRIX TOTAL : <fmt:formatNumber value="${montantTotal}" pattern="###0"/> Ar
                </div>

                <div style="margin-top:40px; font-size:11px; text-align:center; border-top: 1px solid #eee; padding-top:10px; color: #888;">
                    Location Festivité, Madagascar. Merci de votre confiance !
                </div>
            </div>

            <button onclick="downloadPDF()" class="btn-download">📥 TÉLÉCHARGER LE REÇU (PDF)</button>
        </div>
    </div>

    <script>
        function openReceipt() { document.getElementById('receiptModal').style.display = 'block'; }
        function closeReceipt() { document.getElementById('receiptModal').style.display = 'none'; }
        function downloadPDF() {
            const element = document.getElementById('receipt-to-download');
            html2pdf().set({
                margin: 10,
                filename: 'Recu-Location.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            }).from(element).save();
        }
    </script>
</body>
</html>