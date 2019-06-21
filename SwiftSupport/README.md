# Fujifilm SPA iOS SDK Swift Implementation Guide

## Introduction
Follow the guide below to use our SDK if you have a Swift app. If you have an Objective-C app folow the instructions found [here](https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp).

### Step 1: Include Fujifilm SPA SDK and update info.plist
Follow the instructions on Github to include our SDK either using Cocoapods or manual, found [here](https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp).

Be sure to also add the appropriate settings in your info.plist file as defined in the GitHub documentation.

### Step 2: Add the Objective-C Bridge Class
Include the Fujifilm_SPA_SDK_Bridge.h and Fujifilm_SPA_SDK_Bridge.m in your Xcode project. They can be found at  [Fujifilm_SPA_SDK_Bridge.h](https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp/blob/master/SwiftSupport/Fujifilm_SPA_SDK_Bridge.h), and [Fujifilm_SPA_SDK_Bridge.m](https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp/blob/master/SwiftSupport/Fujifilm_SPA_SDK_Bridge.m). If you get a popup that asks to create an Objective-C bridge file, tap on don't create.

### Step 3: Update Build settings with Bridge Class location
1. In your Xcode project target Build Settings (Build Settings tab when you are viewing your targets settings) find the “Objective-C Bridging Header” setting. 
2. Double click the right side of the Objective-C Bridging Header build setting to modify its value. 
3. A popup will appear, drag and drag and drop the header file (Fujifilm_SPA_SDK_Bridge.h) from the left side of Xcode to this popup.

### Step 4: Build your project
Build your project again at this point to ensure there are no errors

### Step 5: Integrate with SPA SDK
In your view controller swift file, ensure it implements the FujifilmSPASDKDelegate protocol:
```swift
class ViewController: UIViewController, FujifilmSPASDKDelegate {
```

In your view controller, create a Fujifilm_SPA_SDK_iOS object. Initialize it using the initWithApiKey method:

```swift
let fujicontroller:Fujifilm_SPA_SDK_iOS? = Fujifilm_SPA_SDK_iOS(
    apiKey: "YOUR_API_KEY", //REPLACE with YOUR ApiKey
    environment: "Preview",
    images: ARRAY_OF_FFIMAGES,
    userID: "", //optional
    retainUserInfo:
    false,
    promoCode: nil, //optional
    launchPage:
    kHome,
    extraOptions: nil)
```

Next, set the Fujifilm_SPA_SDK_iOS object’s delegate to the view controller:

```swift
fujicontroller?.delegate = self
```

Finally, present the Fujifilm_SPA_SDK_iOS object:

```swift
let navController = FujifilmSPASDKNavigationController(rootViewController: fujicontroller!)
self.present(navController, animated: true, completion: { () -> Void in })
```

The FujifilmSPASDKDelegate requires your view controller to implement the method fujifilmSPASDKFinishedWithStatus:(int) statusCode andMessage(NSString*) message.

When the Fujifilm SPA SDK is finished, it will return to the parent app, calling fujifilmSPASDKFinishedWithStatus. You must implement like so:

```swift
func fujifilmSPASDKFinished(withStatus statusCode: Int32, andMessage message: String!) {
        
}
```
Details on status codes can be found in GitHub documentation.

#### Full Example Code

```swift
let kFujifilmSPASDKAPIKey = "5cb79d2191874aca879e2c9ed7d5747c"
let kFujifilmSPASDEnvironment = "Preview"

class ViewController: UIViewController, FujifilmSPASDKDelegate {
   
@IBAction func launchSDK(_ sender: Any) {
        var photoarray: [FFImage] = [FFImage(nsurl: URL(string:"https://webservices.fujifilmesys.com/venus/imagebank/fujifilmCamera.jpg")!)]
        
        let fujicontroller:Fujifilm_SPA_SDK_iOS? = Fujifilm_SPA_SDK_iOS(
            apiKey: kFujifilmSPASDKAPIKey, //REPLACE with YOUR ApiKey
            environment: kFujifilmSPASDEnvironment,
            images: [photoarray[photoarray.count-1]],
            userID: "", //optional
            retainUserInfo:
            false,
            promoCode: nil, //optional
            launchPage:
            kHome,
            extraOptions: nil)
     
        fujicontroller?.delegate = self
        
        let navController = FujifilmSPASDKNavigationController(rootViewController: fujicontroller!)
        
        self.present(navController, animated: true, completion: { () -> Void in })
    }
    func fujifilmSPASDKFinished(withStatus statusCode: Int32, andMessage message: String) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
})
```
### License
IMPORTANT - PLEASE READ THE FOLLOWING TERMS AND CONDITIONS CAREFULLY BEFORE USING THE FOLLOWING COMPUTER CODE (THE “CODE”). USE OF THE CODE IS AT YOUR OWN RISK. THE CODE IS PROVIDED “AS IS”, WITH ANY AND ALL FAULTS, DEFECTS AND ERRORS, AND WITHOUT ANY WARRANTY OF ANY KIND. FUJIFILM DISCLAIMS ALL WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, WITHOUT LIMITATION, ALL IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT, WITH RESPECT TO THE CODE OR DEFECTS IN OPERATION OR ANY PARTICULAR APPLICATION OR USE OF THE CODE. FUJIFILM DOES NOT WARRANT THAT THE CODE WILL MEET YOUR REQUIREMENTS OR EXPECTATIONS, THAT THE CODE WILL WORK ON ANY HARDWARE, OPERATING SYSTEM OR WITH ANY SOFTWARE, THAT THE OPERATION OF THE CODE WILL BE UNINTERRUPTED, FREE OF HARMFUL COMPONENTS OR ERROR-FREE, OR THAT ANY KNOWN OR DISCOVERED ERRORS WILL BE CORRECTED.
FUJIFILM SHALL NOT BE LIABLE TO YOU OR ANY THIRD PARTY FOR ANY LOSS OF PROFIT, LOSS OF DATA, COMPUTER FAILURE OR MALFUNCTION, INTERRUPTION OF BUSINESS, OR OTHER DAMAGE ARISING OUT OF OR RELATING TO THE CODE, INCLUDING, WITHOUT LIMITATION, EXEMPLARY, PUNITIVE, SPECIAL, STATUTORY, DIRECT, INDIRECT, INCIDENTAL, CONSEQUENTIAL, TORT OR COVER DAMAGES, WHETHER IN CONTRACT, TORT OR OTHERWISE, INCLUDING, WITHOUT LIMITATION, DAMAGES RESULTING FROM THE USE OR INABILITY TO USE THE CODE, EVEN IF FUJIFILM HAS BEEN ADVISED OR AWARE OF THE POSSIBILITY OF SUCH DAMAGES.
