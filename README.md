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

<h2>Login Page</h2>

<div>
<br>
<img height="500" style="float:left; margin-right: 25px;" src="https://cloud.githubusercontent.com/assets/22673703/22918680/7eedfe44-f2b1-11e6-8101-e4bd91c6634b.PNG"/>
<img height="500" style="float:right;" src="https://cloud.githubusercontent.com/assets/22673703/22918683/7ef25462-f2b1-11e6-97b4-9da4cff4795d.PNG"/>
<br>
<br>
<img height="500" style="float:left; margin-right: 25px;" src="https://cloud.githubusercontent.com/assets/22673703/22917552/7fef4e66-f2ab-11e6-8482-c1f8b794d907.PNG"/>
<img height="500" style="float:right;" 
src="https://cloud.githubusercontent.com/assets/22673703/22918681/7eee8166-f2b1-11e6-972e-69c2c0f49bd9.PNG "/>
<br>
</div>

<h2>Sharing Page</h2>

<br>
<img height="500" style="float:left;" src="https://cloud.githubusercontent.com/assets/22673703/22918923/fb4a9c30-f2b2-11e6-9f5a-d922a52c5df6.PNG"/>
<img height="500" style="float:right;" src="https://cloud.githubusercontent.com/assets/22673703/22918924/fb9e01ae-f2b2-11e6-8720-6cd4ed84c4ae.PNG"/>
<br>
<br>


<h2>Note</h2>
Used Third Parties 
