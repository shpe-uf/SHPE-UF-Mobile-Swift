# Setting Up SHPE iOS Mobile App on Xcode

Step by step instructions to setting up the SHPE UF Server and SHPE iOS mobile app.

In order to set up Xcode on your device, there are a few necessary applications you must download:

- Node.js  
- VSCode  
- ngrok  
- A GitHub account to access the SHPE UF server  

Using these applications, you are able to set up the SHPE UF server and can clone the repository to your own device.

## Node.js
Download Node.js:  
1. Go to [https://nodejs.org](https://nodejs.org)  
2. Download the macOS version  
3. Verify installation in terminal:  

```bash
node -v
```

## VSCode
Install VSCode if you do not have it already. Once you have VSCode, open the folder that contains the SHPEServer code. Create a file titled `.env`.  

The necessary information to be copied will be sent in the Discord server.  

**Testing the server:**  
To ensure the server is running, type in:  

```bash
npm install
npm start
```

If you see a success message, the server is running correctly.  

## Ngrok
1. Install Ngrok by making an account at [https://dashboard.ngrok.com/login](https://dashboard.ngrok.com/login)  
2. When prompted, download the `.zip` file  
3. Unzip the file using the commands given on the website  
4. Configure your **authtoken**  

Run ngrok, using the same port from your `.env` file:  

```bash
ngrok http 5000
```

After running, you’ll see output. The link next to **Forwarding** is important; copy it for later.

## GitHub
Go to the SHPE GitHub and clone the repo:  

[https://github.com/shpe-uf/SHPE-UF-Mobile-Swift](https://github.com/shpe-uf/SHPE-UF-Mobile-Swift)  

Navigate (`cd`) into the folder you want to clone to, then run:  

```bash
git clone https://github.com/shpe-uf/SHPE-UF-Mobile-Swift.git
```

After cloning, open the project in Xcode. Click the file to open the workspace, then press the **play** button to ensure it builds and runs correctly.

## Step by Step Slides
For more detail, refer to the setup slides:  
[Step by Step Slides for Setting Up Xcode](https://docs.google.com/presentation/d/1derwN9dkDCV2ifVX7zGGkQMl-X-_loxA8yMK3_hm1As/edit?slide=id.p#slide=id.p)

---

*Current page is Setting Up SHPE iOS Mobile App on Xcode*
