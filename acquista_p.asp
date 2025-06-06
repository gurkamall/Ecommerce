<%
If IsEmpty(Session("username")) Or IsNull(Session("username")) Or Session("username") = "" Then
    Session("username") = Request.Form("username")
    Session("password") = Request.Form("password")
End If

Set ObjCon = Server.CreateObject("ADODB.Connection")
Set ObjRs = Server.CreateObject("ADODB.RecordSet")

ObjCon.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("database.accdb")

sqlUserCheck = "SELECT ID FROM persona WHERE username = '" & Replace(Session("username"), "'", "''") & "' AND password = '" & Replace(Session("password"), "'", "''") & "'"
Set rsUser = ObjCon.Execute(sqlUserCheck)

If Not rsUser.EOF Then
    Session("userID") = rsUser("ID")
    
    get_data  = "SELECT prodotti.id_prodotto, prodotti.nome_prodotto, prodotti.prezzo, " & _
               "prodotti.descrizione, prodotti.qta, azienda.nome_azienda AS NomeAzienda, " & _
               "prodotti.categoria " & _
               "FROM prodotti " & _
               "INNER JOIN azienda ON prodotti.azienda = azienda.id_azienda " & _
               "WHERE prodotti.id_prodotto = " & CInt(Session("ID_Prodotto"))

    ObjRs.Open get_data, ObjCon
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Riepilogo Prodotto</title>
    <style>
        :root {
            --primary-color: #4a6fa5;
            --secondary-color: #ff7e5f;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        
        h1 {
            color: var(--primary-color);
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5rem;
            border-bottom: 3px solid var(--secondary-color);
            padding-bottom: 10px;
            display: inline-block;
        }
        
        .product-container {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin-top: 30px;
        }
        
        .product-image {
            flex: 1;
            min-width: 300px;
            text-align: center;
        }
        
        .product-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .product-image img:hover {
            transform: scale(1.03);
        }
        
        .product-details {
            flex: 2;
            min-width: 300px;
        }
        
        .product-details p {
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        
        .product-details strong {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .price {
            font-size: 1.8rem;
            color: var(--secondary-color);
            font-weight: bold;
            margin: 20px 0;
        }
        
        .purchase-form {
            background-color: var(--light-color);
            padding: 25px;
            border-radius: 8px;
            margin-top: 30px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
        }
        
        .purchase-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .purchase-form input[type="number"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            margin-bottom: 20px;
            transition: border-color 0.3s;
        }
        
        .purchase-form input[type="number"]:focus {
            border-color: var(--primary-color);
            outline: none;
        }
        
        .purchase-form input[type="submit"] {
            background-color: var(--success-color);
            color: white;
            border: none;
            padding: 12px 25px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            font-weight: 600;
        }
        
        .purchase-form input[type="submit"]:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
        
        .error-message, .login-message {
            text-align: center;
            padding: 30px;
            background-color: #fff3cd;
            border-left: 5px solid #ffc107;
            margin: 20px 0;
            border-radius: 5px;
        }
        
        .error-message h2, .login-message h2 {
            color: #856404;
            margin-bottom: 15px;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 15px;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #3a5a8c;
            color: white;
        }
        
        .company-name {
            font-style: italic;
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .category-tag {
            display: inline-block;
            background-color: #e9ecef;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            color: var(--dark-color);
            margin-top: 10px;
        }
        
        @media (max-width: 768px) {
            .product-container {
                flex-direction: column;
            }
            
            h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Riepilogo Prodotto</h1>

        <%
            If Not ObjRs.EOF Then
                Do While Not ObjRs.EOF
        %>
        <div class="product-container">
            <div class="product-image">
                <img src="image/<%= CInt(Session("ID_Prodotto")) %>.jpg" alt="Immagine prodotto">
            </div>
            
            <div class="product-details">
                <h2><%= ObjRs("nome_prodotto") %></h2>
                <p class="company-name">Prodotto da: <%= ObjRs("NomeAzienda") %></p>
                <p><strong>Descrizione:</strong><br><%= ObjRs("descrizione") %></p>
                <div class="price"><%= ObjRs("prezzo") %> €</div>
                <span class="category-tag"><%= ObjRs("categoria") %></span>
                
                <div class="purchase-form">
                    <form method="post" action="acquista.asp">
                        <label for="quantita">Quantità da acquistare:</label>
                        <input type="number" name="quantita" min="1" max="<%= ObjRs("qta") %>" required>
                        <input type="hidden" name="ID_Prodotto" value="<%= ObjRs("id_prodotto") %>">
                        <input type="submit" value="Acquista Ora">
                    </form>
                </div>
            </div>
        </div>
        <%
                    ObjRs.MoveNext
                Loop
            Else
        %>
        <div class="error-message">
            <h2>Errore</h2>
            <p>Prodotto non trovato.</p>
            <a href="prodotto.asp" class="btn">Torna alla lista prodotti</a>
        </div>
        <%
            End If
        Else
        %>
        <div class="login-message">
            <h2>Accesso Negato</h2>
            <p>Utente non riconosciuto. Per favore, effettua il login.</p>
            <a href="login.asp" class="btn">Vai al Login</a>
        </div>
        <%
        End If

        If Not ObjRs Is Nothing Then
            If ObjRs.State = 1 Then ObjRs.Close
            Set ObjRs = Nothing
        End If

        If Not rsUser Is Nothing Then
            If rsUser.State = 1 Then rsUser.Close
            Set rsUser = Nothing
        End If

        ObjCon.Close
        Set ObjCon = Nothing
        %>
    </div>
</body>
</html>