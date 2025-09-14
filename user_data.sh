#!/bin/bash
# user_data.sh - EC2 Bootstrap Script

# Log all output to /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting user data script execution..."

# Update system packages
echo "Updating system packages..."
yum update -y

# Enable and install nginx using amazon-linux-extras
echo "Enabling nginx repo and installing nginx..."
amazon-linux-extras install nginx1 -y
yum install -y nginx

# Install additional useful packages
echo "Installing additional packages..."
yum install -y htop curl wget git

# Start and enable nginx
echo "Starting nginx service..."
systemctl start nginx
systemctl enable nginx

# Fetch instance metadata
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "Not available")
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "Not available")
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "Not available")
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone || echo "Not available")

# Create custom index.html with dynamic metadata
echo "Creating custom web page..."
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${project_name} - Day 29 Challenge</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:700,400&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', Arial, sans-serif;
            background: linear-gradient(135deg, #000000, #3d4f2d);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #cddc39;
            overflow: hidden;
        }
        .container {
            background: rgba(30, 40, 20, 0.85);
            border-radius: 20px;
            padding: 40px 32px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.8);
            text-align: center;
            max-width: 650px;
            width: 90%;
            animation: fadeIn 1.5s ease-out, glowBox 3s infinite alternate;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(40px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes glowBox {
            from { box-shadow: 0 0 15px #8bc34a, 0 0 30px #4caf50; }
            to { box-shadow: 0 0 25px #cddc39, 0 0 45px #8bc34a; }
        }
        h1 {
            color: #cddc39;
            margin-bottom: 18px;
            font-size: 2.4em;
            animation: textGlow 2s infinite alternate;
        }
        @keyframes textGlow {
            from { text-shadow: 0 0 10px #cddc39, 0 0 20px #8bc34a; }
            to { text-shadow: 0 0 20px #cddc39, 0 0 40px #4caf50; }
        }
        .success { color: #8bc34a; font-weight: bold; margin-bottom: 18px; font-size: 1.1em; }
        .info-box {
            background: rgba(0,0,0,0.4);
            border-left: 5px solid #cddc39;
            padding: 18px;
            margin: 18px 0;
            text-align: left;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(205,220,57,0.2);
        }
        .badge {
            background: #3d4f2d;
            color: #cddc39;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 13px;
            margin-left: 6px;
        }
        .meta { font-size: 1em; margin: 8px 0; }
        .meta-label { font-weight: bold; color: #8bc34a; }
        .meta-value { color: #e2e8f0; }
        .challenge-list { margin: 0; padding: 0; list-style: none; }
        .challenge-list li {
            margin: 8px 0;
            padding-left: 20px;
            position: relative;
            color: #cddc39;
        }
        .challenge-list li:before {
            content: "✨";
            position: absolute;
            left: 0;
            color: #8bc34a;
        }
        .footer { margin-top: 28px; font-size: 1.1em; color: #9e9e9e; }
        .copy-btn {
            background: #4caf50;
            color: black;
            border: none;
            border-radius: 5px;
            padding: 6px 14px;
            cursor: pointer;
            margin-left: 8px;
            font-size: 0.95em;
            transition: transform 0.2s, background 0.2s;
        }
        .copy-btn:hover { background: #cddc39; transform: scale(1.05); }
        /* Floating bubble animation */
        .bubble {
            position: absolute;
            bottom: -150px;
            background: rgba(205, 220, 57, 0.2);
            border-radius: 50%;
            animation: rise 20s infinite ease-in;
        }
        @keyframes rise {
            0% { transform: translateY(0) scale(0.5); opacity: 0.2;}
            50% { opacity: 0.6;}
            100% { transform: translateY(-120vh) scale(1.2); opacity: 0;}
        }
        .bubble:nth-child(1){ left: 10%; width: 25px;height: 25px; animation-duration: 18s;}
        .bubble:nth-child(2){ left: 30%; width: 40px;height: 40px; animation-duration: 22s;}
        .bubble:nth-child(3){ left: 50%; width: 20px;height: 20px; animation-duration: 16s;}
        .bubble:nth-child(4){ left: 70%; width: 55px;height: 55px; animation-duration: 25s;}
        .bubble:nth-child(5){ left: 90%; width: 35px;height: 35px; animation-duration: 20s;}
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Terraform Challenge - Day 29</h1>
        <div class="success">Infrastructure deployed successfully with Terraform!</div>
        
        <div class="info-box">
            <div class="meta"><span class="meta-label">Project:</span> <span class="meta-value">${project_name}</span></div>
            <div class="meta"><span class="meta-label">Environment:</span> <span class="badge">${environment}</span></div>
            <div class="meta"><span class="meta-label">Instance ID:</span> <span class="meta-value">$INSTANCE_ID</span> <button class="copy-btn" onclick="copyText('$INSTANCE_ID')">Copy</button></div>
            <div class="meta"><span class="meta-label">Public IP:</span> <span class="meta-value">$PUBLIC_IP</span> <button class="copy-btn" onclick="copyText('$PUBLIC_IP')">Copy</button></div>
            <div class="meta"><span class="meta-label">Private IP:</span> <span class="meta-value">$PRIVATE_IP</span></div>
            <div class="meta"><span class="meta-label">Availability Zone:</span> <span class="meta-value">$AZ</span></div>
        </div>
        
        <div class="info-box">
            <strong>🎯 Challenge Completed:</strong>
            <ul class="challenge-list">
                <li>Provider initialized (AWS)</li>
                <li>Virtual machine created (EC2)</li>
                <li>Public IP exposed in outputs</li>
                <li>Web server running (Nginx)</li>
            </ul>
        </div>
        
        <div class="footer">
            <strong>#justvisualise #DevOps #Terraform #IaC</strong>
        </div>
    </div>

    <!-- Floating bubbles -->
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>

    <script>
        function copyText(text) {
            navigator.clipboard.writeText(text);
            alert("Copied: " + text);
        }
    </script>
</body>
</html>
EOF

# Set proper permissions
chmod 644 /usr/share/nginx/html/index.html

# Simple status page
cat > /usr/share/nginx/html/status.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Server Status</title></head>
<body style="background:#000; color:#cddc39; font-family:sans-serif;">
    <h1>Server Status</h1>
    <p>Server Time: <script>document.write(new Date());</script></p>
    <p>Status: <span style="color: #8bc34a;">✅ Running</span></p>
</body>
</html>
EOF

# Restart nginx to ensure fresh HTML is served
systemctl restart nginx

# Completion marker
echo "User data script completed at \$(date)" > /var/log/user-data-complete.log

echo "User data script execution completed successfully!"
echo "Website available at: http://$PUBLIC_IP"
