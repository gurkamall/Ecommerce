<%
id_p = Request.QueryString("id")

If id_p = "" Or Not IsNumeric(id_p) Then
    Response.Write "<h2>Prodotto non valido.</h2>"
    Response.End
End If

Session("ID_Prodotto") = id_p 

Set ObjCon = Server.CreateObject("ADODB.Connection")
ObjCon.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("database.accdb")

Set ObjRs = Server.CreateObject("ADODB.RecordSet")
get_data = "SELECT nome_prodotto, descrizione, prezzo FROM prodotti WHERE id_prodotto = " & id_p
ObjRs.Open get_data, ObjCon

If ObjRs.EOF Then
    Response.Write "<h2>Prodotto non trovato.</h2>"
Else
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= ObjRs("nome_prodotto") %> | TechShop</title>
    <style>
        :root {
            --primary: #3498db;
            --secondary: #2c3e50;
            --light: #ecf0f1;
            --dark: #333;
            --success: #2ecc71;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background-color: #f9f9f9;
        }
        
        header {
            background-color: var(--secondary);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 0;
        }
        
        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }
        
        .user-actions a {
            color: white;
            margin-left: 1rem;
            text-decoration: none;
        }
        
        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-top: 2rem;
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .product-gallery {
            position: relative;
        }
        
        .main-image {
            width: 100%;
            height: 400px;
            object-fit: contain;
            border: 1px solid #eee;
            border-radius: 4px;
            margin-bottom: 1rem;
        }
        
        .thumbnail-container {
            display: flex;
            gap: 1rem;
        }
        
        .thumbnail {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .thumbnail:hover {
            border-color: var(--primary);
            transform: scale(1.05);
        }
        
        .product-info h1 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--secondary);
        }
        
        .price {
            font-size: 1.8rem;
            color: var(--primary);
            font-weight: bold;
            margin: 1rem 0;
        }
        
        .description {
            margin-bottom: 2rem;
            color: #666;
        }
        
        .btn {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #2980b9;
        }
        
        .btn-block {
            display: block;
            width: 100%;
            text-align: center;
        }
        
        .btn-success {
            background-color: var(--success);
        }
        
        .btn-success:hover {
            background-color: #27ae60;
        }
        
        .related-products {
            margin-top: 3rem;
        }
        
        .related-products h2 {
            margin-bottom: 1.5rem;
            color: var(--secondary);
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
        }
        
        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .product-card-body {
            padding: 1rem;
        }
        
        .product-card h3 {
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }
        
        .product-card .price {
            font-size: 1.2rem;
            margin: 0.5rem 0;
        }
        
        footer {
            background-color: var(--secondary);
            color: white;
            text-align: center;
            padding: 2rem 0;
            margin-top: 3rem;
        }
        
        .login-prompt {
            background-color: #fff8e1;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
            text-align: center;
        }
        
        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
            }
            
            .main-image {
                height: 300px;
            }
        }
    </style>
</head>
<body>

<header>
    <div class="container nav">
        <a href="index.asp" class="logo">TechShop</a>
        <div class="user-actions">
            <% If IsEmpty(Session("username")) Or IsNull(Session("username")) Or Session("username") = "" Then %>
                <a href="login.asp">Accedi</a>
                <a href="register.asp">Registrati</a>
            <% Else %>
                <a href="account.asp">Ciao, <%= Session("username") %></a>
                <a href="logout.asp">Esci</a>
            <% End If %>
            <a href="cart.asp">Carrello</a>
        </div>
    </div>
</header>

<div class="container">
    <div class="product-detail">
        <div class="product-gallery">
            <img src="image/<%= id_p %>.jpg" alt="<%= ObjRs("nome_prodotto") %>" class="main-image" id="mainImage">
            <div class="thumbnail-container">
                <img src="image/<%= id_p %>.jpg" alt="<%= ObjRs("nome_prodotto") %>" class="thumbnail" onclick="changeImage(this)">
                <!-- Additional thumbnails would go here -->
            </div>
        </div>
        
        <div class="product-info">
            <h1><%= ObjRs("nome_prodotto") %></h1>
            <div class="price">€<%= FormatNumber(ObjRs("prezzo"), 2) %></div>
            
            <div class="description">
                <h3>Descrizione</h3>
                <p><%= ObjRs("descrizione") %></p>
            </div>
            
            <% If IsEmpty(Session("username")) Or IsNull(Session("username")) Or Session("username") = "" Then %>
                <div class="login-prompt">
                    <p>Devi essere loggato per effettuare acquisti</p>
                    <a href="login.asp" class="btn btn-block">Accedi ora</a>
                </div>
            <% Else %>
                <form action="add_to_cart.asp" method="post">
                    <input type="hidden" name="product_id" value="<%= id_p %>">
                    <div style="margin-bottom: 1rem;">
                        <label for="quantity">Quantità:</label>
                        <select name="quantity" id="quantity" style="padding: 0.5rem; margin-left: 0.5rem;">
                            <% For i = 1 To 10 %>
                                <option value="<%= i %>"><%= i %></option>
                            <% Next %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success btn-block">Aggiungi al carrello</button>
                </form>
            <% End If %>
        </div>
    </div>
    
    <!-- Related Products Section -->
    <div class="related-products">
        <h2>Prodotti correlati</h2>
        <div class="product-grid">
            <%
            ' Get related products (same category)
            Set relatedRs = Server.CreateObject("ADODB.RecordSet")
            get_related = "SELECT TOP 4 p.id_prodotto, p.nome_prodotto, p.prezzo " & _
                         "FROM prodotti p " & _
                         "INNER JOIN categorie c ON p.categoria = c.id_categorie " & _
                         "WHERE p.id_prodotto <> " & id_p & " AND c.id_categorie = " & _
                         "(SELECT categoria FROM prodotti WHERE id_prodotto = " & id_p & ") " & _
                         "ORDER BY RND(-Timer()*p.id_prodotto)"
            
            relatedRs.Open get_related, ObjCon
            
            Do While Not relatedRs.EOF
            %>
                <div class="product-card">
                    <a href="prodotto.asp?id=<%= relatedRs("id_prodotto") %>">
                        <img src="image/<%= relatedRs("id_prodotto") %>.jpg" alt="<%= relatedRs("nome_prodotto") %>">
                        <div class="product-card-body">
                            <h3><%= relatedRs("nome_prodotto") %></h3>
                            <div class="price">€<%= FormatNumber(relatedRs("prezzo"), 2) %></div>
                        </div>
                    </a>
                </div>
            <%
                relatedRs.MoveNext
            Loop
            relatedRs.Close
            Set relatedRs = Nothing
            %>
        </div>
    </div>
</div>

<footer>
    <div class="container">
        <p>&copy; 2023 TechShop. Tutti i diritti riservati.</p>
        <p>
            <a href="about.asp" style="color: white;">Chi siamo</a> | 
            <a href="contact.asp" style="color: white;">Contatti</a> | 
            <a href="terms.asp" style="color: white;">Termini e condizioni</a>
        </p>
    </div>
</footer>

<script>
    // Change main image when thumbnail is clicked
    function changeImage(element) {
        document.getElementById('mainImage').src = element.src;
    }
    
    // Simple quantity validation
    document.querySelector('form')?.addEventListener('submit', function(e) {
        const quantity = parseInt(document.getElementById('quantity').value);
        if (quantity < 1 || quantity > 10) {
            e.preventDefault();
            alert('Per favore seleziona una quantità valida tra 1 e 10');
        }
    });
</script>

</body>
</html>

<%
End If

If Not ObjRs Is Nothing Then ObjRs.Close : Set ObjRs = Nothing
If Not ObjCon Is Nothing Then ObjCon.Close : Set ObjCon = Nothing
%>