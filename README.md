# LoginIntegrations

Login Integrations through Instagram, Facebook, Twitter, Flicker, GooglePlus, LInkedIn and WhatsApp and Sharing Images 
through Facebook, Twitter, Instagram and WhatsApp.

Getting you with the best Integrations in iPhone iOS with Objective - C technology.

Login Integrations like Instagram Login, Facebook Login, Flicker Login, Instagram Login, Twitter Login and GooglePlus Login.

Sharing images through Instagram, Facebook, Whatsapp, and Twitter.



crete an account with your application in Flicker Developer Account with specified Bundle ID and replace your Flicker API Key and Secrete Key
Go to AppDelegate.m

    -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launch
    NSString *apiKey = @"Flicker API Key";
    NSString *secret = @"Flicker Secret Key";
    }
The same way create a application in Instagram Devleoper Account with the specified Bundle ID and replace your Instagram API key and Secrete Key
Go to InstagramLoginViewController.m

Change 
    
    #define INSTAGRAM_CLIENT_ID  @"Instagram API Key"
    #define INSTAGRAM_CLIENTSERCRET  @"Instagram Secret Key"
    
For GooglePlus Login, Create an account in Google Developer accounta with specified Bundle ID and download the Google-Services plist file and copy it to the project.

For Twitter Login Integration Follow Fabric Documentation

In Xcode Project, add URL Schemes of LinkedIn, Facebook, and GooglePlus

Got to Target --> Info  -->URL Types

Add LinkedIn , Facebook, GooglePlus URL Types in Targets as same in Demo.

Login Page
<br>
<img height="700" src= "![loginpage](https://cloud.githubusercontent.com/assets/22673703/22917551/7feef2fe-f2ab-11e6-8d91-567d32f70ac7.PNG) "/>
<br>

    
        
