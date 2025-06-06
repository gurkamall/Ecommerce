<%
' Connessione
Dim ObjCon, ObjRs, get_data, categoria
Set ObjCon = Server.CreateObject("ADODB.Connection")
ObjCon.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("database.accdb")

' Recupera categorie
Set ObjRs = Server.CreateObject("ADODB.RecordSet")
get_data = "SELECT nome_categorie FROM categorie ORDER BY nome_categorie"
ObjRs.Open get_data, ObjCon

' Get featured products for slider
Dim featuredRs
Set featuredRs = Server.CreateObject("ADODB.RecordSet")
get_data = "SELECT TOP 5 id_prodotto, nome_prodotto FROM prodotti ORDER BY RND(-Timer()*id_prodotto)"
featuredRs.Open get_data, ObjCon
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>TechShop - Your Technology Marketplace</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            color: #333;
        }
        
        header {
            background-color: #2c3e50;
            color: white;
            padding: 20px 0;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .logo {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .tagline {
            font-style: italic;
            color: #ecf0f1;
        }
        
        .container {
            width: 80%;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        form {
            margin: 20px 0;
            padding: 15px;
            background-color: #ecf0f1;
            border-radius: 5px;
        }
        
        select, input[type="submit"] {
            padding: 8px;
            margin-right: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 4px;
        }
        
        input[type="submit"] {
            background-color: #3498db;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        input[type="submit"]:hover {
            background-color: #2980b9;
        }
        
        ul {
            list-style-type: none;
            padding: 0;
        }
        
        ul li {
            padding: 10px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s;
        }
        
        ul li:hover {
            background-color: #f9f9f9;
        }
        
        ul li a {
            text-decoration: none;
            color: #3498db;
        }
        
        ul li a:hover {
            text-decoration: underline;
        }
        
        .slider {
            width: 100%;
            overflow: hidden;
            margin: 20px 0;
            position: relative;
            height: 300px;
            background-color: #2c3e50;
            border-radius: 5px;
        }
        
        .slider-container {
            display: flex;
            transition: transform 0.5s ease;
            height: 100%;
        }
        
        .slide {
            min-width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        .slide img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }
        
        .slide-info {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background-color: rgba(0,0,0,0.7);
            color: white;
            padding: 10px;
            text-align: center;
        }
        
        .slider-nav {
            text-align: center;
            margin-top: 10px;
        }
        
        .slider-dot {
            display: inline-block;
            width: 12px;
            height: 12px;
            background-color: #bdc3c7;
            border-radius: 50%;
            margin: 0 5px;
            cursor: pointer;
        }
        
        .slider-dot.active {
            background-color: #3498db;
        }
        
        footer {
            text-align: center;
            padding: 20px;
            background-color: #2c3e50;
            color: white;
            margin-top: 20px;
        }
        
        .login-link {
            display: block;
            text-align: right;
            margin-top: 20px;
        }
        
        .login-link a {
            color: #3498db;
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>
    <div class="logo">TechShop</div>
    <div class="tagline">Your Technology Marketplace</div>
</header>

<div class="container">
    <div class="slider">
        <div class="slider-container" id="slider">
            <%
            Dim slideCount
            slideCount = 0
            Do While Not featuredRs.EOF
            %>
                <div class="slide">
                    <img src="image/<%= featuredRs("id_prodotto") %>.jpg" alt="<%= featuredRs("nome_prodotto") %>">
                    <div class="slide-info"><%= featuredRs("nome_prodotto") %></div>
                </div>
            <%
                slideCount = slideCount + 1
                featuredRs.MoveNext
            Loop
            featuredRs.Close : Set featuredRs = Nothing
            %>
        </div>
    </div>
    <div class="slider-nav" id="sliderNav">
       <%
For i = 1 To slideCount 
    If i = 1 Then
        Response.Write "<span class='slider-dot active' data-index='" & (i-1) & "'></span>"
    Else
        Response.Write "<span class='slider-dot' data-index='" & (i-1) & "'></span>"
    End If
Next 
%>
    </div>

    <h2>Catalogo Prodotti</h2>

    <form method="post" action="">
        Seleziona categoria:
        <select name="categoria">
            <option value="">-- Seleziona --</option>
            <%
            ObjRs.MoveFirst
            Do While Not ObjRs.EOF
                categoria = ObjRs("nome_categorie")
            %>
                <option value="<%= categoria %>" <% If Request.Form("categoria") = categoria Then Response.Write("selected") %>><%= categoria %></option>
            <%
                ObjRs.MoveNext
            Loop
            ObjRs.Close : Set ObjRs = Nothing
            %>
        </select>
        <input type="submit" value="Filtra">
    </form>

    <%
    ' Mostra prodotti in base alla categoria selezionata
    If Request.Form("categoria") <> "" Then
        Set ObjRs = Server.CreateObject("ADODB.RecordSet")
        
        get_data = "SELECT prodotti.nome_prodotto, prodotti.id_prodotto " & _
                   "FROM categorie INNER JOIN prodotti ON categorie.id_categorie = prodotti.categoria " & _
                   "WHERE categorie.nome_categorie = '" & Replace(Request.Form("categoria"), "'", "''") & "'"

        ObjRs.Open get_data, ObjCon

        Response.Write("<h3>Prodotti nella categoria: " & Server.HTMLEncode(Request.Form("categoria")) & "</h3>")
        If ObjRs.EOF Then
            Response.Write("<p>Nessun prodotto trovato.</p>")
        Else
            Response.Write("<ul>")
            Do While Not ObjRs.EOF
               Response.Write("<li><a href='prodotto.asp?id=" & ObjRs("id_prodotto") & "'>" & Server.HTMLEncode(ObjRs("nome_prodotto")) & "</a></li>")
                ObjRs.MoveNext
            Loop
            Response.Write("</ul>")
        End If

        ObjRs.Close : Set ObjRs = Nothing
    End If

    ObjCon.Close : Set ObjCon = Nothing
    %>

    <div class="login-link">
        <a href="login.asp">Area Riservata</a>
    </div>
</div>

<footer>
    &copy; 2023 TechShop - Tutti i diritti riservati
</footer>

<script>
    // Simple slider functionality
    document.addEventListener('DOMContentLoaded', function() {
        const slider = document.getElementById('slider');
        const dots = document.querySelectorAll('.slider-dot');
        let currentIndex = 0;
        const slideCount = <%= slideCount %>;
        
        function goToSlide(index) {
            if (index < 0) index = slideCount - 1;
            if (index >= slideCount) index = 0;
            
            slider.style.transform = `translateX(-${index * 100}%)`;
            currentIndex = index;
            
            // Update dots
            dots.forEach((dot, i) => {
                dot.classList.toggle('active', i === index);
            });
        }
        
        // Dot click handlers
        dots.forEach(dot => {
            dot.addEventListener('click', function() {
                goToSlide(parseInt(this.getAttribute('data-index')));
            });
        });
        
        // Auto-advance slides every 5 seconds
        setInterval(() => {
            goToSlide(currentIndex + 1);
        }, 5000);
    });
</script>

</body>
</html>