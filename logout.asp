<%
If Request("azione") = "logout" Then
    Session.Abandon
    Response.Redirect("form.asp")
Else
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conferma Logout</title>
    <style>
        :root {
            --primary-color: #4a6fa5;
            --danger-color: #e74c3c;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --gray-color: #6c757d;
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            background-image: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
        }
        
        .logout-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            transform: scale(0.95);
            animation: fadeIn 0.3s ease-out forwards;
            border-top: 5px solid var(--danger-color);
        }
        
        @keyframes fadeIn {
            to {
                transform: scale(1);
                opacity: 1;
            }
            from {
                transform: scale(0.95);
                opacity: 0;
            }
        }
        
        .logout-icon {
            font-size: 4rem;
            color: var(--danger-color);
            margin-bottom: 20px;
        }
        
        h2 {
            color: var(--dark-color);
            margin-bottom: 15px;
            font-size: 1.8rem;
        }
        
        p {
            color: var(--gray-color);
            margin-bottom: 30px;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-logout {
            background-color: var(--danger-color);
            color: white;
        }
        
        .btn-logout:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        
        .btn-cancel {
            background-color: white;
            color: var(--dark-color);
            border: 2px solid #e0e0e0;
        }
        
        .btn-cancel:hover {
            background-color: #f8f9fa;
            border-color: var(--gray-color);
            transform: translateY(-2px);
        }
        
        .remember-me {
            margin-top: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            color: var(--gray-color);
        }
        
        @media (max-width: 576px) {
            .logout-container {
                padding: 30px 20px;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="logout-container">
        <div class="logout-icon">
            <i class="fas fa-sign-out-alt"></i>
        </div>
        <h2>Conferma Logout</h2>
        <p>Sei sicuro di voler uscire dal tuo account? Tutte le modifiche non salvate andranno perse.</p>
        
        <div class="btn-group">
            <form method="post" style="display:inline;">
                <input type="hidden" name="azione" value="logout">
                <button type="submit" class="btn btn-logout">
                    <i class="fas fa-sign-out-alt"></i> Esci ora
                </button>
            </form>
            
            <a href="javascript:history.back()" class="btn btn-cancel">
                <i class="fas fa-times"></i> Annulla
            </a>
        </div>
        
        <div class="remember-me">
            <input type="checkbox" id="remember" name="remember">
            <label for="remember">Non chiedere nuovamente per 30 giorni</label>
        </div>
    </div>

    <script>
        // Add smooth transition when clicking cancel
        document.querySelector('.btn-cancel').addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelector('.logout-container').style.animation = 'fadeIn 0.3s ease-out reverse';
            setTimeout(() => {
                window.history.back();
            }, 250);
        });

        // Remember user preference if checked
        document.getElementById('remember').addEventListener('change', function() {
            if(this.checked) {
                // Set a cookie to remember the choice for 30 days
                document.cookie = "rememberLogoutPreference=true; max-age=" + (30*24*60*60) + "; path=/";
            } else {
                // Remove the cookie
                document.cookie = "rememberLogoutPreference=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/";
            }
        });

        // Check if cookie exists on page load
        window.addEventListener('DOMContentLoaded', function() {
            if(document.cookie.split(';').some((item) => item.trim().startsWith('rememberLogoutPreference='))) {
                document.getElementById('remember').checked = true;
            }
        });
    </script>
</body>
</html>
<%
End If
%>