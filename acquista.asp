<%
quantita = CInt(Request.Form("quantita"))

Set ObjCon = Server.CreateObject("ADODB.Connection")
ObjCon.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("DATABASE.accdb")


Set RsUtente = Server.CreateObject("ADODB.RecordSet")
utenteSQL = "SELECT ID FROM persona WHERE ID = " & CInt(Session("userID"))
RsUtente.Open utenteSQL, ObjCon

If RsUtente.EOF Then

    RsUtente.Close
    Set RsUtente = Nothing
    ObjCon.Close
    Set ObjCon = Nothing
    Response.Write("Errore: Utente non trovato.")
    Response.End
End If
RsUtente.Close
Set RsUtente = Nothing

Set RsProdotto = Server.CreateObject("ADODB.RecordSet")
prodottoSQL = "SELECT prodotti.nome_prodotto, prodotti.prezzo, prodotti.descrizione, " & _
              "azienda.nome_azienda AS NomeAzienda, prodotti.qta AS Quantita " & _
              "FROM prodotti INNER JOIN azienda ON prodotti.azienda = azienda.id_azienda " & _
              "WHERE prodotti.id_prodotto = " & CInt(Session("ID_Prodotto"))

RsProdotto.Open prodottoSQL, ObjCon

If RsProdotto.EOF Then
    RsProdotto.Close
    Set RsProdotto = Nothing
    ObjCon.Close
    Set ObjCon = Nothing
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Errore Acquisto</title>
</head>
<body>
    <div class="error-box">
        <h1>Errore</h1>
        <p>Prodotto non trovato. Ritorna indietro e riprova.</p>
        <a href="acquista_p.asp">Torna alla pagina di acquisto</a>
    </div>
</body>
</html>
<%
    Response.End
Else
    qta = CInt(RsProdotto("Quantita"))
    prezzo = CInt(RsProdotto("Prezzo"))
    nomeProdotto = RsProdotto("nome_prodotto")

    RsProdotto.Close
    Set RsProdotto = Nothing
End If
%>
<%

If quantita <= qta Then

    updateSQL = "UPDATE prodotti SET qta = qta - " & quantita & _
                " WHERE id_prodotto = " & CInt(Session("ID_Prodotto"))
    ObjCon.Execute updateSQL

    ProdottoID = CInt(Session("ID_Prodotto"))
    UtenteID = CInt(Session("userID"))
    PrezzoTot = prezzo * quantita
    oggi = Year(Date) & "-" & Right("0" & Month(Date),2) & "-" & Right("0" & Day(Date),2)

    insertSQL = "INSERT INTO acquisto (prodotto, utente, prezzotot, data) " & _
                "VALUES (" & ProdottoID & ", " & UtenteID & ", " & Replace(PrezzoTot, ",", ".") & ", #" & oggi & "#)"
    ObjCon.Execute insertSQL

    
    Session("quantita") = quantita
    Session("Prezzo") = PrezzoTot

    ObjCon.Close
    Set ObjCon = Nothing
%>


<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Acquisto Confermato</title>
</head>
<body>

<div class="confirmation-box">
    <h2>Acquisto completato con successo!</h2>
    <p>Hai acquistato <strong><%= Session("quatita") %></strong> unità di <strong><%= nomeProdotto %></strong>.</p>
    <p>Prezzo totale: <strong><%= Session("Prezzo") %> €</strong></p>
    <a href="form.asp" class="btn">Torna all'acquisto</a>
    <a href="logout.asp" class="btn">Logout</a>
</div>
 
</body>
</html>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Acquisto Confermato! | TechShop</title>
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3a0ca3;
            --accent: #f72585;
            --success: #4cc9f0;
            --light: #f8f9fa;
            --dark: #212529;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: var(--dark);
            line-height: 1.6;
            overflow-x: hidden;
        }
        
        .confirmation-box {
            max-width: 600px;
            margin: 5rem auto;
            padding: 3rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .confirmation-box::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 10px;
            background: linear-gradient(90deg, var(--primary), var(--accent), var(--success));
        }
        
        h2 {
            color: var(--secondary);
            margin-bottom: 1.5rem;
            font-size: 2.2rem;
            position: relative;
            display: inline-block;
        }
        
        h2::after {
            content: "🎉";
            position: absolute;
            right: -40px;
            top: -10px;
            font-size: 1.5rem;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        p {
            margin: 1rem 0;
            font-size: 1.1rem;
        }
        
        strong {
            color: var(--primary);
            font-weight: 600;
        }
        
        .btn {
            display: inline-block;
            padding: 0.8rem 1.8rem;
            margin: 1rem 0.5rem;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(67, 97, 238, 0.4);
        }
        
        .btn-outline {
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
        }
        
        .product-image {
            width: 150px;
            height: 150px;
            object-fit: contain;
            margin: 1.5rem auto;
            display: block;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .price-tag {
            background-color: var(--success);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            display: inline-block;
            margin: 1rem 0;
            font-weight: bold;
            font-size: 1.5rem;
            animation: zoomIn 0.5s ease-out;
        }
        
        @keyframes zoomIn {
            from { transform: scale(0.8); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        
        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background-color: var(--accent);
            opacity: 0;
            z-index: 1000;
            animation: confetti 5s ease-in-out;
        }
        
        @keyframes confetti {
            0% { transform: translateY(0) rotate(0deg); opacity: 1; }
            100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
        }
        
        .checkmark {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            display: block;
            animation: checkmark 0.6s ease;
        }
        
        @keyframes checkmark {
            0% { transform: scale(0); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>

<div class="confirmation-box">
    <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
        <circle cx="26" cy="26" r="25" fill="none" stroke="#4cc9f0" stroke-width="3"/>
        <path fill="none" stroke="#4cc9f0" stroke-width="4" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
    </svg>
    
    <h2>Acquisto completato con successo!</h2>
    
    <img src="image/<%= CInt(Session("ID_Prodotto")) %>.jpg" alt="<%= Server.HTMLEncode(nomeProdotto) %>" class="product-image">
    
    <p>Grazie per il tuo acquisto, <strong><%= Server.HTMLEncode(Session("username")) %></strong>!</p>
    <p>Hai acquistato <strong><%= quantita %></strong> unità di <strong><%= Server.HTMLEncode(nomeProdotto) %></strong>.</p>
    
    <div class="price-tag">
        Totale: <%= FormatNumber(Session("Prezzo"), 2) %> €
    </div>
    
    <p>Riceverai una email di conferma con i dettagli dell'ordine.</p>
    
    <div style="margin-top: 2rem;">
        <a href="form.asp" class="btn">Torna allo shopping</a>
        <a href="account.asp" class="btn btn-outline">Il mio account</a>
    </div>
</div>

<script>
    // Create confetti effect
    function createConfetti() {
        const colors = ['#4361ee', '#3a0ca3', '#f72585', '#4cc9f0', '#f8961e'];
        for (let i = 0; i < 100; i++) {
            const confetti = document.createElement('div');
            confetti.className = 'confetti';
            confetti.style.left = Math.random() * 100 + 'vw';
            confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
            confetti.style.animationDuration = (Math.random() * 3 + 2) + 's';
            document.body.appendChild(confetti);
            
            setTimeout(() => {
                confetti.remove();
            }, 5000);
        }
    }
    
    // Create confetti on page load
    window.onload = function() {
        createConfetti();
        
        // Additional confetti bursts every 2 seconds
        setInterval(() => {
            if(Math.random() > 0.5) {
                createConfetti();
            }
        }, 2000);
    };
</script>

</body>
</html>

<%
Else
    ObjCon.Close
    Set ObjCon = Nothing
    Response.Redirect("acquista_p.asp")
End If
%>
