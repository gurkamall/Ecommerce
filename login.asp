<%
Dim errore
errore = Request.QueryString("errore")
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | TechShop</title>
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3a0ca3;
            --accent: #f72585;
            --light: #f8f9fa;
            --dark: #212529;
            --success: #4cc9f0;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            animation: gradientBG 15s ease infinite;
            background-size: 400% 400%;
        }
        
        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        .login-container {
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            position: relative;
            overflow: hidden;
            transform-style: preserve-3d;
            transition: all 0.5s ease;
        }
        
        .login-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
        }
        
        .login-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, var(--primary), transparent);
            animation: rotate 6s linear infinite;
            z-index: 1;
        }
        
        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .login-content {
            position: relative;
            z-index: 2;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo h1 {
            color: var(--primary);
            font-size: 2.5rem;
            font-weight: 800;
            letter-spacing: -1px;
            background: linear-gradient(to right, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }
        
        .logo p {
            color: var(--dark);
            opacity: 0.7;
            margin-top: 5px;
            font-size: 0.9rem;
        }
        
        h2 {
            color: var(--dark);
            margin-bottom: 25px;
            text-align: center;
            font-size: 1.8rem;
        }
        
        .error {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            animation: shake 0.5s;
            border-left: 4px solid #d32f2f;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--dark);
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background-color: #f8f9fa;
        }
        
        .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
            outline: none;
            background-color: white;
        }
        
        .form-group input::placeholder {
            color: #adb5bd;
        }
        
        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(67, 97, 238, 0.4);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .links {
            text-align: center;
            margin-top: 25px;
        }
        
        .links a {
            color: var(--primary);
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s;
            display: inline-block;
            margin: 0 10px;
        }
        
        .links a:hover {
            color: var(--secondary);
            text-decoration: underline;
        }
        
        .character {
            position: absolute;
            width: 100px;
            height: 100px;
            background-size: contain;
            background-repeat: no-repeat;
            z-index: 3;
            pointer-events: none;
        }
        
        .character-1 {
            background-image: url('https://cdn3.iconfinder.com/data/icons/shopping-solid-icons-vol-1/64/028-512.png');
            top: -30px;
            right: -30px;
            animation: float 6s ease-in-out infinite;
        }
        
        .character-2 {
            background-image: url('https://cdn3.iconfinder.com/data/icons/shopping-solid-icons-vol-1/64/027-512.png');
            bottom: -40px;
            left: -40px;
            animation: float 4s ease-in-out infinite 2s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        
        @media (max-width: 500px) {
            .login-container {
                padding: 30px 20px;
            }
            
            .character {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="character character-1"></div>
        <div class="character character-2"></div>
        
        <div class="login-content">
            <div class="logo">
                <h1>TechShop</h1>
                <p>Il tuo negozio tecnologico preferito</p>
            </div>
            
            <h2>Accedi al tuo account</h2>
            
            <% If errore <> "" Then %>
                <div class="error">
                    <%= Server.HTMLEncode(errore) %>
                </div>
            <% End If %>
            
            <form method="post" action="acquista_p.asp">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" 
                           value="<%= Server.HTMLEncode(Request.Form("username")) %>" 
                           placeholder="Inserisci il tuo username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" 
                           placeholder="Inserisci la tua password" required>
                </div>
                
                <button type="submit" class="btn">Accedi</button>
            </form>
            
            <div class="links">
                <a href="register.asp">Crea un account</a>
                <a href="forgot-password.asp">Password dimenticata?</a>
            </div>
        </div>
    </div>

    <script>
        // Add fun hover effect to form inputs
        document.querySelectorAll('.form-group input').forEach(input => {
            input.addEventListener('mouseenter', () => {
                input.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('mouseleave', () => {
                input.style.transform = 'scale(1)';
            });
        });
        
        // Add character animation on focus
        document.getElementById('username').addEventListener('focus', () => {
            document.querySelector('.character-1').style.transform = 'translateY(-20px) rotate(10deg)';
        });
        
        document.getElementById('password').addEventListener('focus', () => {
            document.querySelector('.character-2').style.transform = 'translateY(-20px) rotate(-10deg)';
        });
        
        // Reset characters when focus is lost
        document.querySelector('form').addEventListener('focusout', () => {
            setTimeout(() => {
                document.querySelectorAll('.character').forEach(char => {
                    char.style.transform = '';
                });
            }, 100);
        });
    </script>
</body>
</html>